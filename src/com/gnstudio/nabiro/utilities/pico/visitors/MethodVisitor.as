package com.gnstudio.nabiro.utilities.pico.visitors
{
	import __AS3__.vec.Vector;
	
	import com.gnstudio.nabiro.utilities.pico.PicoContainer;
	import com.gnstudio.nabiro.utilities.pico.exceptions.MethodFailure;
	import com.gnstudio.nabiro.utilities.pico.exceptions.VisitorNotAllowed;
	import com.gnstudio.nabiro.utilities.pico.helpers.IPicoMethod;
	import com.gnstudio.nabiro.utilities.pico.helpers.IPicoParameter;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ICollectionView;
	
	/**
	 * visitor used to invoke a specifi method 
     * used to create the method invocation procedure
     */ 
	
	public class MethodVisitor implements IVisitors, IEventDispatcher
	{
		
		private var _container:PicoContainer;
			
		// EventDsipatcher instance used in order to implement IEventDispatcher
		private var eventDispatcher:EventDispatcher;
		
		public function MethodVisitor()	{
			
			eventDispatcher = new EventDispatcher();
			
		}
		
		/**
		 * Set the container the visitor have to visit
		 * @param container PicoContainer
		 */ 
		public function visit(container:PicoContainer):void{
			
			var supported:Boolean;
			
			for(var i:int = 0; i < container.acceptVisitors.length; i++){
				
				if((container.acceptVisitors[i]) == getDefinitionByName(getQualifiedClassName(this))){
					
					supported = true;
					break;
					
				}
				
			}
			
			if(!supported){
				
				throw new VisitorNotAllowed();	
				
			}else{
				
				_container = container;
				
			}
			
		}
		
		/**
		 * Invoke a method of a specific component defined in the PicoContainer is visiting
		 * or aver all the component stored in the PicoContainer (clazz is null)
		 * @param method IPicoMethod
		 * @param clazz Class
		 */ 
		public function invoke(method:IPicoMethod, clazz:Class = null):void{
			
			_isTraversing = true;
			
			var params:Array = extractPrams(method.parameters);
			var m:Function;
			
			var i:int = 0;
			
			try{
			
				if(!clazz){
					
					for(i = 0; i < traverse.length; i++){
						
				//		traverse[i][method.name](method.parameters[0].value)
						
						m = traverse[i][method.name];
						m.apply(traverse[i], params);
						
						//commented because otherwise there is no possibility to call a method without adding parameters
						//trace("invoke", traverse[i], method.name, method.parameters[0].value)
						
					}
					
				}else{
					
					for(i = 0; i < traverseTrough(clazz).length; i++){
						
						m = traverseTrough(clazz)[i][method.name];
						m.apply(traverseTrough(clazz)[i], params);
						
						//commented because otherwise there is no possibility to call a method without adding parameters
						//trace("invoke", clazz, traverseTrough(clazz)[i], method.name, method.parameters[0].value)
						
					}
					
				}
					
			
			}catch(e:Error){
					
				throw new MethodFailure();
					
			}
			
			_isTraversing = false;
			
		}
		
		
		/**
		 * Recover the parameter without the name, remember that the name
		 * in the IPicoParameter may be useful for debug and not in order to
		 * pass argument to the method
		 * @param value Vector.<IPicoParameter>
		 * @return Array
		 */ 
		private function extractPrams(value:Vector.<IPicoParameter>):Array{
			
			var array:Array = [];
			
			for(var i:int = 0; i < value.length; i++){
				
				array.push(value[i].value);
				
			}
			
			return array;
			
		}
		
		/**
		 * Traverse through all components of the PicoContainer hierarchy
		 * @return ICollectionView
		 */ 
		public function get traverse():ICollectionView{
			
			if(_container){
				
				return _container.getAll();
			
			}else{
				
				return null;
			
			}
			
		}
		
		private var _isTraversing:Boolean;
		
		/**
		 * specify if a visitor is traversing a PicoContainer, the traverse value is true untile
		 * all the components in the PicoContainer have received an invoke
		 */ 
		public function set isTraversing(value:Boolean):void{
			
			_isTraversing = value;
			
		}
		
		public function get isTraversing():Boolean{
			
			return _isTraversing;
		
		}
		
		/**
		 * traverse all the compoment of the PicoContainer hierarchy that are of a specific type
		 * @param type Class
		 * @return ICollectionView
		 */ 
		public function traverseTrough(type:Class):ICollectionView{
			
			if(_container){
				
				return _container.getAllByClass(type);	
				
			}else{
			
				return null;
				
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