package com.gnstudio.nabiro.ui

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
	
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.system.Capabilities;
	
	import mx.controls.ComboBox;
	import mx.core.mx_internal;
	import mx.events.DropdownEvent;
	
	use namespace mx_internal;
	
	public class MultiComboBox extends ComboBox{
		
		private const MAC:String = "mac";
		private const WIN:String = "win";		
		
		private var multiple:Boolean = false;
		private var os:String;
		
		
		public function MultiComboBox(){
			
			super();
			
			if(Capabilities.os.indexOf("Mac") >= 0){
				
				os = MAC;
				
			}else{
				
				os = WIN;
				
			}
			
			this.addEventListener(DropdownEvent.OPEN, function(e:DropdownEvent):void{
				
				_isOpened = true;
				
			});
			
			this.addEventListener(DropdownEvent.CLOSE, function(e:DropdownEvent):void{
				
				_isOpened = false;
				
			});
			
			
		}
		
		private var _isOpened:Boolean;
		[Bindable]
		public function set isOpened(value:Boolean):void{
			
			_isOpened = value;
			
		}
		
		public function get isOpened():Boolean{
			
			return _isOpened;
			
		}
		
		override public function close(trigger:Event=null) : void{
			
			if (!multiple){
				
				super.close(trigger);
				
			}
		
		}
		
		private var _delimiter:String = ",";
		[Bindable]
		public function set delimiter(value:String):void{
			
			_delimiter = value;
			
		}
		
		public function get delimiter():String{
			
			return _delimiter;
			
		}
		
		
		override public function get value():Object{
			
	        if (editable)
	            return text;
			
			if(selectedIndices.length > 0){
				
				return selectedItems;
				
			}else{
				
				 var item:Object = selectedItem;
	
		        if (item == null || typeof(item) != "object")
		            return item;
		
		        // Note: the explicit comparison with null is important, because otherwise when
		        // the data is zero, the label will be returned.  See bug 183294 for an example.
		        return item.data != null ? item.data : item.label;
				
				
			}
			
	       
	    }
		
		override  public function get selectedLabel():String{
			
		///	trace(this, dataProvider.length, selectedItems.length)
			
			if(this.dataProvider.length <= 1)return "";
			
			
			
			if(selectedItems){
				
				if(selectedItems.length > 0){
				
					var labels:String = "";
					var count:int = 0;
					
					// Sort selectedItem ( ASC )
	
					var labelArray:Array = new Array();
					
					for (var i:uint = 0;i < selectedItems.length; i++) {
						labelArray.push(itemToLabel(selectedItems[i]))
					}
					labelArray.sort();
					/* for (var i:uint = 0;i < labelArray.length; i++) {
						trace(":> ", labelArray[i])
					}	 */				
					
					for each(var item:Object in selectedItems){
						
						if(selectedItems.length > 1 && count < selectedItems.length - 1 ){
							
							labels += itemToLabel(item) + delimiter + " ";
							
						}else{
							
							labels += itemToLabel(item);
							
						}
						
						count++;
											
					}
					
					
					this.toolTip = labelArray.toString();
					return labelArray.toString();
					//this.toolTip = labels;
					//return labels;
				
				}
				
			}
			
			this.toolTip = "";
				
			return super.selectedLabel;

			
		}
		
		override protected function keyDownHandler(e:KeyboardEvent) : void{
			
			if(!_isOpened)return;
			
			super.keyDownHandler( e );
		
			if(os == MAC){
			
				multiple = e.charCode == 0;
			
			}else{
				
				multiple = e.ctrlKey;
				
			}

			if (multiple){
				
				dropdown.allowMultipleSelection = true;
				
			}
			
			
		}
		
		override protected function keyUpHandler(e:KeyboardEvent) : void{
						
			if(!_isOpened)return;
			
			super.keyUpHandler( e );
			
			 if(os == MAC){
				
				multiple = !(e.charCode == 0);
				
			}else{
					
				multiple = !e.ctrlKey;
				
					
			} 

			if (!multiple){
				
				close();
			
			}
			
			multiple = false;
			dropdown.allowMultipleSelection = false;
			
		}
		
		public function set selectedItems( value:Array ) : void{
			
			if ( dropdown ){
				
				dropdown.selectedItems = value;
				
			}
				
		
		}
		
		[Bindable("change")]
		public function get selectedItems( ) : Array{
			
			if ( dropdown ){
				
				return dropdown.selectedItems;
				
			}else{
				
				return null;
				
			}
		
		}
		
		public function set selectedIndices( value:Array ) : void{
			
			if ( dropdown ){				
				
				dropdown.selectedIndices = value;
				var dio:* = dropdown
				
			}
			
			this.text = selectedLabel;
				
		}
		
		[Bindable("change")]
		public function get selectedIndices( ) : Array{
			
			if (dropdown){
				
				return dropdown.selectedIndices;
				
			}else{
				
				return null;
				
			}
		
		
		}
	
	}
}
