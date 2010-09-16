package couk.psyked.starrequests.requests.vo
{
	import flash.display.BitmapData;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import mx.core.BitmapAsset;
	import mx.core.ByteArrayAsset;

	public class ResizeDeclaration
	{

		public static function parse( xml:XML ):ResizeDeclaration
		{
			var rtn:ResizeDeclaration = new ResizeDeclaration();
			rtn.cropToFit = xml.@croptofit = "true";
			rtn.forceRotateToLandscape = xml.@forcerotate == "landscape";
			rtn.forceRotateToPortrait = xml.@forcerotate == "portrait";
			rtn.maxHeight = parseInt( xml.@maxheight, 10 );
			rtn.maxWidth = parseInt( xml.@maxwidth, 10 );
			rtn.minHeight = parseInt( xml.@minheight, 10 );
			rtn.minWidth = parseInt( xml.@minwidth, 10 );
			rtn.rotation = parseInt( xml.@rotation, 10 );
			rtn.name = xml.name.text();
			rtn.rotateToBestFit = xml.@forcerotate == "best";
			rtn.thumbnailData = xml.imagedata[ 0 ].text() as BitmapData;
			return rtn;
		}

		public function ResizeDeclaration()
		{
			// init & default
		}

		public var cropToFit:Boolean;

		public var forceRotateToLandscape:Boolean;

		public var forceRotateToPortrait:Boolean;

		public var maxHeight:int = 400;

		public var maxWidth:int = 600;

		public var minHeight:int;

		public var minWidth:int;

		public var name:String = "Default Resize action";

		public var rotateToBestFit:Boolean;

		/**
		 * The angle of rotation for the images.  Currently built for 90 degree increments.
		 */
		public var rotation:int;

		public var thumbnailData:BitmapData;

		public function clone():ResizeDeclaration
		{
			var rtn:ResizeDeclaration = new ResizeDeclaration();
			rtn.cropToFit = this.cropToFit;
			rtn.forceRotateToLandscape = this.forceRotateToLandscape;
			rtn.forceRotateToPortrait = this.forceRotateToPortrait;
			rtn.maxHeight = this.maxHeight;
			rtn.maxWidth = this.maxWidth;
			rtn.minHeight = this.minHeight;
			rtn.minWidth = this.minWidth;
			rtn.rotation = this.rotation;
			rtn.name = this.name;
			rtn.rotateToBestFit = this.rotateToBestFit;
			rtn.thumbnailData = this.thumbnailData;
			return rtn;
		}

		public function getFileData():XML
		{
			var rtn:XML = new XML( "<resizedeclaration />" );
			rtn.@croptofit = ( this.cropToFit ) ? "true" : "false";
			rtn.@maxheight = this.maxHeight;
			rtn.@maxwidth = this.maxWidth;
			rtn.@minheight = this.minHeight;
			rtn.@minwidth = this.minWidth;
			rtn.@rotation = this.rotation;

			if ( this.rotateToBestFit )
			{
				rtn.forcerotate = "best";
			}
			else if ( this.forceRotateToLandscape )
			{
				rtn.forcerotate = "landscape";
			}
			else if ( this.forceRotateToPortrait )
			{
				rtn.forcerotate = "portrait";
			}
			rtn.appendChild( new XML( "<name>" + this.name + "</name>" ));

			if ( thumbnailData )
			{
				rtn.appendChild( new XML( "<imagedata>" + thumbnailData + "</imagedata>" ));
			}
			return rtn;
		}
	}
}