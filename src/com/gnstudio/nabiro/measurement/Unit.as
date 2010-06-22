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
	
	/**
	 * Class used to define strognly typed unit in the system,
	 * the use of this class is encouraged for complex measurement that
	 * need a more robust support for type checking in system in which measuremens
	 * represent a criticism
	 */ 
	public class Unit{
				
		public function Unit(){
			
			// Do nothing	
			
		}
		
		/**
		 * The string that represents the unit in a system
		 */ 
		private var _symbol:String
		
		public function set symbol(value:String):void{
			
			_symbol = value;
			
		}
		
		public function get symbol():String{
			
			return _symbol;
			
		}
		
		/**
		 * The value of the current unit in the system
		 */
		private var _value:Number
		
		public function set value(value:Number):void{
			
			_value = value;
			
		}
		
		public function get value():Number{
			
			return _value;
			
		}

	}
}