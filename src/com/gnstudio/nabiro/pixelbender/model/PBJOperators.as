package com.gnstudio.nabiro.pixelbender.model
{
	import com.gnstudio.nabiro.mvp.enumeration.EnumerableBase;
	import com.gnstudio.nabiro.mvp.enumeration.Enumeration;
	import com.gnstudio.nabiro.pixelbender.model.dataTypes.PBJOperatorCode;
	
	import flash.errors.IllegalOperationError;
	import flash.utils.getQualifiedClassName;
	
	import mx.utils.ObjectUtil;
	

	public class PBJOperators extends Enumeration
	{
		private static var list:Array = [];	
		
		/**
		 * Initialize this for datatype checking
		 */ 
		private const ALLOWED_DATA_TYPE:Class = PBJOperatorCode;
		 
		private static var counter:int = 0;
		 
		/**
		 * Roles constructor
		 * @param value
		 * @param ordinal
		 *
		 */
		public function PBJOperators(ordinal:int, enumerable:EnumerableBase, key:int){
			
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
		public static const NONE:Enumeration			    		= new PBJOperators(-1, new EnumerableBase("None"), constructorKey);		
		
		public static const OP_ABS:Enumeration       				= new PBJOperators(counter, new EnumerableBase("OpAbs", new PBJOperatorCode(0x18)), constructorKey);
		public static const OP_ACOS:Enumeration       				= new PBJOperators(counter, new EnumerableBase("OpACos", new PBJOperatorCode(0x10)), constructorKey);
		public static const OP_ADD:Enumeration       				= new PBJOperators(counter, new EnumerableBase("OpAdd", new PBJOperatorCode(0x01)), constructorKey);
		public static const OP_ASIN:Enumeration       				= new PBJOperators(counter, new EnumerableBase("OpASin", new PBJOperatorCode(0x0F)), constructorKey);
		public static const OP_ATAN:Enumeration       				= new PBJOperators(counter, new EnumerableBase("OpATan", new PBJOperatorCode(0x11)), constructorKey);
		public static const OP_ATAN2:Enumeration       				= new PBJOperators(counter, new EnumerableBase("OpATan2", new PBJOperatorCode(0x06)), constructorKey);
		public static const OP_BOOLEAN_ALL:Enumeration       		= new PBJOperators(counter, new EnumerableBase("OpBoolAll", new PBJOperatorCode(0x3E)), constructorKey);
		public static const OP_BOOLEAN_ANY:Enumeration       		= new PBJOperators(counter, new EnumerableBase("OpBoolAny", new PBJOperatorCode(0x3D)), constructorKey);
		public static const OP_BOOLEAN_TO_FLOAT:Enumeration       	= new PBJOperators(counter, new EnumerableBase("OpBoolToFloat", new PBJOperatorCode(0x38)), constructorKey);
		public static const OP_BOOLEAN_TO_INT:Enumeration       	= new PBJOperators(counter, new EnumerableBase("OpBoolToInt", new PBJOperatorCode(0x3A)), constructorKey);
		public static const OP_CEIL:Enumeration       				= new PBJOperators(counter, new EnumerableBase("OpCeil", new PBJOperatorCode(0x1B)), constructorKey);
		public static const OP_COS:Enumeration       				= new PBJOperators(counter, new EnumerableBase("OpCos", new PBJOperatorCode(0x0D)), constructorKey);
		public static const OP_CROSS_PRODUCT:Enumeration       		= new PBJOperators(counter, new EnumerableBase("OpCrossProduct", new PBJOperatorCode(0x27)), constructorKey);
		public static const OP_DISTANCE:Enumeration       			= new PBJOperators(counter, new EnumerableBase("OpDistance", new PBJOperatorCode(0x25)), constructorKey);
		public static const OP_DIV:Enumeration       				= new PBJOperators(counter, new EnumerableBase("OpDiv", new PBJOperatorCode(0x05)), constructorKey);
		public static const OP_DOT_PRODUCT:Enumeration       		= new PBJOperators(counter, new EnumerableBase("OpDotProduct", new PBJOperatorCode(0x26)), constructorKey);
		public static const OP_ELSE:Enumeration       				= new PBJOperators(counter, new EnumerableBase("OpElse", new PBJOperatorCode(0x35)), constructorKey);
		public static const OP_END_IF:Enumeration       			= new PBJOperators(counter, new EnumerableBase("OpEndIf", new PBJOperatorCode(0x36)), constructorKey);
		public static const OP_EQUAL:Enumeration       				= new PBJOperators(counter, new EnumerableBase("OpEqual", new PBJOperatorCode(0x28)), constructorKey);
		public static const OP_EXP:Enumeration       				= new PBJOperators(counter, new EnumerableBase("OpExp", new PBJOperatorCode(0x12)), constructorKey);
		public static const OP_EXP2:Enumeration       				= new PBJOperators(counter, new EnumerableBase("OpExp2", new PBJOperatorCode(0x13)), constructorKey);
		public static const OP_FLOAT_TO_BOOLEAN:Enumeration       	= new PBJOperators(counter, new EnumerableBase("OpFloatToBool", new PBJOperatorCode(0x37)), constructorKey);
		public static const OP_FLOAT_TO_INT:Enumeration  	     	= new PBJOperators(counter, new EnumerableBase("OpFloatToInt", new PBJOperatorCode(0x1E)), constructorKey);
		public static const OP_FLOOR:Enumeration  			     	= new PBJOperators(counter, new EnumerableBase("OpFloor", new PBJOperatorCode(0x1A)), constructorKey);
		public static const OP_FRACT:Enumeration  			     	= new PBJOperators(counter, new EnumerableBase("OpFract", new PBJOperatorCode(0x1C)), constructorKey);
		public static const OP_INT_TO_BOOLEAN:Enumeration  			= new PBJOperators(counter, new EnumerableBase("OpIntToBool", new PBJOperatorCode(0x39)), constructorKey);
		public static const OP_INT_TO_FLOAT:Enumeration  			= new PBJOperators(counter, new EnumerableBase("OpIntToFloat", new PBJOperatorCode(0x1F)), constructorKey);
		public static const OP_LENGTH:Enumeration  			     	= new PBJOperators(counter, new EnumerableBase("OpLength", new PBJOperatorCode(0x24)), constructorKey);
		public static const OP_LESS_THAN:Enumeration  			    = new PBJOperators(counter, new EnumerableBase("OpLessThan", new PBJOperatorCode(0x2A)), constructorKey);
		public static const OP_LESS_THAN_EQUAL:Enumeration  		= new PBJOperators(counter, new EnumerableBase("OpLessThanEqual", new PBJOperatorCode(0x2B)), constructorKey);
		public static const OP_LOG:Enumeration  					= new PBJOperators(counter, new EnumerableBase("OpLog", new PBJOperatorCode(0x14)), constructorKey);
		public static const OP_LOG2:Enumeration  					= new PBJOperators(counter, new EnumerableBase("OpLog2", new PBJOperatorCode(0x15)), constructorKey);
		public static const OP_LOGICAL_AND:Enumeration  			= new PBJOperators(counter, new EnumerableBase("OpLogicalAnd", new PBJOperatorCode(0x2D)), constructorKey);
		public static const OP_LOGICAL_NOT:Enumeration  			= new PBJOperators(counter, new EnumerableBase("OpLogicalNot", new PBJOperatorCode(0x2C)), constructorKey);
		public static const OP_LOGICAL_OR:Enumeration  				= new PBJOperators(counter, new EnumerableBase("OpLogicalOr", new PBJOperatorCode(0x2E)), constructorKey);
		public static const OP_LOGICAL_XOR:Enumeration  			= new PBJOperators(counter, new EnumerableBase("OpLogicalXor", new PBJOperatorCode(0x2F)), constructorKey);
		public static const OP_MATRIX_MATRIX_MULT:Enumeration  		= new PBJOperators(counter, new EnumerableBase("OpMatrixMatrixMult", new PBJOperatorCode(0x20)), constructorKey);
		public static const OP_MATRIX_VECTROR_MULT:Enumeration  	= new PBJOperators(counter, new EnumerableBase("OpMatrixVectorMult", new PBJOperatorCode(0x22)), constructorKey);
		public static const OP_MAX:Enumeration  					= new PBJOperators(counter, new EnumerableBase("OpMax", new PBJOperatorCode(0x0A)), constructorKey);
		public static const OP_MIN:Enumeration  					= new PBJOperators(counter, new EnumerableBase("OpMin", new PBJOperatorCode(0x09)), constructorKey);
		public static const OP_MOD:Enumeration  					= new PBJOperators(counter, new EnumerableBase("OpMod", new PBJOperatorCode(0x08)), constructorKey);
		public static const OP_MOV:Enumeration  					= new PBJOperators(counter, new EnumerableBase("OpMov", new PBJOperatorCode(0x1D)), constructorKey);
		public static const OP_MUL:Enumeration  					= new PBJOperators(counter, new EnumerableBase("OpMul", new PBJOperatorCode(0x03)), constructorKey);
		public static const OP_NOP:Enumeration  					= new PBJOperators(counter, new EnumerableBase("OpNop", new PBJOperatorCode(0x00)), constructorKey);
		public static const OP_NORMALIZE:Enumeration  				= new PBJOperators(counter, new EnumerableBase("OpNormalize", new PBJOperatorCode(0x23)), constructorKey);
		public static const OP_NOT_EQUAL:Enumeration  				= new PBJOperators(counter, new EnumerableBase("OpNotEqual", new PBJOperatorCode(0x29)), constructorKey);
		public static const OP_POW:Enumeration  					= new PBJOperators(counter, new EnumerableBase("OpPow", new PBJOperatorCode(0x07)), constructorKey);
		public static const OP_RCP:Enumeration  					= new PBJOperators(counter, new EnumerableBase("OpRcp", new PBJOperatorCode(0x04)), constructorKey);
		public static const OP_R_SQRT:Enumeration  					= new PBJOperators(counter, new EnumerableBase("OpRSqrt", new PBJOperatorCode(0x17)), constructorKey);
		public static const OP_SIGN:Enumeration  					= new PBJOperators(counter, new EnumerableBase("OpSign", new PBJOperatorCode(0x19)), constructorKey);
		public static const OP_SIN:Enumeration  					= new PBJOperators(counter, new EnumerableBase("OpSin", new PBJOperatorCode(0x0C)), constructorKey);
		public static const OP_SQRT:Enumeration  					= new PBJOperators(counter, new EnumerableBase("OpSqrt", new PBJOperatorCode(0x16)), constructorKey);
		public static const OP_STEP:Enumeration  					= new PBJOperators(counter, new EnumerableBase("OpStep", new PBJOperatorCode(0x0B)), constructorKey);
		public static const OP_SUB:Enumeration  					= new PBJOperators(counter, new EnumerableBase("OpSub", new PBJOperatorCode(0x02)), constructorKey);
		public static const OP_TAN:Enumeration  					= new PBJOperators(counter, new EnumerableBase("OpTan", new PBJOperatorCode(0x0E)), constructorKey);
		public static const OP_VECTOR_EQUAL:Enumeration  			= new PBJOperators(counter, new EnumerableBase("OpVectorEqual", new PBJOperatorCode(0x3B)), constructorKey);
		public static const OP_VECTOR_MATRIX_MULT:Enumeration  		= new PBJOperators(counter, new EnumerableBase("OpVectorMatrixMult", new PBJOperatorCode(0x21)), constructorKey);
		public static const OP_VECTOR_NOT_EQUAL:Enumeration  		= new PBJOperators(counter, new EnumerableBase("OpVectorNotEqual", new PBJOperatorCode(0x3C)), constructorKey);
				
		
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