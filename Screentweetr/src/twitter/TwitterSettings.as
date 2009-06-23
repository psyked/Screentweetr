package twitter
{
	public class TwitterSettings
	{
		private static var _instance:TwitterSettings;
		
		private var _username:String;
		private var _password:String;
		
		public function TwitterSettings()
		{
			//
		}
		
		public function set username(str:String):void {
			_username = str;
		}
		
		public function get username():String {
			return _username;
		}
		
		public function set password(str:String):void {
			_password = str;
		}
		
		public function get password():String {
			return _password;
		}
		
		public static function get instance():TwitterSettings {
			if( !_instance) {
				_instance = new TwitterSettings();
			}
			return _instance;
		}
	}
}