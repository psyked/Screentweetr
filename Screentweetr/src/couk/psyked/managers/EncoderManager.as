package couk.psyked.managers
{
	import com.pfp.events.JPEGAsyncCompleteEvent;
	import com.pfp.utils.JPEGAsyncEncoder;

	import couk.psyked.managers.types.EncoderManagerTypes;

	import flash.display.BitmapData;
	import flash.events.DataEvent;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;

	public class EncoderManager extends EventDispatcher
	{
		public static var traceEvents:Boolean = false;

		private static var _instance:EncoderManager;
		private var encoder:JPEGAsyncEncoder;

		public function EncoderManager(target:IEventDispatcher = null)
		{
			super(target);
		}

		public function set serviceType(str:String):void
		{
			if (traceEvents)
			{
				trace("EncoderManager serviceType is ", str);
			}
			switch (str.toLowerCase())
			{
				case EncoderManagerTypes.JPEG:
					encoder = new JPEGAsyncEncoder(100);
					encoder.PixelsPerIteration = 256;
					encoder.addEventListener(JPEGAsyncCompleteEvent.JPEGASYNC_COMPLETE, onEncodingComplete);
					encoder.addEventListener(ProgressEvent.PROGRESS, onEncodingProgress);
					break;
				default:
					break;
			}
		}

		private function onEncodingComplete(e:JPEGAsyncCompleteEvent):void
		{
			if (traceEvents)
			{
				trace("EncoderManager onEncodingComplete");
			}
			dispatchEvent(new JPEGAsyncCompleteEvent(e.ImageData));
		}

		private function onEncodingProgress(e:ProgressEvent):void
		{
			if (traceEvents)
			{
				trace("EncoderManager onEncodingProgress");
			}
			dispatchEvent(e.clone());
		}

		public function encodeBitmapData(b:BitmapData):void
		{
			if (traceEvents)
			{
				trace("EncoderManager encodeBitmapData");
			}
			encoder.encode(b);
		}

		private function progressHandler(e:ProgressEvent):void
		{
			if (traceEvents)
			{
				trace("EncoderManager progressHandler");
			}
			dispatchEvent(e.clone());
		}

		private function uploadCompleteDataHandler(e:DataEvent):void
		{
			if (traceEvents)
			{
				trace("EncoderManager uploadCompleteDataHandler");
			}
			dispatchEvent(e.clone());
		}

		public static function get instance():EncoderManager
		{
			if (!_instance)
			{
				_instance = new EncoderManager();
			}
			return _instance;
		}
	}
}