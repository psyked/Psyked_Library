package couk.psyked.starrequests.requests
{
	import cmodule.aircall.CLibInit;
	import cmodule.aircall.MState;
	import cmodule.aircall.gstate;
	
	import couk.markstar.starrequests.requests.AbstractRequest;
	import couk.psyked.starrequests.requests.vo.ResizeDeclaration;
	import couk.psyked.starrequests.requests.vo.ResizeImageFileRequestVO;
	import couk.psyked.utils.BitmapManager;
	
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.graphics.ImageSnapshot;
	
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
			init = new CLibInit();
			lib = init.init();

			baout = new ByteArray();

			returnObject = new ResizeImageFileRequestVO();
			returnObject.originalFile = file;
			returnObject.originalFile.addEventListener( ProgressEvent.PROGRESS, fileReferenceLoadProgressListener );
			returnObject.originalFile.addEventListener( Event.COMPLETE, fileReferenceLoadCompleteListener );
			returnObject.originalFile.addEventListener( IOErrorEvent.IO_ERROR, loadIOErrorListener );
			returnObject.resizeDeclaration = data.clone();
			returnObject.rotation = data.rotation;

			_completedSignal = new Signal( ResizeImageFileRequestVO );
			_failedSignal = new Signal( String );
		}

		protected var ALLOWED_FILE_TYPES:Array = [ "jpg", "gif", "png", "jpeg" ];

		protected var ba:ByteArray;

		protected var baout:ByteArray;

		protected var init:CLibInit;

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

			//trace( "returnObject.originalFile.type =", returnObject.originalFile.type );

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
				returnObject.originalFile.load();
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

		protected function alchemyEncodingCompleteFunction(out:ByteArray):void
		{
			trace( "alchemyEncodingCompleteFunction" );
			//trace( ResizeDeclaration( returnObject.data ).newFilename );
			//trace( returnObject.originalFile.name );
			//trace( ResizeDeclaration( returnObject.data ).newFilename );
			baout.position = 0;
			//
			// copy the resized, encoded bytearray data into the return object
			//
			returnObject.thumbnailByteArray = new ByteArray();
			returnObject.thumbnailByteArray.writeBytes( baout );

			ba.clear();

			_progressSignal.dispatch( 1 );
			_completedSignal.dispatch( returnObject );
		}

		override protected function cleanup():void
		{
			super.cleanup();

			returnObject.originalFile.removeEventListener( ProgressEvent.PROGRESS, fileReferenceLoadProgressListener );
			returnObject.originalFile.removeEventListener( Event.COMPLETE, fileReferenceLoadCompleteListener );
			returnObject.originalFile.removeEventListener( IOErrorEvent.IO_ERROR, loadIOErrorListener );
			returnObject = null;
		}

		/**
		 * When the filereference has been loaded, we can take the ByteArray and pump
		 * it into the Alchemy encoding library.
		 *
		 * @private
		 */
		protected function fileReferenceLoadCompleteListener( e:Event ):void
		{
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

			var matrix:Matrix = new Matrix();
			var rawbmd:BitmapData = ImageSnapshot.captureBitmapData( loaderInfo.content );
			var manualTransformedBitmapData:BitmapData;
			var finalTransformedBitmapData:BitmapData;

			//trace( "returnObject.rotation =", returnObject.rotation );

			if ( returnObject.rotation )
			{
				//trace( "Manually rotating the image by " + returnObject.rotation + " degrees" );
				matrix.translate( -loaderInfo.content.width / 2, -loaderInfo.content.height / 2 );
				matrix.rotate( returnObject.rotation * ( Math.PI / 180 ));
				loaderInfo.content.transform.matrix = matrix;
				matrix.translate( loaderInfo.content.width / 2, loaderInfo.content.height / 2 );
				//trace( "Raw:", rawbmd.width, rawbmd.height, "Bounds:", bounds.width, bounds.height );
				manualTransformedBitmapData = new BitmapData( loaderInfo.content.width, loaderInfo.content.height, false, 0x00000000 );
				manualTransformedBitmapData.draw( rawbmd, matrix );
				rawbmd = manualTransformedBitmapData.clone();
				matrix = new Matrix();
			}

			//
			// work out how we're going to rotate the bitmapdata.
			//
			//trace( loaderInfo.content.width, loaderInfo.content.height );

			if ( loaderInfo.content.width > loaderInfo.content.height )
			{
				// is landscape
				if ( returnObject.resizeDeclaration.forceRotateToPortrait )
				{
					//trace( "Forcing rotation to portrait" );
					matrix.translate( -rawbmd.width / 2, -rawbmd.height / 2 );
					matrix.rotate( 90 * ( Math.PI / 180 ));
					matrix.translate( rawbmd.height / 2, rawbmd.width / 2 );
					finalTransformedBitmapData = new BitmapData( rawbmd.height, rawbmd.width, false, 0x00000000 );
					finalTransformedBitmapData.draw( rawbmd, matrix );
				}
			}
			else if ( loaderInfo.content.width < loaderInfo.content.height )
			{
				// is portrait
				if ( returnObject.resizeDeclaration.forceRotateToLandscape )
				{
					//trace( "Forcing rotation to landscape" );
					matrix.translate( -rawbmd.width / 2, -rawbmd.height / 2 );
					matrix.rotate( 90 * ( Math.PI / 180 ));
					matrix.translate( rawbmd.height / 2, rawbmd.width / 2 );
					finalTransformedBitmapData = new BitmapData( rawbmd.height, rawbmd.width, false, 0x00000000 );
					finalTransformedBitmapData.draw( rawbmd, matrix );
				}
			}
			else
			{
				// is square
			}

			//loaderInfo.content.transform.matrix = matrix;
			if ( !finalTransformedBitmapData )
			{
				finalTransformedBitmapData = rawbmd;
			}
			var rawBitmapData:BitmapData = ImageSnapshot.captureBitmapData( finalTransformedBitmapData );
			//
			// work out the resizing and transformations we need to apply to the loader object bitmapdata
			//
			var widthRatio:Number;
			var heightRatio:Number;
			var ratio:Number;

			widthRatio = returnObject.resizeDeclaration.maxWidth / rawBitmapData.width;
			heightRatio = returnObject.resizeDeclaration.maxHeight / rawBitmapData.height;
			ratio = ( widthRatio < heightRatio ) ? widthRatio : heightRatio;

			//trace( "Resizing bitmapdata by " + ( ratio * 100 ) + "%" );

			//
			// check if the loaded image data has valid dimensions
			//
			if ( rawBitmapData && rawBitmapData.width && rawBitmapData.height )
			{
				//
				// resize the bitmapdata up/down to the target dimensions
				//
				var bmd:BitmapData = BitmapManager.resampleBitmapData( rawBitmapData, ratio );

				//
				// create the output objects and start encoding
				//
				ba = new ByteArray();
				//var newRect:Rectangle = new Rectangle( 0, 0, returnObject.resizeDeclaration.maxWidth, returnObject.resizeDeclaration.maxHeight );

				trace( bmd.rect );
				ba = bmd.getPixels( bmd.rect );

				//ba = bmd.getPixels( bmd.rect );
				ba.position = 0;

				//var alchemyEncoder:CLibInit = new CLibInit();
				//lib = alchemyEncoder.init();

				if ( baout )
				{
					baout.clear();
				}
				else
				{
					baout = new ByteArray();
				}
				//trace( bmd.width, bmd.height );
				//trace( ba, baout, bmd );
				lib.encodeAsync( alchemyEncodingCompleteFunction, ba, baout, bmd.width, bmd.height, 100, 100 );
				//lib.encode( ba, baout, bmd.width, bmd.height, 85 );
				//ba.clear();
				//trace( baout.length );
				//alchemyEncodingCompleteFunction( baout );
				//
				// copy the resized bitmapdata into the return object
				//
				returnObject.thumbnailBitmapData = bmd.clone();
			}
			else
			{
				//trace( "Dispatching a failed signal #2." );
				_failedSignal.dispatch( "Invalid Bitmap Data loaded." );
			}
		}
	}
}