package com.gnstudio.nabiro.utilities{
	
	
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
	
import mx.utils.ObjectUtil;

public class ArrayUtilities {

    public static function randomize(aArray:Array):Array {
      
      var aCopy:Array = aArray.concat();
      var aRandomized:Array = [];
      
      var oElement:Object;
      
      var nRandom:Number;
      
      for(var i:Number = 0; i < aCopy.length; i++) {
        
        nRandom = NumberUtilities.random(0, aCopy.length - 1);
        aRandomized.push(aCopy[nRandom]);
        aCopy.splice(nRandom, 1);
        
        i--;
        
      }
      
      return aRandomized;
      
    }

    public static function average(aArray:Array):Number {
      
      return sum(aArray) / aArray.length;
    
    }

    public static function sum(aArray:Array):Number {
      
      var nSum:Number = 0;
      
      for(var i:Number = 0; i < aArray.length; i++) {
        
        if(typeof aArray[i] == "number") {
          
          nSum += aArray[i];
          
        }
        
      }
      
      return nSum;
      
    }

    public static function max(aArray:Array):Number {
      
      var aCopy:Array = aArray.concat();
      aCopy.sort(Array.NUMERIC);
      
      var nMaximum:Number = Number(aCopy.pop());
      
      return nMaximum;
      
    }

    public static function min(aArray:Array):Number {
     
      var aCopy:Array = aArray.concat();
      aCopy.sort(Array.NUMERIC);
      
      var nMinimum:Number = Number(aCopy.shift());
      
      return nMinimum;
      
    }

    public static function switchElements(aArray:Array, nIndexA:Number, nIndexB:Number):void {
      
      var oElementA:Object = aArray[nIndexA];
      var oElementB:Object = aArray[nIndexB];
      
      aArray.splice(nIndexA, 1, oElementB);
      aArray.splice(nIndexB, 1, oElementA);
      
    }

    private static function objectEquals(oInstanceA:Object, oInstanceB:Object):Boolean {
      
      for(var sItem:String in oInstanceA) {
       	
       	if(oInstanceA[sItem] is Object) {
          
          if(!objectEquals(oInstanceA[sItem], oInstanceB[sItem])) {
            
            return false;
          
          }
          
        }else{
          
          if(oInstanceA[sItem] != oInstanceB[sItem]) {
            
            return false;
          
          }
        }
        
      }
      
      return true;
      
    }

    public static function equals(aArrayA:Array, aArrayB:Array, bNotOrdered:Boolean, bRecursive:Boolean):Boolean {
      
      if(aArrayA.length != aArrayB.length) {
        
        return false;
      }
      
      
      var aArrayACopy:Array = aArrayA.concat();
      var aArrayBCopy:Array = aArrayB.concat();
     
      if(bNotOrdered) {
        
        aArrayACopy.sort();
        aArrayBCopy.sort();
        
      }
      
      for(var i:Number = 0; i < aArrayACopy.length; i++) {
        
        if(aArrayACopy[i] is Array && bRecursive) {
          
          if(!equals(aArrayACopy[i], aArrayBCopy[i], bNotOrdered, bRecursive)) {
            
            return false;
          
          }
        
        }else if(aArrayACopy[i] is Object && bRecursive) {
        	
          if(!objectEquals(aArrayACopy[i], aArrayBCopy[i])) {
          	
            return false;
            
          }
        
        }else if(aArrayACopy[i] != aArrayBCopy[i]) {
        	
          return false;
          
        }
      }
      
      return true;
      
    }

    public static function findMatchIndex(aArray:Array, oElement:Object, ...rest):Number {
      
      var nStartingIndex:Number = 0;
      var bPartialMatch:Boolean = false;
      
      if(typeof rest[0] == "number") {
        
        nStartingIndex = rest[0];
      
      }else if(typeof rest[1] == "number") {
        
        nStartingIndex = rest[1];
        
      }
      
      if(typeof rest[0] == "boolean") {
      	
        bPartialMatch = rest[0];
        
      }
      
      var bMatch:Boolean = false;
      
      for(var i:Number = nStartingIndex; i < aArray.length; i++) {
        
        if(bPartialMatch) {
          
          bMatch = (aArray[i].indexOf(oElement) != -1);
        
        }else{
        	
          bMatch = (aArray[i] == oElement);
          
        }
        
        if(bMatch) {
        	
          return i;
          
        }
      }
      
      return -1;
      
    }

    public static function findLastMatchIndex(aArray:Array, oElement:Object, oParameter:Object):Number {
     
      var nStartingIndex:Number = aArray.length;
      var bPartialMatch:Boolean = false;
      
      if(typeof arguments[2] == "number") {
       
        nStartingIndex = arguments[2];
      
      }else if(typeof arguments[3] == "number") {
        
        nStartingIndex = arguments[3];
      
      }
      
      if(typeof arguments[2] == "boolean") {
        
        bPartialMatch = arguments[2];
      
      }
      
      var bMatch:Boolean = false;
      
      for(var i:Number = nStartingIndex; i >= 0; i--) {
        
        if(bPartialMatch) {
          
          bMatch = (aArray[i].indexOf(oElement) != -1);
        
        }else{
        	
          bMatch = (aArray[i] == oElement);
          
        }
        
        if(bMatch) {
        	
          return i;
          
        }
      }
      
      return -1;
      
    }

    public static function findMatchIndices(aArray:Array, oElement:Object, bPartialMatch:Boolean = false):Array {
      
      var aIndices:Array = new Array();
      var nIndex:Number = findMatchIndex(aArray, oElement, bPartialMatch);
     
      while(nIndex != -1) {
        
        aIndices.push(nIndex);
        nIndex = findMatchIndex(aArray, oElement, bPartialMatch, nIndex + 1);
      
      }
      
      return aIndices;
      
    }

    public static function decorate(data:Object, type:Class, bRecursive:Boolean = false):Array {
    	
    	// If the decorator is not the right class it stop the methods
    	if(!type is IDataDecorator){
    		
    		throw(new Error("The class does not implement IDataDecorator interface!"));
    		return;
    		
    	}
    	
    	var empty:Array = [];
    	
    	var workingCopy:Object;
    	
    	if(bRecursive) {
    		
    		workingCopy = duplicate(data, true);
    	
    	}else{
    		
    		workingCopy = data;
    		
    	}
    	
    	var limit:int = workingCopy.length;
    	    	
    	for(var i:int = 0; i < limit; i++){
    		    		
    		var o:IDataDecorator = new type();
    		o.renderData = workingCopy[i];    		
    		
    		for (var prop:String in o.renderData){
    			
    			// trace(prop is Array, prop)
    			if(o.renderData[prop] is Array){
    				
    				o.renderData[prop] = decorate(o.renderData[prop], type);
    				
    			}
    			
    		}
    		
    		empty[i] = o;	
    		    		
    	}
    	
    	return empty;
    	
    }
    
    public static function duplicate(input:Object, bRecursive:Boolean = false):Object {
     
      var workingCopy:Object;
      var prop:String;
      
      // Recursion starts
      if(bRecursive) {
        
        // Handle array
        if(input is Array) {
          
          // Create an empty array
          workingCopy = new Array();
          
          // Iteration on the data passed over the arguments
          for(var i:Number = 0; i < input.length; i++) {
            
            // Check if it's an object or a simple data
            if(input[i] is Object) {
              
              workingCopy[i] = duplicate(input[i]);
            
            }else{
            	
              workingCopy[i] = input[i];
              
            }
          }
          
          // Exit the loop
          return workingCopy;
          
        }else{
          
          // If it's not an array the method duplicates the object
          workingCopy = new Object();
          
          // The loop is not against an array, but against an Object
          for(prop in input) {
            
            // Check if the properties are not simple data types
            if(input[prop] is Object && !(input[prop] is String) && !(input[prop] is Boolean) && !(input[prop] is Number)) {
              
              // Duplicate the array
              workingCopy[prop] = duplicate(input[prop], bRecursive);
            
            }else{
              
              // Clone the single item
              workingCopy[prop] = input[prop];
            
            }
          }
          
          // Return the duplicated object
          return workingCopy;
          
        }
        
      // Recursion ends
      }else{
      	
      	// If it's an array make a copy with the concat on the same input array
        if(input is Array) {
          
          // Return the duplicated Array
          return input.concat();
          
        }else{
        	
        	// If it's an object to duplicate then an Object it's what we need	
	        workingCopy = new Object();
	        
	        // Loop over the properties of the object
	        for(prop in input) {
	          	
	          workingCopy[prop] = input[prop];
	            
	        }
	        
	        // Return the duplicated object  
	        return workingCopy;
          
        }
        
      }
      
    }

    static public function toString(oArray:Object, nLevel:uint = 0):String {
      
      var sIndent:String = "";
      
      for(var i:Number = 0; i < nLevel; i++) {
        
        sIndent += "\t";
      
      }
     
      var sOutput:String = "";
     
      for(var sItem:String in oArray) {
        
        if(oArray[sItem] is Object) {
          
          sOutput = sIndent + "** " + sItem + " **\n" + toString(oArray[sItem], nLevel + 1) + sOutput;
        
        }else{
        	
          sOutput += sIndent + sItem + ":" + oArray[sItem] + "\n";
          
        }
      }
      
      return sOutput;
      
    }

  }
  
}