package couk.psyked.utils
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	public class AirBadgeService extends EventDispatcher
	{

		public function AirBadgeService()
		{
			_loader = new Loader();
			var context:LoaderContext = new LoaderContext();
			context.applicationDomain = ApplicationDomain.currentDomain;
			_loader.contentLoaderInfo.addEventListener( Event.INIT, initHandler );
			var swf:String = "http://airdownload.adobe.com/air/browserapi/air.swf";
			var request:URLRequest = new URLRequest( swf );
			_loader.load( request, context );
		}

		private var _loader:Loader;

		private var _service:Object;

		public function getApplicationVersion( applicationId:String, publisherId:String, callback:Function ):void
		{
			_service.getApplicationVersion( applicationId, publisherId, callback );
		}

		public function getStatus():String
		{
			trace( "status:", _service.getStatus());
			return _service.getStatus();
		}

		public function installApplication( url:String, runtimeVersion:String, parameters:Array = null ):void
		{
			trace( "installApplication", url, runtimeVersion, parameters );
			_service.installApplication( url, runtimeVersion, parameters );
		}

		public function launchApplication( applicationId:String, publisherId:String, parameters:Array = null ):void
		{
			trace( "launchApplication", applicationId, publisherId, parameters );
			_service.launchApplication( applicationId, publisherId, parameters );
		}

		private function initHandler( event:Event ):void
		{
			_service = _loader.content;
			dispatchEvent( new Event( Event.COMPLETE ));
		}
	}
}