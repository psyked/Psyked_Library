package com.gnstudio.nabiro.air.utilities.volumeswatcher {
	
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
	 *   @author 					Ivan Varga <ivan.varga@gnstudio.com>
	 *   
	 *	 
	 */
	
	import com.gnstudio.nabiro.air.utilities.events.VolumesWatcherEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.system.Capabilities;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	//----------------------------------------------------------------------
	//
	//  Events
	//
	//----------------------------------------------------------------------
	
	/**
	 * Dispatched when new volume is mounted.
	 * 
	 * @eventType com.gnstudio.air.utilities.events.VolumesWatcherEvent.VOLUME_ADDED
	 */
	[Event(name="VOLUME_ADDED", type="com.gnstudio.air.utilities.events.VolumesWatcherEvent")]
	
	/**
	 * Dispatched when volume is removed.
	 * 
	 * @eventType com.gnstudio.air.utilities.events.VolumesWatcherEvent.VOLUME_REMOVED
	 */
	[Event(name="VOLUME_REMOVED", type="com.gnstudio.air.utilities.events.VolumesWatcherEvent")]       
	
	/**
	 * VolumesWatcher is a singleton class that looks for mounted/removed
	 * external storage drives or inserted/removed disks (CDs, DVDs, ...).
	 */
	public class VolumesWatcher implements IEventDispatcher {
		
		//----------------------------------------------------------------------
		//
		//  Constants
		//
		//----------------------------------------------------------------------
            
        private const WATCH_INTERVAL:Number = 1000;
        
		//----------------------------------------------------------------------
		//
		//  Variables
		//
		//----------------------------------------------------------------------

		/**
		 * @private 
		 * Reference to single instance of this class. 
		 */
		private static var instance:VolumesWatcher;

		/**
		 * @private 
		 * Reference to EventDsipatcher instance used in order to implement IEventDispatcher. 
		 */
		private var eventDispatcher:EventDispatcher;	

		/**
		 * @private 
		 */
        private var timer:Timer;
        
		/**
		 * @private 
		 */
        private var volumes:Dictionary;
        
		//----------------------------------------------------------------------
		//
		//  Constructor / Singleton implementation
		//
		//----------------------------------------------------------------------

        /**
         * @public 
         * Singleton implementation of constructor.
         */
        public function VolumesWatcher() {
        	
			if (instance != null) {
				
				throw new Error("This a singleton class!");
			}
			
			// Instantiate EventDispatcher.
			eventDispatcher = new EventDispatcher();
			
			instance = this;
		}

        /**
         * @public 
         * Get the single instance of the class.
         */
		public static function getInstance():VolumesWatcher {
			
			if (instance == null) {
				
				instance = new VolumesWatcher();
			}
			
			return instance;
		}
        
		//----------------------------------------------------------------------
		//
		//  Class methods and utilities
		//
		//----------------------------------------------------------------------
        
		/**
		 * @public
		 * Start watching volume changes.
		 */
        public function start():void {
        	
            if (!timer) {
            	
                timer = new Timer(WATCH_INTERVAL);
                
                timer.addEventListener(TimerEvent.TIMER, timerEventHandler, false, 0, true);
            }
            
            // Reinitialize the hash everytime we start watching.
            volumes = new Dictionary();
            
            var v:Array = getRootDirectories();
            
            for each (var f:File in v) {

				if (volumes[f.url] == null) {

					volumes[f.url] = f;
				}
            }                       
            
            timer.start();
        }
        
		/**
		 * @public
		 * Stop watching volume changes. 
		 */
        public function stop():void {
        	
        	if (timer) {
        		
		        timer.stop();
		        
		        timer.removeEventListener(TimerEvent.TIMER, timerEventHandler);
        	}
        }
        
		/**
		 * @private
		 * Timer event handler.
		 */
        private function timerEventHandler(e:TimerEvent):void {
        	
            var v:Array = getRootDirectories();
            var vwEvent:VolumesWatcherEvent;
            var found:Boolean = false;

            for (var key:String in volumes) {
            	
	            for each (var fa:File in v) {
	            	
		            if (fa.url == key) {
		            	
	                    found = true;
	                    break;
		            }
	            }
	            
	            if (!found) {
	            	
                    vwEvent = new VolumesWatcherEvent(VolumesWatcherEvent.VOLUME_REMOVED);
                    vwEvent.file = volumes[key];
                    
                    dispatchEvent(vwEvent);

                    delete volumes[key];
	            }
	            
	            found  = false;
            }
            
            for each (var fb:File in v) {
            	
                if (volumes[fb.url] == null) {
                	
                    volumes[fb.url] = fb;

                    vwEvent = new VolumesWatcherEvent(VolumesWatcherEvent.VOLUME_ADDED);
                    vwEvent.file = fb;
                    
                    dispatchEvent(vwEvent);
                }
            }
        }

		/**
		 * @private
		 * Get root directories of the operating system.
		 * 
		 * @return An Array of Files representing the root directories of the operating system. 
		 */
        private function getRootDirectories():Array {
        	
			var v:Array = File.getRootDirectories();
			var os:String = Capabilities.os;
			
			if (os.indexOf("Mac") > -1) {
				
				v = File(v[0]).resolvePath("Volumes").getDirectoryListing();
				
			} else if (os.indexOf("Linux") > -1) {
				
				// TODO Need to impliment Linux.
			}
			
			return v;
        }
        
		//----------------------------------------------------------------------
		//
		//  IEventDispatcher implementation
		//
		//----------------------------------------------------------------------
	
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			
			eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			
			eventDispatcher.removeEventListener(type, listener, useCapture);	
		}
		
		public function dispatchEvent(event:Event):Boolean {
			
			return eventDispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean {
			
			return eventDispatcher.hasEventListener(type);
		}
		
		public function willTrigger(type:String):Boolean {
			
			return eventDispatcher.willTrigger(type);
		}
    }
}