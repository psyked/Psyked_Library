package com.gnstudio.nabiro.mvp.enumeration{
	
		import flash.errors.IllegalOperationError;
		import flash.utils.getQualifiedClassName;
		import mx.utils.ObjectUtil;
	
	/**
	 * Action enumerates link types.
	 * @author Giorgio Natili
	 *
	 */
	
	public class Enumeration{
		 
		
		public function Enumeration(ordinal:int, enumerable:EnumerableBase){
								
			_ordinal = ordinal;
			_data = enumerable.data;
			_name = enumerable.name;
			
		}
		
		/**
		 * Order to return data in the enumeration
		 */ 
		private var _ordinal:int;
		
		public function set ordinal(value:int):void{
			
			_ordinal = value;
			
		}
		
		public function get ordinal():int{
			
			return _ordinal;
			
		}
		
		/**
		 * Data stored in the element
		 */ 
		private var _data:*;
		
		public function get data():*{
			
			return _data;
			
		}
		
		public function set data(value:*):void{
			
			_data = value;
			
		}
		
		/**
		 * Name of the item in the enumeration
		 */		
		private var _name:String;
		
		public function get name():String{
			
			return _name;
			
		}
		
		public function set name(value:String):void{
			
			_name = value;
			
		}
				
		
	}
}