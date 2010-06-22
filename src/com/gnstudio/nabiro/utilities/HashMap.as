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
	 *   @fine tuning			Alessandro Ronchi [ a.ronchi@gnstudio.com ]   
	 *	 
	 */
	
   	import flash.utils.Dictionary;
   	
   	import mx.collections.ArrayCollection;
   	import mx.collections.ICollectionView;
	
	public class HashMap{
		
		protected var dictionary:Dictionary;
		private var itemsCount:int;
		
		public function HashMap(useWeakReferences:Boolean = true){
           
            dictionary = new Dictionary( useWeakReferences );
            
            itemsCount = 0;
        		
		}
		
		/**
		 * Add an item to the dictionary increasing the key automatically; this is done
		 * because the key isn't needed in order to get an object contained in the dictionary
		 * @param value *
		 */ 
		public function addItem(value:*):void{
            
           dictionary[itemsCount] = value;
           
           itemsCount++;
        
        }
        
        /**
        * Recover an item of the Dictionary searching for a specific value for
        * a property mapped in the map object
        * @param key String
        * @param value *
        * @return *
        */
        public function getItem(key:String, value:*) : * {
        	
           	for (var k:* in dictionary){
            	
             	/* trace("    Testing the item", itemsCount)
            	trace("   	", dictionary[k][key], value)  */
           
                if(dictionary[k][key] === value){
                	
                	var item:* = dictionary[k];
                	break;
                	
                }
                
            }
            
            return item;
        
        }
        
        /**
        * Remove all the entries from the Dictionary
        */ 
        public function purgeAll():void{
        	
        	for (var key:* in dictionary){
                
               delete dictionary[key];
            
            }

        	
        }
        /**
        * Delete an item from the Dictionary; the item needs to have 
        * a specific value for a specific propery mapped on the map
        * @param key *
        */
        public function remove(key:String, value:*) : void{
        		        	
      	    for (var k:* in dictionary){
            	
                if(dictionary[k][key] === value){
                	
                	delete dictionary[k];
                	// Bug found by Giorgio 27 nov 09, it implies that
                	// some data are overidden
                	//itemsCount--;
                	break;
                	
                }
       
                
            }
        	
        }
		
		/**
		 * Return the entries of the Dictionary
		 * @return ArrayCollection
		 */ 
		[Bindable]
		public function get entries():ArrayCollection {
           
            var list:ArrayCollection = new ArrayCollection();

            for (var key:* in dictionary){
            	
                list.addItem(dictionary[key]);
                
            }
            
            return list;
            
        }
        
        public function set entries(value:ArrayCollection):void{
        	
        	throw new Error("Hash map entries is read only!");
        	
        }
        
        /**
         * Recover a list of values that matches the proprerty name used as argument
         * @param name String
         * @return ArrayCollection
         */ 
        public function getEntriesByName(name:String):ArrayCollection{
        	
        	var list:ArrayCollection = new ArrayCollection();
        	
        	 for (var key:* in dictionary){
            	
            	if(dictionary[key][name]){
            		
            		list.addItem(dictionary[key][name]);
            		
            	}
                
            }
            
            return list;
        	
        }
        
        /**
		 * Return the entries of the Dictionary as an ICollectionView
		 * @return ICollectionView
		 */ 
        public function getICollectionView():ICollectionView{
        	        	
        	var list:ArrayCollection = new ArrayCollection();

            for (var key:* in dictionary){
            	
                list.addItem(dictionary[key]);
                
            }
            
            var view:ICollectionView = list as ICollectionView;
            
            return view;
        	
        }

	}
}