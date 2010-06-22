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
	
	import com.gnstudio.nabiro.air.data.events.DBEvent;
	
	import flash.data.SQLStatement;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	
	import mx.collections.ArrayCollection;
	
	public class SQLQueue implements IEventDispatcher{
		
		private var _queue:ArrayCollection;
		private var _eventDispatcher:EventDispatcher;
		private var _resultSet:ArrayCollection;
		private var _currentIndex:int;
				
		public function SQLQueue(){
			
			_eventDispatcher = new EventDispatcher();
			
			_resultSet = new ArrayCollection()
			
			_queue = new ArrayCollection();
			
			_currentIndex = 0;
			
		}
				
		public function addItem(query:SQLStatement, stopOnError:Boolean = true):void{
			
			_queue.addItem({query: query, stopOnError: stopOnError});	
		
		}
		
		public function execute():void	{
			
			executeStatement(_currentIndex);
			
		}
		
		
		private function executeStatement(index:int):void{
			
			if (index >= _queue.length){
				
				var db:DBEvent = new DBEvent(DBEvent.SUCCESS_QUEUE_QUERY, null, _resultSet);
				dispatchEvent(db);
				
				return;
				
			}
			
			var item:Object = _queue.getItemAt(index);
			
            var query:SQLStatement = item.query;
           					
    		query.addEventListener(SQLEvent.RESULT, function (e:SQLEvent):void{
				
				e.target.removeEventListener(e.type, arguments.callee)
		
				_currentIndex++;
				
				_resultSet.addItem({query: e.target, result: e.target.getResult().data});
				executeStatement(_currentIndex);						
				
			});
				
    		query.addEventListener(SQLErrorEvent.ERROR,function (e:SQLErrorEvent):void{
        			
        		var db:DBEvent;				
        			
        		if (item.stopOnError){
        				
        			db = new DBEvent(DBEvent.FAILED, e.target.getResult().data, e.target.text);
        			dispatchEvent(db);
        				
        		}else{
        				
        			db = new DBEvent(DBEvent.INSERT_ATTEMPT, e.target.getResult(), e.target.text);
        			dispatchEvent(db);
        			
        			_currentIndex++;
        			
					executeStatement(_currentIndex);	
											
        		}
        			
        			
			});
		
			query.execute();
						
		}
		
		/************************************
		* IEventDispatcher immplementation
		*************************************/ 
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0.0, useWeakReference:Boolean=false):void{
			
			_eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
			
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void	{
			
			_eventDispatcher.removeEventListener(type, listener, useCapture);
			
		}
		
		public function dispatchEvent(event:Event):Boolean {
			
			return _eventDispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean {
			
			return _eventDispatcher.hasEventListener(type);
		}
		
		public function willTrigger(type:String):Boolean {
			
			return _eventDispatcher.willTrigger(type);
			
		}
	}
}