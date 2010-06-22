
package com.gnstudio.nabiro.ui.images {

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
	 *   @author 					Marco Fusetti [ m.fusetti@gnstudio.com ]
	 *   
	 *	 
	 */


	import com.gnstudio.nabiro.ui.images.utils.RedEyeImageData;
	
	import flash.utils.*;
	

	public class RedEyeRemover {

		/**
		private static var RED_FACTOR:Number = 0.5133333;
		private static var GREEN_FACTOR:Number = 1;
		private static var BLUE_FACTOR:Number = 0.1933333;
		*/

		// public function RedEyeRemoverFX() {}


		public static function remove_red(reid:RedEyeImageData):ByteArray {

			reid.pixelBlock.position = 0;
			var destBA:ByteArray = new ByteArray();

			for (var y:int = 0; y < reid.height; y++) {

				for (var x:int = 0; x < reid.width; x++) {

					var alpha:uint = reid.pixelBlock.readUnsignedByte();
					var red:uint = reid.pixelBlock.readUnsignedByte();
					var green:uint = reid.pixelBlock.readUnsignedByte();
					var blue:uint = reid.pixelBlock.readUnsignedByte();

					var adjusted_red:int = Math.round(red * reid.red_factor);
					var adjusted_green:int = Math.round(green * reid.green_factor);
					var adjusted_blue:int = Math.round(blue * reid.blue_factor);

					if (adjusted_red >= adjusted_green - reid.threshold && adjusted_red >= adjusted_blue - reid.threshold){
						red = Math.round((adjusted_green + adjusted_blue) / (2.0 * reid.red_factor));
					}

					destBA.writeByte(alpha); // alpha
					destBA.writeByte(red);
					destBA.writeByte(green);
					destBA.writeByte(blue);
				}
			}

			destBA.position = 0;
			return destBA;
		}
	}
}
