package com.gnstudio.nabiro.utilities.pdf.qad
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
	 *   @author 					Igor Varga [ i.varga@gnstudio.com ]
	 *	 
	 */
	
	import com.gnstudio.nabiro.utilities.pdf.PDFFont;
	
	import flash.utils.ByteArray;

	public class PDFObject
	{
		
		private var _id:String;
		private var _bytes:ByteArray;
		
		public function PDFObject()
		{
			_bytes = new ByteArray();
		}

		public function get objectData():ByteArray
		{
			return _bytes;
		}
		
		public function set objectData( bytes:ByteArray ):void
		{
			bytes.position = 0;
			_bytes.writeBytes( bytes );
		}

		public function get id():String
		{
			return _id;
		}

		public function set id(v:String):void
		{
			_id = v;
		}
	}
}
