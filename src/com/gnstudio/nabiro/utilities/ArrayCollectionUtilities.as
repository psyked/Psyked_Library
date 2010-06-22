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
	 *   @fine tuning			Ivan Varga [ ivan.varga@gnstudio.com ]
	 *	 
	 */
	
	import flash.utils.describeType;
	
	import mx.collections.ArrayCollection;
	
	public class ArrayCollectionUtilities
	{
		
		public static function decorate(data:ArrayCollection, type:Class, bRecursive:Boolean = false):ArrayCollection {
			
    		if (!data)
    			return null;
			
	    	// If the decorator is not the right class it stop the methods
	    	if(!type is IDataDecorator){
	    		
	    		throw(new Error("The class does not implement IDataDecorator interface!"));
	    		return;
	    		
	    	}
	    	
	    	var workingCopy:ArrayCollection;
	    	
	    	if(bRecursive) {
    		
	    		workingCopy = new ArrayCollection();
	    	
	    	}else{
	    		
	    		workingCopy = data;
	    		
	    	}
	    	
	    	var empty:ArrayCollection = new ArrayCollection();
	    	
	    	var limit:int = data.length;
	    	    	
	    	for(var i:int = 0; i < limit; i++){
	    		    		
	    		var o:IDataDecorator = new type();
	    		o.renderData = data.getItemAt(i);    
	    		
	    		if (bRecursive) {
	    		
		    		var xml:XML = describeType(o.renderData);
		    		
		    		if(xml.@isDynamic == "false"){
		    			
		    			var accessorCollections:XMLList = xml..accessor.(@access == 'readwrite').(@type == "mx.collections::ArrayCollection");
		    			var total:int = accessorCollections.length();
		    			
		    			for(var j:int = 0; j < total; j++){
		    				
		    				/* var dio:* = (accessorCollections[j]) */
		    				o.renderData[accessorCollections[j].@name] = decorate(o.renderData[accessorCollections[j].@name], type);
		    				
		    			} 
		    			
		    		}else{
		    			
		    			for (var prop:String in o.renderData){
		    			
			    			// trace(prop is ArrayCollection, prop)
			    			if(o.renderData[prop] is ArrayCollection){
			    				
			    				o.renderData[prop] = decorate(o.renderData[prop], type);
			    				
			    			}
			    			
			    		}
		    			
		    		}
		    		
		    	}  
	    		
	    		empty.addItem(o);
	    			    		    		
	    	}
	    	
	    	return empty;
	    	
	    }

	}
}