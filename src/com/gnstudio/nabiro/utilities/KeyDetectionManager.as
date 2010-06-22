package com.gnstudio.nabiro.utilities
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
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	
	public class KeyDetectionManager implements IEventDispatcher {
		
		private var eventDispatcher:EventDispatcher;
		
		// a list of all the key codes that have been pressed
		private var keys_pressed:Array;
		
		// a multi-dimensional list of all of our key combinations
		private var key_combinations:Array;
		
		// objects listening to this detection
		private var listeners:Array;
		
		// Static instance
		private static var _instance:KeyDetectionManager;
		
		// Stage reference
		private static var stage:Stage;

		
		// Dictionary for the pressed key
		private var keysDown:Dictionary
		
		/* Constructor */
		public function KeyDetectionManager() {
			
			if (_instance != null) throw new Error("KeyDetectionManager is obviously Singleton.");
			
			eventDispatcher = new EventDispatcher()
			
			keys_pressed = [];
			
			key_combinations = [];
			
			listeners = [];
			
			keysDown = new Dictionary(true);
			
		}
		
		public static function getManager(dispaly:DisplayObject):KeyDetectionManager{
			
			if(!KeyDetectionManager._instance){
				
				KeyDetectionManager._instance = new KeyDetectionManager();
				KeyDetectionManager.stage = dispaly.stage;
			
				
			}
			
			return KeyDetectionManager._instance;			
			
		}
		
		private var _enabled:Boolean;
		
		public function set enabled(value:Boolean):void{
			
			if(value){
				
				KeyDetectionManager.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				KeyDetectionManager.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
				
			}else{
				
				KeyDetectionManager.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				KeyDetectionManager.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
				
			}
			
			_enabled = value;
			
		}
		
		public function get enabled():Boolean{
			
			return _enabled;
			
		}
		
		/**
		 * Registers an object to listen for events from the KeyDetection class
		 * @param listener IEventDispatcher
		 */
		public function addHandler(listener:IEventDispatcher):void {
			
			for (var i:Number = 0; i<listeners.length; i++) {
				
				if (listeners[i] == listener) {
					
					return;
				}
				
			}
			
			listeners.push(listener);
			
		}
		/**
		 * Unregisters an object that is listening for events from the KeyDetection class
		 * @param listener IEventDispatcher
		 */
		public function removeHandler(listener:IEventDispatcher):void {
			
			for (var i:Number = 0; i<listeners.length; i++) {
				
				if (listeners[i] == listener) {
					
					listeners.splice(i, 1);
					
				}
			}
		}
		/**
		 * Adds a key combination to listen for
		 * @param name String The name you are giving this combination.  
		 * Note that this is how you will identify which combination has been pressed.
		 * @param keyCode1 int 
		 * @param keyCode2 int 
		 * @param keyCode3 int 
		 * The key codes that you are part of this combination.  Note that they will need to be pressed in the order
		 * that you list them in order for the combination to be fire successfully.
		 */
		public function addCombination(name:String, keyCode1:int, keyCode2:int, keyCode3:int):void {
			
			key_combinations.push(arguments);
			
		}
		// invokes the onKeyCombination event on all listeners
		private function invokeOnKeyCombination(combo_name:String):void {
			
			for (var i:Number = 0; i<listeners.length; i++) {
				
				(listeners[i] as IEventDispatcher).dispatchEvent(new Event(combo_name));
				
			}
		}
		
		private function onKeyUp(e:KeyboardEvent):void {
			
			delete keysDown[e.keyCode];

		}
		
		public function isDown(keyCode:int):Boolean {
			
			return Boolean(keyCode in keysDown);
		
		}
		

		
		private function onKeyDown(e:KeyboardEvent):void {
			
			keysDown[e.keyCode] = true;
			
			var key:int = e.keyCode;
			
			for (var i:Number = 0; i<keys_pressed.length; i++) {
				
				if (!isDown(keys_pressed[i])) {
					
					keys_pressed.splice(i, (keys_pressed.length-i));
				
				}
			}
			
			if (key != keys_pressed[keys_pressed.length-1]) {
				
				keys_pressed.push(key);
				
			}
			
			checkCombinations();
			
		}
		
		private function checkCombinations():void {
			
			for (var j:Number = 0; j<key_combinations.length; j++) {
				
				for (var i:Number = 0; i<keys_pressed.length; i++) {
					
					if (keys_pressed[i] == key_combinations[j][i+1]) {
						
						if (i == key_combinations[j].length-2) {
							
							invokeOnKeyCombination(key_combinations[j][0]);
							return;
							
						}
						
					}else{
						
						break;
						
					}
				}
			}
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
