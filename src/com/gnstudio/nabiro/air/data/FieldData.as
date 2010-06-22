package com.gnstudio.nabiro.air.data
{
	public class FieldData
	{
		
		/**
		 * Class used to define name and value of 
		 * database fields used in the SQLCriteria
		 */ 
		public function FieldData()	{
			
			// Do nothing
			
		}
		
		/**
		 * The name of the field of the table you want to get or update
		 */ 
		private var _name:String;
		
		public function get name():String{
			
			return _name;
			
		}
		
		public function set name(value:String):void{
			
			_name = value;
			
		}
		
		
		/**
		 * The value of the field needed only in an update criterion
		 */ 
		private var _value:*;
		
		public function get value():*{
			
			return _value;
			
		}
		
		public function set value(v:*):void{
			
			_value = v;
			
		}
		
	}
}