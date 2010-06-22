package com.gnstudio.nabiro.services.facebook
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
	import com.gnstudio.nabiro.services.facebook.data.ServerCall;
	import com.gnstudio.nabiro.services.facebook.events.ErrorDataEvent;
	import com.gnstudio.nabiro.services.facebook.model.Album;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	import mx.collections.ArrayCollection;
	import mx.controls.HTML;
	
	public class AirBook implements IEventDispatcher{
		
		private static var _instance:AirBook;
		private static var _className:String = getQualifiedClassName(super);
		private static var _target:IEventDispatcher;
		
		private var _eventDispatcher:EventDispatcher;
				
		/**
		 * The event dispatched if the user login success
		 */
		public static const FACEBOOK_LOGIN_SUCCESS:String = "loginSuccess"; 
		
		/**
		 * The event dispatched if the user login fails
		 */
		public static const FACEBOOK_LOGIN_FAILED:String = "loginFailed"; 
		
		/**
		 * The event dispatched if the image is uploaded
		 */
		public static const FACEBOOK_UPLOAD_SUCCESS:String = "uploadSucces"; 
		
		/**
		 * The URL of the REST server that you will be using.
		 * Change this if you are using a redirect server.
		 */
		protected const REST_URL:String = "http://api.facebook.com/restserver.php";

		/**
		 * This ACTUAL FACEBOOK rest URL.  This cannot be changed.
		 */
		protected const DEFAULT_REST_URL:String = "http://api.facebook.com/restserver.php";

		/**
		 * The URL of the login page a user will be directed to (for desktop applications)
		 * The default will work fine but you can set it to something else.
		 */
		protected const LOGIN_URL:String = "http://www.facebook.com/login.php?connect_display=popup&fbconnect=true";
		
		/**
		 * The VERSION of the API used by the class
		 */		
		protected const VERSION:String = "1.0"
		
		protected const APY_KEY:String = "25e5b4239978aa969c1bdaad76d46f75";
		protected const SECRET:String  = "37a74cb7f27969a51c51abcce4681556";
		
		/**
		 * The default album name created if a user has not albums
		 */ 
		protected const AIR_BOOK_DEFAULT_ALBUM:String = "AirBook album";
		
		/**
		* The HTML used to perform the login in order to get the available API
		*/
		protected var _html:HTML; 
		 
		/**
		* Variables used to store session data, username, etc.
		*/ 
		protected var _username:String;
		protected var _password:String;
		protected var _auth_token:String;
		protected var _session_key:String;
		protected var _uid:String;
		
		/**
		 * Variable used to handle the signup to the application
		 */
		protected var _preventFaultSession:Boolean; 
				
		public function AirBook() {
			
			if (_instance != null && getQualifiedSuperclassName(this) != _className) throw new Error("This a singleton class!");
			
			_eventDispatcher = new EventDispatcher();
			
			_preventFaultSession = false;

		}
		
		/**
		 * Albums of the user and updated trough the server call
		 */
		 private var _userAlbums:ArrayCollection;
		 
		 [Bindable]
		 public function get userAlbums():ArrayCollection{
		 	
		 	return _userAlbums;
		 	
		 }
		 
		 public function set userAlbums(value:ArrayCollection):void{
		 	
		 	_userAlbums = value;
		 	
		 }
		
		/**
		 * Method used to be sure that only an instance of the class will be created
		 * @param target IEventDispatcher
		 */ 
		public static function getInstance(target:IEventDispatcher = null):AirBook{
						
			if(!AirBook._instance){
				
				AirBook._instance = new AirBook();				
				
			}
			
			if(target){
				
				// Define the target that will get the evens
				AirBook._target = target;
							
			}
									
			return AirBook._instance;
			
		}
		
		/**
		 * Method used to perform the login without opening a new browser instance
		 * as the most of the desktop facebook applications
		 * @param u String
		 * @param p String
		 * @param h HTML
		 */ 
		public function login(u:String, p:String, h:HTML):void{
			
			_username = u;
			_password = p;
			_html = h;
			
			var ss:ServerCall = new ServerCall(this.DEFAULT_REST_URL, this.VERSION, this.APY_KEY, this.SECRET, _auth_token);
	
			ss.addEventListener(RestDataEvent.SUCCESS, onToken);
			ss.post("facebook.auth.createToken");
		
		}
		
		/**
		 * Listener to the createToken api call it get the token value and
		 * redirect the HTML instance to the login URL in order to start
		 * to play with the AirBook application
		 * @param e RestDataEvent
		 */ 
		protected function onToken(e:RestDataEvent):void{
			
			e.target.removeEventListener(e.type, arguments.callee);
			
			_html.addEventListener(Event.COMPLETE, onLoginPageLoaded);
			
			// TODO evaluate if the token needs to be stored in the local storage
			_auth_token = e.result;
			
			_html.location = LOGIN_URL /* + "?v=" + this.VERSION +  */ + "&api_key=" + this.APY_KEY //+ "&auth_token=" + e.result;
			trace("_------------------------", _html.location)
			
		}
		
		/**
		 * Listener to the Event.COMPLETE event registered for the HTML instance
		 * it is the one that set the html form values and sumbit it, moreover
		 * it change the listener to the Event.COMPLETE in order to be sure
		 * that the user is logged before getting the session values
		 * @param e Event
		 */  
		protected function onLoginPageLoaded(e:Event):void{
			
			trace("Login page ready")
			
			// Check if the facebook application needs to be installed
			if(e.target.htmlLoader.window.document.getElementById('confirm_button')){
								
				e.target.removeEventListener(e.type, arguments.callee);
				_preventFaultSession = true;
								
				if(_target){
					
					_target.dispatchEvent(new ErrorDataEvent(ErrorDataEvent.FACEBOOK_APP_NOT_INSTALLED, new URLRequest(LOGIN_URL + "?v=" + this.VERSION + "&api_key=" + this.APY_KEY + "&auth_token=" + _auth_token)));
					
				}else{
					
					dispatchEvent(new ErrorDataEvent(ErrorDataEvent.FACEBOOK_APP_NOT_INSTALLED, new URLRequest(LOGIN_URL + "?v=" + this.VERSION + "&api_key=" + this.APY_KEY + "&auth_token=" + _auth_token)));
					
				}
			
				
			}else{
			
				if(e.target.htmlLoader.window.document.getElementById('email'))e.target.htmlLoader.window.document.getElementById('email').value = _username;
				if(e.target.htmlLoader.window.document.getElementById('pass'))e.target.htmlLoader.window.document.getElementById('pass').value = _password;
				if(e.target.htmlLoader.window.document.getElementById('persistent_inputcheckbox'))e.target.htmlLoader.window.document.getElementById('persistent_inputcheckbox').checked = true;
					
				(e.target.htmlLoader.window.document.forms[0].submit());
				
				_html.removeEventListener(Event.COMPLETE, onLoginPageLoaded);
				_html.addEventListener(Event.COMPLETE, onLoginPerformed);
			
			}
			
			
		}
		
		/**
		 * Handler that understand if the login has been perfromed in the dummy
		 * HTML component and that start to recover session information
		 * @param e Event
		 */ 
		protected function onLoginPerformed(e:Event):void{
			
			_html.removeEventListener(Event.COMPLETE, onLoginPageLoaded);
			
			e.target.removeEventListener(e.type, arguments.callee);
			
			trace("Start Session recovery")
			
			if(!_preventFaultSession)geSession();			
			
		}
		
		/**
		 * Method used to uderstand if the user has added the application on the 
		 * facebook account
		 */ 
		protected function getAppUser():void{
			
			var ss:ServerCall = new ServerCall(this.DEFAULT_REST_URL, this.VERSION, this.APY_KEY, this.SECRET, _auth_token);
			
			var params:Vector.<Parameter> = new Vector.<Parameter>();
			params.push(new Parameter("session_key", _session_key));
			
			ss.addEventListener(RestDataEvent.SUCCESS, onAppUser);
			ss.addEventListener(RestDataEvent.FAILED, onAppNotUser);
			ss.post("facebook.users.isAppUser", params)
			
		}
		
		/**
		 * Listener to the isAppUser api call it redirect the user to the page
		 * of installation if the uses has not installed the airbook application
		 * @param e RestDataEvent
		 */ 
		protected function onAppNotUser(e:RestDataEvent):void{
			
			if(_target){
					
				_target.dispatchEvent(new ErrorDataEvent(ErrorDataEvent.FACEBOOK_APP_NOT_INSTALLED, new URLRequest(LOGIN_URL + "?v=" + this.VERSION + "&api_key=" + this.APY_KEY + "&auth_token=" + e.result)));
					
			}else{
					
				dispatchEvent(new ErrorDataEvent(ErrorDataEvent.FACEBOOK_APP_NOT_INSTALLED, new URLRequest(LOGIN_URL + "?v=" + this.VERSION + "&api_key=" + this.APY_KEY + "&auth_token=" + e.result)));
					
			}
			
		}
		/**
		 * Listener to the isAppUser api call it redirect the user to the page
		 * of installation if the uses has not installed the airbook application
		 * @param e RestDataEvent
		 */ 
		protected function onAppUser(e:RestDataEvent):void{
			
			if(int(e.result) == 1){
				
				getUserInfo();
				
			}else{
				
				// navigateToURL(new URLRequest(LOGIN_URL + "?v=" + this.VERSION + "&api_key=" + this.APY_KEY + "&auth_token=" + e.result), "_blank");
				
				if(_target){
					
					_target.dispatchEvent(new ErrorDataEvent(ErrorDataEvent.FACEBOOK_APP_NOT_INSTALLED, new URLRequest(LOGIN_URL + "?v=" + this.VERSION + "&api_key=" + this.APY_KEY + "&auth_token=" + e.result)));
					
				}else{
					
					dispatchEvent(new ErrorDataEvent(ErrorDataEvent.FACEBOOK_APP_NOT_INSTALLED, new URLRequest(LOGIN_URL + "?v=" + this.VERSION + "&api_key=" + this.APY_KEY + "&auth_token=" + e.result)));
					
				}
				
			}
						
		}
				
		
		/**
		 * Methods that recover the session of the logged user trough the auth_token
		 */ 
		protected function geSession():void{
			
			var ss:ServerCall = new ServerCall(this.DEFAULT_REST_URL, this.VERSION, this.APY_KEY, this.SECRET, _auth_token);
			
			var params:Vector.<Parameter> = new Vector.<Parameter>();
			params.push(new Parameter("auth_token", _auth_token));
			
			ss.addEventListener(RestDataEvent.SUCCESS, onSession, false, Number.MAX_VALUE, true);
			ss.addEventListener(RestDataEvent.FAILED, onSessionFailed);
			
			ss.post("facebook.auth.getSession", params);
					
		}
		
		protected function onSessionFailed(e:RestDataEvent):void{
			
			e.target.removeEventListener(e.type, arguments.callee);
			
			if(_target){
					
				_target.dispatchEvent(new Event(FACEBOOK_LOGIN_FAILED));
				
				trace("TARGET:");
					
			}else{
					
				dispatchEvent(new Event(FACEBOOK_LOGIN_FAILED));
				
				trace("LOCAL:");
				
			}
			
			trace("		The Session is not correct!");
					
		}
		
		/**
		 * Listener to the getSession api, it recovers the session_key
		 * @param e RestDataEvent
		 */ 
		protected function onSession(e:RestDataEvent):void{
			
			// TODO evaluate if an infinite session is required
			
			e.target.removeEventListener(e.type, arguments.callee);
			
			var facebook_namespace:Namespace = new Namespace("http://api.facebook.com/1.0/");
			default xml namespace = facebook_namespace;
			
			_session_key = e.result..session_key;
			
			default xml namespace = new Namespace("");
									
			getAppUser();
			
		}
		
		/**
		 * Method used to recover the user info trough the api
		 */ 
		protected function getUserInfo():void{
			
			var ss:ServerCall = new ServerCall(this.DEFAULT_REST_URL, this.VERSION, this.APY_KEY, this.SECRET, _auth_token);
			
			var params:Vector.<Parameter> = new Vector.<Parameter>();
			params.push(new Parameter("session_key", _session_key));
			
			ss.addEventListener(RestDataEvent.SUCCESS, onGetUserInfo, false, Number.MAX_VALUE, true);
			ss.post("facebook.users.getLoggedInUser", params);
			
		}
		
		/**
		 * Listener to the getLoggedInUser api call it is the
		 * responsible of the valorization of the _uid property
		 * @param e RestDataEvent
		 */ 
		protected function onGetUserInfo(e:RestDataEvent):void{
			
			e.target.removeEventListener(e.type, arguments.callee);
			
			_uid = e.result;
			
			if(_target){
					
				_target.dispatchEvent(new Event(FACEBOOK_LOGIN_SUCCESS));
					
			}else{
					
				dispatchEvent(new Event(FACEBOOK_LOGIN_SUCCESS));
					
			}
			
		}				
		
		/**
		 * Method used to uplaod ap picture on your ablums on facebook
		 * @param album String
		 * @param data ByteArray
		 * @param caption String
		 */ 
		public function upload(album:String, data:ByteArray, caption:String = ""):void{			
			
			var ss:ServerCall = new ServerCall(this.DEFAULT_REST_URL, this.VERSION, this.APY_KEY, this.SECRET, _auth_token);
			
			var params:Vector.<Parameter> = new Vector.<Parameter>();
			params.push(new Parameter("session_key", _session_key));
			params.push(new Parameter("aid", album));
			params.push(new Parameter("uid", _uid));
			params.push(new Parameter("caption", caption));
			params.push(new Parameter("data", data));
			
			ss.addEventListener(RestDataEvent.SUCCESS, onImageUploaded, false, Number.MAX_VALUE, true);
			
			ss.post("facebook.photos.upload", params);
						
		}
		
		/**
		 * Listener to the upload api call is the responsible of the
		 * event diptatched in order to understand if the image has been uploaded
		 * @param e RestDataEvent
		 */ 
		protected function onImageUploaded(e:RestDataEvent):void{
			
			if(_target){
					
				_target.dispatchEvent(new Event(FACEBOOK_UPLOAD_SUCCESS));
					
			}else{
					
				dispatchEvent(new Event(FACEBOOK_UPLOAD_SUCCESS));
					
			}
			
		}
		
		/**
		 * Method used to recover the albums list of the logged user
		 */ 
		public function getAlbums():void{
			
			if(userAlbums)userAlbums.removeAll();
			
			var ss:ServerCall = new ServerCall(this.DEFAULT_REST_URL, this.VERSION, this.APY_KEY, this.SECRET, _auth_token);
			
			var params:Vector.<Parameter> = new Vector.<Parameter>();
			params.push(new Parameter("session_key", _session_key));
			params.push(new Parameter("uid", _uid));
			
			ss.addEventListener(RestDataEvent.SUCCESS, onAlbums);
			ss.post("facebook.photos.getAlbums", params);
			
		}
		
		/**
		 * Listener to the getAlbums api call is the responsible of the
		 * population of the userAlbums Array, if no albums
		 * are available it creates the default album
		 * @param e RestDataEvent
		 */ 
		private function onAlbums(e:RestDataEvent):void{
			
			e.target.removeEventListener(e.type, arguments.callee);
			
			var xdata:XML = XML(String(e.result).split('xmlns="http://api.facebook.com/1.0/"').join(""));
							
			var dp:ArrayCollection = new ArrayCollection();
			var xc:XMLList = xdata..album
				
			for each(var item:XML in xc){
				
				var album:Album = new Album();
				album.id = item.aid;
				album.name = item.name;
				
				dp.addItem(album);
					
			}
			
			if(dp.length == 0){
				
				createAlbum(AIR_BOOK_DEFAULT_ALBUM)
				
			}else{
				
				this.userAlbums = dp;
								
			}

					
		}
		
		/**
		 * Method used to create a new album on facebook
		 * @param album String
		 */ 
		public function createAlbum(album:String):void{
			
			var ss:ServerCall = new ServerCall(this.DEFAULT_REST_URL, this.VERSION, this.APY_KEY, this.SECRET, _auth_token);
			
			var params:Vector.<Parameter> = new Vector.<Parameter>();
			params.push(new Parameter("uid", _uid));
			params.push(new Parameter("name", album));
			params.push(new Parameter("visible", "everyone"));
			
			ss.addEventListener(RestDataEvent.SUCCESS, onNewAlbum);
			ss.post("facebook.photos.createAlbum", params);			
			
		}
		
		/**
		 * Listener to the createAlbum api call it creates a new album
		 * on the facebook user account
		 * @param e RestDataEvent
		 */ 
		private function onNewAlbum(e:RestDataEvent):void{
			
			var event:RestDataEvent;
			
			var _xml:XML = new XML(e.result);
			
			default xml namespace = new Namespace("http://api.facebook.com/1.0/");			
			
			if(_xml..error_code == undefined){
				
				event = new RestDataEvent(RestDataEvent.SUCCESS, _xml);
				getAlbums();
			
			}else{
				
				event = new RestDataEvent(RestDataEvent.FAILED, _xml);
				
			}
			
			default xml namespace = new Namespace("");
			
			dispatchEvent(event);			
			
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