package com.gnstudio.nabiro.mvp.core
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
	
	import com.gnstudio.nabiro.mvp.command.CommandCallEvent;
	import com.gnstudio.nabiro.mvp.mapper.PresenterNotifier;
	import com.gnstudio.nabiro.mvp.core.events.UpdatePresenterEvent;
	
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.getQualifiedClassName;
	
	
	/**
	 * The presenter base class is able to get a view to update and a set of property to 
	 * watch trough a PresenterChangeDetector instance, the PresenterChangeDetector can 
	 * listen to specific VO properties or to ANY if you don't have a domain strictly
	 * connected to the UI
	 */ 
	public class Presenter implements IEventDispatcher{
		
		protected var _dataSet:*;
		
		// EventDsipatcher instance used in order to implement IEventDispatcher
		private var eventDispatcher:EventDispatcher;
		
		protected var _view:IView;
		
		public function Presenter(v:IView = null, ...props){			
			
			// Check the name of the class to avoid mistakes
			var name:String = getQualifiedClassName(this);
			var cname:String = name.substr(name.lastIndexOf("::") + 2);
			
			if(cname.toLocaleLowerCase().indexOf("presenter") >= 0){
				
				throw(new IllegalOperationError("The prenseter class name can't contain the word 'presenter'"));
				
			}
			
			eventDispatcher = new EventDispatcher();
			
			// Define the view, use it only in order to dispatch events
			_view = v;
			
			// Initialize the PresenterChangeDetector
			if(props.length > 0){
				
				var watcher:PresenterChangeDetector = new PresenterChangeDetector(v, this);
	 							
				for(var i:uint = 0; i < props[0].length; i++){
					
					watcher.addProperty(props[0][i])
									
				}
				
				var notifier:PresenterNotifier = new PresenterNotifier(watcher);
				_view.dispatchEvent(new CommandCallEvent(CommandCallEvent.COMMAND, notifier))
				
			}
			
			// Add the listeners
			addEventListener(UpdatePresenterEvent.SERVICE_FAULT, onServiceFault);
			addEventListener(UpdatePresenterEvent.UPDATE_FAULT, onUpdateFault);
			addEventListener(UpdatePresenterEvent.UPDATE_SUCCESFULL, onResult);
			
			
		}
		
		/**
		 * Listener to the onServiceFault, the event that indicates that something goes
		 * wrong on the server update, remmber to overwrite it
		 * @param e UpdatePresenterEvent
		 */ 
		protected function onServiceFault(e:UpdatePresenterEvent):void{
			
			throw(new Error("The onServiceFault method has to be overriden"));
			
		}
		
		/**
		 * Listener to the onServiceFault, the event that indicates that something goes
		 * wrong on the update, it's not an error but a data malformed or something else,
		 * remember to overwrite it
		 * @param e UpdatePresenterEvent
		 */ 
		protected function onUpdateFault(e:UpdatePresenterEvent):void{
			
			throw(new Error("The onUpdateFault method has to be overriden"));
			
		}
		
		/**
		 * Listener to the onResult, the event that indicates that data comes
		 * from a server update, remember to overwrite it
		 * @param e UpdatePresenterEvent
		 */ 
		protected function onResult(e:UpdatePresenterEvent):void{
			
			throw(new Error("The onResult method has to be overriden"));
			
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