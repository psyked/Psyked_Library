package com.gnstudio.nabiro.ui.images
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
	
	import mx.controls.Image;
	import flash.filters.ColorMatrixFilter;
	
	/**
	 * As the name hints, this parameter defines whether the image should be greyscaled or not
	 * @default false
	 **/
	[Style(name = "greyscale", type = "Boolean")]
			
	/**
	 * Tints the image using the color defined in this style
	 * @default #000000
	 **/
	[Style(name = "tintColor", type = "Number", format = "Color")]

	public class GreyscaleImage extends Image
	{
		
		/**
		 * Greyscale ColorMatrixFilter
		 * @private
		 */
		private const GREY_MATRIX: ColorMatrixFilter = new ColorMatrixFilter( [.33, .33, .33, 0, 0, .33, .33, .33, 0, 0, .33, .33, .33, 0, 0, .33, .33, .33, 1, 0] );

		/**
		 * Backup of the last value of the style "greyscale"
		 * @default false
		 * @private
		 */
		private var _greyscale: Boolean = false;
			
		/**
		 * Backup of the last value of the style "tintColor"
		 * @default #000000
		 * @private
		 */
		private var _tintColor: Number = 0x000000;
		
		public function GreyscaleImage()
		{
			super();
		}
		
		/**
		 * Extracts the red component of an RGB color Number.
		 * @param	color   The RGB color
		 * @return          The [0.255] value of the red component
		 * @private
		 */
		private function Red(color: Number): Number {
				
			return ((color & 0xFF0000) >>> 16) / 255;
				
		}

		/**
		 * Extracts the red component of an RGB color Number.
		 * @param	color   The RGB color
		 * @return          The [0.255] value of the red component
		 * @private
		 */
		private function Green(color: Number): Number {
				
			return ((color & 0x00FF00) >>> 8) / 255;
				
		}

		/**
		 * Extracts the red component of an RGB color Number.
		 * @param	color   The RGB color
		 * @return          The [0.255] value of the red component
		 * @private
		 */
		private function Blue(color: Number): Number {
				
			return (color & 0x0000FF) / 255;
				
		}

		/**
		 * Updates the image manipulations
		 * @param	unscaledWidth   The width, in pixels, of this object before any scaling
		 * @param	unscaledHeight  The height, in pixels, of this object before any scaling
		 */
		override protected function updateDisplayList(unscaledWidth: Number, unscaledHeight: Number): void {
			
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			var greyscale: Boolean = (getStyle('greyscale') != undefined) ? Boolean(getStyle('greyscale')) : false;
			var tintColor: Number = (getStyle('tintColor') != undefined) ? Number(getStyle('tintColor')) : 0x000000;
				
			if (greyscale) {
					
				filters = [GREY_MATRIX]
				
			} else if (tintColor > 0) {
					
				filters = [ new ColorMatrixFilter([
							Red(tintColor), 0, 0, 0, 0,
							0, Green(tintColor), 0, 0, 0,
							0, 0, Blue(tintColor), 0, 0,
							0, 0, 0, 1, 0
							]) ];
					
			} else {
					
				filters = [];
					
			}
			
		}

		
	}
}