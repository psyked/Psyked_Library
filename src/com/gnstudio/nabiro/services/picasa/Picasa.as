package com.gnstudio.nabiro.services.picasa
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
	
	import com.gnstudio.nabiro.services.model.Photo;
	import com.gnstudio.nabiro.services.picasa.events.PicasaResultEvent;
	import com.gnstudio.nabiro.services.picasa.model.Album;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.Socket;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.Security;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	import mx.collections.ArrayCollection;	
	
	public class Picasa implements IEventDispatcher{
		
		 /**
		 * Picasaweb service doesn't have its crossdomain.xml file at the root 
		 * of the host, so we have to load manualy.
		 */
		public static var POLICY_FILE_URL : String = "http://photos.googleapis.com/data/crossdomain.xml";
		
		/**
		 * Picasaweb API access point. Reflects the "api" projection value.
		 * Updatability is r/w when the user of the content is authenticated. 
		 * 
		 * @see http://code.google.com/apis/picasaweb/reference.html#Projection
		 */  
		public static var FEED_API_URL : String = "http://photos.googleapis.com/data/feed/api/";
		
		/**
		 * Picasaweb BASE access point. Reflects the "base" projection value.
		 * Used by feed readers. This is read only.
		 * 
		 * @see http://code.google.com/apis/picasaweb/reference.html#Projection
		 */
		public static var FEED_BASE_URL : String = "http://photos.googleapis.com/data/feed/base/";
		
		/**
		 * Google login access point
		 * 
		 * @see http://code.google.com/apis/accounts/docs/AuthForInstalledApps.html
		 */
		public static var LOGIN_URL : String = "https://www.google.com/accounts/ClientLogin"
		
		/**
		 * Porperties used in order to implement the Singleton pattern
		 * 
		 */ 
		private static var _instance:Picasa;
		private static var _className:String = getQualifiedClassName(super);
		private static var _target:IEventDispatcher;
		
		/**
		 * Property used fot the IEventDispatcher implementation
		 */ 
		private var _eventDispatcher:EventDispatcher;
		
		/**
		 * Properties used to store the google login response values
		 * 
		 * @see http://code.google.com/apis/accounts/docs/AuthSub.html 
		 */ 
		protected var SID:String;
		protected var LSID:String;
		protected var Auth:String;
		
		/**
		 * Property used to store username and password
		 */ 
		protected var username:String;
		protected var password:String;		
		
		/**
		 * Property that indicates if the user is logged in
		 */ 
		public var loggedIn:Boolean;
		
		/**
		 * Namespeces used in order to parse the XML feeds
		 */ 
		protected const GPHOTO_NAMESPACE:Namespace = new Namespace("http://schemas.google.com/photos/2007");
		protected const MEDIA_NAMESPACE:Namespace  = new Namespace("http://search.yahoo.com/mrss/");		
		
		/**
		 * Albums of the user and updated trough the server call
		 * 
		 * @see com.gnstudio.services.picasa.model.Album
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
		 * @see com.gnstudio.services.picasa.model.Photo
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
		 * Valid values for the thumb dimension you get in the album details
		 * 
		 * @see http://code.google.com/apis/picasaweb/reference.html#Parameters
		 */
		private const THUMB_SIZES:Array = [32, 48, 64, 72, 144, 160];  
		
		/**
		 * Valid values for the image dimension you get in the album details
		 * 
		 * @see http://code.google.com/apis/picasaweb/reference.html#Parameters
		 */
		private const IMAGE_SIZES:Array = [200, 288, 320, 400, 512, 576, 640, 720, 800];  
		
		/**
		 * Thumb dimension with default value
		 */
		public var thumbSize:int = THUMB_SIZES[1];
		  
		/**
		 * Pictures dimension with default value
		 */
		public var imageSize:int = IMAGE_SIZES[7];
		
		/**
		 * Enable cropping on the recovered images with default value
		 */
		public var isCropped:Boolean = false; 
		
		/**
		 * Constructor used to implement Singleton
		 */				
		public function Picasa(){
			
			if (_instance != null && getQualifiedSuperclassName(this) != _className) throw new Error("This a singleton class!");
			
			_eventDispatcher = new EventDispatcher();
			
		}
		
		/**
		 * Method used to be sure that only an instance of the class will be created
		 * @param target IEventDispatcher
		 */ 
		public static function getInstance(target:IEventDispatcher = null):Picasa{
			
			Security.loadPolicyFile(POLICY_FILE_URL);
						
			if(!Picasa._instance){
				
				Picasa._instance = new Picasa();				
				
			}
			
			if(target){
				
				// Define the target that will get the evens
				Picasa._target = target;
							
			}
									
			return Picasa._instance;
			
		}
		
		public function clientLogin(u:String, p:String):void{
			
			username = u;
			password = p;
			
			var request:URLRequest = new URLRequest("https://www.google.com/accounts/ClientLogin");
				
			var data:URLVariables = new URLVariables("Email=" + username + "&Passwd=" + password + "&service=lh2");
				
			request.contentType = "application/x-www-form-urlencoded";
			request.method = URLRequestMethod.POST;
			request.data = data;
				
			var loader:URLLoader = new URLLoader();
			
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleLoginStatus);
			loader.addEventListener(IOErrorEvent.IO_ERROR, handleCallFault);
			loader.addEventListener(Event.COMPLETE, handleLoginResponse);
			
			loader.load(request);			
			
		}
		
		protected function handleCallFault(e:IOErrorEvent):void{
			
			e.target.removeEventListener(e.type, arguments.callee);
			
			trace("call error");
			
			var event:PicasaResultEvent = new PicasaResultEvent(PicasaResultEvent.CALL_ERROR);
			
			if(_target){
            	
            	_target.dispatchEvent(event);
            	
            }else{
            	
            	dispatchEvent(event);
            	
            }
			
		}
		
		protected function handleLoginStatus(e:HTTPStatusEvent):void{
			
			e.target.removeEventListener(e.type, arguments.callee);
			
			var event:PicasaResultEvent;
			
			if(e.status == 200){
            				
            	trace("login performed")
            	loggedIn = true;
            	event = new PicasaResultEvent(PicasaResultEvent.LOGIN_SUCCESS);
            			
            }else{
            				
            	trace("login not performed")
            	loggedIn = false;
            	event = new PicasaResultEvent(PicasaResultEvent.LOGIN_FAULT);
            				
            }
            
            if(_target){
            	
            	_target.dispatchEvent(event);
            	
            }else{
            	
            	dispatchEvent(event);
            	
            }
			
		}
		
		protected function handleLoginResponse(e:Event):void{
			
			e.target.removeEventListener(e.type, arguments.callee);
			
			var raw:String = e.target.data;
			
			SID = raw.substring(raw.indexOf("=") + 1,  raw.indexOf("LSID=")).split("\n").join("").split("\r").join("");
			LSID =  raw.substring(raw.indexOf("LSID=") + 5,  raw.indexOf("Auth=")).split("\n").join("").split("\r").join("");
			Auth = raw.substring(raw.indexOf("Auth=") + 5).split("\n").join("").split("\r").join("");
			
			trace("SID", SID)
			trace("LSID",LSID)
			trace("Auth", Auth)
			
		}
		
		/**
		 * Get all albums for a sepcific user
		 * 
		 * @see http://code.google.com/apis/picasaweb/developers_guide_protocol.html#ClientLogin
		 */ 
		public function getAllAlbums():void{
			
		/* 	var test:HTTPURLLoader = new HTTPURLLoader();
			test.load(new URLRequest(FEED_API_URL + "user/" + username + "?kind=album&access=all"))
			
			return */
			
			
			if(!loggedIn){
				
				throw (new Error("User need to be logged in before getting albums!"));
				
			}else{
				
				var request:URLRequest = new URLRequest(FEED_API_URL + "user/" + username + "?kind=album&access=public");
								
			/* 	request.contentType = "multipart/form-data;";
				request.method = URLRequestMethod.POST;
				
				request.data = addCustomHeader("Authorization:", " GoogleLogin auth='" + Auth + "'"); */
				
				var loader:URLLoader = new URLLoader();
				loader.addEventListener(Event.COMPLETE, onAllAlbumsData);
				
				loader.load(request);
				
			}
			
		}
		
		protected function onAllAlbumsData(e:Event):void{
			
			var xdata:XML = XML(e.target.data)
			
			default xml namespace = new Namespace("xmlns='http://www.w3.org/2005/Atom'");
			
			trace(xdata)
			
			default xml namespace = new Namespace("");
			
		}
		
		protected function addCustomHeader(name:String, value:String):ByteArray{
			
			var header:ByteArray = new ByteArray();
            header.endian = Endian.BIG_ENDIAN;
            
           	for (var i:int = 0; i < name.length; i++){
                        	
           		header.writeByte(name.charCodeAt(i));
                        
			}
                        
            header.writeUTFBytes(value);
                        
            header.writeShort(0x0d0a);
            header.writeShort(0x0d0a);
            
            return header;
			
		}
		
		/**
		 * Method used in order to get the albums of the current user
		 * or of another valid google account
		 * @param user String
		 */ 
		public function getPublicAlbums(user:String = "", changeUser:Boolean = false):void{
			
			if(user == "" && !username){
				
				throw (new Error("User need to be logged in before getting albums!"));
				
			}else{
				
				var u:String;
				
				if(!changeUser){
				
					user != "" ? u = user : u = username;
					
				}else{
					
					u = username = user;
					
				}
				
				var request:URLRequest = new URLRequest(FEED_API_URL + "user/" + u + "?kind=album&access=public");
								
				var loader:URLLoader = new URLLoader();
				loader.addEventListener(Event.COMPLETE, onPublicAlbumsData);
				loader.addEventListener(IOErrorEvent.IO_ERROR, onPublicAlbumsDataFault);
				
				loader.load(request);
				
			}
			
		}
		
		protected function onPublicAlbumsDataFault(e:IOErrorEvent):void{
			
			e.target.removeEventListener(e.type, arguments.callee);
			
			var event:PicasaResultEvent = new PicasaResultEvent(PicasaResultEvent.NO_ALBUM_DATA);
			
			if(_target){
            	
            	_target.dispatchEvent(event);
            	
            }else{
            	
            	dispatchEvent(event);
            	
            }
			
		}
		
		/**
		 * Listener to the Event.COMPLETE event for the kind=album&access=public call
		 * @param e Event
		 */ 
		protected function onPublicAlbumsData(e:Event):void{
			
			e.target.removeEventListener(e.type, arguments.callee);
			
			var xdata:XML = XML(e.target.data)
			
			var ns:Namespace = xdata.namespaceDeclarations()[0];
			var albums:XMLList= xdata.ns::entry;
			
			var tmp:Array = [];
			
			for each(var item:XML in albums){
				
				var album:Album = new Album();
				
				album.id = item.GPHOTO_NAMESPACE::id;
				album.location = item.GPHOTO_NAMESPACE::location;
				album.name = item.GPHOTO_NAMESPACE::name;
				
				tmp.push(album);
					
			}
			
			userAlbums = new ArrayCollection(tmp);		
			
			var event:PicasaResultEvent = new PicasaResultEvent(PicasaResultEvent.ALBUM_DATA);
			
			if(_target){
            	
            	_target.dispatchEvent(event);
            	
            }else{
            	
            	dispatchEvent(event);
            	
            }
			
		}
		
		/**
		 * Method used in order to get the data of a specific album, the method
		 * uses some properties in order to set the size of the thumns and of the
		 * preview images
		 * @param album String
		 * @param user
		 */ 
		public function getPublicAlbumPhotos(album:String, user:String = ""):void{
			
			if(currentPhotos)currentPhotos.removeAll();
			
			var u:String;
				
			user != "" ? u = user : u = username;
			
			var crop:String;
			isCropped ? crop = "c" : crop = "u";
		
			var request:URLRequest = new URLRequest(FEED_API_URL + "user/" + u + "/albumid/" + album + "?thumbsize=" + (thumbSize + crop) + "&imgmax=" + (imageSize + crop) + "&d=");
								
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onPublicAlbumPhotos);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onPublicAlbumPhotosFault);
				
			loader.load(request);
			
		}
		
		protected function onPublicAlbumPhotosFault(e:IOErrorEvent):void{
			
			var event:PicasaResultEvent = new PicasaResultEvent(PicasaResultEvent.NO_ALBUM_DETAILS);
			
			if(_target){
            	
            	_target.dispatchEvent(event);
            	
            }else{
            	
            	dispatchEvent(event);
            	
            }
			
		}
		
		protected function onPublicAlbumPhotos(e:Event):void{
			
			var xdata:XML = XML(e.target.data)
			
			var ns:Namespace = xdata.namespaceDeclarations()[0];
			var photos:XMLList= xdata.ns::entry;
			
			var tmp:Array = [];
			
			for each(var item:XML in photos){
				
				var photo:Photo = new Photo();
				
				photo.original = item.ns::content.@src.split("s" + imageSize + "/").join("");
				photo.name = item.MEDIA_NAMESPACE::group.MEDIA_NAMESPACE::title;
				photo.id = item.GPHOTO_NAMESPACE::id;
				photo.preview = item.MEDIA_NAMESPACE::group.MEDIA_NAMESPACE::content.@url;
				photo.thumbnail = item.MEDIA_NAMESPACE::group.MEDIA_NAMESPACE::thumbnail.@url;
				
				tmp.push(photo);
			}
			
			currentPhotos = new ArrayCollection(tmp);
			
			var event:PicasaResultEvent = new PicasaResultEvent(PicasaResultEvent.ALBUM_DETAILS);
			
			if(_target){
            	
            	_target.dispatchEvent(event);
            	
            }else{
            	
            	dispatchEvent(event);
            	
            }
			
		}
		
		public function testSocket():void{
			
		var sData:String =	"POST /data/media/api/user/" + username + "/albumid/5285487739590107649/photoid/5285487739590107649/"  
							sData += "HTTP/1.1\n\r" 
							sData += "Host: picasaweb.google.com"
							sData += "X-HTTP-Method-Override: DELETE" 
							sData += "Authorization: GoogleLogin auth=" + Auth
							sData += "Content-Length: 0" 
							sData += "Content-Type: application/x-www-form-urlencoded"
			var socket:Socket = new Socket();
			
			socket.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void{
				
				trace(e.errorID)
				trace(e.text)
				trace(e.type)
				
			})
			
			socket.connect("72.14.247.190", 443);
			socket.writeUTF(sData);
			socket.close()

			
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