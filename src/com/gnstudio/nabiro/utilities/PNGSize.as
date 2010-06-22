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
	
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class PNGSize extends ByteArray implements IGetImageSize
	{
		
		private var _height:Number;
		private var _width:Number;
		
		public function PNGSize(){
			
			endian = Endian.BIG_ENDIAN;
			
			_width = 0;
			_height = 0;
			
		}
		
		public function extractSize():Rectangle{
			
			position = 16
			_width += this.readUnsignedByte() << 24;
			
			position = 17
			_width += this.readUnsignedByte() << 16;
			
			position = 18
			_width += this.readUnsignedByte() << 8;
			
			position = 19
			_width += this.readUnsignedByte();
			
			position = 20
			_height += this.readUnsignedByte() << 24;
			
			position = 21
			_height += this.readUnsignedByte() << 16;
			
			position = 22
			_height += this.readUnsignedByte() << 8;
			
			position = 23
			_height += this.readUnsignedByte();
			
			position = 0;
			
			return new Rectangle(0, 0, _width, height);
			
		}
		

		
		/**
		 * The width of the parsed image 
		 */
		public function get width():uint {
			
			return _width;
		
		}
		
		/**
		 * The height of the parsed image 
		 */
		public function get height():uint {
			
			return _height;
		
		}
		
		private function getShortBigEndian(ba:ByteArray,offset:int):Number{

			return ba[offset]<<8|ba[offset+1];

		}



		private function getShortLittleEndian(ba:ByteArray,offset:int):int{

			return ba[offset]|ba[offset+1]<<8;

		}



		private function getIntBigEndian(ba:ByteArray,offset:int):int{

			return ba[offset]<<24|ba[offset+1]<<16|ba[offset+2]<<8|ba[offset+3];

		}

	}

}