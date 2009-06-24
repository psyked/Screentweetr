package twitter
{
	import flash.filesystem.File;

	public interface ITwitterService
	{
		function uploadToService(file:File, _message:String = null):void
	}
}