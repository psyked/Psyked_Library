package com.gnstudio.nabiro.services.events
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
	
	import flash.events.Event;

	public class RestDataEvent extends Event
	{
		
		public static var SUCCESS:String = 'success';		
		public static var FAILED:String = 'failed';
		
		private var _result:XML;
		
		public function RestDataEvent(type:String, rs:XML = null, query:String = ""){
			
			super(type, false, false);
			
			_result = rs;
			
		}
		
		public override function clone():Event {
			
			return new RestDataEvent(type, result);
			
		}

		public override function toString():String {
			
			return formatToString("RestDataEvent", "type", "bubbles", "cancelable", "eventPhase", "result");
									
		}	
		
		public function get result () : XML{
			
			return _result;
		
		}
		
		
	}
}