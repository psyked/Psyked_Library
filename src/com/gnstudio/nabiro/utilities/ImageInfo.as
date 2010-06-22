package com.gnstudio.nabiro.utilities
{
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	public class ImageInfo implements IGetImageType,IGetImageSize
	{
		
		private var _byteArray:ByteArray;
		
		private var _width:uint;
		private var _height:uint;
		private var _type:String;
		
		
		
		public function ImageInfo(b:ByteArray)
		{
			_byteArray = b;
		}
		
		public function extractType():String{
			
			_byteArray.position = 0;
			var fileData:ImageType = new ImageType();
			_byteArray.readBytes(fileData, 0, _byteArray.bytesAvailable);
			fileData.position = 0;
	        _type = fileData.extractType()
	      
	       _byteArray.position = 0;
	        return _type;
			
		}
		
		public function extractSize():Rectangle{
			
			if(!_type){
				
				extractType();
			
			}
			_byteArray.position = 0;
			
			if(_type == ImageType.PNG){
			 	
				var pngData:PNGSize = new PNGSize();
				_byteArray.readBytes(pngData, 0, _byteArray.bytesAvailable);
				pngData.position = 0;
		        pngData.extractSize();
				_width = pngData.width;
				_height = pngData.height;
			
			 }else if(_type == ImageType.JPG){
				
				var jpgData:JPGSize = new JPGSize();
				_byteArray.readBytes(jpgData, 0, _byteArray.bytesAvailable);
				jpgData.position = 0;
		        jpgData.extractSize();
				_width = jpgData.width;
				_height = jpgData.height;
			
			}else if(_type == ImageType.GIF){
				
				var gifData:GIFSize = new GIFSize();
				_byteArray.readBytes(gifData, 0, _byteArray.bytesAvailable);
				gifData.position = 0;
		        gifData.extractSize();
				_width = gifData.width;
				_height = gifData.height;
				
			}
			_byteArray.position = 0;
			return new Rectangle(0,0,_width,_height);
		
		}
		
		
		public function get type():String{
			
			return _type;
			
		}
		public function get width():uint{
			
			return _width
		}
		
		public function get height():uint{
		
			return _height;
		}
		
		
	}
}