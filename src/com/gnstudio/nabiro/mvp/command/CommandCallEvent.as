package com.gnstudio.nabiro.mvp.command
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
	
	public class CommandCallEvent extends Event{
		
		public static const COMMAND:String = "doCommand";
		public static const MACRO:String = "doMacro";
		
		public var command:ICommand;
		public var nameSpace:Namespace;
		
		public function CommandCallEvent(type:String, cm:ICommand = null, ns:Namespace= null, bubbles:Boolean=true, cancelable:Boolean=false){
			
			super(type, bubbles, cancelable);
			
			command = cm;
			nameSpace = ns;
		}
		
		public override function clone():Event {
			
			return new CommandCallEvent(type, command, nameSpace);
		
		}

		public override function toString():String {
			
			return formatToString("CommandCallEvent", "type", "bubbles", "cancelable", "eventPhase", "command", "nameSpace");
		
		}	

	}
}