package couk.psyked.starrequests.requests.vo
{
	import flash.display.BitmapData;
	import flash.net.FileReference;
	import flash.utils.ByteArray;

	/**
	 * Return object for the image resampling / encoding functions, that contains
	 * ByteArray, BitmapData, File objects, and unspecified data objects for the 
	 * original command.
	 * 
	 * @author James
	 */
	public class ResizeImageFileRequestVO
	{
		/**
		 * 
		 * @default 
		 */
		public var thumbnailByteArray:ByteArray;
		/**
		 * 
		 * @default 
		 */
		public var thumbnailBitmapData:BitmapData;
		/**
		 * 
		 * @default 
		 */
		public var originalFile:FileReference;
		/**
		 * 
		 * @default 
		 */
		public var data:Object;
		/**
		 * 
		 * @default 
		 */
		public var resizeDeclaration:ResizeDeclaration;
	}
}