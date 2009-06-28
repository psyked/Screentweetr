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
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;

	public class TweetPhoto extends EventDispatcher implements ITwitterService
	{
		private static var _instance:TweetPhoto;
		private var file:File;
		private var APIKey:String = "02217aa0912b17d691abf29e271ebdc8";

		public function TweetPhoto()
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

			var xmlString:String = '<UploadPost xmlns="http://tweetphotoapi.com" xmlns:i="http://www.w3.org/2001/XMLSchema-instance">';
			xmlString += '<ApiKey>' + APIKey + '</ApiKey>';
			xmlString += '<Message>' + _message + '</Message>';
			xmlString += '<MimeType>image/jpg</MimeType>';
			xmlString += '<Password>' + ApplicationConfig.instance.getSetting("twitterPassword") + '</Password>';
			xmlString += '<UserName>' + ApplicationConfig.instance.getSetting("twitterUsername") + '</UserName>';
			xmlString += '</UploadPost>';

			var urlRequest:URLRequest;

			/* var urlVars:URLVariables = new URLVariables();
			urlVars.username = ApplicationConfig.instance.getSetting("twitterUsername");
			urlVars.password = ApplicationConfig.instance.getSetting("twitterPassword"); */

			if (_message)
			{
				urlRequest = new URLRequest("http://tweetphotoapi.com/api/tpapi.svc/uploadandpost");
				/* urlVars.message = _message; */
			}
			else
			{
				urlRequest = new URLRequest("http://tweetphotoapi.com/api/tpapi.svc/upload");
			}
			
			var fs:FileStream = new FileStream();
			fs.open(file, FileMode.READ);
			//fs.bytesAvailable
			//fs.close();
			
			urlRequest.requestHeaders = [new URLRequestHeader("Content-Type", "application/x-www-form-urlencoded"), new URLRequestHeader("Content-Length", fs.bytesAvailable.toString())];
			fs.close();
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = xmlString;

			file.upload(urlRequest, 'media');
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
			trace(event.data);
			//trace("Upload is complete, recieved response from TwitPic.");
			var resultXML:XML = new XML(event.text);

			var errorMessage:String = resultXML.child("err")[0];
			var resultUrl:String = resultXML.child("mediaurl")[0];

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

		public static function get instance():TweetPhoto
		{
			if (!_instance)
			{
				_instance = new TweetPhoto();
			}
			return _instance;
		}

	}
}