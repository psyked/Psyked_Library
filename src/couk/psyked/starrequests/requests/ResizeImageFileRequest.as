package couk.psyked.starrequests.requests
{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Rectangle;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import mx.collections.ArrayCollection;
	import mx.effects.Resize;
	import mx.graphics.ImageSnapshot;
	import cmodule.jpegencoder.CLibInit;
	import couk.markstar.starrequests.requests.AbstractRequest;
	import couk.markstar.starrequests.requests.IRequest;
	import couk.psyked.starrequests.requests.vo.ResizeImageFileRequestVO;
	import couk.psyked.starrequests.requests.vo.ResizeDeclaration;
	import couk.psyked.utils.BitmapManager;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import spark.primitives.Rect;

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

			var alchemyEncoder:CLibInit = new CLibInit();
			lib = alchemyEncoder.init();

			baout = new ByteArray();
			
			//trace( data, file.name );
			returnObject = new ResizeImageFileRequestVO();
			returnObject.originalFile = file;
			returnObject.originalFile.addEventListener( ProgressEvent.PROGRESS, fileReferenceLoadProgressListener );
			returnObject.originalFile.addEventListener( Event.COMPLETE, fileReferenceLoadCompleteListener );
			returnObject.originalFile.addEventListener( IOErrorEvent.IO_ERROR, loadIOErrorListener );
			//returnObject.data = data.clone();
			returnObject.resizeDeclaration = data.clone();

			//_file = file;
			_completedSignal = new Signal( ResizeImageFileRequestVO );
			_failedSignal = new Signal( String );

		/*_loader = new Loader();
		   _loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, fileReferenceLoadProgressListener );
		   _loader.contentLoaderInfo.addEventListener( Event.COMPLETE, fileReferenceLoadCompleteListener );
		 _loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, fileReferenceLoadIOErrorListener );*/
		}

		protected var ALLOWED_FILE_TYPES:Array = [ "jpg", "gif", "png", "jpeg" ];

		//protected var _file:File;

		//protected var _loader:Loader;

		protected var baout:ByteArray;

		protected var lib:Object;

		protected var returnObject:ResizeImageFileRequestVO;

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

			trace( "returnObject.originalFile.type =", returnObject.originalFile.type );

			//
			// Note: File type returns the extension with a "." included - whereas extension doesn't use the same.
			// We should just remove the "."'s from the extension before checking against it.
			// We can also check against lowercase because we only put things into the types listing in lowercase.
			//
			var fixedFileType:String = returnObject.originalFile.type.toLowerCase().split( "." ).join( "" );

			if ( returnObject.originalFile.type && checkArrayCollection.contains( fixedFileType ))
			{
				//
				// if the filetype is supported
				//
				/*if ( !returnObject.originalFile.data )
				   {
				   // if the file data is not already loaded
				   _loader.load( new URLRequest( returnObject.originalFile[ "url" ]));
				   }
				   else
				 {*/
				returnObject.originalFile.load();
				/*}*/
			}
			else
			{
				//
				// if the filetype is not supported, throw an error signal.
				//
				trace( "Dispatching a failed signal." );
				_failedSignal.dispatch( "Resize failed because the filetype is not supported." );
			}
		}

		protected function alchemyEncodingCompleteFunction( ba:ByteArray ):void
		{
			//trace( "alchemyEncodingCompleteFunction" );
			//trace( ResizeDeclaration( returnObject.data ).newFilename );
			//trace( returnObject.originalFile.name );
			//trace( ResizeDeclaration( returnObject.data ).newFilename );
			//
			// copy the resized, encoded bytearray data into the return object
			//
			returnObject.thumbnailByteArray = ba;

			/*var location:File = File.documentsDirectory.resolvePath( "ImageSizer Output Files/" + returnObject.resizeDeclaration.newFilename );
			   //trace( location.url, location.nativePath );
			   var fs:FileStream = new FileStream();
			   fs.open( location, FileMode.WRITE );
			   fs.writeBytes( ba );
			 fs.close();*/

			_progressSignal.dispatch( 1 );
			_completedSignal.dispatch( returnObject );
			//cleanup();
		}

		override protected function cleanup():void
		{
			super.cleanup();

			/*			_loader.contentLoaderInfo.removeEventListener( ProgressEvent.PROGRESS, fileReferenceLoadProgressListener );
			   _loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, fileReferenceLoadCompleteListener );
			   _loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, fileReferenceLoadIOErrorListener );
			 _loader = null;*/
			returnObject.originalFile.removeEventListener( ProgressEvent.PROGRESS, fileReferenceLoadProgressListener );
			returnObject.originalFile.removeEventListener( Event.COMPLETE, fileReferenceLoadCompleteListener );
			returnObject.originalFile.removeEventListener( IOErrorEvent.IO_ERROR, loadIOErrorListener );
			returnObject = null;
			//lib = null;
		}

		/**
		 * When the filereference has been loaded, we can take the ByteArray and pump
		 * it into the Alchemy encoding library.
		 *
		 * @private
		 */
		protected function fileReferenceLoadCompleteListener( e:Event ):void
		{
			//trace( "completeListener", e );
			//trace( returnObject.originalFile.name );
			//var loaderInfo:LoaderInfo = LoaderInfo( e.currentTarget );
			var fileRef:FileReference = FileReference( e.currentTarget );
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, loaderLoadCompleteListener );
			loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, loadIOErrorListener );
			loader.loadBytes( fileRef.data );
		}

		/**
		 * @private
		 */
		protected function fileReferenceLoadProgressListener( e:ProgressEvent ):void
		{
			//trace( "progressListener", e );
			_progressSignal.dispatch( e.bytesLoaded / e.bytesTotal );
		}

		/**
		 * @private
		 */
		protected function loadIOErrorListener( e:IOErrorEvent ):void
		{
			//trace( "ioErrorListener", e );
			trace( "IOErrorEvent: Dispatching a failed signal." );
			_failedSignal.dispatch( e.text );
			//cleanup();
		}

		protected function loaderLoadCompleteListener( e:Event ):void
		{
			var loaderInfo:LoaderInfo = ( e.currentTarget as LoaderInfo );

			baout = new ByteArray();

			//
			// work out the resizing and transformations we need to apply to the loader object bitmapdata
			//
			var widthRatio:Number;
			var heightRatio:Number;
			var ratio:Number;

			widthRatio = returnObject.resizeDeclaration.maxWidth / loaderInfo.content.width;
			heightRatio = returnObject.resizeDeclaration.maxHeight / loaderInfo.content.height;
			ratio = ( widthRatio < heightRatio ) ? widthRatio : heightRatio;

			trace( "Resizing bitmapdata by " + ( ratio * 100 ) + "%" );

			//
			// check if the loaded image data has valid dimensions
			//
			if ( loaderInfo.content && loaderInfo.content.width && loaderInfo.content.height )
			{
				//
				// resize the bitmapdata up/down to the target dimensions
				//
				var bmd:BitmapData = BitmapManager.resampleBitmapData( ImageSnapshot.captureBitmapData( loaderInfo.content ), ratio );

				//
				// create the output objects and start encoding
				//
				var ba:ByteArray = new ByteArray();
				var newRect:Rectangle = new Rectangle( 0, 0, returnObject.resizeDeclaration.maxWidth, returnObject.resizeDeclaration.maxHeight );

				ba = bmd.getPixels( newRect );
				ba.position = 0;
				lib.encodeAsync( alchemyEncodingCompleteFunction, ba, baout, bmd.width, bmd.height, 100 );

				//
				// copy the resized bitmapdata into the return object
				//
				returnObject.thumbnailBitmapData = bmd;
			}
			else
			{
				//trace( "Dispatching a failed signal #2." );
				_failedSignal.dispatch( "Invalid Bitmap Data loaded." );
			}
		}
	}
}