package com.gnstudio.nabiro.pixelbender.model
{
	import com.gnstudio.nabiro.mvp.enumeration.EnumerableBase;
	import com.gnstudio.nabiro.mvp.enumeration.Enumeration;
	import com.gnstudio.nabiro.pixelbender.model.dataTypes.PBJLoadOperator;
	
	import flash.errors.IllegalOperationError;
	import flash.utils.getQualifiedClassName;
	
	import mx.utils.ObjectUtil;
	

	public class PBJLoadOperators extends Enumeration
	{
		private static var list:Array = [];	
		
		/**
		 * Initialize this for datatype checking
		 */ 
		private const ALLOWED_DATA_TYPE:Class = PBJLoadOperator;
		 
		private static var counter:int = 0;
		 
		/**
		 * Roles constructor
		 * @param value
		 * @param ordinal
		 *
		 */
		public function PBJLoadOperators(ordinal:int, enumerable:EnumerableBase, key:int){
			
			super(ordinal, enumerable);
			
			if(key != constructorKey){
				
				throw new IllegalOperationError("Cannot instantiate anymore: " + getQualifiedClassName(enumerable));  
				return;
				
			} 
			
			if(!enumerable.data is ALLOWED_DATA_TYPE){
				
				throw new IllegalOperationError("Cannot instantiate elements of this type: " + getQualifiedClassName(enumerable));  
				return;
				
			}
			
			if(ordinal >= 0 && ordinal - counter == 0){
				
				counter++;
			
			}
			
			list.push(this);
					
		}
		
		/**
		 * Keep NONE here and add your data below
		 */ 
		public static const NONE:Enumeration			    					= new PBJLoadOperators(-1, new EnumerableBase("None"), constructorKey);		
		
		public static const OP_LOAD_FLOAT:Enumeration       					= new PBJLoadOperators(counter, new EnumerableBase("OpLoadFloat", new PBJLoadOperator()), constructorKey);
		public static const OP_LOAD_INT:Enumeration       						= new PBJLoadOperators(counter, new EnumerableBase("OpLoadInt", new PBJLoadOperator()), constructorKey);
		
		
		/**
		 * Value used to avoid other data
		 */
		private static const constructorKey:int = 5612584;
 
		/**
		 * A list of all link actions
		 * @return Array
		 *
		 */
		public function get fullList():Array{
			
			return list;
			
		}
 
		/**
		 * A list of link types appropriate for use in ComboBox and other
		 * selection components as a DataProvider
		 *
		 * myComboBox.dataProvider = Roles.dataProviderList;
		 * @return
		 *
		 */
		public static function get dataProviderList():Array{
						
			var dList:Array = ObjectUtil.copy(list) as Array;
			
			dList.sortOn("ordinal", Array.NUMERIC)
			
			dList.shift();
			
			return dList;
			
		}
		 
		/**
		 * Select a role type by its value property
		 * @param value
		 * @return IEnumerable
		 *
		 */
		public static function selectByName(value:String):*{
			
			var returned:* = NONE.data;
			
			for each ( var item:Enumeration in list){				
				
				if (value == item.name){
					
					returned = item.data;
					break;
					
				}
				
			}
 
			return returned;
			
		}
		
		public static function get items():int{
			
			return list.length - 1;
			
		}
		
	}
}