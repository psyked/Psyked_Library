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
	 *   @idea maker 			Fedele Marotti [ f.marotti@gnstudio.com ]
	 *   @author 					Fedele Marotti [ f.marotti@gnstudio.com ]
	 *   @request maker 	Giorgio Natili [  g.natili@gnstudio.com ]
	 *	 @fine tuning			Giorgio Natili [  g.natili@gnstudio.com ]
	 */
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	
	import mx.controls.Image;
	import mx.core.DragSource;
	import mx.core.IUIComponent;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	
	public class SmartDragManager
	{
		
		private static var _instance:SmartDragManager = new SmartDragManager();
		private static var _draggableItems:Array ;
		private static var _droppableItems:Array ;
		
	  	public static function makeDraggable( component:IUIComponent,showProxy:Boolean = true, dropTargets:Array = null):IUIComponent{
		   	
		   	if(_draggableItems == null){
		   		
		   		_draggableItems = new Array();
		   		
		   	}
		   	
			var missing:Boolean = true;
			var lim:int = _draggableItems.length;
			
			
			for(var i:int = 0; i < lim; i++){
				
				if(_draggableItems[i].dragInitiator == component){
					
					missing = false;
					break;
					
				}
				
			}
			
			if(missing ){
				
				component.addEventListener( MouseEvent.MOUSE_DOWN, doDrag );
				var item:Item = new Item(component,showProxy,dropTargets
				
				)
				_draggableItems.push(item)
			
			}
			
			
			return component;
		
		}
	   
	  	protected static function doDrag( mouseEvent:MouseEvent ):void {
			
			var dragInitiator:IUIComponent = mouseEvent.currentTarget as IUIComponent;
	      	var dragImg:Image = new Image();
	      	
	      	if(neededProxy(dragInitiator)){
	      		
				var bitmapData:BitmapData = new BitmapData(dragInitiator.width, dragInitiator.height, true, 0x00000000);
	   			bitmapData.draw(dragInitiator);
	
	            var bitmap:Bitmap = new Bitmap(bitmapData);
	
				dragImg.source = bitmap;
				
	      	}
			var dsource:DragSource = new DragSource();
			dsource.addData(dragInitiator, 'item');
			
			DragManager.doDrag(dragInitiator, dsource, mouseEvent, dragImg);
			
	   	}
	   	
	   
		public static function makeDroppable( component:IUIComponent , onDrop:Function ):IUIComponent{
	   		
	   		if(_droppableItems == null){
		   		
		   		_droppableItems = new Array();
		   		
		   	}
		   	
			var missing:Boolean = true;
			var lim:int = _droppableItems.length;
			
			for(var i:int = 0; i < lim; i++){
				
				if(_droppableItems[i] == component){
					
					missing = false;
					break;
					
				}
				
			}
			
			if( missing ){
				
				component.addEventListener( DragEvent.DRAG_OVER, allowDrop );
				component.addEventListener( DragEvent.DRAG_DROP, onDrop);
				_droppableItems.push(component);
				
	  		}
	  		
			return component;
	      
		}
	   	
	   	
	   	
	   	
	   	private static function getAllowedDropTargets(component:IUIComponent):Array{
	   		
	   		var lim:int = _draggableItems.length;
			
			var allowedDropTarget:Array;
			
			for(var i:int = 0; i < lim; i++){
				
				if(_draggableItems[i].dragInitiator == component){
					
					if(_draggableItems[i].dropTargets){
					
						allowedDropTarget = _draggableItems[i].dropTargets;
						break;
					
					}
					
				}
				
			}
			
	   		return allowedDropTarget;
	   		
	   	}
	   	
	   	
	   	
		protected static function allowDrop( dragEvent:DragEvent ):void{
			
			var dropTarget:IUIComponent = dragEvent.currentTarget as IUIComponent;
			var component:IUIComponent = dragEvent.dragSource.dataForFormat('item') as IUIComponent;
			var allowedDropTargets:Array = getAllowedDropTargets(component);
			
			if(allowedDropTargets != null){

				for(var i:int=0;i< allowedDropTargets.length; i++){
					
					if(dropTarget is allowedDropTargets[i]){
						
						DragManager.acceptDragDrop( dropTarget );
						return;
						
					}
							
				}

				
			}else {
			
				DragManager.acceptDragDrop( dropTarget );
			
			}
	      	
		}
	   
	   //	public static function denyDrop(
	   	
		
		public static function removeDrag( component:IUIComponent ):IUIComponent{
		   	
			var lim:int = _draggableItems.length;
			
			for(var i:int = 0; i < lim; i++){
				
				if(_draggableItems[i].dragInitiator == component){
				
					_draggableItems.splice(i, 1);
					component.removeEventListener( MouseEvent.MOUSE_DOWN, doDrag );
					
					return component;
				
				}
			
			}
			
			return null;
		
		}
	   	
	   	
	   	public static function removeDrop( component:IUIComponent ):IUIComponent{
	   		
	   		var lim:int = _droppableItems.length;
			
			for(var i:int = 0; i < lim; i++){
				
				if(_droppableItems[i] == component){
				
					_droppableItems.splice(i, 1);
					component.removeEventListener( DragEvent.DRAG_ENTER, allowDrop );
					
					return component;
				
				}
			
			}
			
			return null;
		
			
	      
		
		}
		
		
		private static function neededProxy(dragInitiator:IUIComponent):Boolean{
			
			for each(var item:Item in _draggableItems){
			
				if(item.dragInitiator == dragInitiator){
				
					return item.showProxyImage;
					
				}
			
			}
			
			
			return true;
		
		}
	   
	}
	
}
	
	
	import flash.display.DisplayObject;
	import mx.core.IUIComponent;
	

	class Item{
	
		private var _dragInitiator:IUIComponent;		
		private var _showProxyImage:Boolean;
		private var _dropTargets:Array;
		
		public function Item(dragInitiator:IUIComponent,showProxyImage:Boolean,dropTargets:Array = null){
			
			_dragInitiator = dragInitiator;
			_showProxyImage = showProxyImage;
			_dropTargets = dropTargets;
		
		}
	
		public function get dragInitiator():IUIComponent{
		
			return _dragInitiator;
		
		}		
		public function get showProxyImage():Boolean{
		
			return _showProxyImage;
		
		}
		
		public function get dropTargets():Array{
		
			return _dropTargets;
		
		}
		
	}
