package com.gnstudio.nabiro.air.data
{
	import __AS3__.vec.Vector;
	
	import mx.core.IUID;
	import mx.utils.UIDUtil;
	
	public class SQLCriteria extends SQLStatementHaware implements IUID
	{
		
		public static const SELECT:int = 0;
		public static const UPDATE:int = 1;
		public static const DELETE:int = 2;
		public static const CUSTOM:int = 3;
		
		/**
		 * Class used to express queries in a more strucutred way, if a custom query is needed
		 * use the CUSTOM criteria type and the table argument to inject the query in the system
		 * @param criteriaType int; the type of query
		 * @param table String; the table name or the custom query
		 * @param field String; the field of the table on which perform the SQL comparison
		 * @param operator String; the SQL operator to use in the comparison
		 * @param value *; the value used to perform the SQL comparison
		 * @param fields Vector.<FieldData>; the vector of fields to use in the select or in the update (in update mode the value to change is expresses in the FieldData instance
		 * 
		 * @see FieldData
		 */
		
		public function SQLCriteria(criteriaType:int, table:String, field:String, operator:String, value:*, fields:Vector.<FieldData> = null){
			
			super();
			
			_uid = UIDUtil.createUID();
		
			var f:FieldData;
			var count:int;
			var queryFields:String;
			
			switch(true){
				
				case criteriaType == CUSTOM:
				text = table;
				break;
				
				case criteriaType == SELECT:
				
				queryFields = ""
				count = 0;				
				
				for each(f in fields){
					
					if(f){
						
						fields.length > 1 ? count < fields.length - 1 ? queryFields += f.name + ", " : queryFields += f.name : queryFields = f.name;
						
					}
					
					count++;
					
				}
				
				text = "SELECT " + queryFields + " FROM " + table + " WHERE " + field + " " + operator + " " + value;
				break;
				
				case criteriaType == UPDATE:
				
				queryFields = "";
				count = 0;
				
				for each(f in fields){
					
					var separator:String;
					
					if(f){
						
						if(fields.length > 1 && count < fields.length - 1){
							
							separator = ", ";
							
						}else{
							
							separator = "";							
							
						}
						
						if(f.value is String){
							
							queryFields += f.name + " = " + "'" + f.value + "'" + separator;
							
						}else{
							
							queryFields += f.name + " = " + f.value + separator;
							
						}
						
					}
					
					count++;
					
				}
				
				text = "UPDATE " +  table + " SET " + queryFields + " WHERE " +  field + " " + operator + " " + value;
				break;
				
				case criteriaType == DELETE:
				text = "DELETE FROM " + table +  " WHERE " + field + " " + operator + " " + value;
				break;
				
				
			}
		
		}
		
	    /**
		 * Unique idetifier used to create a match
		 * between the event fired and the component
		 * that need to get some results
		 */		
		private var _uid:String;
		
		public function  get uid():String{
			
			return _uid;
			
		}
		
		public function set uid(value:String):void{
			
			_uid = value;
			
		}
		
		/**
		 * Types of available criteria: INSERT, UPDATE, DELETE
		 * @return int
		 */ 
		private var _type:int;
		
		public function get type():int{
			
			return _type;
			
		}
		
		
		
	}
}