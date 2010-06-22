package com.gnstudio.nabiro.fms.flash
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;

	public class FMSSnapShot extends Sprite
	{
		
		private var ns:NetStream;
		private var video:Video;
		
		private var videoWidth:Number;
		private var videoHeight:Number;
		private var videoFile:String;
		
		public function FMSSnapShot(c:NetConnection, file:String, w:Number, h:Number){
			
		
			ns = new NetStream(c);
			ns.client = this;
			/* ns.addEventListener(NetStatusEvent.NET_STATUS, function(e:NetStatusEvent):void{
				
				trace(e.info.code)
				
			})
			 */
			videoFile = file;
			
			videoHeight = h;
			videoWidth = w;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			
			
		}
		
		public function onMetaData(info:Object):void {
			
			
		}
		
		private function onRemoved(e:Event):void{
			
			video.clear();
			ns.close();
			
		}
		
		private function onAdded(e:Event):void{
			
			video = new Video();
			
			video.width = videoWidth;
		 	video.height = videoHeight;
		 	
		 	addChild(video);
			
			video.attachNetStream(ns);
           	ns.play(videoFile);           
           	
           	var t:Timer = new Timer(100);
           	t.addEventListener(TimerEvent.TIMER, showPreview);
           	
         	t.start();
						
			this.graphics.lineStyle(1, 0xff0000, 1);
			this.graphics.drawRect(0, 0, videoWidth, videoHeight)
			
			
		}
		
		
		// Seeks to the beginning of the video
         private function showPreview(e:TimerEvent):void {
            
            e.target.removeEventListener(e.type, arguments.callee);
            
            ns.seek(0);     
            
          	ns.pause();    
           
         
         }      

		
	}
}