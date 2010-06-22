package com.gnstudio.nabiro.mvp.enumeration
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
	
	import mx.utils.ObjectProxy;
	
	public class EnumerableBase extends ObjectProxy {		
				
		public function EnumerableBase (name:String, data:* = null){
			
			_name = name;
			_data = data;
			
		}
				
		/**
		 * Data stored in the element
		 */ 
		private var _data:*;
		
		public function get data():*{
			
			return _data;
			
		}
		
		public function set data(value:*):void{
			
			_data = value;
			
		}
		
		/**
		 * Name of the item in the enumeration
		 */		
		private var _name:String;
		
		public function get name():String{
			
			return _name;
			
		}
		
		public function set name(value:String):void{
			
			_name = value;
			
		}

	}
}