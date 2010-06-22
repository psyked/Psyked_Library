package com.gnstudio.nabiro.ui.images.utils
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	
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
	
	public class OutputLevels
	{
		
		private const MID_POINT:uint = 127;
		
		private var _midPoint:uint;
		
		public function OutputLevels(midPoint:uint = MID_POINT){
			
			_midPoint = midPoint;
			
		}
		
		public function setLevels(bitmapData:BitmapData, blackPoint:uint, whitePoint:uint):BitmapData{
			
			var r:Array = [];
			var g:Array = [];
			var b:Array = [];

			for (var i:uint = 0; i <= blackPoint; i++){
				
				r.push(0);
				g.push(0);
				b.push(0);

			}

			var value:uint = 0;
			var range:uint = _midPoint - blackPoint;

			for (i = blackPoint + 1; i <= _midPoint; i++){

				value = ((i - blackPoint)/range) * 127;
				r.push(value << 16);
				g.push(value << 8);
				b.push(value);

			}

			range = whitePoint - _midPoint;

			for (i = _midPoint + 1; i <= whitePoint; i++){

				value = ((i - _midPoint)/range) * 128 + 127;

				r.push(value << 16);
				g.push(value << 8);
				b.push(value);

			}

			for (i = whitePoint + 1; i < 256; i++){

				r.push(0xFF << 16);
				g.push(0xFF << 8);
				b.push(0xFF);

			}

			bitmapData.paletteMap(bitmapData, bitmapData.rect, new Point(),	r, g, b);
			
			return bitmapData;
			
		}

	}
}