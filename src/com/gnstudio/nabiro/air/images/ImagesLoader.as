package com.gnstudio.nabiro.air.images
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
	
	import com.gnstudio.nabiro.air.images.data.ImageData;
	import com.gnstudio.nabiro.air.images.events.ImageLoadEvent;
	import com.gnstudio.nabiro.utilities.BitmapUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;

    [Event(name="load", type="flash.events.Event")]
    [Event(name="invalid", type="flash.events.Event")]
    [Event(name="complete", type="flash.events.Event")]
    
    public class ImagesLoader implements IEventDispatcher{
    	
    	/**
    	 * EventDsipatcher instance used in order to implement IEventDispatcher
    	 */ 
		private var eventDispatcher:EventDispatcher;
		protected static var target:IEventDispatcher;
    	
    	/**
    	 * Singleton implementation
    	 */ 
    	private static var imagesLoader:ImagesLoader;
		private static var className:String = getQualifiedClassName(super);
    	
    	/**
    	 * Queue of the images to load
    	 */ 
        private var _queue:Array;
        
        /**
        * Loader and current file
        */ 
        private var _loader:Loader;
        private var _file:File;
		
		/**
		 * Filter on the file extensions
		 */ 
        protected var _filter:RegExp = /^\S+\.(jpg|jpeg|png)$/i;
		
		/**
		 * Constants used for the event dispatching
		 */ 
        public static const INVALID:String = "invalid";
        public static const VALID:String = "valid";
        public static const COMPLETE:String = "complete";

        public function ImagesLoader(){
        	
        	if (imagesLoader != null && getQualifiedSuperclassName(this) != className) throw new Error("This a singleton class!");
        	
        	eventDispatcher = new EventDispatcher();
        	
            _queue = [];
            _loader = new Loader();
            
            _loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
            _loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadError );
            
        }
        
        /**
		 * Method used to be sure that only an instance of the class will be created
		 * @param target IEventDispatcher
		 */ 
		public static function getInstance(target:IEventDispatcher = null):ImagesLoader{
						
			if(!ImagesLoader.imagesLoader){
				
				ImagesLoader.imagesLoader = new ImagesLoader();				
				
			}
			
			if(target){
				
				// Define the target that will get the evens
				ImagesLoader.target = target;
							
			}
									
			return ImagesLoader.imagesLoader;
			
		}
		
		/**
		 * Validation of the file extensions against the 
		 * protected _filter property
		 * @param file File
		 */ 
        private function validateFile(file:File):Boolean{
        	
            return _filter.exec( file.name ) != null;
        
        }
		
		/**
		 * Handler of the IOErrorEvent.IO_ERROR event that can occours 
		 * during the loading of each single image
		 * @param e IOErrorEvent
		 */ 
        protected function onLoadError(e:IOErrorEvent):void{
        	
             if(ImagesLoader.target){
             
             	ImagesLoader.target.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, e.text));
             
             }else{
             	
             	dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, e.text));
             
             }
            
        }
		
		/**
		 * Handler of the Event.COMPLETE event that occours each time
		 * that an image is loaded
		 * @param e Event
		 */ 
        protected function onLoadComplete(e:Event):void {
        	
        	// Send the data of the images in the event flow
        	var bd:BitmapData = ( _loader.content as Bitmap ).bitmapData
        	
            var data:ImageData = new ImageData( _file.name, _file.url, BitmapUtil.generateThumbnail(( _loader.content as Bitmap ).bitmapData));
            
            if(ImagesLoader.target){
            	
            	ImagesLoader.target.dispatchEvent(new ImageLoadEvent(data));
            
            }else{
            	
            	dispatchEvent(new ImageLoadEvent(data));
            	
            }
            
            // Handling of the queue
            if( _queue.length <= 0 ){
				
				if(ImagesLoader.target){
					
					ImagesLoader.target.dispatchEvent(new Event(COMPLETE));
					
				}else{
					
					 dispatchEvent(new Event(COMPLETE));
					
				}
               
                // Clear the queue if all the images are loaded
                clear();                
            
            }else{
            	
            	// Load the next image
                loadNext();    
                
            }
        }

		/**
		 * Load a file getting the information from the queue
		 * @param file File
		 */ 
        private function loadFile(file:File):void {
            
            _file = file;
            
            if( validateFile(_file)){
            	
                _loader.load( new URLRequest(_file.url));
                
                if(ImagesLoader.target){
            		
            		ImagesLoader.target.dispatchEvent( new Event(VALID));
            		
            	}else{
            		
            		dispatchEvent( new Event(VALID));
            		
            	}     
            
            }else{
            	
            	if(ImagesLoader.target){
            		
            		ImagesLoader.target.dispatchEvent( new Event(INVALID));
            		
            	}else{
            		
            		dispatchEvent( new Event(INVALID));
            		
            	}               
                
                if( _queue.length > 0 ){
                	
                	loadNext();
                	
                }else{
                
                	if(ImagesLoader.target){
                		
                		ImagesLoader.target.dispatchEvent(new Event(COMPLETE));
                		
                	}else{
                		
                		dispatchEvent( new Event(COMPLETE));
                		
                	}               	
                
                }
            }
        }
		
		/**
		 * Load the next file removing an element from the queue
		 */ 
        private function loadNext():void{
        	
            if( _queue.length > 0){
                
                loadFile(_queue.shift());
            
            }
        }
        
       	/**
         * Load all the files stored in the queue
         */ 
       	public function loadAll():void{
        	
           if( _queue.length <= 0 ) return;
            
            loadFile(_queue[0]);
             
           _queue.shift();
            
       	}
		
		/**
		 * Add a single file to the queue
		 * @param file File
		 */ 
       	public function addFile(file:File):void{
        	
        	_queue.push(file);
            
       	}
		
		/**
		 * Add multiple files to the queue
		 * @param elements Array
		 */ 
		public function addFiles(elements:Array):void{
						
			if(_queue.length > 0){
				
				_queue.concat(elements);
				
			}else{
				
				_queue = elements;
				
			}
			
		}
		
		/**
		 * Method used to reset the queue
		 */ 
        public function clear():void{
        	
        	// Check if the process of loading an image is still occourring
        	if(_loader.contentLoaderInfo.bytesLoaded < _loader.contentLoaderInfo.bytesTotal){
        		
        		// Close it
        		_loader.close();
        		
        	}
        	
            _queue = [];
            
        }
        
        /************************************
		* IEventDispatcher immplementation
		*************************************/ 
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0.0, useWeakReference:Boolean=false):void{
			
			eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
			
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void	{
			
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