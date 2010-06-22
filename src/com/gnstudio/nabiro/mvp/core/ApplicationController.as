package com.gnstudio.nabiro.mvp.core
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
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

	public class ApplicationController implements IEventDispatcher{
		
		private var eventDispatcher:EventDispatcher;
		
		protected var classPath:String;
		protected var domainPath:String;
		
		public function ApplicationController  (enforcer:AbstractEnforcer){
			
			if(enforcer == null){
				
				throw(new Error("ViewController is an Abstrac class"));
				
			}
			
			eventDispatcher = new EventDispatcher();
		
		}
		
		public function getClassView(data:Object):Class{
			
			throw(new Error("the getClassView method has to be overriden"));
			
		}
		
		public function getViewState(data:Object):String{
			
			throw(new Error("the getViewState method has to be overriden"));
			
		}
		
		public function getView(data:Object):DisplayObject{
			
			throw(new Error("the getView method has to be overriden"));
			
		}
		
		public function getDomainCommand(command:String):URLRequest{
			
			if(!domainPath){
				
				throw(new Error("A domain path has to be defined"));
				
			}
			
			var url:URLRequest = new URLRequest(domainPath + command);
						
			return url;
			
		}
		
		protected function getAccess():AbstractEnforcer{
			
			return new AbstractEnforcer();
			
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

internal class AbstractEnforcer{
	
	
	
}