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
	 *   @fine tuning			Ivan Varga [ ivan.varga@gnstudio.com ]
	 *	 
	 */
	 
	import com.gnstudio.nabiro.ui.vo.SmartRenderData;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import mx.controls.List;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.IFactory;
	import mx.core.mx_internal;
	import mx.events.ListEvent;
	
	use namespace mx_internal;
	
	public class VariableRowList extends List{
		
		
		
		public function VariableRowList(){
			
			this.variableRowHeight = true;
			this.wordWrap = true;
			this.selectable = false;	
			
		//	rowHeight = 400
			
		//	allowRendererStealingDuringLayout = false				
			
		}
		
		/* override mx_internal function createItemMask(x:Number, y:Number, width:Number, height:Number):DisplayObject{
            
            var mask:Shape;
            
            try{
            	
            	mask = super.createItemMask(x, y, width, height) as Shape;
            	
            }catch(e:Error){
            	
            	mask = new FlexShape();
           		mask.name = "mask";
            	
            }
        	
        	return mask;	
                                    	
		} */
		
		/**
		 * Removes all item renderers from display list and also cleans all references to them. 
		 */
		public function removeAllRenderers():void {
			
			purgeItemRenderers();
			
			// Do the clean up once more, searching for the ISmartRenderer implementers.
			var contentLimit:int = listContent.numChildren;
			
			for (var contentIndex:int = 0; contentIndex < contentLimit; contentIndex++) {
				
				var child:DisplayObject = listContent.getChildAt(contentIndex) as DisplayObject;
				
				if (child as ISmartRenderer) {
					
					listContent.removeChild(child);
					
					contentLimit = listContent.numChildren;
					contentIndex--;
					
				}
				
			}
			
			// Destroy highlight references.
			lastHighlightItemRenderer = null;
			
			lastHighlightItemRendererAtIndices = null;
			
			// Do total clean of measuringObjects Dictionary.
			var key:Object;
			
			for (key in measuringObjects) {
				
				if (measuringObjects[key] && measuringObjects[key].parent) {
					
					measuringObjects[key].parent.removeChild(DisplayObject(measuringObjects[key]));
					
				}
				
				measuringObjects[key] = null;
				key = null;
				delete measuringObjects[key];
				
			}
			
			measuringObjects = new Dictionary(true);
			
			// Do total clean of factoryMap Dictionary.
			for (key in factoryMap) {
				
				if (key && key.parent) {
					
					key.parent.removeChild(DisplayObject(key));
					
				}
				
				factoryMap[key] = null;
				key = null;
				delete factoryMap[key];
				
			}
			
			factoryMap = new Dictionary(true);
			
		}
		
		override  protected function mouseClickHandler(event:MouseEvent):void{
			
			var item:IListItemRenderer = mouseEventToItemRenderer(event);
	        if (!item)
	            return;
	        
	        try{
		        
		        ISmartRenderer(item).clicked = true;
		        				      
		    }catch(e:Error){
		        		
		        trace("It's not an ISmartRenderer implementors", e.message, item)
		        event.stopImmediatePropagation()
		        		
		    }	          
	
	        var pt:Point = itemRendererToIndices(item);
	        
	        // during tweens, we may get null
	        if (pt) {
	        	
	            var listEvent:ListEvent = new ListEvent(ListEvent.ITEM_CLICK);
	            
	            listEvent.columnIndex = pt.x;
	            listEvent.rowIndex = pt.y;
	            listEvent.itemRenderer = item;
	            
	            dispatchEvent(listEvent);
	            
	        }
			
		}

	     override protected function configureScrollBars():void{
	    	
		    	var rowCount:int = listItems.length;
	        if (rowCount == 0) return;
	
	        // ignore nonvisible rows off the top
	        var yy:Number;
	        var i:int;
	        var n:int = listItems.length;
	        // if there is more than one row and it is a partial row we dont count it
	        while (rowCount > 1 && rowInfo[n - 1].y + rowInfo[n-1].height > listContent.height - listContent.bottomOffset)
	        {
	            rowCount--;
	            n--;
	        }
	
	        // offset, when added to rowCount, is the index of the dataProvider
	        // item for that row.  IOW, row 10 in listItems is showing dataProvider
	        // item 10 + verticalScrollPosition - lockedRowCount - 1;
	        var offset:int = verticalScrollPosition - lockedRowCount - 1;
	        // don't count filler rows at the bottom either.
	        var fillerRows:int = 0;
	        // don't count filler rows at the bottom either.
	        while (rowCount && listItems[rowCount - 1].length == 0)
	        {
	            if (collection && rowCount + offset >= collection.length)
	            {
	                rowCount--;
	                ++fillerRows;
	            }
	            else
	                break;
	        }
	
	        // we have to scroll up.  We can't have filler rows unless the scrollPosition is 0
	        // We don't do the adjustment if a data effect is running, because that prevents
	        // a smooth effect. Effectively, we pin the scroll position while the effect is
	        // running.
	        if (verticalScrollPosition > 0 && fillerRows > 0 && !runningDataEffect)
	        {
	            /* if (adjustVerticalScrollPositionDownward(Math.max(rowCount, 1)))
	                return; */
	        }
	
	        if (listContent.topOffset)
	        {
	            yy = Math.abs(listContent.topOffset);
	            i = 0;
	            while (rowInfo[i].y + rowInfo[i].height <= yy/30)
	            {
	                rowCount--;
	                i++;
	                if (i == rowCount)
	                    break;
	            }
	        }
	
	        var colCount:int = listItems[0].length;
	        var oldHorizontalScrollBar:Object = horizontalScrollBar;
	        var oldVerticalScrollBar:Object = verticalScrollBar;
	        var roundedWidth:int = Math.round(unscaledWidth);
	        var length:int = collection ? collection.length - lockedRowCount*5: 0;
	        var numRows:int = rowCount - lockedRowCount;
	
	        setScrollBarProperties((isNaN(_maxHorizontalScrollPosition)) ?
	                            Math.round(listContent.width) :
	                            Math.round(_maxHorizontalScrollPosition + roundedWidth),
	                            roundedWidth, length, numRows);
	        maxVerticalScrollPosition = Math.max(length - numRows, 0);
	    	
	    	
	    } 

		/* override mx_internal function setupRendererFromData(item:IListItemRenderer, wrappedData:Object):void{
			
			super.setupRendererFromData(item, wrappedData);
			
			trace("called", wrappedData.state)
			
		} 
		
		override protected function mouseEventToItemRenderer(event:MouseEvent):IListItemRenderer
    {
    	
    	trace('mouseEventToItemRenderer')
    	
        var r:IListItemRenderer = super.mouseEventToItemRenderer(event);
        return r == itemEditorInstance ? null : r;
    }
				 */
		override  protected function getReservedOrFreeItemRenderer(data:Object):IListItemRenderer {
		        		        
		        var item:IListItemRenderer;
		        var uid:String;		        
		        
		        if (runningDataEffect)
		            item = IListItemRenderer(reservedItemRenderers[uid = itemToUID(data)]); 
		
		        if (item)
		            delete reservedItemRenderers[uid];
		        else
		        {
		            var factory:IFactory = getItemRendererFactory(data);
		            if (freeItemRenderersByFactory)
		            {
		                if (factory == itemRenderer)
		                {
		                    if (freeItemRenderers.length)
		                    {
		                        item = freeItemRenderers.pop();
		                        delete freeItemRenderersByFactory[factory][item];
		                    }
		                }
		                else
		                {
		                    var freeRenderers:Dictionary = freeItemRenderersByFactory[factory];
		                    if (freeRenderers)
		                    {
		                        for (var p:* in freeRenderers)
		                        {
		                            item = p;
		                            delete freeItemRenderersByFactory[factory][item];
		                            break;
		                        }
		                    }
		                }
		
		            }
		        }
		        
		        var dt:SmartRenderData = SmartRenderData(data);
		        
		        if(item){
		        	
		        	try{
		        	//	trace("@@@@@", dt.renderData.behaviorTypeName, dt.state)
		        		ISmartRenderer(item).updateState(dt.state);
		        		
		        		// trace("getReservedOrFreeItemRenderer", item, item.height, this.height)
		        		
		        		/* var a:Array = (this.rowInfo)
		        				      var b:* = this.actualCollection
		        				      var c:* = this.collectionIterator;
		        				      
		        				      trace('dragScrollingInterval', dragScrollingInterval)
		        				      trace(this.collectionIterator)
		        				      trace(this.itemToItemRenderer(item.data), item) */
		        				      
		        	}catch(e:Error){
		        		
		        		trace("It's not an ISmartRenderer implementors", e.message, item)
		        		
		        	}
		        
		        }
		        		        
			return item;
			
		}
		
		override public function createItemRenderer(data:Object):IListItemRenderer{
			
			var dt:SmartRenderData = SmartRenderData(data);
						
			var factory:IFactory;

	        // get the factory for the data
	        factory = getItemRendererFactory(dt);
	        
	        if (!factory){
	        	
	            if (data == null){
	                
	                factory = nullItemRenderer;
	            
	            }
	            
	            if (!factory){
	            	
	            	factory = itemRenderer;
	            		
	            }
	                
	        }
	
	        var renderer:IListItemRenderer;
	        
	        // if it is the default column factory, see if
	        // the freeItemRenderers table has a free one
	        if (factory == itemRenderer){
	     
	            if (freeItemRenderers && freeItemRenderers.length){
	                
	                renderer = freeItemRenderers.pop();
	                delete freeItemRenderersByFactory[factory][renderer];
	            
	            }
	        
	        }else if (freeItemRenderersByFactory){
	        	
	            // other re-usable renderers are in the FactoryMap
	            var d:Dictionary = freeItemRenderersByFactory[factory];
	            
	            if (d){
	                
	                for (var p:* in d){
	                    
	                    renderer = IListItemRenderer(p);
	                    delete d[p];
	                    break;
	                    
	                }
	            }
	        }
	
	        if (!renderer){
	       
	            renderer = factory.newInstance();
	            renderer.styleName = this;
	            factoryMap[renderer] = factory;
	            
	        }
			
			if(dt != null){
								
				 if(renderer){
				 			        	
		        	try{
		        		
		        		ISmartRenderer(renderer).updateState(dt.state);
		        	//	trace("createItemRenderer", renderer, renderer.height, this.height)
		        		
		        	}catch(e:Error){
		        		
		        		trace("It's not an ISmartRenderer implementors", e.message, e.name, e.getStackTrace(), "\n", renderer)
		        		
		        	}
		        	
		  	 }
			
			}			
			
	        renderer.owner = this;     
	        
	        return renderer;
			
		}
	}
}