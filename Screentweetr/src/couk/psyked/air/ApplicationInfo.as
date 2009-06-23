package couk.psyked.air
{
	import flash.desktop.NativeApplication;
	/**
	 * 
	 * @author James Ford (Psyked.co.uk)
	 * @version 1.2 16th January 2009
	 * 
	 * Version 1.1 introduces a change to the icon source path fetching, suggested by
	 * http://userflex.wordpress.com/2008/04/03/xml-ns-e4x/ via blog comments.
	 * 
	 */	
	public class ApplicationInfo
	{
		internal static var _instance:ApplicationInfo;
		internal static var _initalised:Boolean = false;
		
		private static var appXML:XML;
		private static var ns:Namespace;
		
		public function ApplicationInfo()
		{
			init();            
		}
		
		private function init():void {
			_instance = this;
			_initalised = getAppXML();
		}
		
		private function getAppXML():Boolean {
			appXML = NativeApplication.nativeApplication.applicationDescriptor;
			ns = appXML.namespace();
			
			var _rtn:Boolean = false;
			if(appXML != null){
				_rtn = true;
			} else {
				throw new Error("NativeApplication applicationDescriptor could not be loaded");
			}
			return _rtn;
		}
		
		public static function get appID():String {
			if(!_initalised){
				if(_instance == null){
					new ApplicationInfo();
				}
				_instance.init();
			}
			return appXML.ns::id[0];
		}
		
		public static function set appID(str:String):void {
			throw new Error("appID cannot be set with ActionScript");
		}
		
		public static function get appVersion():String {
			if(!_initalised){
				if(_instance == null){
					new ApplicationInfo();
				}
				_instance.init();
			}
			return appXML.ns::version[0];
		}
		
		public static function set appVersion(str:String):void {
			throw new Error("appVersion cannot be set with ActionScript");
		}
		
		public static function get appName():String {
			if(!_initalised){
				if(_instance == null){
					new ApplicationInfo();
				}
				_instance.init();
			}
			return appXML.ns::name[0];
		}
		
		public static function set appName(str:String):void {
			throw new Error("appName cannot be set with ActionScript");
		}
		
		public static function get appFilename():String {
			if(!_initalised){
				if(_instance == null){
					new ApplicationInfo();
				}
				_instance.init();
			}
			return appXML.ns::filename[0];
		}
		
		public static function set appFilename(str:String):void {
			throw new Error("appName cannot be set with ActionScript");
		}
		
		public static function get appDescription():String {
			if(!_initalised){
				if(_instance == null){
					new ApplicationInfo();
				}
				_instance.init();
			}
			return appXML.ns::description[0];
		}
		
		public static function set appDescription(str:String):void {
			throw new Error("appDescription cannot be set with ActionScript");
		}
		
		public static function get appCopyright():String {
			if(!_initalised){
				if(_instance == null){
					new ApplicationInfo();
				}
				_instance.init();
			}
			return appXML.ns::copyright[0];
		}
		
		public static function set appCopyright(str:String):void {
			throw new Error("appCopyright cannot be set with ActionScript");
		}
		
		public static function get appIcon16URL():String {
			if(!_initalised){
				if(_instance == null){
					new ApplicationInfo();
				}
				_instance.init();
			}
			var xmlns : Namespace;
			var namespaces : Array = appXML.namespaceDeclarations();
			for each (var ns : Namespace in namespaces)
			{
				if (ns.prefix == "")
				{
					xmlns = ns;
					break;
				}
			}
			return XML(appXML)..xmlns::image16x16;
		}
		
		public static function set appIcon16URL(str:String):void {
			throw new Error("appIcon cannot be set with ActionScript");
		}
		
		public static function get appIcon32URL():String {
			if(!_initalised){
				if(_instance == null){
					new ApplicationInfo();
				}
				_instance.init();
			}
			var xmlns : Namespace;
			var namespaces : Array = appXML.namespaceDeclarations();
			for each (var ns : Namespace in namespaces)
			{
				if (ns.prefix == "")
				{
					xmlns = ns;
					break;
				}
			}
			return XML(appXML)..xmlns::image32x32;
		}
		
		public static function set appIcon32URL(str:String):void {
			throw new Error("appIcon cannot be set with ActionScript");
		}
		
		public static function get appIcon48URL():String {
			if(!_initalised){
				if(_instance == null){
					new ApplicationInfo();
				}
				_instance.init();
			}
			var xmlns : Namespace;
			var namespaces : Array = appXML.namespaceDeclarations();
			for each (var ns : Namespace in namespaces)
			{
				if (ns.prefix == "")
				{
					xmlns = ns;
					break;
				}
			}
			return XML(appXML)..xmlns::image48x48;
		}
		
		public static function set appIcon48URL(str:String):void {
			throw new Error("appIcon cannot be set with ActionScript");
		}
		
		public static function get appIcon128URL():String {
			if(!_initalised){
				if(_instance == null){
					new ApplicationInfo();
				}
				_instance.init();
			}
			var xmlns : Namespace;
			var namespaces : Array = appXML.namespaceDeclarations();
			for each (var ns : Namespace in namespaces)
			{
				if (ns.prefix == "")
				{
					xmlns = ns;
					break;
				}
			}
			return XML(appXML)..xmlns::image128x128;
		}
		
		public static function set appIcon128URL(str:String):void {
			throw new Error("appIcon cannot be set with ActionScript");
		}
	}
}