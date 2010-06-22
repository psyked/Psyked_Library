package com.gnstudio.nabiro.services.flickr.data
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
	
	import com.gnstudio.nabiro.mvp.core.Parameter;
	import com.gnstudio.nabiro.services.events.RestDataEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	public class ServerCall implements IEventDispatcher{
		
		private var _eventDispatcher:EventDispatcher; 
		private var _target:IEventDispatcher; 
	
		
		private var _xml:XML ;
		public function get xml():XML{
			
			return _xml;
			
		}
		
		private var _rest:String;
		private var _version:String;
		private var _key:String;
		private var _secret:String;
		
		public function ServerCall(rest:String, key:String, secret:String){
			
			_eventDispatcher = new EventDispatcher();
			
			_rest = rest;
			_key = key;
			_secret = secret;
			
		}
		
		/**
		 * Method used to invoke the facebook api
		 * @param method String
		 * @param params Vector.<Parameter>
		 * @param tg IEventDispatcher
		 */ 
		public function post(method:String, params:Vector.<Parameter> = null, tg:IEventDispatcher = null):void{			
			
			if(tg){
				
				_target = tg;
				
			}
			
			
			var parameters:Vector.<Parameter> = new Vector.<Parameter>();			
			
			parameters.push(new Parameter("api_key", _key));
			parameters.push(new Parameter("method", method));			
			
			// Add the data to the parameters 
			if(params != null){
				
				for each(var item:Parameter in params){
					
					parameters.push(item)
					
				}
				
			} 
			
	
			var urlencoded:String = "";
								
			for each( var p:Parameter in parameters){
				
				urlencoded.length > 0 ? urlencoded += "&" + p.name + "=" + p.value : urlencoded += p.name + "=" + p.value;
				
				
				
			}
			
			var request:URLRequest = new URLRequest(_rest);
			
			var data:URLVariables = new URLVariables(urlencoded);	
		
			request.contentType = "application/x-www-form-urlencoded";
			request.method = URLRequestMethod.GET;
			request.data = data;				
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, result);			
			
			loader.load(request);
			
			trace(request.url, urlencoded)
				
			
		}
		
		/**
		 * Get the value from the params Vector passed as an argument to the post method
		 * @param field String
		 * @param value:Vector.<Parameter>
		 * @return *
		 */ 		
		private function getValueFromField(field:String, value:Vector.<Parameter>):*{
			
			var returned:*;
			
			for each( var p:Parameter in value){
				
				if( p.name == field){
					
					returned = p.value;
					break;
					
				}
			}
		
			return returned;
			
		}
		
				
		/**
		 * Listener to the Event.COMPLETE registed for the loader that invokes 
		 * the facebook api, it sends the data over the class or create an error
		 * @param e Event
		 */ 
		protected function result(e:Event):void{
			
			e.target.removeEventListener(e.type, arguments.callee);
			
			// pull the XML out of the loader
			_xml = new XML(e.target.data);
			
			var event:RestDataEvent;
			
			if(_xml.@stat == "ok"){
				
				event = new RestDataEvent(RestDataEvent.SUCCESS, _xml);
			
			}else{
				
				event = new RestDataEvent(RestDataEvent.FAILED, _xml);
				
			}
			
			if(_target){
				
				_target.dispatchEvent(event);
				
			}else{
				
				dispatchEvent(event);
								
			}
			trace("===== Server Call Result ===== ")
			trace(_xml)
			trace("===== END ===== ") 
			
			default xml namespace = new Namespace("");
			
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