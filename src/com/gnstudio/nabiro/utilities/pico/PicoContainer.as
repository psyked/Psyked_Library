package com.gnstudio.nabiro.utilities.pico
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
	
	import com.gnstudio.nabiro.utilities.HashMap;
	import com.gnstudio.nabiro.utilities.pico.events.PicoContainerEvent;
	import com.gnstudio.nabiro.utilities.pico.exceptions.ComponentExists;
	import com.gnstudio.nabiro.utilities.pico.exceptions.VisitorNotAllowed;
	import com.gnstudio.nabiro.utilities.pico.monitors.ComponentMonitor;
	import com.gnstudio.nabiro.utilities.pico.monitors.IMonitor;
	import com.gnstudio.nabiro.utilities.pico.visitors.IVisitors;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ICollectionView;

	public class PicoContainer implements IEventDispatcher
	{
		
		// EventDsipatcher instance used in order to implement IEventDispatcher
		private var eventDispatcher:EventDispatcher;
		
		private var components:HashMap;
		
		private var visitors:Vector.<Class>;
		
		public function PicoContainer(){
			
			eventDispatcher = new EventDispatcher();
			
			components = new HashMap();
			
		}
		
		/**
		 * add a component to the pico container, if you set the name
		 * you can add also multiple instances of the same component
		 * @param component *
		 * @param name = ""
		 */ 
		public function addComponent(component:*, name:String = ""):void{
			
			var compo:Component = new Component();
			
			compo.value = component;
			compo.name = name;
			
			if(!checkComponentExists(getDefinitionByName(getQualifiedClassName(component)) as Class, name) && !checkInstanceNotStored(component)){
				
				components.addItem(compo);
				
				dispatchEvent(new PicoContainerEvent(PicoContainerEvent.ADDING_COMPONENT, component, true));
				
			}else{
				
				throw new ComponentExists();
				
			}
			
		}
		
		/**
		 * recover a component from the container
		 * @param clazz Class
		 * @param name String
		 */ 
		public function getComponent(clazz:Class, name:String = ""):*{
			
			return checkComponentExists(clazz, name);
			
		}
		
		/**
		 * Return a list of all the components instances stored in the hashmap
		 * @return ICollectionView
		 */ 
		public function getAll():ICollectionView{
			
			var collection:ArrayCollection = new ArrayCollection();
			
			for each(var item:Component in components.entries){
				
				collection.addItem(item.value);
				
			}
			
			return collection;
			
		}
		
		/**
		 * Return a list of all the components instances stored in the hashmap
		 * filtered by the class used as a parameter
		 * @param clazz Class
		 * @return ICollectionView
		 */ 
		public function getAllByClass(clazz:Class):ICollectionView{
			
			var collection:ArrayCollection = new ArrayCollection();
			
			for each(var item:Component in components.entries){
				
				if(item.value is clazz){
					
					collection.addItem(item.value);
					
				}
				
			}
			
			return collection;
			
		}
		
		/**
		 * register a monitor to a component, use the name just in case
		 * you have multiple components of the same type and you are
		 * defining a monitor for a specific one, if no name is passed and multiple
		 * components of the same class are containe in the container the firts one
		 * will monitored
		 * @param clazz Class
		 * @param name Strin
		 * @return IMonitor
		 */ 
	    public function monitorComponent(clazz:Class, name:String = ""):IMonitor{
	    	
	    	var component:* = checkComponentExists(clazz, name);
	    	var monitor:IMonitor;
	    	
	    	if(!component){
	    		
	    		dispatchEvent(new PicoContainerEvent(PicoContainerEvent.MONITOR_ERROR, component, false));
	    		return monitor;
	    		
	    	}
	    		
	    	monitor = new ComponentMonitor(component);
	    		
	    	dispatchEvent(new PicoContainerEvent(PicoContainerEvent.MONITOR_REGISTERED, component, true));
	    	
	    	return monitor;
	    	
	    	
	    }
		
		/**
		 * Specify the vistors allowed from the container, it perform a check that the 
		 * class implements the IVisitors interface
		 * @param value Vector.<Class>
		 */ 
		public function set acceptVisitors(value:Vector.<Class>):void{
			
			var name:String = getQualifiedClassName(IVisitors);
			var implement:Boolean = false;
			
			for(var i:int = 0; i < value.length; i++){
				
				var implementors:XMLList = describeType(value[i])..implementsInterface;
				
				for(var j:int = 0; j < implementors.length(); j++){
					
					if(implementors[j].@type.toXMLString() == name){
						
						implement = true;
						break;
						
					}
					
				}
				
				
			}
			
			if(!implement){
				
				throw new VisitorNotAllowed();
				
			}else{
			
				visitors = value;
				
			}
			
		}
		
		public function get acceptVisitors():Vector.<Class>{
			
			return visitors;
			
		}
		
		/**
		 * Check if a component already exists in the container, the behavior is 
		 * different accordingly to the parameters that you are sending to the method
		 * @param clazz Class
		 * @param name Strin
		 * @reurn *
		 */ 
		protected function checkComponentExists(clazz:Class = null, name:String = ""):*{
			
			var result:*;
			
			for each(var item:Component in components.entries){
				
				if(clazz != null && name == ""){
				
					if(checkClassNotStored(item, clazz)){
						
						result = item.value;
						break;
						
					}
				
				}
				
				if(name != ""){
				
					if(checkNameNotStored(item, name)){
						
						result = item.value;
						break;
						
					}
				
				}
				
			}
			
			if(result){
			
				dispatchEvent(new PicoContainerEvent(PicoContainerEvent.COMPONENT_EXIST, item, false));
				
			}
			
			return result;
			
			
		}
		
		/**
		 * Check if an implementor of an interface exists in the container
		 * @param interfaze Class
		 * @param name String
		 * return *
		 */ 
		protected function checkImplementorExists(interfaze:Class, name:String = ""):*{
			
			var result:*;
			
			for each(var item:Component in components.entries){
				
				if(name != ""){
				
					if(checkNameNotStored(item, name)){
						
						result = item.value;
						break;
						
					}
				
				}else{
					
					var xdata:XML = describeType(item.value);
					var implemented:XMLList = xdata..implementsInterface;
					
					var limit:int = implemented.length();
					
					for(var i:int = 0; i < limit; i++){
						
						if(getDefinitionByName(implemented[i].@type) == interfaze){
							
							result = item.value;
							break;
							
						}
						
					}
					
				}
				
			}
			
			if(result){
			
				dispatchEvent(new PicoContainerEvent(PicoContainerEvent.COMPONENT_EXIST, item, false));
				
			}
			
			return result;
			
			
		}
		
		/**
		 * Recover an interface implementor
		 * @param interfaze Class
		 * @param name String
		 * return *
		 */
		public function getImplementor(interfaze:Class, name:String = ""):*{
			
			return checkImplementorExists(interfaze, name);
			
		}
		/**
		 * Remove the component from the container 
		 * @param component *
		 * @param name String
		 */		
		public function removeComponent(component:*, name:String = ""):void{
			
			var compo:Component = new Component();
			
			compo.value = component;
			compo.name = name;
			
			for each(var item:Component in components.entries){
				
				if(item.name == compo.name){
					
					components.remove("name", name);
					break;
					
				}
				
			}
		}
		
		/**
		 * Check that a class is not already stored
		 * @param item Component
		 * @param clazz Class
		 * @return Boolean
		 */ 
		private function checkClassNotStored(item:Component, clazz:Class):Boolean{
			
			var itemClass:Class = getDefinitionByName(getQualifiedClassName(item.value)) as Class;
					
			return itemClass == clazz;
			
		}
		
		
		/**
		 * Check that a component is not already stored
		 * @param item Component
		 * @param name String
		 * @return Boolean
		 */ 
		private function checkNameNotStored(item:Component, name:String):Boolean{
			
			return item.name == name;
			
		}
		
		/**
		 * Check if a component is not already stored in the HashMap
		 * @param component *
		 * @return Boolean
		 */ 
		private function checkInstanceNotStored(component:*):Boolean{
			
			var result:Boolean;
			
		//	trace("checkInstanceNotStored", component)
			
			for each(var item:Component in components.entries){
				
				if(item.value == component){
					
					result = true;
					break;
					
				}
				
			}
			
			return result;
			
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

/**
 * Definition of the internal component used by the container,
 * it's a wrapper used in order to easly find a component by name
 */ 
internal class Component{
	
	private var _name:String;
	
	public function get name():String{
		
		return _name;
		
	}
	
	public function set name(value:String):void{
		
		_name = value;
		
	}
	
	private var _value:*;
	
	public function get value():*{
		
		return _value;
		
	}
	
	public function set value(component:*):void{
		
		_value = component;
		
	}
	
}