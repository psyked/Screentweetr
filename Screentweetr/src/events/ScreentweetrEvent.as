package events
{
	import flash.events.Event;

	public class ScreentweetrEvent extends Event
	{
		
		public static const OPEN_NOTIFICATION:String = "openNotification";
		public static const CLOSE_NOTIFICATION:String = "closeNotification";
		public static const OPEN_SETTINGS:String = "openSettings";
		public static const CLOSE_SETTINGS:String = "closeSettings";
		public static const UPLOAD_IMAGE:String = "uploadImage";
		public static const OPEN_HELP:String = "openHelp";
		public static const CLOSE_HELP:String = "closeHelp";
		
		public function ScreentweetrEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}