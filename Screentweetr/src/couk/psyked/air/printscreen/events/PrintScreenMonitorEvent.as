package couk.psyked.air.printscreen.events {
	import flash.display.Bitmap;
	import flash.events.Event;

	public class PrintScreenMonitorEvent extends Event {

		public static const ADD_SCREENSHOT:String = "onPrintScreenAdd";
		public static const CHANGE_SCREENSHOT:String = "onPrintScreenChange";
		public static const REMOVE_SCREENSHOT:String = "onPrintScreenRemove";

		public var bitmap:Bitmap;

		public function PrintScreenMonitorEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}

		public override function clone():Event {
			var out:PrintScreenMonitorEvent = new PrintScreenMonitorEvent(type, bubbles, cancelable);
			out.bitmap = bitmap;

			return out;
		}
	}
}