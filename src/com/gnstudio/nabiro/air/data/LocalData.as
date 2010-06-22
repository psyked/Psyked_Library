package com.gnstudio.nabiro.air.data
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
	
	import __AS3__.vec.Vector;
	
	import com.gnstudio.nabiro.air.data.events.DBEvent;
	import com.gnstudio.nabiro.air.data.utils.OperationsQueue;
	import com.gnstudio.nabiro.air.utilities.Logger;
	import com.gnstudio.nabiro.mvp.encryption.MD5;
	
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;

	public class LocalData implements IEventDispatcher
	{
		
		private var eventDispatcher:EventDispatcher;
		
		private static var _className:String = getQualifiedClassName(super);
		private static var _instance:LocalData;
		
		private var _target:IEventDispatcher;
		
		private var connections:Dictionary;
		private var connectionsCount:int;
		
		private var initializeDestination:File;
		
		// Operations queue
		private var operationsQueue:OperationsQueue;
		private var processingQueue:Boolean;
		
		public static const INITIALIZATION_COMPLETED:String = "onInstallationDataBaseCopied";
		public static const INITIALIZATION_NOT_COMPLETED:String = "onInstallationDataBaseNotCopied";
		public static const DEFAULT_CONNECTION:String = "nabiroDataAccess";
		
		public function LocalData()	{
			
			if (_instance != null && getQualifiedSuperclassName(this) != _className) throw new Error("This a singleton class!");
			
			eventDispatcher = new EventDispatcher();
			
			connections = new Dictionary(true);
			
			operationsQueue = OperationsQueue.getQueeManager();
						
		}
		
		/**
		 * Initialize a databse and create the default connection to the database
		 * It moves a db from the app directory to the storage dir just in case you
		 * need to perform great updates in folders with r/w permissions
		 * @param source File
		 * @param destination File
		 * @oaram erase Boolean
		 * @param tg IEventDispatcher
		 */ 
		public function initializedDataBase(source:File, destination:File, erase:Boolean = false, tg:IEventDispatcher = null):void{
			
			_target = tg;
			
			try{
			
				if(!destination.exists){
					
					initializeDestination = destination;
					
					// Perform a copy from the installtion database
					source.copyToAsync(destination);				
					source.addEventListener(Event.COMPLETE, onInitialized);
					
					
				}else{
					
					if(erase){
						
						if(destination.exists){
							
							destination.deleteFile();
							source.copyToAsync(destination);				
							source.addEventListener(Event.COMPLETE, onInitialized);
							
						}
						
						return
						
					}
					
					var connection:SQLConnection = new SQLConnection();
				
					connection.addEventListener(SQLEvent.OPEN, onDataBaseOpened);			
					connection.addEventListener(SQLErrorEvent.ERROR, onDataBaseOpeningError);
					
					var data:ConnectionData = new ConnectionData();
					
					data.name = DEFAULT_CONNECTION;
					data.connection = connection;
					data.target = _target;
					
					connections[String(connectionsCount)] = data;
					
					connectionsCount++;
					
					connection.open(destination);
					
					/* if(_target){
						
						_target.dispatchEvent(new Event(INITIALIZATION_COMPLETED));
					
					}else{
						
						dispatchEvent(new Event(INITIALIZATION_COMPLETED));
						
					} */
					
				}
			
			}catch(e:Error){
				
				if(_target){
					
					_target.dispatchEvent(new Event(INITIALIZATION_NOT_COMPLETED));
				
				}else{
					
					dispatchEvent(new Event(INITIALIZATION_NOT_COMPLETED));
					
				}
				
			}
			
		}
		
		public function resetDefault():void{
			
			for(var i:String in connections){
				
				connections[i].connection.close();
				//(connections[i] as ConnectionData).connection.close();
				
			}
			
		}
		
		/**
		 * Listener to the database insitialization event it notifies
		 * the class or the target that the database is ready and inititalize
		 * the connection with the default name
		 * @param e Event
		 */ 
		private function onInitialized(e:Event):void{
			
			e.target.removeEventListener(e.type, arguments.callee);
			
			var connection:SQLConnection = new SQLConnection();
			
			connection.addEventListener(SQLEvent.OPEN, onDataBaseOpened);			
			connection.addEventListener(SQLErrorEvent.ERROR, onDataBaseOpeningError);
			
			var data:ConnectionData = new ConnectionData();
			
			data.name = DEFAULT_CONNECTION;
			data.connection = connection;
			data.target = _target;
			
			connections[connectionsCount] = data;
			
			connectionsCount++;
			
			connection.open(initializeDestination);
			
			/* if(_target){
					
				_target.dispatchEvent(new Event(INITIALIZATION_COMPLETED));
				
			}else{
					
				dispatchEvent(new Event(INITIALIZATION_COMPLETED));
					
			} */
			
		}
		
		/**
		 * Recover a stored connection by name
		 * @param name String
		 * @return SQLConnection
		 */ 
		public function getConnectionByName(name:String):SQLConnection{
			
			var connection:SQLConnection;
			
			for (var stored:String in connections){
			
				if((connections[stored] as ConnectionData).name == name){
					
					connection = (connections[stored] as ConnectionData).connection;
					break;					
					
				}
				
			}
			
			return connection;
			
		}
		
		/**
		 * Create a connection to a database and dispatch the DBEvent.OPENED if everything works fine
		 * @param db File
		 * @param openMode String 
		 * @param tg IEventDispatcher
		 */ 
		public function createConnection(name:String, db:File, openMode:String = SQLMode.CREATE, tg:IEventDispatcher = null):void{
			
			var connection:SQLConnection = new SQLConnection();
			
			connection.addEventListener(SQLEvent.OPEN, onDataBaseOpened);			
			connection.addEventListener(SQLErrorEvent.ERROR, onDataBaseOpeningError);
			
			var data:ConnectionData = new ConnectionData();
			
			data.name = name;
			data.connection = connection;
			data.target = tg;
			
			connections[connectionsCount] = data;
			
			connectionsCount++;
			
			connection.open(db, openMode);
			
		}
		
		/**
		 * Listener to the database opening event, when the event is fired
		 * the connection is really opeend with the default database
		 * @param e SQLEvent
		 */ 
		protected function onDataBaseOpened(e:SQLEvent):void{
			
			e.target.removeEventListener(e.type, arguments.callee);
				
			var target:IEventDispatcher = recoverTarget(IEventDispatcher(e.target));
				
			if(target){
					
				target.dispatchEvent(new DBEvent(DBEvent.OPENED));
					
			}else{
					
				if(_target){
					
					_target.dispatchEvent(new Event(INITIALIZATION_COMPLETED));
				
				}else{
					
					dispatchEvent(new Event(INITIALIZATION_COMPLETED));
					
				}
					
			}
				
		}
		
		/**
		 * Handler used just in case something goes wrong during the opening of the
		 * default databas
		 * @param e SQLErrorEvent
		 */
		protected function onDataBaseOpeningError(e:SQLErrorEvent):void{
				
			e.target.removeEventListener(e.type, arguments.callee);
				
			var target:IEventDispatcher = recoverTarget(IEventDispatcher(e.target));
				
			if(target){
					
				target.dispatchEvent(new Event(INITIALIZATION_NOT_COMPLETED));
					
			}else{
					
				if(_target){
					
					_target.dispatchEvent(new Event(INITIALIZATION_NOT_COMPLETED));
				
				}else{
					
					dispatchEvent(new Event(INITIALIZATION_NOT_COMPLETED));
					
				}
					
			}
			
		}
		
		/**
		 * Define the query / queries to perform trough a set of SQLCriteria
		 * @param name; the name of the connection
		 * @param queries Vector.<SQLCriteria>
		 * @param stopOnError Boolean
		 */
		public function makeQuery(name:String, queries:Vector.<SQLCriteria>, tg:IEventDispatcher = null, stopOnError:Boolean = true):void{
			
			var queue:SQLQueue = new SQLQueue();
			
			for each(var query:SQLCriteria in queries){
				
				query.sqlConnection = getConnectionByName(name);
				
				queue.addItem(query, stopOnError);
				
			}
			
			queue.addEventListener(DBEvent.SUCCESS_QUEUE_QUERY, function(e:DBEvent):void{
			
				e.target.removeEventListener(e.type, arguments.callee);
				
				var tmp:String = "";
				
				var log:Logger = Logger.getInstance();
				
				for each(var item:Object in e.result){
					
					tmp += item.query.uid;
					log.addLog(item.query.text);
					
				}
				
				var queryuid:String = MD5.encrypt(tmp);
								
				operationsQueue.removeStep();
				
				if(_target){
					
					_target.dispatchEvent(new DBEvent(DBEvent.SUCCESS_QUERY, null, e.result, queryuid));
				
				}else{
					
					if(tg){
						
						tg.dispatchEvent(new DBEvent(DBEvent.SUCCESS_QUERY, null, e.result, queryuid));
						
					}else{
					
						dispatchEvent(new DBEvent(DBEvent.SUCCESS_QUERY, null, e.result, queryuid));
						
					}
					
				}				
				
			}); 
			
			queue.addEventListener(DBEvent.FAILED, onFailed);
			
			operationsQueue.addStep(queue);
			
			queue.execute();
			
		}
		
		protected function onFailed(e:DBEvent):void{
			
			e.target.removeEventListener(e.type, arguments.callee)
			// TODO Implement it
			
		}
				
		/**
		 * Method used to recover the target defined for a specific database connection,
		 * with multiple databases you can define multiple targets
		 * @param tg IEventDispatcher
		 */ 
		protected function recoverTarget(tg:IEventDispatcher):IEventDispatcher{
			
			var target:IEventDispatcher;
			
			for (var stored:String in connections){
			
				if((connections[stored] as ConnectionData).connection == tg){
					
					target = (connections[stored] as ConnectionData).target;
					break;					
					
				}
				
			}
			
			return target || _target;
			
			
		}
		
		/**
		 * Static method used to recover the unique instance that manage connections
		 * @return LocalData
		 */ 
		public static function getInstance():LocalData{
			
			if(!_instance){
				
				_instance = new LocalData();				
				
			}
			
			return _instance;
			
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

import flash.data.SQLConnection;
import flash.events.IEventDispatcher;

/**
 * Internal class used to store the information related
 * to each single connection that the class can handle
 */

internal class ConnectionData{
	
	public function ConnectionData(){
		
		// Do nothing
		
	}
	
	/**
	 * Connection name
	 */
	private var _name:String;
	
	public function get name():String{
		
		return _name;
		
	}
	
	public function set name(value:String):void{
		
		_name = value;
		
	}
	
	/**
	 * SQL connection stored in the local data dictionary
	 */ 
	private var _connection:SQLConnection;
	
	public function get connection():SQLConnection{
		
		return _connection;
		
	}
	
	public function set connection(value:SQLConnection):void{
		
		_connection = value;
		
	}
	
	/**
	 * Target on which the events will be dispatched
	 * if target is null the class will use the default target for dispatching
	 */
	private var _target:IEventDispatcher;
	
	public function get target():IEventDispatcher{
		
		return _target;
		
	}
	
	public function set target(value:IEventDispatcher):void{
		
		_target = value;
		
	}
	
	
}