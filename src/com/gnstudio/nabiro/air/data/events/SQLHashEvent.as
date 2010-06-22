package com.gnstudio.nabiro.air.data.events
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
	
	import flash.data.SQLConnection;
	import flash.events.Event;

	public class SQLHashEvent extends Event
	{
		
		/**
		 * Events
		 */
		public static const CONNECTION_CLOSE_ERROR:String = "onDataBaseCloseError";
		public static const CONNECTION_CLOSE_SUCCESS:String = "onDataBaseCloseSucces";
		public static const CONNECTION_ADDED:String = "onDataBaseConnectionAdded";
		public static const EMPTY_CONNECTION_CREATED:String = "onEmptyDataBaseConnectionCreated";
		
		public var connection:SQLConnection;
		public var connectionName:String;
		
		public function SQLHashEvent(type:String, name:String, conn:SQLConnection = null, bubbles:Boolean=false, cancelable:Boolean=false){
			
			super(type, bubbles, cancelable);
			
			connection = conn;
			
			connectionName = name;
			
		}
		
		public override function clone():Event {
			
			return new SQLHashEvent(type, connectionName, connection);
			
		}

		public override function toString():String {
			
			return formatToString("SQLHashEvent", "type", "bubbles", 
									"cancelable", "eventPhase", "connectionName", "connection");
									
		}	
		
	}
}