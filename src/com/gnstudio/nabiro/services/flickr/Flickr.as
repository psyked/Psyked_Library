package com.gnstudio.nabiro.services.flickr
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
	import com.gnstudio.nabiro.services.flickr.data.ServerCall;
	import com.gnstudio.nabiro.services.flickr.model.Album;
	import com.gnstudio.nabiro.services.model.Photo;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	import mx.collections.ArrayCollection;
	
	public class Flickr implements IEventDispatcher{
		
		private static var _instance:Flickr;
		private static var _className:String = getQualifiedClassName(super);
		private static var _target:IEventDispatcher;
		
		private var _eventDispatcher:EventDispatcher;
		
		/**
		 * The URL of the REST server that you will be using.
		 * Change this if you are using a redirect server.
		 */
		protected const REST_URL:String = "http://api.flickr.com/services/rest/?";

		/**
		 * This ACTUAL FLICKR rest URL.  This cannot be changed.
		 */
		protected const DEFAULT_REST_URL:String = "http://api.flickr.com/services/rest/?";

		/**
		 * The URL of the login page a user will be directed to (for desktop applications)
		 * The default will work fine but you can set it to something else.
		 */
		protected const LOGIN_URL:String = "http://api.flickr.com/services/auth/?";
		
		/**
		 * The data you need in order to use flickr api
		 */
		protected const APY_KEY:String = "716fac989da28ae26431d9744a434110";
		protected const SECRET:String  = "89db0024b0f6593b";
		
		/**
		 * Event constants
		 */
		public static const USERDATA_RECOVERED:String = "onUserDataRecovered"; 
		public static const USERALBUMS_RECOVERED:String = "onUserAlbumsRecovered"; 
		public static const ALBUMPHOTOS_RECOVERED:String = "onUserPhotosRecovered"; 
		
		/**
		* Variables used to store session data, username, etc.
		*/ 
		protected var _username:String;
		protected var _password:String;
		protected var _auth_token:String;
		protected var _session_key:String;
		protected var _frob:String;
		protected var _uid:String;
				
		public function Flickr() {
			
			if (_instance != null && getQualifiedSuperclassName(this) != _className) throw new Error("This a singleton class!");
			
			_eventDispatcher = new EventDispatcher();

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
		 * Photos of the user selected and updated trough the server call
		 * 
		 * @see com.gnstudio.services.flickr.model.Photo
		 */
		private var _currentPhotos:ArrayCollection;
		 
		[Bindable]
		public function get currentPhotos():ArrayCollection{
		 	
			return _currentPhotos;
		 	
		}
		 
		public function set currentPhotos(value:ArrayCollection):void{
		 	
			_currentPhotos = value;
		 	
		}
		
		/**
		 * Method used to be sure that only an instance of the class will be created
		 * @param target IEventDispatcher
		 */ 
		public static function getInstance(target:IEventDispatcher = null):Flickr{
						
			if(!Flickr._instance){
				
				Flickr._instance = new Flickr();				
				
			}
			
			if(target){
				
				// Define the target that will get the evens
				Flickr._target = target;
							
			}
									
			return Flickr._instance;
			
		}
		
		/**
		 * Method used to recover the user info trough the api
		 */ 
		public function getUserInfo(u:String):void{
			
			_username = u;
			
			var ss:ServerCall = new ServerCall(this.DEFAULT_REST_URL , this.APY_KEY, this.SECRET);
			
			var params:Vector.<Parameter> = new Vector.<Parameter>();
			params.push(new Parameter("username", _username));
			
			ss.addEventListener(RestDataEvent.SUCCESS, onGetUserInfo);
			ss.post("flickr.people.findByUsername", params);
		
		}
		
		/**
		 * Listener to the findByUsername api call it is the
		 * responsible of the valorization of the _uid property
		 * @param e RestDataEvent
		 */ 
		protected function onGetUserInfo(e:RestDataEvent):void{
			
			e.target.removeEventListener(e.type, arguments.callee);
			
			_uid =  e.result.user.@nsid;
			
			var event:Event = new Event(Flickr.USERDATA_RECOVERED);
			
			if(_target){
				
				_target.dispatchEvent(event);
				
			}else{
				
				dispatchEvent(event);
				
			}
						
		}				
	
		/**
		 * Method used to recover the albums list of the logged user
		 */ 
		public function getAlbums():void{
			
			if(!_uid){
				
				throw(new Error("You need to recover your user id before!"));
				
			}
			
			if(userAlbums)userAlbums.removeAll();
			
			var ss:ServerCall = new ServerCall(this.DEFAULT_REST_URL , this.APY_KEY, this.SECRET);
			
			var params:Vector.<Parameter> = new Vector.<Parameter>();
			params.push(new Parameter("user_id", _uid));
			
			ss.addEventListener(RestDataEvent.SUCCESS, onAlbums);
			ss.post("flickr.photosets.getList", params);
			
		}
		
		/**
		 * Listener to the getList api call is the responsible of the
		 * population of the userAlbums ArrayCollection, if no albums
		 * are available it creates the default album
		 * @param e RestDataEvent
		 */ 
		private function onAlbums(e:RestDataEvent):void{
			
			e.target.removeEventListener(e.type, arguments.callee);			
			
			var xdata:XML = XML(e.result);
						
			var dp:ArrayCollection = new ArrayCollection();
			var xc:XMLList = xdata..photoset;
				
			for each(var item:XML in xc){
				
				var album:Album = new Album();
				album.id = item.@id;
				album.name = item.title;
				
				dp.addItem(album);
					
			}
			
			this.userAlbums = dp;
			
			var event:Event = new Event(Flickr.USERALBUMS_RECOVERED);
			
			if(_target){
				
				_target.dispatchEvent(event);
				
			}else{
				
				dispatchEvent(event);
				
			}
					
		}
		
		public function getPublicAlbumPhotos(album:String):void{
			
			if(currentPhotos)currentPhotos.removeAll();
						
			var ss:ServerCall = new ServerCall(this.DEFAULT_REST_URL , this.APY_KEY, this.SECRET);
			
			var params:Vector.<Parameter> = new Vector.<Parameter>();
			params.push(new Parameter("photoset_id", album));
			
			ss.addEventListener(RestDataEvent.SUCCESS, onPublicAlbumPhotos);
			ss.post("flickr.photosets.getPhotos", params);
			
			
		}
		
		protected function onPublicAlbumPhotos(e:RestDataEvent):void{
			
			e.target.removeEventListener(e.type, arguments.callee);	
						
			var photos:XMLList = e.result..photo;
			
			var tmp:Array = [];
			
			for each(var item:XML in photos){
				
				var photo:Photo = new Photo();
				
				photo.name = item.@title;
				photo.id = item.@id;
				photo.original = "http://farm" + item.@farm + ".static.flickr.com/" + item.@server + "/" + item.@id + "_" + item.@secret + "_b.jpg"; //"_o.jpg"; 
				photo.preview = "http://farm" + item.@farm + ".static.flickr.com/" + item.@server + "/" + item.@id + "_" + item.@secret + "_m.jpg";
				photo.thumbnail = "http://farm" + item.@farm + ".static.flickr.com/" + item.@server + "/" + item.@id + "_" + item.@secret + "_t.jpg";
							
				tmp.push(photo);
				
				trace(photo.original);
				
			}
			
			currentPhotos = new ArrayCollection(tmp);
			
			var event:Event = new Event(Flickr.ALBUMPHOTOS_RECOVERED);
			
			if(_target){
				
				_target.dispatchEvent(event);
				
			}else{
				
				dispatchEvent(event);
				
			}

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