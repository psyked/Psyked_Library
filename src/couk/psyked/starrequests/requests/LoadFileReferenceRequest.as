package couk.psyked.starrequests.requests
{
	import flash.events.Event;
	import flash.net.FileReference;
	import couk.markstar.starrequests.requests.AbstractRequest;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	public class LoadFileReferenceRequest extends AbstractRequest
	{
		public function LoadFileReferenceRequest( _fileRef:FileReference )
		{
			fileRef = _fileRef;
			_completedSignal = new Signal( FileReference );
		}

		protected var fileRef:FileReference;

		override public function get completedSignal():ISignal
		{
			return super.completedSignal;
		}

		override public function send():void
		{
			super.send();

			fileRef.addEventListener( Event.COMPLETE, onFileLoadComplete );
			fileRef.load();
		}

		protected function onFileLoadComplete( e:Event ):void
		{
			fileRef.removeEventListener( Event.COMPLETE, onFileLoadComplete );
			_completedSignal.dispatch( fileRef );
		}
	}
}