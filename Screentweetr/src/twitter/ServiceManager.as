package twitter
{
	import flash.events.DataEvent;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
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
				twitterService.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
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
				default:
					break;
			}
			twitterService.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			twitterService.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, uploadCompleteDataHandler);
		}
		
		public function get serviceType():String {
			return _serviceType;
		}

		private function progressHandler(e:ProgressEvent):void
		{
			trace("ServiceManager progressHandler");
			dispatchEvent(e.clone());
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