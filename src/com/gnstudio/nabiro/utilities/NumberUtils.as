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
	
	[Bindable]
	public class NumberUtils
	{
		public function NumberUtils()
		{
		}
		
		public static function roundNumber(num:Number, noPlaces:int):Number {
   				 
   			return Math.round(num * Math.pow(10, noPlaces))/Math.pow(10, noPlaces);
			
		} 
		
		public static function thousandsFormatter(tot:String, thousand_separator:String, decimail_separator:String):String {
	
			var thousandSeparator:String = thousand_separator;
			var decimalSeparator:String = decimail_separator;
			var original_number:Number = Number(tot);
			
			if (!(original_number) is Number) {
				
				return ("");
			
			}
			
			var decimal_part:String = "";
			var is_minus:Boolean = false;
			var number_part:String = "";
			var final_delimitted_number:String = "";
			var minus_validator:int = 0;
			var integer_length:int = 0;
			
			integer_length = tot.length;
			
			if (tot.indexOf(".") != -1) {
				
				decimal_part = tot.substring(tot.indexOf(".")+1, tot.length);
				integer_length = tot.indexOf(".");
				
			}
			
			if (original_number < 0) {
				
				is_minus = true;
				minus_validator = 1;
			
			}
			
			number_part = tot.substring(minus_validator, integer_length);
			
			if (number_part.length > 3) {
				
				var j:int = number_part.length;
				
				for (var i:int = 0; i<=j; ++i) {
					
					if (i>2 && (i-1)%3 == 0) {
						
						final_delimitted_number = number_part.charAt(j-i) + thousandSeparator + final_delimitted_number;
						continue;
					
					}
					
					final_delimitted_number = number_part.charAt(j-i) + final_delimitted_number;
				}
				
			} else {
				
				final_delimitted_number = number_part;
				
			}
			
			if (decimal_part != "") {
				
				if(decimal_part.length == 1){
					
					decimal_part = decimal_part + "0";
					
				}
				
				final_delimitted_number = final_delimitted_number + decimalSeparator + decimal_part;
			
			}else{
				
				decimal_part = "00"
				final_delimitted_number = final_delimitted_number + decimalSeparator + decimal_part;
				
			}
			
			if (is_minus == true) {
				
				final_delimitted_number = "-" + final_delimitted_number;
			
			}
			
			return (final_delimitted_number);
		}

	}
}