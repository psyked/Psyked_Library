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
	
	import flash.events.Event;
	
	import mx.rpc.AbstractService;

	/**
	 * This class defines a wrapper event which encapsulates a remote method 
	 * invocation result into the eventData object.     
	 */ 
	public class RemoteObjectWrapperEvent extends Event {
	    //----------------------------------------------------------------------
	    //
	    //  Class constants
	    //
	    //----------------------------------------------------------------------
		
		/**
		 * The RemoteObjectWrapperEvent.RESULT constant defines the value of the 
		 * type property of the RemoteObjectWrapperEvent object for a result 
		 * event, which indicates that a result has been received. 
		 */ 
		public static const RESULT:String = "dataResult";
		
		/**
		 * The RemoteObjectWrapperEvent.FAULT constant defines the value of the 
		 * type property of the RemoteObjectWrapperEvent object for a fault 
		 * event, which indicates that a fault has been generated. 
		 */ 
		public static const FAULT:String = "dataFault";
		
        //----------------------------------------------------------------------
        //
        //  Class properties
        //
        //----------------------------------------------------------------------
		
		/**
		 * The data returned as result by the remote method invocation.
		 */
		public var eventData:Object;
		
		/**
		 * The current operations performed.
		 */
		public var currentService:AbstractService;
		
        //----------------------------------------------------------------------
        //
        //  Constructor
        //
        //----------------------------------------------------------------------

		/**
		 * Constructor.
		 */
		public function RemoteObjectWrapperEvent(type:String, 
												 data:Object,
												 service:AbstractService = null, 
												 bubbles:Boolean = false, 
												 cancelable:Boolean = false) {
			
			super(type, bubbles, cancelable);
			eventData = data;
			currentService = service;
						
		}
		
        //----------------------------------------------------------------------
        //
        //  Overridden methods.
        //
        //----------------------------------------------------------------------

		public override function clone():Event {
			return new RemoteObjectWrapperEvent(type, eventData, currentService);
		}

		public override function toString():String {
			return formatToString("RemoteObjectWrapperEvent", "type", "bubbles", 
									"cancelable", "eventPhase", "eventData", "currentService");
		}	
	}
}