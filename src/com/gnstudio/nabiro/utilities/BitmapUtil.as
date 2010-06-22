package com.gnstudio.nabiro.utilities
{
	/**
	 *
	 * GNstudio nabiro
	 * =====================================================================
	 * Copyright(c) 2009
	 * http://www.gnstudio.com
	 *
	 *
	 *
	 * This file is part of the nabiro flash platform framework
	 *
	 *
	 * nabiro is free software; you can redistribute it and/or modify
	 * it under the terms of the GNU Lesser General Public License as published by
	 * the Free Software Foundation; either version 3 of the License, or
	 * at your option) any later version.
	 *
	 * nabiro is distributed in the hope that it will be useful,
	 * but WITHOUT ANY WARRANTY; without even the implied warranty of
	 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	 * GNU General Public License for more details.
	 *
	 * You should have received a copy of the GNU Lesser General Public License
	 * along with Intelligere SCS; if not, write to the Free Software
	 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
	 * =====================================================================
	 *
	 *
	 *
	 *   @package  nabiro
	 *
	 *   @version  0.9
	 *   @idea maker 			Giorgio Natili [ g.natili@gnstudio.com ]
	 *   @author 					Giorgio Natili [ g.natili@gnstudio.com ]
	 *   
	 *	 
	 */
	
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    import flash.utils.ByteArray;
    
    import mx.graphics.codec.JPEGEncoder;
    import mx.graphics.codec.PNGEncoder;

    public class BitmapUtil
    {
    	
    	public static const THUMBNAIL_WIDTH:Number = 120;
		public static const THUMBNAIL_HEIGHT:Number = 120;
    	
        public static function generateThumbnail(bmp:BitmapData, w:Number = THUMBNAIL_WIDTH, h:Number = THUMBNAIL_HEIGHT, crop:Boolean = false):BitmapData{
        	
            var scale:Number = 1.0;
            
            if( bmp.width > w || bmp.height > h ){
            	
                scale = Math.min( w / bmp.width, h / bmp.height );
            
            }
            
            var m:Matrix = new Matrix();
            m.scale( scale, scale );

            if(!crop){
            	
                m.tx = ( w / 2 ) - ( ( bmp.width * scale ) / 2 );
                m.ty = ( h / 2 ) - ( ( bmp.height * scale ) / 2 );
            
            }else{
                
                w = bmp.width * scale;
                h = bmp.height * scale;
            
            }

            var bmd:BitmapData = new BitmapData( w, h, true );
            bmd.draw( bmp, m );
            
            return bmd;
            
        }
        
        public static function capture(target:DisplayObject, format:String):ByteArray{

			var relative:DisplayObject = target.parent;			
			var rect:Rectangle = target.getBounds(relative);
						
			var bitmapData:BitmapData = new BitmapData(rect.width, rect.height);
						
			bitmapData.draw(relative, new Matrix(1, 0, 0, 1, -rect.x, -rect.y ));
				
			var byteArray:ByteArray;
			
			switch (format){
					
				case "JPG":
				var jpgEncoder:JPEGEncoder = new JPEGEncoder(80);
				byteArray = jpgEncoder.encode(bitmapData);
				break;
							
				case "PNG":
				var pngEncoder:PNGEncoder = new PNGEncoder()
				byteArray = pngEncoder.encode(bitmapData);
				break;
				
				default:
				byteArray = bitmapData.getPixels(rect);
				break;
			
			}
				
			return byteArray;	
			
        }
				
    }
}
