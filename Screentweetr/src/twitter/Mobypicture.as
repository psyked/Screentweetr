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
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	public class Mobypicture extends EventDispatcher implements ITwitterService
	{

		private static var _instance:Mobypicture;
		private var file:File;
		private var developerKey:String = "NeZwjPKVT34a2P4D";

		public function Mobypicture()
		{
			//
		}

		public function uploadToService(_file:File, _message:String = null):void
		{
			file = _file;
			file.addEventListener(Event.CANCEL, cancelHandler);
			file.addEventListener(Event.COMPLETE, completeHandler);
			file.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			file.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			file.addEventListener(Event.OPEN, openHandler);
			file.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			file.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, uploadCompleteDataHandler);

			var urlRequest:URLRequest;

			var urlVars:URLVariables = new URLVariables();
			urlVars.u = ApplicationConfig.instance.getSetting("twitterUsername");
			urlVars.p = ApplicationConfig.instance.getSetting("twitterPassword");
			urlVars.k = developerKey;
			urlVars.t = "Upload from Screentweetr";
			urlVars.s = "twitter";
			urlVars.action = "postMediaUrl";
			urlVars.format = "xml";

			/* if (_message)
			 { */
			urlRequest = new URLRequest("http://api.mobypicture.com/");
			urlVars.d = _message;
			/* }
			   else
			   {
			   urlRequest = new URLRequest("http://yfrog.com/api/upload");
			 } */

			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = urlVars;

			file.upload(urlRequest, 'i');
		}

		private function cancelHandler(event:Event):void
		{
			dispatchEvent(event.clone());
			trace("cancelHandler: " + event);
		}

		private function completeHandler(event:Event):void
		{
			dispatchEvent(event.clone());
			trace("completeHandler: " + event);
		}

		private function httpStatusHandler(event:HTTPStatusEvent):void
		{
			dispatchEvent(event.clone());
			trace("httpStatusHandler: " + event);
		}

		private function ioErrorHandler(event:IOErrorEvent):void
		{
			dispatchEvent(event.clone());
			trace("ioErrorHandler: " + event);
		}

		private function openHandler(event:Event):void
		{
			dispatchEvent(event.clone());
			trace("openHandler: " + event);
		}

		private function progressHandler(event:ProgressEvent):void
		{
			dispatchEvent(event.clone());
			trace("Uploading", Math.round((event.bytesLoaded / event.bytesTotal) * 100), "%");
		}

		private function securityErrorHandler(event:SecurityErrorEvent):void
		{
			dispatchEvent(event.clone());
			trace("securityErrorHandler: " + event);
		}

		private function uploadCompleteDataHandler(event:DataEvent):void
		{
			//trace(event.data);
			//trace("Upload is complete, recieved response from Mobypicture.");
			var resultXML:XML = new XML(event.text);

			var errorMessage:String = resultXML.child("result")[0].@code;
			var resultUrl:String = resultXML.child("url")[0];

			file.removeEventListener(Event.CANCEL, cancelHandler);
			file.removeEventListener(Event.COMPLETE, completeHandler);
			file.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			file.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			file.removeEventListener(Event.OPEN, openHandler);
			file.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			file.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			file.removeEventListener(Event.COMPLETE, uploadCompleteDataHandler);
			file.removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA, uploadCompleteDataHandler);

			dispatchEvent(event.clone());
		}

		public static function get instance():Mobypicture
		{
			if (!_instance)
			{
				_instance = new Mobypicture();
			}
			return _instance;
		}

	}
}