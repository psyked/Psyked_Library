package couk.psyked.starrequests.requests.vo
{

	public class ResizeDeclaration
	{
		public function ResizeDeclaration()
		{
			// init & default
		}

		public var cropToFit:Boolean;

		public var forceRotateToLandscape:Boolean;

		public var forceRotateToPortrait:Boolean;

		public var maxHeight:int;

		public var maxWidth:int;

		public var minHeight:int;

		public var minWidth:int;

		public var name:String;

		public var newFilename:String;

		public var rotateToBestFit:Boolean;

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
			rtn.name = this.name;
			rtn.newFilename = this.newFilename;
			rtn.rotateToBestFit = this.rotateToBestFit;
			return rtn;
		}
	}
}