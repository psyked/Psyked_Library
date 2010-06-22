package com.gnstudio.nabiro.ui
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
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	
	import mx.controls.Image;
	import mx.core.FlexLoader;
	
	
	public class CenteredImage extends Image {
		
		public var lastMeasuredWidtht:Number = 0;
		public var lastMeasuredHeight:Number = 0;
		
		/**
		* Constructor
		*/ 	
		public function CenteredImage()	{
		
			super();
			
		}
		
		public function clean():void{
			
			if (content){				
				
				if(content.parent is FlexLoader){
					
					var contentHolder:Loader = content.parent as Loader;
	
					contentHolder.unload();
					
				}else{
					
					var bitmpapHolder:Bitmap = content as Bitmap;
					
					bitmpapHolder
					
				}
							
				
			}
			
		}

		/**
		* override updateDisplayList
	 	* center the contentHolder inside the Image component
	 	* @param w Number
	 	* @param h Number
	 	*/
		override protected function updateDisplayList(w:Number, h:Number):void {
		
			super.updateDisplayList(w, h);			
			
			if (content){				
				
				var skinClass:Class = getStyle("brokenImageBorderSkin");
					
				if(content is skinClass){
					
					content.x = w / 2;
					content.y = h / 2;
					
				}else if(content.parent is FlexLoader){
					
					var contentHolder:Loader = content.parent as Loader;
	
					contentHolder.x = (w - (contentHolder.contentLoaderInfo.width*contentHolder.scaleX)) / 2;
					contentHolder.y = (h - (contentHolder.contentLoaderInfo.height*contentHolder.scaleY)) / 2;
					
				}else{
					
					var bitmpapHolder:Bitmap = content as Bitmap;
					
					content.x = (w - (bitmpapHolder.bitmapData.width*content.scaleX)) / 2;
					content.y = (h - (bitmpapHolder.bitmapData.height*content.scaleY)) / 2;
					
					
				}
							
				
			}

			lastMeasuredHeight = getExplicitOrMeasuredHeight();
			lastMeasuredWidtht = getExplicitOrMeasuredWidth();
			
			
		}

	}

}