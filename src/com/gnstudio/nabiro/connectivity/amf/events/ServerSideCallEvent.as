package com.gnstudio.nabiro.connectivity.amf.events
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
	
	import com.gnstudio.nabiro.connectivity.amf.remote.IRemoteMethod;
	
	import flash.events.Event;
	
	public class ServerSideCallEvent extends Event{
		
		public static const LOGGED_CALL:String = "loggedCall";
		public static const ANONYMOUS_CALL:String = "anonymousCall";
		public static const PERFORM_LOGIN:String = "performLogin";
		
		public var ignoreSystemManager:Boolean;
		public var fakeObject:IRemoteMethod;
		public var nameSpace:Namespace;
		
		public function ServerSideCallEvent(type:String, fake:IRemoteMethod = null, ns:Namespace= null, ignore:Boolean = false, bubbles:Boolean=true, cancelable:Boolean=false){
			
			super(type, bubbles, cancelable);
			
			ignoreSystemManager = ignore;
			fakeObject = fake;
			nameSpace = ns;
			
		}
		
		public override function clone():Event {
			
			return new ServerSideCallEvent(type, fakeObject, nameSpace, ignoreSystemManager);
		
		}

		public override function toString():String {
			
			return formatToString("ServerSideCallEvent", "type", "bubbles", "cancelable", "eventPhase", "fakeObject", "nameSpace", "ignoreSystemManager");
		
		}	

	}
}