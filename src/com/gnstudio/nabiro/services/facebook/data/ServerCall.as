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
	
	import __AS3__.vec.Vector;
	
	import com.gnstudio.nabiro.mvp.core.Parameter;
	import com.gnstudio.nabiro.mvp.encryption.MD5;
	import com.gnstudio.nabiro.services.events.RestDataEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	public class ServerCall implements IEventDispatcher{
		
		private var _eventDispatcher:EventDispatcher; 
		private var _target:IEventDispatcher; 
		
		protected const UPLOAD_URL:String = "http://www.flexcamp.it/facebook/doUpload.php?";
		
		protected static var callID:int = 0;
		
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
		
		private var _rest:String;
		private var _version:String;
		private var _key:String;
		private var _secret:String;
		private var _auth_token:String;
		
		public function ServerCall(rest:String, version:String, key:String, secret:String, auth_token:String){
			
			_eventDispatcher = new EventDispatcher();
			
			_rest = rest;
			_version = version;
			_key = key;
			_secret = secret;
			_auth_token = auth_token;
			
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
			
			var call_id:String = ( new Date().valueOf() ).toString() + ( ServerCall.callID++ ).toString();
			
			var parameters:Vector.<Parameter> = new Vector.<Parameter>();			
			
			parameters.push(new Parameter("api_key", _key));
			parameters.push(new Parameter("v", _version));
			parameters.push(new Parameter("call_id", call_id));
			parameters.push(new Parameter("method", method));		
						
			// Add the data to the parameters 
			if(params != null){
				
				for each(var item:Parameter in params){
					
					parameters.push(item)
					
				}
				
			} 
						
			parameters.push(new Parameter("sig", sig(parameters)));
	
			var urlencoded:String = "";
			
			var isBinary:Boolean = false;
					
			for each( var p:Parameter in parameters){
				
				urlencoded.length > 0 ? urlencoded += "&" + p.name + "=" + p.value : urlencoded += p.name + "=" + p.value;
				
				if(p.value is ByteArray){
					
					isBinary = true;
					break;
				
				}
				
			}
			
			var request:URLRequest = new URLRequest(_rest);
			
			if(isBinary){
				
				var header:CustomDataHeader = new CustomDataHeader();
				
				// The data params that need to be appended at the end 
				var doLater:Parameter;
				 
				for each( var pm:Parameter in parameters){
				
				 	if(pm.value is ByteArray){				 		
				 		
				 		//header.writeFileData("image_" + call_id + ".jpg", pm.value);
				 		doLater = pm;
				 		
				 	}else{
				 		
				 		if(pm.name != "uid" && pm.name != "caption")header.writePostData(pm.name, pm.value);
				 						 		
					} 
				 	
				}
				
				// TODO handle different file fomrat 
				header.writeFileData("image_" + call_id + ".jpg", doLater.value); 
				 
                var b:String = header.closeData();
                
                request.method = URLRequestMethod.POST;
               	
               	// With \r\n you get: ArgumentError: Error #2096: The HTTP request header 1.0 cannot be set via ActionScript.
               	// In order to avoid this there is a try, if in the future the policy for air application will change the 
               	// devlopers can use this class safely
               
               	var ac:URLRequestHeader = new URLRequestHeader("Accept-Charset", "ISO-8859-1,utf-8;q=0.7,*;q=0.7\r\n");
	            var ae:URLRequestHeader = new URLRequestHeader("Accept-Encoding", "gzip,deflate\r\n");
	            var mv:URLRequestHeader = new URLRequestHeader("MIME-version", "1.0\r\n");
	            var cl:URLRequestHeader = new URLRequestHeader("Content-length", String(header.getData().length) + "\r\n");
	            var ka:URLRequestHeader = new URLRequestHeader("Keep-Alive", "300\r\n");
	            var cn:URLRequestHeader = new URLRequestHeader("Connection", "keep-alive\r\n");
	                
	            request.requestHeaders.push(ac);
	            request.requestHeaders.push(ae);
	            request.requestHeaders.push(mv);
	            request.requestHeaders.push(cl);
	            request.requestHeaders.push(ka);
	            request.requestHeaders.push(cn);
	               
	            request.contentType = "multipart/form-data; boundary=" + b;
                	
            	request.data = header.getData();
            						
			}else{
				
				var data:URLVariables = new URLVariables(urlencoded);	
		
				request.contentType = "application/x-www-form-urlencoded";
				request.method = URLRequestMethod.POST;
				request.data = data;
				
			}
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, result);
			
			isBinary ? loader.dataFormat = URLLoaderDataFormat.BINARY : loader.dataFormat = URLLoaderDataFormat.TEXT;
			
			try{
				
				loader.load(request);
				
			}catch(e:Error){
				
				request = new URLRequest(UPLOAD_URL + "auth_token=" + _auth_token + "&session_key=" + getValueFromField("session_key", params) + "&uid=" + 
										 getValueFromField("uid", params) + "&aid=" + getValueFromField("aid", params) + "&filename=image_" + call_id + ".jpg" + "&caption=" + getValueFromField("caption", params));
				
				request.method = URLRequestMethod.POST;
				request.data = doLater.value;
				
				loader.dataFormat = URLLoaderDataFormat.TEXT;
				
				loader.load(request);
								
			}
		
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
		 * Construct the signature as described by Facebook api documentation
		 * (will only be used if NOT using a redirect server)
		 */
		private function sig(value:Vector.<Parameter>):String{
			
			var a:Array = [];
			
			for each( var p:Parameter in value){
				
				if( p.name != 'sig' ){
					
					a.push( p.name + '=' + p.value);
					
				}
			}
			
			a.sort();
			
			var s:String = '';
			
			for( var i:int = 0; i < a.length; i++){
				
				s += a[i];
			
			}
			
			s += _secret;
			
			return MD5.encrypt( s );
			
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