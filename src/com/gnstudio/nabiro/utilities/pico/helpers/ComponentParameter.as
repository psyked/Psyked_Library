package com.gnstudio.nabiro.utilities.pico.helpers
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
	 */
	 
	/**
	 * Class used to define a parameter to use during the method invocation,
	 * the name property is useful for debug
	 */ 
	
	public class ComponentParameter implements IPicoParameter
	{
		public function ComponentParameter(n:String = "", v:* = null){
			
			_name = n;
			_value = v;
			
		}
		
		/**
		 * Set the name of the parameter
		 * @param value String
		 */ 
		private var _name:String;
		public function set name(value:String):void{
			
			 _name = value;
			
		}
		
		public function get name():String{
			
			return  _name;
		
		}
		
		/**
		 * Set the value of the parameter used in the method invocation
		 * @param value *
		 */ 
		private var _value:*;
		public function set value(value:*):void{
			
			_value = value;
			
		}
		
		public function get value():*{
			
			return _value;
		
		}
		
	}
}