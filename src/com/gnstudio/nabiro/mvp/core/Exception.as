package com.gnstudio.nabiro.mvp.core
{
	import flash.errors.IllegalOperationError;
	
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
	
	public class Exception extends IllegalOperationError
	{
		
		/**
		 * The purpose of this class is to deliver to the view informations
		 * about the kind of error retrieved from the server, the reason why
		 * it extends the IllegalOperationError is in order to use it in the
		 * try cacth statements
		 * @param message String
		 * @param data:*
		 * @param ns Namespace
		 */ 
		
		public function Exception(message:String="", dt:* = null, ns:Namespace = null){
			
			super(message);
			
			_data = dt;
			_nameSpace = ns;
			
		}
		
		private var _data:*;
		
		private function get data():*{
			
			return _data;
			
		}
		
		private function set data(value:*):void{
			
			_data = value;
			
		}
		
		private var _nameSpace:Namespace;
		
		public function get nameSpace():Namespace{
			
			return _nameSpace;
			
		}
		
		public function set nameSpace(value:Namespace):void{
			
			_nameSpace = value;
			
		}
		
		
	}
}