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
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class ElementTypeAwareCollection extends ArrayCollection{
		
		private var classType:Class;
		
		public function ElementTypeAwareCollection(type:Class, source:Array=null){
			
			classType = type;
			
			for each (var item:* in source){
				
				check(item);
				
			}
			
			super(source);
			
		}
		
		private function check(item:*):void{
			
			if (!(item is classType)) {
				
   				throw new TypeError("Wrong type, " + classType.toString() + " was expected");
   				
   			}

			
		}
		
		public function get type():Class {
			
    		return classType;
    		
    	}
  		
  		override public function addItem(item:Object):void {
  			
   			check(item);
   			super.addItem(item);
   			
    	}
 
 		override public function addItemAt(item:Object, index:int):void {
    			
    		check(item);  			
  			super.addItemAt(item, index);
  			
    	}

				
	}
}