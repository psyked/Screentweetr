package config
{
	import couk.mmtdigital.air.ApplicationConfig;
	import couk.mmtdigital.air.ApplicationConfigStorageType;
	import couk.mmtdigital.air.events.ApplicationConfigEventType;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	
	import mx.binding.utils.BindingUtils;

	[Bindable]
	public class ScreentweetrApplicationConfig extends EventDispatcher
	{

		private static var instance:ScreentweetrApplicationConfig;
		private static var configFile:ApplicationConfig;

		public static var APPLICATION_CONFIG_READY:String = "applicationConfigReady";

		public var USERNAME:String;
		public var PASSWORD:String;

		/**
		 * This class acts as an intermediary between the ApplicationConfig class, stores
		 * static variables and makes the settings available for data binding.
		 */

		public function ScreentweetrApplicationConfig()
		{
			if (instance == null)
			{
				instance = this;
			}
			else
			{
				throw new Error("DesktopTwitterApplicationConfig should be a singleton");
			}
			configFile = new ApplicationConfig();
			configFile.addEventListener(ApplicationConfigEventType.CONFIG_FILE_LOADED, onConfigReadyHander);
			/* If a nonsecure configuration file exists, delete it. */
			var lFile:File = new File(configFile.configFilepath);
			if(lFile.exists) {
				lFile.moveToTrash();
			}
			configFile.storageDirectory = ApplicationConfigStorageType.ENCRYPTED_STORE;
		}

		public function load():void
		{
			configFile.load();
		}

		protected function onConfigReadyHander(e:Event = null):void
		{
			refreshConfigFile();

			BindingUtils.bindSetter(changeUsername, this, "USERNAME");
			BindingUtils.bindSetter(changePassword, this, "PASSWORD");

			dispatchEvent(new Event(APPLICATION_CONFIG_READY));
		}

		public function refreshConfigFile():void
		{
			if (ApplicationConfig.instance.getSetting("twitterUsername"))
			{
				instance.USERNAME = ApplicationConfig.instance.getSetting("twitterUsername");
			}
			if (ApplicationConfig.instance.getSetting("twitterPassword"))
			{
				instance.PASSWORD = ApplicationConfig.instance.getSetting("twitterPassword");
			}
		}

		private function changeUsername(newValue:String):void
		{
			ApplicationConfig.instance.setSetting("twitterUsername", newValue);
		}

		private function changePassword(newValue:String):void
		{
			ApplicationConfig.instance.setSetting("twitterPassword", newValue);
		}

		public static function getInstance():ScreentweetrApplicationConfig
		{
			if (instance == null)
			{
				instance = new ScreentweetrApplicationConfig();
			}
			return instance;
		}
	}
}