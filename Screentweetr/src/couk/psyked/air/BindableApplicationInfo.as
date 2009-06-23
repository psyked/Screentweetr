package couk.psyked.air
{
	
	public class BindableApplicationInfo
	{
		
		[Bindable]
		public static var appCopyright:String=ApplicationInfo.appCopyright;
		
		[Bindable]
		public static var appName:String=ApplicationInfo.appName;
		
		[Bindable]
		public static var appDescription:String=ApplicationInfo.appDescription;
		
		[Bindable]
		public static var appVersion:String=ApplicationInfo.appVersion;
		
		[Bindable]
		public static var appIcon48URL:String=ApplicationInfo.appIcon48URL;
		
		[Bindable]
		public static var appIcon16URL:String=ApplicationInfo.appIcon16URL;
		
		public function BindableApplicationInfo()
		{
			//TODO: implement function
		}
	
	}
}