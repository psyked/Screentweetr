package couk.psyked.events
{
	import flash.events.Event;
	
	public class ReadConfigCompleteEvent extends Event
	{
		public static var CONFIG_LOADED:String="application_config_loaded";
		
		public var UTFBytes:String;
		
		public function ReadConfigCompleteEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	
	}
}