package couk.psyked.starrequests.requests
{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	/*import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;*/
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import mx.collections.ArrayCollection;
	import mx.effects.Resize;
	import mx.graphics.ImageSnapshot;
	import cmodule.jpegencoder.CLibInit;
	import couk.markstar.starrequests.requests.AbstractRequest;
	import couk.markstar.starrequests.requests.IRequest;
	import couk.psyked.starrequests.requests.vo.GenerateThumbnailBitmapDataRequestVO;
	import couk.psyked.starrequests.requests.vo.ResizeDeclaration;
	import couk.psyked.utils.BitmapManager;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	/**
	 * The idea behind this class is that it would be more efficient to display a
	 * thumbnail version of an image (like, 120x120 pixels) rather than a full-on 3000x3000
	 * pixel image.  This request will load a specified file and generate a thumbnail version
	 * of the image to use.  The ByteArray it returns is the JPEG-encoded bitmap data for the
	 * thumbnail.
	 *
	 * Ideally you'd store the thumbnail in a cache file somewhere, to save having to generate
	 * the thumbnail over and over again.  This class Request makes use of an Alchemy JPEG encoder
	 * class to do its encoding faster, but makes use of some pure AS3 classes that leverage the
	 * guts of the Flash Player to resample the bitmap data to the requested size.
	 *
	 * If you pass a string of these commands in a syncronous queue it's a real shit for
	 * memory consumption, but it does clean up after itself when it's done.
	 */
	public class ResizeImageFileRequest extends AbstractRequest
	{
		public function ResizeImageFileRequest( file:FileReference, data:ResizeDeclaration )
		{
			//trace( data, file.name );
			returnObject = new GenerateThumbnailBitmapDataRequestVO();
			returnObject.originalFile = file;
			//returnObject.data = data.clone();
			returnObject.resizeDeclaration = data.clone();

			var alchemyEncoder:CLibInit = new CLibInit();
			lib = alchemyEncoder.init();

			baout = new ByteArray();

			//_file = file;
			_completedSignal = new Signal( GenerateThumbnailBitmapDataRequestVO );
			_failedSignal = new Signal( String );

			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, fileReferenceLoadProgressListener );
			_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, fileReferenceLoadCompleteListener );
			_loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, fileReferenceLoadIOErrorListener );
		}

		protected var ALLOWED_FILE_TYPES:Array = [ "jpg", "gif", "png", "jpeg" ];

		//protected var _file:File;

		protected var _loader:Loader;

		protected var baout:ByteArray;

		protected var lib:Object;

		protected var returnObject:GenerateThumbnailBitmapDataRequestVO;

		override public function get completedSignal():ISignal
		{
			return super.completedSignal;
		}

		override public function send():void
		{
			super.send();

			var checkArrayCollection:ArrayCollection = new ArrayCollection( ALLOWED_FILE_TYPES );

			//trace( "_file.extension", _file.extension );
			//trace( "checkArrayCollection.contains( _file.extension )", checkArrayCollection.contains( _file.extension ));

			//if ( returnObject.originalFile.extension && checkArrayCollection.contains( returnObject.originalFile.extension.toLowerCase()))
			if ( returnObject.originalFile.type && checkArrayCollection.contains( returnObject.originalFile.type.toLowerCase()))
			{
				if ( !returnObject.originalFile.data )
				{
					_loader.load( new URLRequest( returnObject.originalFile[ "url" ]));
				}
				else
				{
					returnObject.originalFile.load();
				}
			}
			else
			{
				alchemyEncodingCompleteFunction( new ByteArray());
			}
		}

		override protected function cleanup():void
		{
			super.cleanup();

			_loader.contentLoaderInfo.removeEventListener( ProgressEvent.PROGRESS, fileReferenceLoadProgressListener );
			_loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, fileReferenceLoadCompleteListener );
			_loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, fileReferenceLoadIOErrorListener );
			_loader = null;
		}

		/**
		 * @private
		 */
		protected function fileReferenceLoadCompleteListener( e:Event ):void
		{
			trace( "completeListener", e );
			trace( returnObject.originalFile.name );
			var loaderInfo:LoaderInfo = LoaderInfo( e.currentTarget );

			baout = new ByteArray();

			var widthRatio:Number;
			var heightRatio:Number;
			var ratio:Number;

			widthRatio = returnObject.resizeDeclaration.maxWidth / loaderInfo.content.width;
			heightRatio = returnObject.resizeDeclaration.maxHeight / loaderInfo.content.height;
			ratio = ( widthRatio < heightRatio ) ? widthRatio : heightRatio;

			if ( loaderInfo.content && loaderInfo.content.width && loaderInfo.content.height )
			{
				var bmd:BitmapData = BitmapManager.resampleBitmapData( ImageSnapshot.captureBitmapData( loaderInfo.content ), ratio );
				var ba:ByteArray = new ByteArray();
				ba = bmd.getPixels( bmd.rect );
				ba.position = 0;
				lib.encodeAsync( alchemyEncodingCompleteFunction, ba, baout, bmd.width, bmd.height, 100 );

				returnObject.thumbnailBitmapData = bmd;
			}
			else
			{
				_failedSignal.dispatch( "Invalid Bitmap Data loaded." );
			}
		}

		/**
		 * @private
		 */
		protected function fileReferenceLoadIOErrorListener( e:IOErrorEvent ):void
		{
			trace( "ioErrorListener", e );
			_failedSignal.dispatch( e.text );
			cleanup();
		}

		/**
		 * @private
		 */
		protected function fileReferenceLoadProgressListener( e:ProgressEvent ):void
		{
			trace( "progressListener", e );
			_progressSignal.dispatch( e.bytesLoaded / e.bytesTotal );
		}

		private function alchemyEncodingCompleteFunction( ba:ByteArray ):void
		{
			//trace( "alchemyEncodingCompleteFunction", ba );
			//trace( ResizeDeclaration( returnObject.data ).newFilename );
			//trace( returnObject.originalFile.name );
			//trace( ResizeDeclaration( returnObject.data ).newFilename );
			returnObject.thumbnailByteArray = ba;

			/*var location:File = File.documentsDirectory.resolvePath( "ImageSizer Output Files/" + returnObject.resizeDeclaration.newFilename );
			//trace( location.url, location.nativePath );
			var fs:FileStream = new FileStream();
			fs.open( location, FileMode.WRITE );
			fs.writeBytes( ba );
			fs.close();*/

			_progressSignal.dispatch( 1 );
			_completedSignal.dispatch( returnObject );
			cleanup();
		}
	}
}