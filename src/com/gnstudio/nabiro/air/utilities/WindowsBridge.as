package com.gnstudio.nabiro.air.utilities
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
	
	import com.gnstudio.nabiro.air.utilities.events.IntraWinComEvent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;

	public class WindowsBridge implements IEventDispatcher
	{
		
		private var eventDispatcher:EventDispatcher;
			               
		private static var _className:String = getQualifiedClassName(super);
		private static var _instance:WindowsBridge;
		
		private const LISTENERS:Dictionary = new Dictionary(true);
		
		public static const INVALID_MESSAGE:String = "onBridgeInvalidMessage";
		
		private static const UID:Number = 83658;
		
		
		private var count:int;
		
		public function WindowsBridge(uid:Number){
			
			if (_instance != null && getQualifiedSuperclassName(this) != _className) throw new Error("This a singleton class!");
			
			if(uid != UID){
				
				throw new Error("You cannot instantiate a singleot class directly");
				
			}
				                       
			eventDispatcher = new EventDispatcher();
			
			count = 0;
			
			addEventListener(IntraWinComEvent.DEFAULT, onDefaultMessage);
			
		}
		
		
		/**
		 * Static method used to recover the unique instance that manage connections
		 * @return WindowsBridge
		 */
		public static function getInstance():WindowsBridge{
				                       
			if(!_instance){
					                               
				_instance = new WindowsBridge(UID);                           
					                               
			}
				                       
			return _instance;
				                       
		}
		
		public function register(item:DisplayObject, message:String):void{
			
			LISTENERS[count] = {item: item, message: message};
			
			count++;
			
		}
		
		public function remove(item:DisplayObject):void{
			
			for (var k:* in LISTENERS){
            	
                if(LISTENERS[k].item === item){
                	
                	delete LISTENERS[k];
                	count--;
                	break;
                	
                }
       
                
            }
			
		}
		
		private function onDefaultMessage(e:IntraWinComEvent):void{
			
			var tg:IEventDispatcher;
			
			for (var k:* in LISTENERS){
				
				var t:* = LISTENERS[k]
				
				if(LISTENERS[k].message == e.event.type){
					
					tg = LISTENERS[k].item;
					
					try{
						
						tg.dispatchEvent(e.event);
						
					}catch(error:Error){
						
						dispatchEvent(new Event(INVALID_MESSAGE));
						
					}
					
				}
				
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