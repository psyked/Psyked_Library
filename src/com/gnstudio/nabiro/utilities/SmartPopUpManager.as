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
	
	import com.gnstudio.nabiro.utilities.events.SmartPopUpChangeEvent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.core.IFlexDisplayObject;
	import mx.effects.Move;
	import mx.effects.easing.Quintic;
	import mx.managers.PopUpManager;
	
	public class SmartPopUpManager implements IEventDispatcher{
		
				
		private var _openedPopup:int = 0;
		private var _lastPopup:IFlexDisplayObject;
		
		private var eventDispatcher:EventDispatcher;
		private var target:IEventDispatcher;
		
		private var moveEffect:Move;
		
		private static var _globalParent:DisplayObject;
		
		public static function set globalParent(value:DisplayObject):void{
			
			_globalParent = value;
			
		}
		
		public static function get globalParent():DisplayObject{
			
			return _globalParent;
			
		}
		
		[Bindable]
		public function get openedPopup():int{
			
			return _openedPopup;
			
		}
		
		/**
		 * Center the popup
		 */		
		private static var _centerPopUp:Boolean = true;
		
		public static function get doCenterPopUp():Boolean{
			
			return _centerPopUp;
			
		}
		
		public static function set doCenterPopUp(value:Boolean):void{
			
			_centerPopUp = value;
			
		}	
		
		/**
		 * Use the transitions to center the popup
		 */		
		private static var _useTranistion:Boolean = true;
		
		public static function get useTranistion():Boolean{
			
			return _useTranistion;
			
		}
		
		public static function set useTranistion(value:Boolean):void{
			
			_useTranistion = value;
			
		}		
		
		public function set openedPopup(value:int):void{
			
			_openedPopup = value;
			
			var e:SmartPopUpChangeEvent = new SmartPopUpChangeEvent(SmartPopUpChangeEvent.POP_UP_CHANGED, _openedPopup);
			
			if(target){
				
				target.dispatchEvent(e);
				
			}else{
				
				dispatchEvent(e);
				
			}
						
		}
		
		private static var _instance:SmartPopUpManager = new SmartPopUpManager();
		
		public function SmartPopUpManager(){
			
			if (_instance != null) throw new Error("SmartPopUpManager is obviously Singleton.");
			
			eventDispatcher = new EventDispatcher()
			
		}		
		
		public static function addPopUp(window:IFlexDisplayObject, parent:DisplayObject, modal:Boolean = false, childList:String = null):void{
			
			_instance.openedPopup++;
			
			var p:DisplayObject;
			
			if(parent == null && _globalParent != null){
				
				p = SmartPopUpManager._globalParent;
				
			}else{
				
				p = parent;
				
			}
			
			PopUpManager.addPopUp(window, p, modal, childList);
			
		}
		
		public static function getInstance(tg:IEventDispatcher = null):SmartPopUpManager  {
			
			if(tg){
				
				_instance.target = tg;
				
			}
			
			return _instance;
			
		}
		
		public static function bringToFront(popUp:IFlexDisplayObject):void{
			
			PopUpManager.bringToFront(popUp);
			
		}
		
		public static function centerPopUp(popUp:IFlexDisplayObject):void{
			
			PopUpManager.centerPopUp(popUp);
			
		}
		
		public static function createPopUp(parent:DisplayObject, className:Class, modal:Boolean = false, childList:String = null):IFlexDisplayObject{
			
			_instance.openedPopup++;
			
			var p:DisplayObject;
			
			if(parent == null && _globalParent != null){
				
				p = SmartPopUpManager._globalParent;
				
			}else{
				
				p = parent;
				
			}
			
			try{
			
				_instance._lastPopup = PopUpManager.createPopUp(p, className, modal, childList);;
				
				if(SmartPopUpManager.doCenterPopUp){
					
					_instance._lastPopup.stage.addEventListener(Event.RESIZE, _instance.handleResize);
					_instance._lastPopup.addEventListener(Event.REMOVED_FROM_STAGE, _instance.clear);
				
				}
			
			}catch(e:Error){
				
				trace(new className())
				
				/* _instance._lastPopup =  */PopUpManager.addPopUp(new className() as IFlexDisplayObject, p, true, childList);
				
			}
			
			return _instance._lastPopup;
			
		}
		
		private function clear(e:Event):void{
			
			 e.target.stage.removeEventListener(Event.RESIZE, handleResize);
			
		}
		
		private function handleResize(e:Event):void{
			
			if(SmartPopUpManager.useTranistion){
				
				if(moveEffect){
					
					moveEffect.stop();
					moveEffect = null;
					
				}
				
				moveEffect = new Move();
				moveEffect.target = _lastPopup;
				moveEffect.duration = 500;
				moveEffect.easingFunction = Quintic.easeInOut;
				moveEffect.xTo = (_lastPopup.stage.stageWidth - _lastPopup.width) / 2;
				moveEffect.yTo = (_lastPopup.stage.stageHeight - _lastPopup.height) / 2;
				moveEffect.play();
			
			}else{
				
				PopUpManager.centerPopUp(_lastPopup);
				
			}
			
		//	
			
		}
		
		public static function removePopUp(popUp:IFlexDisplayObject):void{
						
			if(_instance.openedPopup > 0){
			
				_instance.openedPopup--;
				PopUpManager.removePopUp(popUp);
				
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

