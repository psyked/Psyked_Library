package com.gnstudio.nabiro.mvp.core.events
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

	public class UpdatePresenterEvent extends Event
	{
		
		// Event constants
		public static const UPDATE_SUCCESFULL:String = "onPresenterUpdated";
		public static const UPDATE_FAULT:String = "onPresenterUpdateFault"
		public static const SERVICE_FAULT:String = "onServiceFault"
		
		// Instance variables
		public var dataTranfer:*;
		public var nameSpace:Namespace;
		
		public function UpdatePresenterEvent(type:String, data:*, ns:Namespace = null, bubbles:Boolean=false, cancelable:Boolean=false){
			
			super(type, bubbles, cancelable);
			
			dataTranfer = data;
			nameSpace = ns;
			
			
		}
		
		override public function clone():Event{
			
			return new UpdatePresenterEvent(type, dataTranfer, nameSpace);
			
		}
		
		public override function toString():String {
			
			return formatToString("UpdatePresenerEvent", "type", "bubbles", 
									"cancelable", "eventPhase", "dataTranfer", "nameSpace");
		}	
		
	}
}