package twitter
{
	import flash.events.IEventDispatcher;
	import flash.filesystem.File;

	public interface ITwitterService extends IEventDispatcher
	{
		function uploadToService(file:File, _message:String = null):void
	}
}