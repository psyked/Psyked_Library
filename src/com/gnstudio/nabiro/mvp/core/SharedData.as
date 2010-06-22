package com.gnstudio.nabiro.mvp.core
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
	 *   @fine tuning			Ivan Varga [ ivan.varga@gnstudio.com ]
	 *	 
	 */
	
	import com.gnstudio.nabiro.mvp.core.events.SharedDataEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedSuperclassName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.describeType;
	
	import mx.collections.IViewCursor;
	
	/**
	 * The shared data class allow you to store values (primitive or complex)
	 * accordingly to a key and then receive update and delete notifications
	 */
	
	public class SharedData implements IEventDispatcher{
		
		// Static class data
		private static var _instance:SharedData;
		protected var _keys:Array;
		
		private static var className:String = getQualifiedClassName(super);
		
		// Instance variables
		protected var dictionary:Dictionary;	
		
		// EventDsipatcher instance used in order to implement IEventDispatcher
		private var eventDispatcher:EventDispatcher;	
		
		protected var initialized:Boolean;
		
		
		public function SharedData(){
			
			if (_instance != null && getQualifiedSuperclassName(this) != className) throw new Error("This a singleton class!");
						
			eventDispatcher = new EventDispatcher()
			
			_keys = [];
			
			dictionary = new Dictionary(true);
			
		}
		
		/**
		 * Return the instance
		 * @return SharedData
		 */ 
		public static function getInstance(reset:Boolean = false):SharedData{
			
			if(!_instance){
				
				_instance = new SharedData();
				_instance.initialized = true;
				
			}
			
			if(reset){
				
				SharedData._instance.dictionary = new Dictionary(true);
				
			}
			
			return SharedData._instance;
			
		}
		
		/**
		 * Add a value to the dictionary and notify the observer
		 * that something is happen and that a new value has been added
		 * @param key String
		 * @param value *
		 */ 
		public function addValue(key:String, value:*):void{
			
			var toPerform:Boolean = true;
			
			// Check if the values is already stored
			var limit:int = _keys.length;
			
			for(var i:int = 0; i < limit; i++){
				
				if(_keys[i] == key){
					
					updateValue(key, value);
					
					toPerform = false;
					break;
					
				}
				
			}
			
			if(toPerform){
			
				_keys.push(key)
				
				dictionary[key] = value;
				dispatchEvent(new SharedDataEvent(SharedDataEvent.KEY_ADDED, key, null, value));				
				
			}
			
		}
		
		public function createCursor():IViewCursor{
			
			 return new SharedDataViewCursor(this, dictionary);
			
		}
		
		/**
		 * Update the value of one item of the dictionary and notitify the
		 * observer that an update has been performed or that the 
		 * key is not sotred in the dictionary
		 * @param key String
		 * @param value *
		 */
		public function updateValue(key:String, value:*):void{
			
			// Check if the values is already stored
			var limit:int = _keys.length;
			
			var keyFound:Boolean;
			
			for (var stored:String in dictionary){
				
				if(stored == key){
									
					var oldValue:* = dictionary[key];					
					dictionary[key] = value;
					
					keyFound = true;
					
					this.dispatchEvent(new SharedDataEvent(SharedDataEvent.KEY_UPDATED, key, oldValue, value));										
					break;
					
				}
				
			}
			
			if(!keyFound)dispatchEvent(new SharedDataEvent(SharedDataEvent.KEY_RECOVER_ERROR, key));	
			
		}
		
		/**
		 * Recover a key from the dictionary, if you specify the field
		 * the methos will search for you in a specific field of the 
		 * object stored in the dictionary
		 * @param key String
		 * @param field String ""
		 * @return *
		 */ 
		public function getValue(key:String, field:String = ""):*{
			
			var value:*;
			
			if(!initialized){
				
				throw new Exception("Shared Data is not initialized");
				return;
				
			}
			
			for (var stored:String in dictionary){
				
				if(stored == key){
					
					value = dictionary[key];
					break;
					
				}
				
			}
			
			try{		
				
				if(field != ""){
				
					var xdata:XML = describeType(value);
					
					if(xdata.@isDynamic == "true"){
						
						value = value[field];
						
					}else{
						
						if(xdata.accessor.(@name == field).length() > 0){
						
							value = value[xdata.accessor.(@name == field).@name];
							
						}else{
							
							value = value[xdata.variable.(@name == field).@name];
							
						}
						
					}
					
				}
			
			}catch(error:Error){
				
				dispatchEvent(new SharedDataEvent(SharedDataEvent.KEY_RECOVER_ERROR, key));	
				
			}
			
			return value;
			
		}
		
		/**
		 * Delete all the values of the dictionary
		 */ 
		public function deleteAll():void{
			
			for (var key:String in dictionary){
				
				delete dictionary[key];
				
			}
			
			_keys = [];
		}
		
		/**
		 * Get all the valueso stored in the dictionary
		 * @return Array
		 */ 
		public function getAll():Array{
			
			var tmpArr:Array = [];
			
			for (var stored:String in dictionary){
				
				tmpArr.push(dictionary[stored]);
			}
			
			return tmpArr;
			
		}
		
		/**
		 * Delete a specific value and return a boolean in order to 
		 * understand if the value has been found and deleted; actually
		 * it also dispatches an event 
		 * @return Boolean
		 */
		public function deleteValue(key:String):Boolean{
			
			var cleared:Boolean = false;
			
			for (var stored:String in dictionary){
				
				if(stored == key){
										
					var limit:int = _keys.length;
					
					for(var i:int = 0; i < limit; i++){
						
						if(_keys[i] == key){
							
							_keys.splice(i, 1);
							break;
							
						}
						
					}
				
					dispatchEvent(new SharedDataEvent(SharedDataEvent.KEY_DELETED, key, dictionary[key]));	
					
					delete dictionary[key];
					
					cleared = true;
					break;
					
				}
				
			}
			
			
			return cleared;
			
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

import mx.collections.IViewCursor;
import mx.collections.CursorBookmark;
import mx.collections.ICollectionView;
import flash.events.Event;
import flash.utils.Dictionary;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import mx.collections.ListCollectionView;
import mx.collections.ArrayCollection;
import mx.collections.errors.CursorError;
import mx.collections.Sort;
import mx.collections.errors.SortError;
import mx.events.FlexEvent;
	

internal class SharedDataViewCursor extends EventDispatcher implements IViewCursor{
	
	 /**
     *  @private
     */
    private static const BEFORE_FIRST_INDEX:int = -1;

    /**
     *  @private
     */
    private static const AFTER_LAST_INDEX:int = -2;
    
    /**
     *  @private
     */
    private var currentIndex:int;

    /**
     *  @private
     */
    private var currentValue:Object;

    /**
     *  @private
     */
    private var invalid:Boolean;
    
    private var _view:ListCollectionView;
	
	public function SharedDataViewCursor(tg:IEventDispatcher, data:Dictionary){
			
		super(tg);
		
		var tmpArr:Array = [];
			
		for (var stored:String in data){
				
			tmpArr.push(data[stored]);
		
		}
		
		_view = new ArrayCollection(tmpArr)
			
	}
	
	public function get afterLast():Boolean{
		
		checkValid();
        return currentIndex == AFTER_LAST_INDEX || view.length == 0;
        
	}
	
	private function checkValid():void
    {
        if (invalid)
        {
           throw new CursorError("Cursor not valid");
        }
    }
		
	public function get beforeFirst():Boolean{
		
		checkValid();
        return currentIndex == BEFORE_FIRST_INDEX || view.length == 0;
	
	}
		
	public function get bookmark():CursorBookmark{
		
		checkValid();
		
        if (view.length == 0 || beforeFirst){
        	
        	return CursorBookmark.FIRST;
        	
        } else if (afterLast) {
        
        	return CursorBookmark.LAST;
        
        }else{
        	
        	return null;
        	
        }        
        
	}
		
	public function get current():Object
	{
		return null;
	}
		
	public function get view():ICollectionView
	{
		return null;
	}
		
	public function findAny(values:Object):Boolean{
		
		checkValid();
		
        var lcView:ListCollectionView = ListCollectionView(view);
        var index:int;
       
        if (index > -1){
        	
            currentIndex = index;
            setCurrent(lcView.getItemAt(currentIndex));
            
        }
        
        return index > -1;
	}
	
	private function setCurrent(value:Object, dispatch:Boolean = true):void{
       
        currentValue = value;

        if (dispatch){
        	
        	 dispatchEvent(new FlexEvent(FlexEvent.CURSOR_UPDATE));
        	
        }
           
    }
	
	
		
	public function findFirst(values:Object):Boolean
	{
		return false;
	}
		
	
		
	public function findLast(values:Object):Boolean
	{
		return false;
	}
		
	
	public function insert(item:Object):void
	{
	}
		
	public function moveNext():Boolean
	{
		return false;
	}
		
	public function movePrevious():Boolean
	{
		return false;
	}
		
	public function remove():Object
	{
		return null;
	}
		
	public function seek(bookmark:CursorBookmark, offset:int=0, prefetch:int=0):void
	{
	}
	
}