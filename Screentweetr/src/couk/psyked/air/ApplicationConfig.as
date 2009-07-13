package couk.psyked.air
{
	import couk.psyked.air.events.ApplicationConfigEventType;
	
	import flash.data.EncryptedLocalStore;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import mx.events.FlexEvent;

	public class ApplicationConfig extends EventDispatcher
	{
		internal static var _instance:ApplicationConfig;
		internal static var _initalised:Boolean;

		private var _defaultFilepath:String;

		private var _isDefaultConfig:Boolean;
		private var _isNewConfig:Boolean;
		private var _isLoaded:Boolean;

		private var _storageDirectory:String;

		private var configFile:XML;

		public function ApplicationConfig()
		{
			if (_instance == null)
			{
				_instance = this;
				init();
			}
			else
			{
				throw new Error("ApplicationConfig should be a singleton");
			}
		}

		public static function get instance():ApplicationConfig
		{
			if (_instance == null)
			{
				_instance = new ApplicationConfig();
			}
			return _instance;
		}

		public function get exists():Boolean
		{
			var _file:File = new File("app-storage:/configuration.xml");
			return _file.exists;
		}

		public function get loaded():Boolean
		{
			return _isLoaded;
		}

		public function get isDefaultConfig():Boolean
		{
			return _isDefaultConfig;
		}

		public function get isNewConfig():Boolean
		{
			return _isNewConfig;
		}

		public function get configFilepath():String
		{
			var _file:File = new File("app-storage:/configuration.xml");
			return _file.nativePath;
		}

		public function get storageDirectory():String
		{
			return _storageDirectory;
		}

		public function set storageDirectory(value:String):void
		{
			if (value == ApplicationConfigStorageType.NORMAL || value == ApplicationConfigStorageType.ENCRYPTED_STORE)
			{
				_storageDirectory = value;
			}
			else
			{
				throw new Error("ApplicationConfigStorageType is not recognised.");
			}
		}

		public function set defaultConfigFile(value:String):void
		{
			var _testFile:File = new File(value);

			if (_testFile.exists)
			{
				_defaultFilepath = value;
			}
			else
			{
				throw new Error("The file specified to defaultConfigFile does not exist.");
			}
		}

		public function getAllSettings():Array
		{
			var rtnArray:Array = new Array();

			var xmlNode:XML = configFile.settings[0];
			var list:XMLList = xmlNode.children();

			for each (var node:XML in list)
			{
				node = validateSetting(node);
				rtnArray.push(node.name());
			}

			return rtnArray;
		}

		public function deleteAllSettings():void
		{
			var array:Array = getAllSettings();
			for (var i:uint = 0; i < array.length; i++)
			{
				deleteSetting(array[i]);
			}
		}

		public function deleteSetting(settingName:String):void
		{
			var setting:XML = configFile.settings[0][settingName][0];
			//trace(setting);
			delete configFile.settings[0][settingName];

			//trace(configFile);

			writeConfigFile()
		}

		private function init():void
		{
			_instance = this;
			_initalised = getConfigFile();
		}

		private function getConfigFile():Boolean
		{
			var _rtn:Boolean = false;

			if (configFilepath == ApplicationConfigStorageType.NORMAL)
			{
				var file:File = new File("app-storage:/configuration.xml");

				if (file.exists)
				{
					_rtn = true;
				}
				else
				{
					createBlankConfigFile();
				}
			}
			else if (configFilepath == ApplicationConfigStorageType.ENCRYPTED_STORE)
			{
				_rtn = true;
			}

			dispatchEvent(new FlexEvent(FlexEvent.INITIALIZE));

			return _rtn;
		}

		public function load():void
		{
			readConfigFile();
		}

		private function readConfigFile():void
		{
			var file:File;

			if (_storageDirectory == ApplicationConfigStorageType.ENCRYPTED_STORE)
			{
				trace("Reading Config file from Encrypted local store.");
				onReadCompleteHandler();
			}
			else
			{
				file = File.applicationStorageDirectory;
				file = file.resolvePath("configuration.xml");

				trace("Reading Config file from: ", file.nativePath);

				var fileStream:FileStream = new FileStream();
				fileStream.addEventListener(ProgressEvent.PROGRESS, onReadProgressHandler);
				fileStream.addEventListener(Event.COMPLETE, onReadCompleteHandler);
				fileStream.addEventListener(IOErrorEvent.IO_ERROR, onReadIOErrorHandler);
				fileStream.openAsync(file, FileMode.READ);
			}

		}

		private function onReadProgressHandler(e:ProgressEvent):void
		{
			dispatchEvent(e.clone());
		}

		private function onReadCompleteHandler(e:Event = null):void
		{
			var _rtn:String

			if (_storageDirectory == ApplicationConfigStorageType.ENCRYPTED_STORE)
			{
				var ls:ByteArray = EncryptedLocalStore.getItem("configFile");

				if (ls)
				{
					_rtn = ls.readUTFBytes(ls.bytesAvailable);
				}
			}
			else
			{
				var fileStream:FileStream = (e.target as FileStream);
				_rtn = fileStream.readUTFBytes(fileStream.bytesAvailable);
				fileStream.close();
			}

			try
			{
				configFile = XML(_rtn);

				if (!validateConfigFile())
				{
					createBlankConfigFile();
				}
			}
			catch (e:Error)
			{
				createBlankConfigFile();
			}
			_isLoaded = true;

			dispatchEvent(new Event(ApplicationConfigEventType.CONFIG_FILE_LOADED, true, true));
		}

		private function onReadIOErrorHandler(e:IOErrorEvent):void
		{
			var fileStream:FileStream = (e.target as FileStream);
			fileStream.close();
			readConfigFile();
		}

		protected function validateConfigFile():Boolean
		{
			var rtnBoolean:Boolean = false;

			try
			{
				var firstNodeLength:uint = uint(XMLList(XML(configFile)..*).length());

				if (firstNodeLength > 0)
				{
					// use a try..catch here because we're assuming a named XML node
					try
					{
						var secondNodeLength:uint = uint(XMLList(XML(configFile).settings..*).length());

						if (secondNodeLength > 0)
						{
							getAllSettings();
							rtnBoolean = true;
						}
						else
						{
							// do nothing (returns false)
						}
					}
					catch (e:Error)
					{
						// if the 2nd node is named incorrectly, do nothing and return
						// false (the default return var for this function)
					}
				}
				else
				{
					// there is no first node, so don't do anything and return false,
					// which is the default return var for this function.
				}
			}
			catch (e:Error)
			{
				// this catch is looking for errors coercing the data to XML.
			}
			//trace("Configuration file valid = ", rtnBoolean);
			return rtnBoolean;
		}

		private function createBlankConfigFile():void
		{
			_isDefaultConfig = true;
			_isNewConfig = true;

			var myXML:XML;

			trace("Creating Blank configuration file.");
			//trace(_defaultFilepath);
			//trace("_defaultFilepath != \"\" =", _defaultFilepath != "")

			if (_defaultFilepath != null)
			{
				var file:File = new File(_defaultFilepath);

				if (file.exists)
				{
					var fileStream:FileStream = new FileStream();
					fileStream.open(file, FileMode.READ);
					var str:String = fileStream.readUTFBytes(fileStream.bytesAvailable);
					myXML = new XML(str);
					fileStream.close();
				}
				else
				{
					throw new Error("Default file path for Application Config leads to a file which does not exist.");
				}
			}
			else
			{
				myXML = new XML("<configuration><settings></settings></configuration>");
			}
			configFile = myXML;

			/*var file:File = File.applicationStorageDirectory;
			   file = file.resolvePath("configuration.xml");

			   var fileStream:FileStream = new FileStream();
			   fileStream.openAsync(file, FileMode.WRITE);

			   try
			   {
			   fileStream.writeUTFBytes(myXML);
			   }
			   catch (e:IOError)
			   {
			   trace("I/O Error");

			 }*/
			writeConfigFile();
		}

		private function validateSetting(xml:XML):XML
		{
			if (xml)
			{
				if (xml.child("value").toXMLString() == "")
				{
					var prevContents:String = xml.toString();
					var prevName:String = xml.name();
					//trace(prevContents, prevName);
					xml = new XML("<" + prevName + "><value>" + prevContents + "</value></" + prevName + ">");
					configFile.settings[0][prevName] = xml;

					writeConfigFile();
				}
			}
			return xml;
		}

		public function getSetting(settingName:String):String
		{
			if (!_initalised)
			{
				//trace("Is not initalised");
				if (_instance == null)
				{
					//trace("Does not exist");
					new ApplicationConfig();
				}
					//_init();
			}
			//trace("Getting setting '" + settingName + "'");
			var _rtn:String; // = "";
			//if(configFile) {
			//try
			//{
			//var xml:XML = validateSetting(configFile.settings.child(settingName)[0]);
			//trace("xml = ", xml);
			if (configFile.settings.child(settingName)[0])
			{
				_rtn = configFile.settings.child(settingName)[0].value;
			}
			//trace(settingName, _rtn)
			/*}
			   catch (e:*)
			   {
			   //trace(settingName, "Error")
			 }*/
			trace("Getting setting '" + settingName + "' = '" + _rtn + "'");
			//trace("Return = "+_rtn);
			//} else {
			//	trace("Trying to read config before file is loaded.");
			//}
			return _rtn;
		}

		private static function writeIOErrorHandler(e:IOErrorEvent):void
		{
			//trace("I/O Error");
		}

		/**
		 * @param settingName String name of the setting to create in the configuration file.
		 * @param value The value of the new setting
		 */
		public function setSetting(settingName:String, value:String):void
		{
			_isDefaultConfig = false;
			trace("Setting setting '" + settingName + "' to '" + value + "'");

			var str:String = value;

			if (!_initalised)
			{
				//trace("Is not initalised");
				if (_instance == null)
				{
					//trace("Does not exist");
					new ApplicationConfig();
				}
				init();
			}

			//trace("configFile:", configFile)
			if (configFile)
			{
				//trace("getSetting(" + settingName + ") = '" + getSetting(settingName) + "'");
				//trace("configFile.settings.child(settingName)[0].value.toString() = "+configFile.settings.child(settingName)[0].value.toString())
				var _newchild:XML = XML("<" + settingName + "><value>" + str + "</value></" + settingName + ">");
				//trace(getSetting(settingName), typeof(getSetting(settingName)));
				if (getSetting(settingName) == null)
				{
					//trace("configFile.settings.toString() =",configFile.settings.toString())

					//else
					//{
					//TODO: Need to check if settings node exists, and if not, create it.
					//trace("blank")
					configFile.settings[0].appendChild(_newchild);
						//trace(configFile.settings[0]);
						//trace(_newchild);
						//}
				}
				else
				{
					//trace("not blank")
					configFile.settings.child(settingName)[0].value = str;
				}
			}
			writeConfigFile();
			trace(configFile);
			dispatchEvent(new Event(Event.CHANGE));
		}

		private function writeConfigFile():void
		{
			if (_storageDirectory == ApplicationConfigStorageType.ENCRYPTED_STORE)
			{
				var ba:ByteArray = new ByteArray();
				ba.writeUTFBytes(configFile.toXMLString());
				EncryptedLocalStore.setItem("configFile", ba);
			}
			else
			{
				var file:File = File.applicationStorageDirectory;
				file = file.resolvePath("configuration.xml");

				var fileStream:FileStream = new FileStream();
				fileStream.open(file, FileMode.WRITE);
				fileStream.addEventListener(IOErrorEvent.IO_ERROR, writeIOErrorHandler);
				fileStream.writeUTFBytes(configFile);
				fileStream.close();
			}
		}
	}
}