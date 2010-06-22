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
	
	public final class IdentityMapDetail
	{
		
		private var _liveTime:int;
		private var _checkTime:int;
		private var _checkFiled:String;
		
		public function IdentityMapDetail(liveTime:int, checkTime:int, checkFiled:String){
			
			_liveTime = liveTime;
			_checkTime = checkTime;
			_checkFiled = checkFiled;
			
		}
		
		/**
		 * The time an object can live in the cache in milliseconds
		 */ 
		public function get liveTime():int{
			
			return _liveTime;
			
		}
		
		/**
		 * The interval on which perform the cache clear
		 */ 
		public function get checkTime():int{
			
			return _checkTime;
			
		}
		
		/**
		 * The property of the stored object to check for equality and removal
		 */ 
		public function get checkFiled():String{
			
			return _checkFiled;
			
		}

	}
}