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
	
	import com.gnstudio.nabiro.utilities.mock.core.ClassNameFinder;
	
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	
	public class DataUtils{
		
		public static function deepCopy(obj:*, clazz:Class):*{
				
				var newInstance:* = new clazz();
				
				
				var data:XML = describeType(obj);
				
				var accessors:XMLList = data..accessor.(@access == "readwrite");

				var variables:XMLList = data..variable;
				
	
				var accessorList:XMLList = new XMLList();
	
				var item:XML;
				var count:int = 0;
	
				for each(item in accessors){
	
					accessorList[count] = item;
					count++;
	
				}
	
				for each(item in variables){
	
					accessorList[count] = item;
					count++;
	
				}
	
				var accessorLimit:int = accessorList.length();		
				
				for(var i:int = 0;  i < accessorLimit; i++){

					var type:String = XML(accessorList[i]).@type.toXMLString();
					var node:Object;
					var leaf:Object;
	
					
	
					if(type == "uint" || type == "int" || type == "Boolean" || type == "String" || type == "Number"){

						newInstance[XML(accessorList[i]).@name.toXMLString()] = obj[XML(accessorList[i]).@name.toXMLString()]
	
					//	trace("It's simple", XML(accessorList[i]).@name.toXMLString())
					//	trace(obj[XML(accessorList[i]).@name.toXMLString()])
					

					}else{

				//		trace("\tIt's a complex",XML(accessorList[i]).@name.toXMLString(), XML(accessorList[i]).@type.toXMLString(), obj[XML(accessorList[i]).@name.toXMLString()])
						try{
							
					//		trace(ClassNameFinder.classNameForMock(obj[XML(accessorList[i]).@name.toXMLString()]))
							
							var cl:Class = getDefinitionByName(ClassNameFinder.classNameForMock(obj[XML(accessorList[i]).@name.toXMLString()])) as Class;
							
							newInstance[XML(accessorList[i]).@name.toXMLString()] = obj[XML(accessorList[i]).@name.toXMLString()] as cl
							
						//	trace("--------", getDefinitionByName(ClassNameFinder.classNameForMock(obj[XML(accessorList[i]).@name.toXMLString()])))
						
						}catch(e:Error){
							
							// TODO handle the interfaces
							
						}
				

					}

					

				}				
				
				return newInstance as clazz;
				
			}
		
		
		// set clone items function
		public static function cloneItesm (array:Array):Array {
			
			// create temp items array
			var tmpArr:Array = [];
			
			// loop through each object in items array
			for (var currentItem:* in array) {
				
				// create new object for current item
				tmpArr[currentItem] = {};
				
				// loop through current item
				for (var currentObject:* in array[currentItem]) {
					
					tmpArr[currentItem][currentObject] =  array[currentItem][currentObject];
				
				}
			}
		 	
			return tmpArr;
		}




	public static function cloneObject(source:Object):* {
		    
		    var copier:ByteArray = new ByteArray();
		    copier.writeObject(source);
		    copier.position = 0;
		    
		    return(copier.readObject());
		
		}

	}
}