package com.gnstudio.nabiro.ui
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
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.events.VideoEvent;
	
	public class SnapShotVideoPlayer extends VideoPlayer{
		
		public static const BITMAP_DATA:String = "onBitmapData";
		
		private var _doSnapshot:Boolean;
		
		private var delayed:Timer;
		
		/**
		 * Snapshot of the video
		 */ 
		private var _snapShot:BitmapData;
		
		public function get snapShot():BitmapData{
						
			return _snapShot;
			
		}
				
		public function SnapShotVideoPlayer(doSnapshot:Boolean = true){
			
			super();
			
			_doSnapshot = doSnapshot;
						
			setStyle("backgroundAlpha", 0);					
			
		}
		
		
		override protected function childrenCreated():void{
			
			super.childrenCreated();
			
			//if(_doSnapshot)this.addEventListener(VideoEvent.PLAYING, onVideoReady);
			
			//return			
			
			if(_doSnapshot){
				
				this.addEventListener(VideoEvent.PLAYING, onVideoReady);
								
				var checker:Timer = new Timer(60);
				checker.addEventListener(TimerEvent.TIMER, onChecker);
				
				visible = false;
				
				checker.start();
				
				
				
			}
						
		}
		
		private function onChecker(e:TimerEvent):void{
						
			if(this.state == "playing"){
												
				e.target.stop();
				e.target.removeEventListener(e.type, arguments.callee);
				
				getSnapShot();
				
			}
				
		}
				
		protected function onVideoReady(e:VideoEvent):void{
			
			trace("video is ready")
			
			stop();
			
			return;
			
			trace("############", this.playheadTime)
			
			e.target.removeEventListener(e.type, arguments.callee);
			
			playheadTime = 4
			
			trace("############", this.playheadTime)
			
			getSnapShot()
			
			//stop()
								
			/* var ciccio: Timer = new Timer(500)//callLater(getSnapShot)//();					
			ciccio.addEventListener(TimerEvent.TIMER, function(evt:TimerEvent):void{
				trace("statrato")
				evt.target.removeEventListener(evt.type, arguments.callee);
				getSnapShot()
				
			});
			
			ciccio.start() */
		}
				
		
		private function getSnapShot():void{
			
			stop();
			
			/* trace("playheadTime", playheadTime ) 
			
			playheadTime = 0;
			
			trace("playheadTime", playheadTime ) 
			
			stop(); */
							
			visible = true;
			
			try{
				
				_snapShot = new BitmapData(this.videoWidth, this.videoHeight, true, 0x00000000);
				_snapShot.draw(this);
				
				if(delayed){
					
					delayed.stop();
					delayed.removeEventListener(TimerEvent.TIMER, onGetSnapShotDelayed);
					
				}
				
				dispatchEvent(new Event(SnapShotVideoPlayer.BITMAP_DATA));	
							
			}catch(e:Error){
								
				if(!delayed){
				
					delayed = new Timer(10);
					delayed.addEventListener(TimerEvent.TIMER, onGetSnapShotDelayed);
				
					delayed.start();				
				
				}
				
			}			
			
		}
		
		private function onGetSnapShotDelayed(e:TimerEvent):void{
			
			getSnapShot();
					
		}
		
	}
}