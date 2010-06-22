package com.gnstudio.nabiro.ui.images.utils
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

	 import __AS3__.vec.Vector;

	public class LuminanceHelper
	{


		public static const RED_Y:Number   = .2126;
		public static const GREEN_Y:Number = .7152;
		public static const BLUE_Y:Number  = .0722;

		public static function luminance(vector : Vector.<Vector.<Number>>):Vector.<Number>{

			var total : Vector.<Number> = new Vector.<Number>( 256 );
			var pY:Number;

			// Y comp = red * 0.2126 + green * 0.7152 + blue 0.0722

			for (var i:int = 0 ; i < 256; i++ ) {

				pY = LuminanceHelper.RED_Y * vector[0][i];
				pY += LuminanceHelper.GREEN_Y * vector[1][i];
				pY += LuminanceHelper.BLUE_Y * vector[2][i];

				total[i] = pY;
			}

			/*
			for (var i:int = 0 ; i < 3; i++ ) {

				for (var j : int = 0 ; j < 256; j++ ) {

					if ( !total[ j ] ){

						total[ j ] = 0;

					}

					total[ j ] += vector[ i ][ j ];
				}
			}
			*/

			return( total );

		}

	}


}
