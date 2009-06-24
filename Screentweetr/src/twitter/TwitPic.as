package twitter
{
	import couk.mmtdigital.air.ApplicationConfig;

	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	public class TwitPic extends EventDispatcher implements ITwitterService
	{

		private static var _instance:TwitPic;
		private var _file:File;
		private var message:String;

		public function TwitPic()
		{
			//
		}

		private function selectFile(f:File):void
		{
			_file = f;
			_file.addEventListener(Event.CANCEL, cancelHandler);
			_file.addEventListener(Event.COMPLETE, completeHandler);
			_file.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			_file.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_file.addEventListener(Event.OPEN, openHandler);
			_file.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			_file.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			_file.addEventListener(Event.SELECT, selectHandler);
			_file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, uploadCompleteDataHandler);
		}

		public function uploadToService(file:File, _message:String = null):void
		{
			selectFile(file);
			message = _message;
			fileSelected();
		}

		private function cancelHandler(event:Event):void
		{
			trace("cancelHandler: " + event);
		}

		private function completeHandler(event:Event):void
		{
			trace("completeHandler: " + event);
		}

		private function httpStatusHandler(event:HTTPStatusEvent):void
		{
			trace("httpStatusHandler: " + event);
		}

		private function ioErrorHandler(event:IOErrorEvent):void
		{
			trace("ioErrorHandler: " + event);
		}

		private function openHandler(event:Event):void
		{
			trace("openHandler: " + event);
		}

		private function progressHandler(event:ProgressEvent):void
		{
			var file:FileReference = FileReference(event.target);
			dispatchEvent(event.clone());
			trace("Uploading", Math.round((event.bytesLoaded / event.bytesTotal) * 100), "%");
		}

		private function securityErrorHandler(event:SecurityErrorEvent):void
		{
			trace("securityErrorHandler: " + event);
		}

		private function selectHandler(event:Event):void
		{
			var file:FileReference = FileReference(event.target);
			trace("selectHandler: name=" + file.name);
		}

		private function fileSelected(event:Event = null):void
		{
			var urlRequest:URLRequest

			var urlVars:URLVariables = new URLVariables();
			urlVars.username = ApplicationConfig.instance.getSetting("twitterUsername");
			urlVars.password = ApplicationConfig.instance.getSetting("twitterPassword");
			if (message)
			{
				urlRequest = new URLRequest("http://twitpic.com/api/uploadAndPost");
				urlVars.message = message;
			}
			else
			{
				urlRequest = new URLRequest("http://twitpic.com/api/upload");
			}

			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = urlVars;

			_file.upload(urlRequest, 'media');
		}

		private function uploadCompleteDataHandler(event:DataEvent):void
		{
			trace("Upload is complete, recieved response from TwitPic.");
			var resultXML:XML = new XML(event.text);

			var errorMessage:String = resultXML.child("err")[0];
			var resultUrl:String = resultXML.child("mediaurl")[0];

			if (resultUrl)
			{
				trace("Opening new window to show TwitPic results.");
					//navigateToURL(new URLRequest(resultUrl), "_blank");
			}
			else
			{
				trace("FAIL WHALE! :", errorMessage);
			}

			_file.removeEventListener(Event.CANCEL, cancelHandler);
			_file.removeEventListener(Event.COMPLETE, completeHandler);
			_file.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			_file.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_file.removeEventListener(Event.OPEN, openHandler);
			_file.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			_file.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			_file.removeEventListener(Event.SELECT, selectHandler);
			_file.removeEventListener(Event.COMPLETE, uploadCompleteDataHandler);
			_file.removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA, uploadCompleteDataHandler);

			dispatchEvent(event.clone());
		}

		/* public function get message():String
		   {
		   return _message;
		   }

		   public function set message(v:String):void
		   {
		   _message = v;
		 } */

		public static function get instance():TwitPic
		{
			if (!_instance)
			{
				_instance = new TwitPic();
			}
			return _instance;
		}
	}
}