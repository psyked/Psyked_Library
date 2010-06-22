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
	
	public class GIFSize extends ByteArray implements IGetImageSize
	{
		
		private var _height:Number;
		private var _width:Number;
		
		public function GIFSize(){
			
			endian = Endian.BIG_ENDIAN;
			
			_width = 0;
			_height = 0;
			
		}
		
		public function extractSize():Rectangle{
			
			
			position = 6;
			
			// the structure of the gif is this:
			// in the first 6 position there is a description of the gif type
			// in 7 and 8 we can find the width
			// in 8 and 9 we can find the height
			
			// obviusly width and height are expressed in hex;
			// so to take the value of the width
			// we need to store the first value somewhere 
			// then we must take the second value and sum to the first one 
			// we can sum hex using bitwise operators with this we shift the value of 8 bytes so :
			
			// byte7 = this.readUnsignedByte(); // byte7 = 0x11 (17 in a more redable format)
			// byte8 = this.readUnsignedByte()  // byte8 = 0x03 
			// byte8 = byte8 << 8 // byte8 = 0x03 00 (768 in a more redable format)
			// _width = byte7 + byte8 // width = 0x03 11 (785 in a more redable format)
			
			_width = this.readUnsignedByte();
			_width += this.readUnsignedByte()  << 8
			
			
			_height = this.readUnsignedByte();
			_height += this.readUnsignedByte() << 8;
			
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