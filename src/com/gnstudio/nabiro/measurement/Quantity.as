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
	
	import __AS3__.vec.Vector;
	
	/**
	 * This class is a way you can represents quantity in complex
	 * systems that use strongly typed unit, the public methods can be overriden
	 * in order to handle measurement with unit that has complexity like speed, 
	 * area, etc.
	 */ 
	public class Quantity
	{
		public function Quantity(){
			
			// Do nothing
			
		}
		
		/**
		 * Sum a vector of units, it's a nice way to guarantee that
		 * elements are of the same data types
		 * @param values Vector.<Unit>
		 * @return Number
		 */ 
		public function sum(values:Vector.<Unit>):Number{
			
			var limit:int = values.length;
			
			for(var i:int = 0; i < limit; i++){
				
				_amount += values[i].value;
								
			}
						
			return _amount
						
		}	
		
		/**
		 * Subtract a vector of units, it's a nice way to guarantee that
		 * elements are of the same data types
		 * @param values Vector.<Unit>
		 * @return Number
		 */ 
		public function minus(values:Vector.<Unit>):Number{
			
			var limit:int = values.length;
			
			for(var i:int = 0; i < limit; i++){
				
				_amount -= values[i].value;
								
			}
						
			return _amount
						
		}	
		
		/**
		 * Multiply a vector of units, it's a nice way to guarantee that
		 * elements are of the same data types
		 * @param values Vector.<Unit>
		 * @return Number
		 */ 
		public function multiply(values:Vector.<Unit>):Number{
			
			var limit:int = values.length;
			
			for(var i:int = 0; i < limit; i++){
				
				_amount *= values[i].value;
								
			}
						
			return _amount
						
		}	
		
		public function divide(values:Vector.<Unit>):Number{
			
			var limit:int = values.length;
			
			for(var i:int = 0; i < limit; i++){
				
				_amount /= values[i].value;
								
			}
						
			return _amount
						
		}
		
		/**
		 * Compare a couple of unit and return a code accordingly
		 * to the result of the comparison, if there is no way to
		 * make a comparison the method thorw an exception
		 * @param a Unit
		 * @param b Unit
		 * @return int (GREATER_THAN 1, LESS_THAN -1, EQUAL 0
		 */ 
		public function compare(a:Unit, b:Unit):int{
			
			const GREATER_THAN:int = 1;
			const LESS_THAN:int = -1;
			const EQUAL:int = 0;
			
			var code:int;
			
			switch(true){
				
				case a.value == b.value:
				code = EQUAL;
				break;
				
				case a.value < b.value:
				code = LESS_THAN;
				break;
				
				case a.value > b.value:
				code = GREATER_THAN;
				break;
				
				default:
				throw new Error("No comparison result found");
				break
				
			}
			
			return code;
			
			
		}
		
		/**
		 * The unit used in the quantity
		 */ 
		private var _unit:Unit;
		
		public function get unit():Unit{
			
			return _unit;
			
		}
		
		public function set unit(value:Unit):void{
			
			_unit = value;
			
		}
		
		/**
		 * The amount of units stored in the quantity
		 */ 
		private var _amount:Number;
		
		public function get amount():Number{
			
			return _amount;
			
		}
		
		public function set amount(value:Number):void{
			
			_amount = value;
			
		}
		
		/**
		 * Human reader representation of the quantity
		 */ 
		public function toString():String{
			
			return String(_amount) + _unit.symbol;
			
		}

	}
}