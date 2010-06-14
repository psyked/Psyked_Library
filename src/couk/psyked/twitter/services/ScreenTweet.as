package couk.psyked.twitter.services
{
	import couk.psyked.air.ApplicationConfig;
	import couk.psyked.twitter.ITwitterService;
	
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
	import flash.utils.ByteArray;
	
	import ru.inspirit.net.MultipartURLLoader;

	public class ScreenTweet extends EventDispatcher implements ITwitterService
	{
		private static var _instance:ScreenTweet;
		private var file:File;
		private var APIKey:String = "api-st-76030b7f18bcf4d613fbfdb514bdb1f2";

		public function ScreenTweet()
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

			var data:ByteArray = new ByteArray();
			var inStream:FileStream = new FileStream();
			inStream.open(file, FileMode.READ);
			inStream.readBytes(data, 0, data.length);
			inStream.close();

			var ml:MultipartURLLoader = new MultipartURLLoader();
			ml.addVariable("uname", ApplicationConfig.instance.getSetting("twitterUsername"));
			ml.addVariable("upass", ApplicationConfig.instance.getSetting("twitterPassword"));
			ml.addVariable("apikey", APIKey);
			if (_message)
			{
				ml.addVariable("message", _message);
				//ml.addVariable("privacy", "public");
			}
			else
			{
				ml.addVariable("message", "");
				//ml.addVariable("privacy", "private");
			}
			ml.addVariable("privacy", "public");
			ml.addFile(data, "screenshot.jpg", "image", "image/jpeg");
			ml.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, uploadCompleteDataHandler); // never catched
			ml.load('http://screentweet.com/api/uploadandpost/');
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

		public static function get instance():ScreenTweet
		{
			if (!_instance)
			{
				_instance = new ScreenTweet();
			}
			return _instance;
		}

	}
}