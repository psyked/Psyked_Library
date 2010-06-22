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
	
	import flash.errors.IllegalOperationError;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import mx.collections.ArrayCollection;
	import mx.utils.ObjectUtil;
	
	public class IdentityMap
	{
		
		private var hash:IdentityHashMap;
		
		private static var identityMap:IdentityMap;
		
		private var classType:Class;
		private var detail:IdentityMapDetail;
		
		private var timer:Timer;
		private var existence:int;
		
		/**
		 * Constructor
		 * Define the class type of the object that can be added to the map and the details
		 * @param singleton IdentityMapSingleton
		 * @param classType Class
		 * @detail IdentityMapDetail
		 */ 
		public function IdentityMap(singleton:IdentityMapSingleton, classType:Class, detail:IdentityMapDetail){
			
			hash = new IdentityHashMap();
			
			this.classType = classType;
			this.detail = detail;
		
			existence = 0;
			
			timer = new Timer(detail.checkTime);
			timer.addEventListener(TimerEvent.TIMER, onCacheCheck);
			
			timer.start();
			
		}
		
		/** 
		 * Listener to the TimerEvent.TIMER event it is the responsible
		 * of the purge of the items after a precise slot of time
		 * in order to avoid memory issues
		 * @param e TimerEvent
		 */ 
		private function onCacheCheck(e:TimerEvent):void{
			
			existence += detail.checkTime;
			
			var tmpCollection:ArrayCollection = hash.entries;
			
			for each(var item:Object in tmpCollection){				
			
				if(existence > item.creation + detail.liveTime ){
				
					IdentityMap.identityMap.removeElement(item);
					
				}
				
			}
			
		//	trace("existence", existence, tmpCollection)
				
		}
		
		/**
		 * Return the entries polished from the time creation data
		 * @return ArrayCollection
		 */		
		[Bindable]
		public function get entries():ArrayCollection{
			
			var tmpCollection:ArrayCollection = new ArrayCollection();
			
			for each(var item:Object in hash.entries){
				
				tmpCollection.addItem(item.value);
				
			}
			
			return tmpCollection;
			
		}
		
		public function set entries(value:ArrayCollection):void{
			
			throw new Error("IdentityMap entries is read only!");
			
		}
		
		/**
		 * Method used in order to add an element, 
		 * if the element already exists it is returned and not
		 * added
		 * @param item *
		 * @return *
		 */ 
		public function addElement(item:*):*{
			
			check(item);
		
			if(!exist(item)){
				
				hash.addItem({value: item, creation: getTimer()});
				
			}else{
				
				return item;
				
			}
			
		}
		
		/**
		 * Method used in order to recover an existing item from the mao
		 * @param value *
		 * @return *
		 */ 
		public function getElement(value:*):*{
			
			var item:*;
			
			var tmpCollection:ArrayCollection = hash.entries;
			
			for each(var obj:* in tmpCollection){
				
				if(obj.value[detail.checkFiled] == value){
					
					item = obj.value;
					break;
					
				}
				
			}
			
			return item;
			
		}
		
		/**
		 * Method used to remove an item, it check the existence
		 * of the object before removing
		 * @param item *
		 * @return Boolean
		 */ 
		private function removeElement(item:*):Boolean{
			
			var success:Boolean = false;
			
			if(exist(item.value)){
				
				hash.remove("", item.value);
				success = true;
				
			}
			
			return success;
			
		}
		
		/**
		 * Method used in order to check if the item exist in the map
		 * and in order to avoid the loading of two objects with the 
		 * same data
		 * @param item *
		 * @rerurn Boolean
		 */ 
		private function exist(item:*):Boolean{
			
			var status:Boolean = false;
			
			var tmpCollection:ArrayCollection = hash.entries;
			
			for each(var obj:* in tmpCollection){
				
				if(obj.value[detail.checkFiled] == item[detail.checkFiled]){
					
					status = true;
					break;
					
				}
				
			}
			
			return status;
			
		}
		
		/**
		 * Static method used in order to get and IdentityMap instance, if you
		 * have aleady called the method with all the parameteres you can avoid the
		 * parameters in the successive calls if you don't need to change the datatype
		 * of the stored objects or the info releated to the IdentityMap
		 * @param classType Class
		 * @param detail IdentityMapDetail
		 * @return IdentityMap
		 */ 
		public static function getInstance(classType:Class = null, detail:IdentityMapDetail = null):IdentityMap{
			
			if(!classType && !detail && !IdentityMap.identityMap){
				
				throw(new IllegalOperationError("IdentityMap.identityMap has not been initialized with the needed values!"));
				return;
				
			}
			
			if(IdentityMap.identityMap){
				
				if(classType != null){
				
					IdentityMap.identityMap.classType = classType;
				
				}
				
				if(detail != null){
					
					IdentityMap.identityMap.detail = detail;
					
				}	
				
			}else{
				
				IdentityMap.identityMap = new IdentityMap(new IdentityMapSingleton(), classType, detail);
				
			}
			
						
			return IdentityMap.identityMap;
			
		}
		
		/**
		 * Method used in order to perform datatype checking on
		 * the elements added to the map
		 * @param item *
		 */ 
		private function check(item:*):void{			
				
			if (!(item is IdentityMap.identityMap.classType)) {
				
   				throw new TypeError("Wrong type, " + ObjectUtil.toString(IdentityMap.identityMap.classType) + " was expected");
   				
   			}

			
		}

	}
}

internal class IdentityMapSingleton{
	
	
	
}
