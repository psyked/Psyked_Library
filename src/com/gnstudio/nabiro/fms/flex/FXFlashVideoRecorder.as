package com.gnstudio.nabiro.fms.flex
{
	import com.gnstudio.nabiro.fms.IVideoRecorder;
	import com.gnstudio.nabiro.mvp.encryption.MD5;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import mx.core.UIComponent;

	public class FXFlashVideoRecorder extends UIComponent implements IVideoRecorder{
		
		// Thumbnails
		public static const THUMBS:int = 4;
		public static const THUMB_WIDTH:Number = 78;
		public static const THUMB_HEIGHT:Number = 78;
		
		// Events const
		public static const CONNECTION_READY:String = "onConnectionReady";
		public static const CONNECTION_ERROR:String = "onConnectionError";
		public static const START_RECORDING:String = "onStartRecording";
		public static const PAUSE_RECORDING:String = "onPauseRecording";
		public static const THUMBS_RECOVERED:String = "onThumbsRecovered";
		
		// FMS assets
		private var nc:NetConnection;
		private var ns:NetStream;
		
		// Media assets
		private var video:Video;
		private var camera:Camera;
		
		// Component is already recording
		protected var isRecording:Boolean;
		
		// FMS instance definition
		private var server:String;
		private var userId:String;
		
		// Status of the component
		private var isOnTheStage:Boolean;
		
		// Video management
		public var currentVideoName:String;
		
		
		public function FXFlashVideoRecorder(){
			
			super();
									
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
						
		}
		
		private function onAdded(e:Event):void{
			
			isOnTheStage = true;
			
			video = new Video(videoWidth, videoHeight);
			
			addChild(video);
			
			update();
			
		}
		
		
		public function purgeAll():void{
			
			if(nc){
				
				ns.close()
				nc.close()
				
			}
			
			if(replayedStream){
				
				replayedStream.seek(0)
				replayedStream.pause();
				
			}
			
			video.clear();
			
		}
		
		private function onRemoved(e:Event):void{
			
			isOnTheStage = false;
			
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
		}
		
		/**
		 * Size of the video width with default values
		 */
		private var _videoWidth:Number = 1;
		 
		public function get videoWidth():Number{
		 	
			return _videoWidth;
		 	
		}
		 
		public function set videoWidth(value:Number):void{
		 	
			if(value != _videoWidth){
		 		
		 		_videoWidth = value;
		 		
		 		update();
		 		
		 	}
		 	
		 }
		 
		/**
		 * Size of the video height with default values
		 */
		private var _videoHeight:Number = 1;
		 
		public function get videoHeight():Number{
		 	
			return _videoHeight;
		 	
		}
		 
		public function set videoHeight(value:Number):void{
		 	
			if(value != _videoHeight){
		 		
				_videoHeight = value;
		 		
		 		update();
		 		
			}
		 	
		}
		
		/**
		 * Background color definition
		 */
		private var _background:uint = 0x000000;
		
		public function set background(value:uint):void{
			
			if(value != _background){
				
				_background = value;
				update();
				
			}
			
		}
		
		public function get background():uint{
			
			return _background;
			
		}
		
		/**
		 * Background alpha value with default
		 */		
		private var _backgroundAlpha:Number = 1.0; 
		
		public function set backgroundAlpha(value:Number):void{
			
			if(value != _backgroundAlpha){
				
				_backgroundAlpha = value;
				update();
				
			}
			
		}
		
		public function get backgroundAlpha():Number{
			
			return _backgroundAlpha;
			
		}
		
		/**
		 * Border color value 
		 */
		private var _backgroundBorder:uint = 0x000000;
		
		public function set backgroundBorder(value:uint):void{
			
			if(value != _backgroundBorder){
				
				_backgroundBorder = value;
				
			}
			
		}
		
		public function get backgroundBorder():uint{
			
			return _backgroundBorder;
			
		}
		 
		/**
		 * Marker for the update
		 */
		private var _udpateDirty:Boolean;
		
		/**
		 * Update the UI in order to change the video 
		 * instance size and the background color
		 */ 
		private function update():void{
		 	
		 	if(!isOnTheStage){
		 	
		 		_udpateDirty = true;
		 		return;
		 	
		 	}
		 	
		 	if(video){
		 		
		 		video.width = videoWidth;
		 		video.height = videoHeight;
		 		
		 	}
		 	
		 //	if(background){
		 		
		 		graphics.clear();
		 		
		 		graphics.beginFill(_background, _backgroundAlpha);
		 		
		 	//	if(_backgroundBorder){
		 			
		 			graphics.lineStyle(1, _backgroundBorder, 1);
		 		
		 		//}
		 		
		 		graphics.drawRect(0, 0, videoWidth, videoHeight);
		 		
		 //	}
		 	
		 	trace("update!", _backgroundBorder, background, videoWidth, videoHeight)
		 	
		}
		
		/**
		 * Hanlder of the net connection
		 * @param e NetStatusEvent
		 */
		protected function onStatus(e:NetStatusEvent):void{
			
			trace(e.info.code)
			
			if(e.info.code != "NetConnection.Connect.Success"){
				
				dispatchEvent(new Event(CONNECTION_ERROR));
				
			}else{
				
				ns = new NetStream(nc);
				ns.client = this;
				
				ns.addEventListener(NetStatusEvent.NET_STATUS, onStreamReady)
				ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncMessages);
				
				dispatchEvent(new Event(CONNECTION_READY));
				
			}
			
		}
		
		public function onPlayStatus(info:Object):void {
			
			trace("handling playstatus here");
		
		}
		
		public function onMetaData(info:Object):void {
		
			trace("width: " + info.width);
			trace("height: " + info.height);
		
		}
		
		protected function onAsyncMessages(e:AsyncErrorEvent):void{
			
			trace("***", e.error)
			
		}
		
		/**
		 * Send the informations to the parent instance about the streaming status
		 * @param e NetStatusEvent
		 */ 
		protected function onStreamReady(e:NetStatusEvent):void{
			
			trace(e.info.code);
			
			dispatchEvent(new Event(e.info.code));
			
		}
		
		/**
		 * Generate the video file name accordingly to the uid and date
		 * @return videoName String
		 */
		protected function get createVideoName():String{
			
			var d:Date = new Date();			
			var vName:String = String(userId) + d.valueOf();
			
			currentVideoName =  MD5.encrypt(vName);
			
			return currentVideoName;
			
		}
		
		/**
		 * Method called from the server in order to get the thumbList
		 * @param value Array
		 */ 
		public function getVideos(value:Array):void{
			
			_thumbs = value;
			
			if(value.length > THUMBS){
				
				_thumbs = _thumbs.slice(0, THUMBS);	
				
			}
			
			dispatchEvent(new Event(THUMBS_RECOVERED));
			
		}
		
		/**
		 * Thumb list
		 */
		private var _thumbs:Array;
		
		public function get thumbs():Array{
			
			return _thumbs;
			
		}
		
		/**
		 * Net connection
		 */
		public function get netConnection():NetConnection{
			
			return nc;
			
		} 
				
		/***********************************************
		 ******** IVideoRecorder Implementation ********
		 **********************************************/
		 
		 public function startPreview():void{
		 	
		 	if(!camera){
				
				camera = Camera.getCamera();
								
			}
			
			video.attachCamera(camera);
		 	
		 }    
		 
		public function connect(fmsAddress:String, uid:String = ""):void{
		 	
		 	if(!nc){
		 		
		 		nc = new NetConnection();
		 		nc.client = this;
		 		nc.addEventListener(NetStatusEvent.NET_STATUS, onStatus);
		 		
		 		nc.connect(fmsAddress, uid);
		 		
		 		
		 	}else{
		 		
		 		if(server != fmsAddress || userId != uid){
		 			
		 			nc.close();
		 			
		 			nc.connect(fmsAddress + "/" + uid, uid);
		 			
		 		}		 		
		 		
		 	}
		 	
		 	server = fmsAddress;
		 	userId = uid;
		 	
		}
				
		public function recordVideo():void{
					
			if(!camera){
				
				camera = Camera.getCamera();
								
			}
			
			video.attachCamera(camera);
			
			ns.attachCamera(camera);
			
			var mic:Microphone = Microphone.getMicrophone();
			mic.setUseEchoSuppression(true);

			ns.attachAudio(mic);
			
			ns.publish(createVideoName, "record");
			
			isRecording = true;
			
			dispatchEvent(new Event(START_RECORDING));			
			
		}
		
		public function stopRecording():void{
			
			isRecording = false;
			
			ns.close();
			
		}
		
		public function pauseRecording():void{
			
			if(isRecording){
				
				isRecording = false;
				ns.pause();
				
			}else{
				
				ns.publish(currentVideoName, "append");
				isRecording = true;
				
			}
			
			
		}
		
		private var replayedStream:NetStream;
		public function playStream(net:NetStream):void{
			
			replayedStream = net;
			
			video.clear();
				
			video.attachNetStream(replayedStream);
			
			replayedStream.resume()
			
		}
		
		public function stopStream():void{
			
			if(replayedStream){
				
				replayedStream.pause();
				
			}
			
		}
		
		public function set mute(value:Boolean):void{
			
			var s:SoundTransform
			
			if(ns){
				
				s = ns.soundTransform;
				
				if(value){
					
					s.volume = 0;
					
				}else{
					
					s.volume = 1;
					
				}
				
				ns.soundTransform = s;
				
			}
			
			if(replayedStream){
				
				s = replayedStream.soundTransform;
				
				if(value){
					
					s.volume = 0;
					
				}else{
					
					s.volume = 1;
					
				}
				
				replayedStream.soundTransform = s;
				
			}
			
		}
		
		public function reviewVideo(id:String = ""):void{
			
			if(isRecording){
				
				ns.close();
				
			}
			
			// if the id is an empty string it reproduce the actual video
			if(id == ""){
				
				ns.play(currentVideoName);
				
				video.clear();
				
				video.attachNetStream(ns);
				
			}else{
				
				ns.play(id);
				
				video.clear();
				
				video.attachNetStream(ns);
				
			}
			
			
		}
		
		public function confirmVideo(id:int = 0):void{
			
			
			
		}  
		
	}
}