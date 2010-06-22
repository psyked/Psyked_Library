package com.gnstudio.nabiro.utilities.pdf
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
	
	import __AS3__.vec.Vector;
	
	public class PDFPage
	{
		private var _width:uint;
		private var _height:uint;
		private var _images:Vector.<PDFImage>;

		public function PDFPage( )
		{

		}
		
		public function get width():uint
		{
			return _width;
		}

		public function set width(v:uint):void
		{
			_width = v;
		}
		
		public function get height():uint
		{
			return _height;
		}

		public function set height(v:uint):void
		{
			_height = v;
		}

		/**
		 * List of all images in the page
		 */
		public function get images():Vector.<PDFImage>
		{
			return _images;
		}
		
		public function set images( i:Vector.<PDFImage> ):void
		{
			_images = i;
		}
	}
}
