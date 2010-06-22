package com.gnstudio.nabiro.utilities.pico.monitors
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
	 */
	
	import __AS3__.vec.Vector;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.describeType;
	
	/**
	 * A class that can listen and dispatch events in order to be a bridge for all the application,
	 * imagine the context in which you want to get events releated to a component in a presenter
	 * of the application avoiding to have a concrete knowledge of the component you are monitoring
	 */ 
	public class ComponentMonitor implements IMonitor, IEventDispatcher
	{
		private var _component:*;
		private var _events:Array;
		
		// EventDsipatcher instance used in order to implement IEventDispatcher
		private var eventDispatcher:EventDispatcher;
		
		
		public function ComponentMonitor(component:*){
			
			eventDispatcher = new EventDispatcher();
			
			_events = [];
			
			_component = component;
			
		}
		
		/**
		 * Register for all the constants of a specific class, be aware to use Event
		 * subclasses here
		 * @param events Vector.<Class>
		 */ 
		public function registerFor(events:Vector.<Class>):void{
		
			for(var i:int = 0; i < events.length; i++){
				
				registerListener(events[i], (describeType(events[i]) as XML).constant);
				
			}
		
		}
		
		/**
		 * Do the dirty job of registering the listeners gettung the value
		 * of the type string through a dyanmic access to the constants of the class
		 * @param clazz Class
		 * @param constants XMLList
		 */ 
		private function registerListener(clazz:Class, constants:XMLList):void{
			
			for(var i:int = 0; i < constants.length(); i++){
				
				var event:String = clazz[constants[i].@name.toXMLString()];
				
				_events.push(event);
				
				if(_component is IEventDispatcher && event != null){
					
					(_component as IEventDispatcher).addEventListener(event, handler);
					
				}
				
			}
			
		}
		
		/**
		 * The handler that act as a bridge to forward events
		 * in the application
		 * @param e Event
		 */ 
		private function handler(e:Event):void{
			
			dispatchEvent(e);
			trace(e)
			
		}
		
		/**
		 * Stop each listener and reset the events array, once you call this
		 * method the registerFor method has to be called again in order
		 * to initialize again the monitor
		 */ 
		public function stop():void	{
			
			for(var i:int = 0; i < _events.length; i++){
				
				if(_component is IEventDispatcher && _events[i] != null){
				
					(_component as IEventDispatcher).removeEventListener(_events[i], handler);
					
				}
				
				
			}
			
			_events = [];
			
		}
		
		/**
		 * Remove any reference to the component that is monitored
		 */ 
		public function dispose():void{
			
			if(_events.length > 0){
			
				stop();
			
			}
			
			_component = null;
			
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