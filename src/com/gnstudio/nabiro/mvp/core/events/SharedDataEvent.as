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

	public class SharedDataEvent extends Event
	{
		
		// Event constants
		public static const KEY_UPDATED:String = "onKeyUpdated";
		public static const KEY_DELETED:String = "onKeyDeleted"
		public static const KEY_ADDED:String = "onKeyAdded"
		public static const KEY_RECOVER_ERROR:String = "onKeyRecoverError"
		
		// Instance variables
		public var updatedValue:*;
		public var previousValue:*;
		public var keyField:String;
		
		public function SharedDataEvent(type:String, key:String, previous:* = null, updated:* = null, bubbles:Boolean=false, cancelable:Boolean=false){
			
			super(type, bubbles, cancelable);
			
			keyField = key;
			
			previousValue = previous;
			updatedValue = updated;
			
			
		}
		
		override public function clone():Event{
			
			return new SharedDataEvent(type, keyField, previousValue, updatedValue);
			
		}
		
		public override function toString():String {
			
			return formatToString("SharedDataEvent", "type", "bubbles", 
									"cancelable", "eventPhase", "keyField", "previousValue", "updatedValue");
		}	
		
	}
}