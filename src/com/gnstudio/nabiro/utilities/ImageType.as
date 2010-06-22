package com.gnstudio.nabiro.utilities
{
	import flash.utils.ByteArray;
	
	public class ImageType extends ByteArray implements IGetImageType
	{
		
		public static var GIF:String = "gif";
		public static var JPG:String = "jpg";
		public static var PNG:String = "png";
		
		private var _type:String;
		
		public function ImageType() {
			
		}
		
		public function extractType():String{
			
			position  = 0;
			
	       	var b1:int = readByte() & 0xFF;
		   	var b2:int = readByte() & 0xFF;
		
			if (b1 == 0xFF && b2 == 0xD8) {
				
				_type = JPG;
				
			}else if (b1 == 0x89 && b2 == 0x50) {
				
		    	_type = PNG;
		    	
			}else if (b1 == 0x47 && b2 == 0x49) {
				
				_type = GIF;
				
			}else{
			
				throw(new Error('The specified data type is not allowed, use only JPG, PNG or GIF files',0))
				
			}
			
			return _type;
		
		}
		
		public function get type():String{
			
			return _type;
		
		}
		
		
	   
	}
}