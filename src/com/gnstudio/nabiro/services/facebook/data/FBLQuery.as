package com.gnstudio.nabiro.services.facebook.data
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
	
	import com.gnstudio.nabiro.mvp.encryption.MD5;
	import com.gnstudio.nabiro.services.events.RestDataEvent;
	import com.gnstudio.nabiro.services.facebook.AirFBookConnector;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	public class FBLQuery
	{
		private var _eventDispatcher:EventDispatcher; 
		private var _target:IEventDispatcher; 
		
		private var api_key:String;
		private var call_id:Number;
		private var format:String;
		private var version:String;
		private var session_key:String;
		private var secret:String;
		
		private const METHOD:String = "fql.query";
		
		private static var callID:int = 0;
		
		private var requestArguments:Array;
		
		private var _facebook_namespace:Namespace;
		protected function get FACEBOOK_NAMESPACE():Namespace{
			
			if(_facebook_namespace == null){
				
				_facebook_namespace = new Namespace("http://api.facebook.com/1.0/");
			
			}
			
			return _facebook_namespace;
			
		}
		
		private var _xml:XML ;
		public function get xml():XML{
			
			return _xml;
			
		}
		
		public function FBLQuery(key:String, session:String, v:String, sc:String, f:String = "XML"){
						
			_eventDispatcher = new EventDispatcher();
			
			call_id = new Date().valueOf() + FBLQuery.callID++;
						
			api_key = key;
			session_key = session;
			version = v;
			format = f
			secret = sc;
			
			requestArguments = []	
			
		}
		
		public function makeQuery(query:String, tg:IEventDispatcher = null, additionalArguments:Object = null):void{
			
			if(tg){
				
				_target = tg;
				
			}
			
			var urlArgs:URLVariables = new URLVariables();
			
			if (additionalArguments) {
		       
		       for (var key:String in additionalArguments) {
		         	
		         	if (additionalArguments[key] is Array) {
		            	
		            	urlArgs[key] = additionalArguments[key].join(",");
		          	
		          	}else{
		            
		            	urlArgs[key] = additionalArguments[key];
		          
		          }
        
        		}
        		
      		}
      		
		    urlArgs ['call_id'] = call_id;
		    urlArgs ['session_key'] = session_key;
		    urlArgs ['api_key'] = api_key;
      		urlArgs ['v'] = version;
		    urlArgs ['method'] = METHOD;
		  	urlArgs ['query'] = query;
		    if(format != "XML")urlArgs ['format'] = format;
		     
		  	     
		    for(var arg:String in urlArgs) {
		        
		       var val:* = urlArgs[arg];
		       requestArguments.push(arg + "=" + val);
		      
		    }
		      
		    requestArguments.sort();
		      
		    var hashString:String = requestArguments.join("") + secret;
      		urlArgs['sig'] = MD5.encrypt(hashString);
      		
      		var request:URLRequest = new URLRequest(AirFBookConnector.DEFAULT_REST_URL);
			
			request.contentType = "application/x-www-form-urlencoded";
			request.method = URLRequestMethod.POST;
			request.data = urlArgs;
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, result);
			
			loader.load(request);
			
			
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
			
			default xml namespace = FACEBOOK_NAMESPACE;
			
			var event:RestDataEvent;
			
			trace("_xml..error_code.length()", _xml..error_code.length());
						
			if( _xml..error_code.length() == 0){
				
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