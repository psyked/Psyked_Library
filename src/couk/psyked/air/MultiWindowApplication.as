package couk.psyked.air
{
	import flash.display.BitmapData;
	import flash.display.Screen;
	
	import spark.components.Application;
	import spark.components.Window;

	public class MultiWindowApplication extends Application
	{
		public function MultiWindowApplication()
		{
			super();
		}

		public function openWindowCentered( window:Window ):void
		{
			// instanciate the nativewindow
			window.open();
			window.nativeWindow.x = ( Screen.mainScreen.visibleBounds.width - window.nativeWindow.width ) / 2;
			window.nativeWindow.y = ( Screen.mainScreen.visibleBounds.height - window.nativeWindow.height ) / 2;
		}
		
		public var splashScreenImage:BitmapData;
	}
}