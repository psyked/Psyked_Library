package com.gnstudio.nabiro.utilities.pdf.pdfbox.cos
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
	
	public class COSObject extends COSBase
	{
		private var _baseObject:COSBase;
		private var _objectNumber:COSInteger;
		private var _generationNumber:COSInteger;
    
		public function COSObject( object:COSBase )
		{
			_baseObject = object;
		}
		
		public function get baseObject():COSBase
		{
			return _baseObject;
		}

		public function set baseObject(v:COSBase):void
		{
			_baseObject = v;
		}

		public function get generationNumber():COSInteger
		{
			return _generationNumber;
		}

		public function set generationNumber(v:COSInteger):void
		{
			_generationNumber = v;
		}

		public function get objectNumber():COSInteger
		{
			return _objectNumber;
		}

		public function set objectNumber(v:COSInteger):void
		{
			_objectNumber = v;
		}
		
	}
}