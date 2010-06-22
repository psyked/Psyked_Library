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
	 *   
	 *	 
	 */
	
	import com.gnstudio.nabiro.mvp.core.events.UpdatePresenterEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class PresenterChangeDetector implements IEventDispatcher
	{
		
		public static const PROPERTY_NOT_EXIST:String = "Property not exist";
		public static const ANY_PROPERTY:String = "checkForAny";
		
		private var eventDispatcher:EventDispatcher;
		
		private var properties:Array;
		private var presenter:Presenter;
		
		protected var discriminant:String = "mx.core::IFlexDisplayObject";
		
		private var _view:IView;
		
		public function get view():IView{
			
			return _view;
			
		}
		
		
		public function PresenterChangeDetector(v:IView, p:Presenter){
			
			eventDispatcher = new EventDispatcher();
			
			properties = [];
			
			_view = v;
			presenter = p;
			
			var toCheck:String = getQualifiedClassName(view);
			
			trace("\tPresenterChangeDetector:", toCheck, getQualifiedClassName(view))
			
			var accessorList:XMLList = describeType(view).accessor.(@declaredBy == toCheck);
			
			for each(var item:XML in accessorList){				
				
				try{
				
					var c:Class = getDefinitionByName(item.@type) as Class;
					
					if(describeType(c)..implementsInterface.(@type == discriminant).length() == 0){
					
						properties.push(new Property(item.@access, item.@type, item.@name));
						trace("\t\titem.@name", item.@name)
					}	
				
				}catch(e:Error){
					
					trace(e.message)
					
				}		
				
			}
			
			trace("\tChange detector may check", properties.length, "properties EXCLUDING UI elements\n")
			
		}
		
		public function get watched():Array{
			
			return _watched;
			
		}
		
		private var _watched:Array;
		private var _watchAny:Boolean;
		public function addProperty(property:String):void{
			
			if(property == PresenterChangeDetector.ANY_PROPERTY){
								
				if(!_watched){
				
					_watched = [];
				
				}
				
				_watched.push(property);
				
				_watchAny = true;
				
				return;
				
			}
			
			if(checkPropertyExist(property) && !checkPropertyIsWhatched(property)){
				
				if(!_watched){
				
					_watched = [];
				
				}
				
				if(_watched.length > properties.length){
					
					throw (new Error("You can't what more properties than the ones that exist on the object"));
					
					
				}else{
				
					_watched.push(property);
					
				}
				
			}else{
				
				throw (new Error("The property you want to watch doesn't exist or that it's already whatched"));
				
			}
			
		}
		
		public function removeProperty(property:String):void{
			
			if(checkPropertyIsWhatched(property)){
				
				var limit:int = _watched.length;
			
				for(var i:int = 0; i < limit; i++){
					
					if(_watched[i] == property){
						
						_watched.splice(i, 1);
						break;
						
					}
					
				}
			
				
			}
						
		}
		
		public function notifyError(data:*, exception:Exception, ns:Namespace = null):void{
			
			presenter.dispatchEvent(new UpdatePresenterEvent(UpdatePresenterEvent.SERVICE_FAULT, {data: data, exception: exception}, ns));
			
		}
		
		public function checkData(value:Object, ns:Namespace = null):void{
			
			if(_watchAny == true){
				
				presenter.dispatchEvent(new UpdatePresenterEvent(UpdatePresenterEvent.UPDATE_SUCCESFULL, value, ns));
				return;
				
			}
			
			var limit:int = _watched.length;
			
			for(var i:int = 0; i < limit; i++){
					
				if(value[_watched[i]]){
					
					var data:* = value[_watched[i]]
					presenter.dispatchEvent(new UpdatePresenterEvent(UpdatePresenterEvent.UPDATE_SUCCESFULL, value, ns));
					break;
					
				}else{
					
					presenter.dispatchEvent(new UpdatePresenterEvent(UpdatePresenterEvent.UPDATE_FAULT, PROPERTY_NOT_EXIST, ns));
					
				}
					
			}
			
		}
		
		protected function checkPropertyIsWhatched(property:String):Boolean{
			
			var exist:Boolean = false;
			
			if(_watched){
				
				var whatchedCount:int = _watched.length;
				
				for(var i:int = 0; i < whatchedCount; i++){
					
					if(_watched[i] == property){
						
						exist = true
						
					}
					
				}
				
			}
			
			return exist;
			
		}
		
		protected function checkPropertyExist(property:String):Boolean{
			
			var exist:Boolean = false;
					
			var limit:int = properties.length;
			
			for(var i:int = 0; i < limit; i++){
				
				if((properties[i] as Property).name == property){
					
					exist = true;
					break;
					
				}
				
			}
			
			return exist;
			
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

internal class Property{
	
	public function Property(a:String, t:String, n:String){
		
		access = a;
		type = t;
		name = n;
		
	}
	
	public var access:String;
	public var type:String;
	public var name:String;
	
}