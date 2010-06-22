package com.gnstudio.nabiro.air.data.utils
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
	
	import com.gnstudio.nabiro.air.data.events.SQLHashEvent;
	
	import flash.data.SQLConnection;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	/**
	 * 
	 * <code>SQLConnectionHash</code> is class which provides 
	 * a centralized location from which all <code>SQLConnection</code> instances
	 * can be managed and retrieved.
	 * 
	 * <p>
	 * <code>SQLConnectionHelper</code> utilizes the <code>nativePath</code> 
	 * property of a <code>File</code> object used to create the connection. 
	 * This is utilized to uniquely identify each cached <code>SQLConnection</code> 
	 * database instance within the connections map.
	 * </p>
	 * 
	 */	
	 
	 
	public class SQLConnectionHash implements IEventDispatcher{
		
		
		private var eventDispatcher:EventDispatcher = new EventDispatcher();
		
		
		/**
		 *
		 * Contains a mapping of each unique <code>SQLConnection</code> instance
		 *  
		 */		
		private const connections:Dictionary = new Dictionary(true);
		
		
		
		public function SQLConnectionHash(){
			
			eventDispatcher = new EventDispatcher();
			
		}

		/**
		 *
		 * Retrieves a managed <code>SQLConnection</code> instance based on the
		 * unique name of the connection
		 * 
		 * @example The following example demonstrates how <code>SQLConnectionHelper</code>
		 * can be utilized to retrieve a reference to a shared <code>SQLConnection</code>
		 * 
		 * @param   unique name of the <code>SQLConnection</code> 
		 * @return  managed <code>SQLConnection</code> instance
		 * 
		 */
		public  function getConnection(name:String) : SQLConnection{
			
			var connection:SQLConnection;
			
			for (var k:* in connections){
					
				if(k == name){
					
					connection = connections[k];
					
				}
				
			}
			
			if (connection == null){
				
				connection = new SQLConnection();
				connections[ name ] = connection; 
				
				dispatchEvent(new SQLHashEvent(SQLHashEvent.EMPTY_CONNECTION_CREATED, name, connection));
				
			}
			
			return connection;
			
		}
		
		/**
		 * Add a connection to the hashmap checking if a connection with this name already exists
		 * 
		 * @param name String
		 * @param connection SQLConnection
		 * 
		 */
		
		public  function addConnection(name:String, connection:SQLConnection):void{
			
			for (var k:* in connections){
					
				if(k == name){
						
					throw new Error("A connection with the name " + name + " already exist");
					break;
						
				}
					
			}
				
			connections[name] = connection;
			
			dispatchEvent(new SQLHashEvent(SQLHashEvent.CONNECTION_ADDED, name, connection));
			
		}
		
		/**
		 *
		 * Closes the connection to the previously cached <code>SQLConnection</code>
		 * instance and remove it from the map
		 * 
		 * @param   The database name of the <code>SQLConnection</code>
		 * 
		 */		
		public  function closeConnection(name:String) : void{
			
			var connection:SQLConnection;
			
			for (var k:* in connections){
					
				if(k == name){
						
					connection = connections[k];
					break;
						
				}
					
			}

			if ( connection != null ){
				
				if ( connection.connected && !connection.inTransaction ){
					
					connection.close();
					delete connections[k];
					
					dispatchEvent(new SQLHashEvent(SQLHashEvent.CONNECTION_CLOSE_SUCCESS, name, connection));
					
				}	
							
			}else{
				
				dispatchEvent(new SQLHashEvent(SQLHashEvent.CONNECTION_CLOSE_ERROR, name));
				
			}
		}
		
		/************************************
		* IEventDispatcher immplementation
		*************************************/ 
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0.0, useWeakReference:Boolean=false):void{
			
			eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
			
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void	{
			
			eventDispatcher.removeEventListener(type, listener, useCapture);
			
		}
		
		public function dispatchEvent(event:Event):Boolean {
			
			return eventDispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean {
			
			return eventDispatcher.hasEventListener(type);
		}
		
		public function willTrigger(type:String):Boolean {
			
			return eventDispatcher.willTrigger(type);
			
		}
	}
	

}