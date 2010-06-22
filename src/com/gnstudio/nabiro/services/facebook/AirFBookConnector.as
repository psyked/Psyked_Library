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
	
	import com.gnstudio.nabiro.json.JSON;
	import com.gnstudio.nabiro.mvp.core.Parameter;
	import com.gnstudio.nabiro.services.events.RestDataEvent;
	import com.gnstudio.nabiro.services.facebook.data.FBLQuery;
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
	import mx.managers.CursorManager;
	
	public class AirFBookConnector implements IEventDispatcher{
		
		private static var _instance:AirFBookConnector;
		private static var _className:String = getQualifiedClassName(super);
		private static var _target:IEventDispatcher;
		
		private var _eventDispatcher:EventDispatcher;
				
		/**
		 * The event dispatched if the user login success
		 */
		public static const FACEBOOK_LOGIN_SUCCESS:String = "loginSuccess"; 
		
		/**
		 * The event dispatched if the user initialization is complete
		 */
		public static const FACEBOOK_INIT_COMPLETE:String = "initComplete"; 
		
		/**
		 * The event dispatched if the user login success and other permissions are needed
		 */
		public static const FACEBOOK_EXTEND_PERMISSION:String = "extendPermission"; 
		
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
		public static const DEFAULT_REST_URL:String = "http://api.facebook.com/restserver.php";

		
		
		public static const BASE_URL:String = "http://www.facebook.com";
   		public static const LOGIN_SUCCESS:String = BASE_URL + "/connect/login_success.html";
   		public static const LOGIN_FAIL:String = BASE_URL +  "/connect/login_failure.html";
   		public static const EXTEND_PERMISSION:String = BASE_URL +  "/connect/prompt_permissions.php?";
   		
   		public static const LOGGED_IN:String = BASE_URL +  "/extern/desktop_login_status.php";
   		
   		public static var permissionsRequired:Array = ["photo_upload", "status_update", "read_stream" ,"publish_stream"];
   		
   		public var ext_perm:String;
   		
   		private static const allPermissions:Array = [
												      'email',
												      'offline_access',
												      'status_update',
												      'photo_upload',
												      'create_listing',
												      'create_event',
												      'rsvp_event',
												      'sms',
												      'video_upload',
												      'create_note',
												      'share_item',
												      'read_stream',
												      'publish_stream',
												      'auto_publish_short_feed'
												    ];
   		
   		/**
		 * The URL of the login page a user will be directed to (for desktop applications)
		 * The default will work fine but you can set it to something else.
		 */
		protected const LOGIN_URL:String = BASE_URL + "/login.php?";
		
		/**
		 * The VERSION of the API used by the class
		 */		
		protected const VERSION:String = "1.0"
		
		/**
		 * Infor get from the registration of an application in the facebook network
		 */  
		private static var api_key:String;
		private static var secret:String;
		
		private var expires:int;
		private var session_key:String;
		private var sig:String;
		private var uid:String;
	
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
		
		/**
		 * Variable used to handle the signup to the application
		 */
		protected var _preventFaultSession:Boolean; 
				
		public function AirFBookConnector() {
			
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
		public static function getInstance(key:String = "", desktopSecret:String = "", target:IEventDispatcher = null):AirFBookConnector{
						
			if(!AirFBookConnector._instance){
				
				AirFBookConnector._instance = new AirFBookConnector();				
				
			}
			
			if(key)api_key = key;
			if(desktopSecret)secret = desktopSecret;
						
			if(target){
				
				// Define the target that will get the evens
				AirFBookConnector._target = target;
							
			}
									
			return AirFBookConnector._instance;
			
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
			
			var ss:ServerCall = new ServerCall(DEFAULT_REST_URL, this.VERSION, api_key, secret, _auth_token);
	
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
			
			CursorManager.setBusyCursor();
			
			e.target.removeEventListener(e.type, arguments.callee);
			
			_html.addEventListener(Event.COMPLETE, onLoginPageLoaded);
			
			// TODO evaluate if the token needs to be stored in the local storage
			_auth_token = e.result;
						
			_html.location = LOGIN_URL + "api_key=" + api_key + "&return_session=true&connect_display=popup&fbconnect=true&nochrome=true&next=" + LOGIN_SUCCESS + "&display=popup&cancel_url=" + LOGIN_FAIL + "&v=" + VERSION; 
			
		}
		
		/**
		 * Listener to the Event.COMPLETE event registered for the HTML instance
		 * it is the one that set the html form values and sumbit it, moreover
		 * it change the listener to the Event.COMPLETE in order to be sure
		 * that the user is logged before getting the session values
		 * @param e Event
		 */  
		protected function onLoginPageLoaded(e:Event):void{
			
			CursorManager.removeBusyCursor();
			
			if(e.target.htmlLoader.window.document.getElementById('email') && _username != "")e.target.htmlLoader.window.document.getElementById('email').value = _username;
			if(e.target.htmlLoader.window.document.getElementById('pass') && _password != "")e.target.htmlLoader.window.document.getElementById('pass').value = _password;
			
			_html.removeEventListener(Event.COMPLETE, onLoginPageLoaded);
			_html.addEventListener(Event.LOCATION_CHANGE, makeBusy);
			
			_html.addEventListener(Event.COMPLETE, onLoginPerformed);
			
			trace("Login page ready")
						
		}
		
		private function makeBusy(e:Event):void{
				
			CursorManager.setBusyCursor();
				
		}
		
		/**
		 * Handler that understand if the login has been perfromed in the dummy
		 * HTML component and that start to recover session information
		 * @param e Event
		 */ 
		protected function onLoginPerformed(e:Event):void{
						
			e.target.removeEventListener(e.type, arguments.callee);
			
			CursorManager.removeBusyCursor();
			
			try{
			
				var session_pattern:RegExp = /\{.+?\}/;
	       	 	var info:String = session_pattern.exec(unescape(_html.location))[0];
				var obj:Object = JSON.decode(info);
				
				_html.removeEventListener(Event.LOCATION_CHANGE, makeBusy);
				
				expires = obj.expires;	
				if(secret.length == 0)secret = obj.secret;	
				session_key = obj.session_key;	
				sig = obj.sig;
				uid = obj.uid;	
				
				if(_target){
					
					_target.dispatchEvent(new Event(FACEBOOK_LOGIN_SUCCESS));
				
				}else{
						
					dispatchEvent(new Event(FACEBOOK_LOGIN_SUCCESS));
					
				}
			
				getAppUser();
			
			}catch(error:Error){
				
				if(_target){
					
					_target.dispatchEvent(new Event(FACEBOOK_LOGIN_FAILED));
				
				}else{
						
					dispatchEvent(new Event(FACEBOOK_LOGIN_FAILED));
					
				}
				
			}
				
		}
		
		/**
		 * Method used to uderstand if the user has added the application on the 
		 * facebook account
		 */ 
		protected function getAppUser():void{
			
			var fql:FBLQuery = new FBLQuery(api_key, session_key, VERSION, secret);
			fql.addEventListener(RestDataEvent.SUCCESS, onAppUser);
			fql.addEventListener(RestDataEvent.FAILED, onAppNotUser);
			
			fql.makeQuery("select " + "is_app_user " + " from user where uid = " + uid)
						
		}
		
		/**
		 * Listener to the isAppUser api call it redirect the user to the page
		 * of installation if the uses has not installed the airbook application
		 * @param e RestDataEvent
		 */ 
		protected function onAppNotUser(e:RestDataEvent):void{
			
			if(_target){
					
				_target.dispatchEvent(new ErrorDataEvent(ErrorDataEvent.FACEBOOK_APP_NOT_INSTALLED, new URLRequest(LOGIN_URL + "?v=" + this.VERSION + "&api_key=" + api_key + "&auth_token=" + e.result)));
					
			}else{
					
				dispatchEvent(new ErrorDataEvent(ErrorDataEvent.FACEBOOK_APP_NOT_INSTALLED, new URLRequest(LOGIN_URL + "?v=" + this.VERSION + "&api_key=" + api_key + "&auth_token=" + e.result)));
					
			}
			
		}
		/**
		 * Listener to the isAppUser api call it redirect the user to the page
		 * of installation if the uses has not installed the airbook application
		 * @param e RestDataEvent
		 */ 
		protected function onAppUser(e:RestDataEvent):void{			
			
			var facebook_namespace:Namespace = new Namespace("http://api.facebook.com/1.0/");
			default xml namespace = facebook_namespace;
			
			var isUser:int = int(e.result..is_app_user)
			
			default xml namespace = new Namespace("");
			
			if(isUser == 1){
				
				getUserInfo();
				
			}else{
								
				if(_target){
					
					_target.dispatchEvent(new ErrorDataEvent(ErrorDataEvent.FACEBOOK_APP_NOT_INSTALLED, new URLRequest(LOGIN_URL + "?v=" + this.VERSION + "&api_key=" + api_key + "&auth_token=" + e.result)));
					
				}else{
					
					dispatchEvent(new ErrorDataEvent(ErrorDataEvent.FACEBOOK_APP_NOT_INSTALLED, new URLRequest(LOGIN_URL + "?v=" + this.VERSION + "&api_key=" + api_key + "&auth_token=" + e.result)));
					
				}
				
			}
						
		}
				
		/**
		 * Method used to recover the user info trough the api
		 */ 
		protected function getUserInfo():void{
			
			var fql:FBLQuery = new FBLQuery(api_key, session_key, VERSION, secret);
			fql.addEventListener(RestDataEvent.SUCCESS, onGetUserInfo);
			
			fql.makeQuery("select " + permissionsRequired.join(" ,") + " from permissions where uid = " + uid)
			
			
		}
		
		/**
		 * Listener to the getLoggedInUser api call it is the
		 * responsible of the valorization of the _uid property
		 * @param e RestDataEvent
		 */ 
		protected function onGetUserInfo(e:RestDataEvent):void{
			
			e.target.removeEventListener(e.type, arguments.callee);
			
			ext_perm = "";
			var xdata:XML = XML(e.result);
			
			var facebook_namespace:Namespace = new Namespace("http://api.facebook.com/1.0/");
			default xml namespace = facebook_namespace;
			
			var nodes:XMLList = xdata.permissions.children()
			
			for(var i:int = 0; i < permissionsRequired.length; i++){
			
				var t:QName = nodes[i].name();
				
				if(t.localName == permissionsRequired[i]){
					
					if(nodes[i].text() == "0"){
						
						ext_perm += t.localName;
						if(i < permissionsRequired.length - 1){
							
							ext_perm += ",";
							
						}
						
					}
					
				}
				
			}
			
			default xml namespace = new Namespace("");
			
			if(_target){
				
				if(ext_perm.length > 0){
					
					_target.dispatchEvent(new Event(FACEBOOK_EXTEND_PERMISSION));
					
				}else{
					
					_target.dispatchEvent(new Event(FACEBOOK_INIT_COMPLETE));
					
				}
				
					
			}else{
				
				if(ext_perm.length > 0){
					
					dispatchEvent(new Event(FACEBOOK_EXTEND_PERMISSION));
					
				}else{
					
					dispatchEvent(new Event(FACEBOOK_INIT_COMPLETE));
					
				}
				
			}
			
		}				
		
		/**
		 * Method used to uplaod ap picture on your ablums on facebook
		 * @param album String
		 * @param data ByteArray
		 * @param caption String
		 */ 
		public function upload(album:String, data:ByteArray, caption:String = ""):void{			
			
			var ss:ServerCall = new ServerCall(DEFAULT_REST_URL, this.VERSION, api_key, secret, _auth_token);
			
			var params:Vector.<Parameter> = new Vector.<Parameter>();
			params.push(new Parameter("session_key", session_key));
			params.push(new Parameter("aid", album));
			params.push(new Parameter("uid", uid));
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
			
			var ss:ServerCall = new ServerCall(DEFAULT_REST_URL, this.VERSION, api_key, secret, _auth_token);
			
			var params:Vector.<Parameter> = new Vector.<Parameter>();
			params.push(new Parameter("session_key", session_key));
			params.push(new Parameter("uid", uid));
			
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
			
			var ss:ServerCall = new ServerCall(DEFAULT_REST_URL, this.VERSION, api_key, secret, _auth_token);
			
			var params:Vector.<Parameter> = new Vector.<Parameter>();
			params.push(new Parameter("uid", uid));
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