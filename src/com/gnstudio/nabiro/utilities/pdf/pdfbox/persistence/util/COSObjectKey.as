package com.gnstudio.nabiro.utilities.pdf.pdfbox.persistence.util
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
	
	public class COSObjectKey
	{
		private var _number:Number;
    	private var _generation:Number;

		public function COSObjectKey(number:Number, generation:Number)
		{
			_number = number;
			_generation = generation;
		}

    	public function get generation():Number
    	{
    		return _generation;
    	}

    	public function set generation(v:Number):void
    	{
    		_generation = v;
    	}

		public function get number():Number
		{
			return _number;
		}

		public function set number(v:Number):void
		{
			_number = v;
		}
		
		public function toString():String
	    {
	        return "" + _number + " " + _generation + " R";
	    }
		
	}
}
