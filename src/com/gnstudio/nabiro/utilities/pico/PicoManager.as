package com.gnstudio.nabiro.utilities.pico
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
	 */
	
	import __AS3__.vec.Vector;
	
	import com.gnstudio.nabiro.utilities.HashMap;
	import com.gnstudio.nabiro.utilities.pico.exceptions.ContainerExists;
	import com.gnstudio.nabiro.utilities.pico.exceptions.ContainerNotExists;
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ICollectionView;
	
	public class PicoManager
	{
		
		public static const REMOVE_ALL:String = "removeAllThePicoContainer";
		
		public static var containers:HashMap = new HashMap();
		
		/**
		 * Add a container to the dictionary 
		 * @param container PicoContainer
		 * @return Boolean
		 */
    	public static function addContainer(container:PicoContainer, name:String):Boolean{
    		
    		var className:String = getQualifiedClassName(container);
    		
    		var clazz:Class = getDefinitionByName(className) as Class;
    		
    		if(!containers.getItem("name", name) && !containers.getItem("container", container)) {
    			
    			containers.addItem({container: container, name: name});
    			
    		}else{
    			
    			throw new ContainerExists();
    			
    		}
    		
    		return true;
    		
    	}
    	
    	 /**
    	  * Remove a container from the manager 
    	  * @param type Class
    	  * @param name String
    	  */
    	public static function removeContainer(name:String):void{
    		
    		if(name != REMOVE_ALL){
    		
    			containers.remove("name", name);
    			
    		}else{
    			
    			containers.purgeAll();
    			
    		}
    		
    	} 
    	
    	public static function getAll():ICollectionView{
    		
    		return containers.entries;
    		
    		
    		
    	}
    	
    	/**
    	 * Delete all the content of the dictionary (with some exceptions)
    	 * @param exclude Vector.<String>
    	 */
    	 public static function refresh (exclude:Vector.<String>):void{
    	 	
    	 	var collection:ArrayCollection = containers.entries;
    	 	
    	 	for each(var item:Object in collection){
    	 		
    	 		for(var i:int = 0; i < exclude.length; i++){
    	 			
    	 			if(item.name != exclude[i]){
    	 				
    	 				containers.remove("name", exclude[i]);
    	 				
    	 			}
    	 			
    	 		}
    	 		
    	 	}
    	 	
    	 }
    	 
    	/**
    	 * Recover the PicoContainer using the name with which you stored
    	 * the container in the manager
    	 * @param name String
    	 * @return PicoContainer
    	 */ 
    	 public static function getPicoContainer(name:String):PicoContainer{
    	 	
    	 	if(!containers.getItem("name", name).container){
    	 		
    	 		throw new ContainerNotExists();
    	 		
    	 	}
    	 	
    	 	return PicoContainer(containers.getItem("name", name).container);
    	 	
    	 }

		/**
		 * Used to recover a PicoContainer already stored in the manager,
		 * the search in the HashMap can be succesful or not accordingly to
		 * the PicoContainer instances already stored in the HashMap
		 * @param type Class
		 * @return Boolean
		 */     
	    private static function searchHashMap(type:Class):Boolean{
	    	
	    	var result:Boolean
	    	
	    	if(containers.getItem("type", type)){
	    		
	    		result = true;
	    		
	    		}else{
	    		
	    		result = false;
	    		
	    	}
	    	
	    	return result;
	    	
	    }
		
		
	}
}