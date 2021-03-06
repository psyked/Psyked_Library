package com.gnstudio.nabiro.measurement
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
	
	import flash.errors.IllegalOperationError;
	
	/**
	 * Simple conversion system, in order to handle complex conversion like
	 * Celsius to Fahreneight you have to override the converter method
	 */ 
	public class ConversionRatio
	{
		
		private var _ratio:Number;
		
		public function ConversionRatio(ratio:Number = 1){
			
			_ratio = ratio;
			
		}
		
		public function convertTo(value:Quantity):Number{
			
			return value.amount * _ratio;
			
		}
		
		public function converter(a:Quantity, b:Quantity):Number{
			
			throw new IllegalOperationError("Complex conversion requires more than a simple method, override the method and define your calculation.");
			
			var value:Number;
			
			return value;
			
		}

	}
}

