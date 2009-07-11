package couk.psyked.air.printscreen
{
	import couk.psyked.air.printscreen.events.PrintScreenMonitorEvent;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * Dispatched when the clipboard contains a screenshot (where one didn't exist before)
	 *
	 * @eventType couk.psyked.air.printscreen.events.PrintScreenMonitorEvent
	 */
	[Event(name="ADD_SCREENSHOT", type="couk.psyked.air.printscreen.events.PrintScreenMonitorEvent")]
	
	/**
	 * Dispatched when a different screenshot is taken (bitmap is replaced for a different bitmap)
	 *
	 * @eventType couk.psyked.air.printscreen.events.PrintScreenMonitorEvent
	 */
	[Event(name="CHANGE_SCREENSHOT", type="couk.psyked.air.printscreen.events.PrintScreenMonitorEvent")]
	
	/**
	 * Dispatched when the clipboard goes from a screenshot, to no screenshot
	 *
	 * @eventType couk.psyked.air.printscreen.events.PrintScreenMonitorEvent
	 */
	[Event(name="REMOVE_SCREENSHOT", type="couk.psyked.air.printscreen.events.PrintScreenMonitorEvent")]
	
	public class PrintScreenMonitor extends EventDispatcher
	{
		private var ignoreCurrentBitmap:Boolean=false;
		private var timer:Timer;
		private var _interval:Number;
		private static const DEFAULT_MONITOR_INTERVAL:Number=2000;
		
		private var bitmapdatacache:BitmapData;
		
		/**
		 * 	Constructor.
		 *
		 * 	@param interval How often in milliseconds the system is polled for
		 * 	volume change events. Default value is 2000, minimum value is 1000
		 */
		public function PrintScreenMonitor(interval:Number=-1)
		{
			if (interval != -1)
			{
				if (interval < 1000)
				{
					_interval=1000;
				}
				else
				{
					_interval=interval;
				}
			}
			else
			{
				_interval=DEFAULT_MONITOR_INTERVAL;
			}
		}
		
		public function clearCache():void
		{
			ignoreCurrentBitmap=true;
			bitmapdatacache=null;
		}
		
		/**
		 * 	How often the system is polled for Volume change events.
		 */
		public function get interval():Number
		{
			return _interval;
		}
		
		/**
		 * Begins the monitoring of changes to the attached File volumes.
		 */
		public function watch():void
		{
			
			if (!timer)
			{
				timer=new Timer(_interval);
				timer.addEventListener(TimerEvent.TIMER, onTimerEvent, false, 0, true);
			}
			
			timer.start();
		}
		
		/**
		 * Stops monitoring for changes to the attached File volumes.
		 */
		public function unwatch():void
		{
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER, onTimerEvent);
			timer = null;
		}
		
		private function onTimerEvent(e:TimerEvent):void
		{
			
			var outEvent:PrintScreenMonitorEvent;
			var bitmapfound:Boolean=Clipboard.generalClipboard.hasFormat(ClipboardFormats.BITMAP_FORMAT);
			
			if (!bitmapdatacache)
			{
				if (bitmapfound)
				{
					if (ignoreCurrentBitmap)
					{
						// if we're ignoring this bitmap
						ignoreCurrentBitmap=false;
					}
					else
					{
						outEvent=new PrintScreenMonitorEvent(PrintScreenMonitorEvent.ADD_SCREENSHOT);
						outEvent.bitmap=new Bitmap(Clipboard.generalClipboard.getData(ClipboardFormats.BITMAP_FORMAT) as BitmapData)
						dispatchEvent(outEvent);
					}
				}
				else
				{
					//trace("no bitmapdata");
				}
			}
			else
			{
				if (bitmapfound)
				{
					if (ignoreCurrentBitmap)
					{
						// if we're ignoring this bitmap
						ignoreCurrentBitmap=false;
					}
					else
					{
						if (bitmapdatacache.compare(Clipboard.generalClipboard.getData(ClipboardFormats.BITMAP_FORMAT) as BitmapData) == 0)
						{
							// if the cached bitmap is the same as the current bitmap
						}
						else
						{
							outEvent=new PrintScreenMonitorEvent(PrintScreenMonitorEvent.CHANGE_SCREENSHOT);
							outEvent.bitmap=new Bitmap(Clipboard.generalClipboard.getData(ClipboardFormats.BITMAP_FORMAT) as BitmapData)
							dispatchEvent(outEvent);
						}
					}
				}
				else
				{
					outEvent=new PrintScreenMonitorEvent(PrintScreenMonitorEvent.REMOVE_SCREENSHOT);
					dispatchEvent(outEvent);
				}
			}
			
			if (bitmapfound)
			{
				bitmapdatacache=Clipboard.generalClipboard.getData(ClipboardFormats.BITMAP_FORMAT) as BitmapData;
			}
			else
			{
				bitmapdatacache=null;
			}
		}
	}
}