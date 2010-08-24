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
		public var thumbnailByteArray:ByteArray;
		public var thumbnailBitmapData:BitmapData;
		public var originalFile:FileReference;
		public var data:Object;
		public var resizeDeclaration:ResizeDeclaration;
		public var rotation:int;
	}
}