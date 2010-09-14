package couk.psyked.starrequests.requests.vo
{
	import flash.net.FileReference;

	public class ResizeDeclaration
	{
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
			return rtn;
		}
	}
}