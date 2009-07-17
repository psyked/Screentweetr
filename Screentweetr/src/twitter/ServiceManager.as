package twitter
{
	import couk.psyked.air.ApplicationConfig;
	
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	
	import twitter.types.ServiceTypes;

	public class ServiceManager extends EventDispatcher implements ITwitterService
	{
		private static var _instance:ServiceManager;

		private var twitterService:ITwitterService;
		private var _serviceType:String;

		public function ServiceManager(target:IEventDispatcher = null)
		{
			super(target);
		}

		public function set serviceType(str:String):void
		{
			trace("ServiceManager serviceType");
			if (twitterService)
			{
				twitterService.removeEventListener(Event.CANCEL, cancelHandler);
				twitterService.removeEventListener(Event.COMPLETE, completeHandler);
				twitterService.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
				twitterService.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				twitterService.removeEventListener(Event.OPEN, openHandler);
				twitterService.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
				twitterService.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				twitterService.removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA, uploadCompleteDataHandler);
				twitterService = null;
			}

			_serviceType = str;

			switch (str)
			{
				case ServiceTypes.TWIT_PIC:
					twitterService = TwitPic.instance;
					break;
				case ServiceTypes.TWEET_PHOTO:
					twitterService = TweetPhoto.instance;
					break;
				case ServiceTypes.SCREEN_TWEET:
					twitterService = ScreenTweet.instance;
					break;
				case ServiceTypes.YFROG:
					twitterService = YFrog.instance;
					break;
				case ServiceTypes.TWITGOO:
					twitterService = Twitgoo.instance;
					break;
				case ServiceTypes.MOBYPICTURE:
					twitterService = Mobypicture.instance;
					break;
				case ServiceTypes.IMG_LY:
					twitterService = ImgLy.instance;
					break;
				case ServiceTypes.POSTEROUS:
					twitterService = Posterous.instance;
					break;
				case ServiceTypes.TWITR_PIX:
					twitterService = TwitrPix.instance;
					break;
				case ServiceTypes.TWIT_DOC:
					twitterService = TwitDoc.instance;
					break;
				default:
					ApplicationConfig.instance.setSetting("defaultService", ServiceTypes.TWEET_PHOTO);
					twitterService = TweetPhoto.instance;
					break;
			}
			twitterService.addEventListener(Event.CANCEL, cancelHandler);
			twitterService.addEventListener(Event.COMPLETE, completeHandler);
			twitterService.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			twitterService.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			twitterService.addEventListener(Event.OPEN, openHandler);
			twitterService.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			twitterService.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			twitterService.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, uploadCompleteDataHandler);

		}

		public function get serviceType():String
		{
			return _serviceType;
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

		private function uploadCompleteDataHandler(e:DataEvent):void
		{
			trace("ServiceManager uploadCompleteDataHandler");
			dispatchEvent(e.clone());
		}

		public function uploadToService(file:File, _message:String = null):void
		{
			trace("ServiceManager uploadToService");
			twitterService.uploadToService(file, _message);
		}

		public static function get instance():ServiceManager
		{
			if (!_instance)
			{
				_instance = new ServiceManager();
			}
			return _instance;
		}

	}
}