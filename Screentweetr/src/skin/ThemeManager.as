package skin
{

	import flash.events.IEventDispatcher;
	import mx.events.StyleEvent;

	public class ThemeManager
	{
		import mx.styles.StyleManager;

		private static var _skin:String;

		public function ThemeManager()
		{
			//
		}

		/**
		 * Changes the selected skin by unloading current style declarations
		 * and loading new style declarations from the embedded stylesheet swf file.
		 */
		public static function changeSkin(skinUrl:String):void
		{
			if (_skin != null)
			{
				StyleManager.unloadStyleDeclarations(_skin, true);
			}
			_skin = skinUrl;
			try
			{
				var styleEvent:IEventDispatcher = StyleManager.loadStyleDeclarations(_skin, true); // force immediate update
				styleEvent.addEventListener(StyleEvent.COMPLETE, function():void
					{
					});
				styleEvent.addEventListener(StyleEvent.ERROR, function():void
					{
					});
			}
			catch (e:*)
			{
				trace("StyleManager Error");
			}
		}
	}
}