package com.gnstudio.nabiro.utilities.events
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
	
	public class CountDownEvent extends Event{
		
		public static const COUNT_DOWN_CHANGED:String = "onCountDownChanged";
		
		public var days:String;
		public var hours:String;
		public var minutes:String;
		public var seconds:String;
		public var milliseconds:String;
		
		public function CountDownEvent(d:String, h:String, m:String, s:String, ms:String, bubbles:Boolean=true, cancelable:Boolean=true){
			
			days = d;
			hours = h;
			minutes = m;
			seconds = s;
			milliseconds = ms;
			
			super(COUNT_DOWN_CHANGED, bubbles, cancelable);		
			
		}
		
		public override function clone():Event {
			
			return new CountDownEvent(days, hours, minutes, seconds, milliseconds);
		
		}

		public override function toString():String {
			
			return formatToString("CountDownEvent", "type", "bubbles", "cancelable", "eventPhase", "days", "hours", "minutes", "seconds", "milliseconds");
		
		}	
	}
}