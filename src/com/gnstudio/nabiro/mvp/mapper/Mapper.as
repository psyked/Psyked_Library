package com.gnstudio.nabiro.mvp.mapper
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
	import com.gnstudio.nabiro.mvp.command.ICommand;
	import com.gnstudio.nabiro.mvp.command.MacroCommand;
	import com.gnstudio.nabiro.mvp.core.IView;
	import com.gnstudio.nabiro.mvp.core.PresenterChangeDetector;
	import com.gnstudio.nabiro.mvp.instructions.InstructionEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;

	public class Mapper implements IEventDispatcher
	{
		
		private static var mapper:Mapper = new Mapper();
		private static var className:String = getQualifiedClassName(super);
		
		protected var target:IEventDispatcher;
		
		private var eventDispatcher:EventDispatcher;
		protected var elements:Array;
		protected var presenters:Array;
		
		/**
		 * Compsition bugs fix
		 * Add in the extended class all the command class you need to use as 
		 * private var commandVariable:CommandClass;
		 */
		 
		 /**
		 * The mapper class is singleton and is able to store a reference to all the 
		 * visual UI elements that are able to receive an instruction, it's also able 
		 * to get and execute a command that is launched from everywere in the application
		 * @param singleton MapperSingleton
		 * @param target IEventDispatcher
		 */		
		public function Mapper(){
			
			trace("\nCreating a mapper", getQualifiedClassName(this), "with superclass", getQualifiedSuperclassName(this), "\n");
			
			if (mapper != null && getQualifiedSuperclassName(this) != className) throw new Error("This a singleton class!");
			
			// Reference for the IEventDispatcher implementation	
			eventDispatcher = new EventDispatcher();
									
			// Create the array that will hold the elements
			elements = [];
			
			// Create the array of presenters
			presenters = [];
						
		}
		
				
		public function updateInstance(instance:Mapper, target:IEventDispatcher = null):Mapper {
		
			if (instance != null && instance is Mapper){
				
				Mapper.mapper = instance;
				
			}else{
				
				throw new Error("Incorrect Singleton update");
				
			}
			
			if(target){
				
				// Define the target that will get the evens
		//		this.target = target;
				
				// Define the listener for the target
				Mapper.mapper.registerTarget(target);
				
			}
			
			return Mapper.mapper;
		
        }

		
		/**
		 * Register an element to the mapper and perform a check in order to avoid 
		 * duplicates in the elemenst array
		 * @param element IMapperCandidate
		 * @return IMapperCandidate
		 */ 
		public function register(element:IMapperCandidate):IMapperCandidate{
			
			var missing:Boolean = true;
			var lim:int = elements.length;
			
			for(var i:int = 0; i < lim; i++){
				
				if(elements[i] == element){
					
					missing = false;
					break;
					
				}
				
			}
			
			// Only if the element is not already stored it will be added			
			missing ? elements.push(element) : null;
			
			trace(this, "### Mapper elements ###\n", elements, "\n")
			
			return element;
			
		}
		
		/**
		 * Remove an element from the elements array and return the removed element
		 * @param element IMapperCandidate
		 * @return IMapperCandidate
		 */ 
		public function unregister(element:IMapperCandidate):IMapperCandidate{
			
			var lim:int = elements.length;
			
			for(var i:int = 0; i < lim; i++){
				
				if(elements[i] == element){
					
					elements.splice(i, 1);
					break;
					
				}
				
			}
			
			var totalPresenters:int = presenters.length;
			
			for (var j:int = 0; j < totalPresenters; j++){
				
				if((presenters[j] as PresenterChangeDetector).view == element){
					
					presenters.splice(j, 1);
					break;
					
				}
				
			}
			
			// trace("Mapper elements", elements);
			
			return element;
			
		}
		
		/**
		 * Method used to be sure that only an instance of the class will be created
		 * @param target IEventDispatcher
		 */ 
		public static function getInstance(target:IEventDispatcher = null):Mapper{
						
			if(!Mapper.mapper){
				
				Mapper.mapper = new Mapper();				
				
			}
			
			if(target){
				
				// Define the target that will get the evens
				// target = target;
				
				// Define the listener for the target
				Mapper.mapper.registerTarget(target)
				
			}
									
			return Mapper.mapper;
			
		}
		
		protected function registerTarget(tg:IEventDispatcher):void{
			
			if(target){
				
				target.removeEventListener(CommandCallEvent.COMMAND, onCommand);
				target.removeEventListener(CommandCallEvent.MACRO, onMacro);
			 	target.removeEventListener(InstructionEvent.PERFORM_ISNTRUCTION, onInstruction);
			 	
			 	target = null;
				
			}
			
			target = tg;
			
			// Register the listeners for the COMMAND and for the MACRO
			target.addEventListener(CommandCallEvent.COMMAND, onCommand);
			//Mapper.target["parent"].addEventListener(CommandCallEvent.COMMAND, onCommand);
			target.addEventListener(CommandCallEvent.MACRO, onMacro);
			//Mapper.target["parent"].addEventListener(CommandCallEvent.MACRO, onMacro);
					
			// Register the listener for the instruction
			 target.addEventListener(InstructionEvent.PERFORM_ISNTRUCTION, onInstruction);
			//Mapper.target["parent"].addEventListener(InstructionEvent.PERFORM_ISNTRUCTION, onInstruction);
								
		}
		
		/**
		 * Receive and execute the command from the application
		 * @param e CommandCallEvent
		 */ 
		protected function onCommand(e:CommandCallEvent):void{
			
			
			if(e.command is PresenterNotifier){
				
				trace("\t Adding new presenter", e, "\n")
				presenters.push((e.command as PresenterNotifier).presenterWatcher);
				return;
				
			}
			
			trace("\t", e, e.currentTarget, e.target);
			
			try{
				
				(e.command as ICommand).execute();
				
			}catch(error:Error){
				
				trace(error.message)
				
			}
			
		}
		
		/**
		 * Get the current presenter interested in the update strategy
		 * @view IView
		 */
		public function getCurrentWatcher(view:IView):PresenterChangeDetector{
			
			var watcher:PresenterChangeDetector;
			
			var limit:int = presenters.length;
			
			for(var i:int = 0; i < limit; i++){
				trace("::::::::::::::::::::::", presenters[i], presenters[i].view)
				if((presenters[i] as PresenterChangeDetector).view == view)	{
					
					watcher = (presenters[i] as PresenterChangeDetector);
					break;
					
				}
			}
			
			return watcher;
			
		} 
		
		/**
		 * Receive and execute the macro from the application
		 * @param e CommandCallEvent
		 */ 
		protected function onMacro(e:CommandCallEvent):void{
			
			trace(e);
			
			try{
				
				(e.command as MacroCommand).execute();
				
			}catch(error:Error){
				
				trace(error.message)
				
			}
			
		}
		
		/**
		 * Listener to the InstructionEvent.PERFORM_ISNTRUCTION event
		 * it checks if an UI element has a listener for the event storede in the
		 * InstructionEvent isnstance and if so send the event and the parameters
		 * to the object
		 * @param e InstructionEvent
		 */ 
		protected function onInstruction(e:InstructionEvent):void{			
			
			// trace( e.target, e.currentTarget, this)
			
			trace("  Called instruction from MAIN mapper: ->", e.toPerform, e.parameters); 
			
			try{
				
				var ClassReference:Class = getDefinitionByName(e.toPerform) as Class;			
				var instance:Object = new ClassReference(e.target, e.parameters);
			
			}catch(error:Error){
			
				trace("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@", error.message);
				throw(new Error(error.message));
				return
			
			}
			
			for each (var item:IMapperCandidate in elements){
				
				if(item.hasEventListener(ClassReference.DO_HANDLE)){
				
					item.dispatchEvent(instance as Event);
					trace("Instruction sent on item -->", item, ClassReference.DO_HANDLE)
					
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

