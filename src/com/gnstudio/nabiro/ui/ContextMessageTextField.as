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
	 *   @fine tuning	         Fabio Biondi [ f.biondi@gnstudio.com ]
	 *	 
	 */
	
	
	import mx.controls.Label;
	import mx.controls.TextInput;
	import mx.core.EdgeMetrics;
	import mx.core.FlexVersion;
	import mx.core.IRectangularBorder;
	import mx.core.mx_internal;
	
	use namespace mx_internal;
	
	[Style(name="errorContextColor", type="uint", format="Color", inherit="yes")]

	public class ContextMessageTextField extends TextInput{
		
		
		public static const MARGIN:Number = 5;
		
		
		protected var _contextLabel:Label;
		
		private var _addedHeight:Number;
		private var _originalTextfieldHeight:Number;
		private var _contextMessageChanged:Boolean;
		private var _contextMessage:String;
		private var _contextMeasureDirty:Boolean;
		private var _focusIsDirty:Boolean;
		
		[Bindable]
		public function set contextMessage(value:String):void{
			
			if(value != _contextMessage){
				
				_contextMessageChanged = true;
				_contextMessage = value;
				
				invalidateProperties();
			
			}
			
		}
		
		public function get contextMessage():String{
			
			return _contextMessage;
			
		}
		
		public function ContextMessageTextField(){
			
			super();
			
			_focusIsDirty = true;
		
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			
			var bm:EdgeMetrics;
			
			

	        if (border){
	        	
	        	 if(_contextLabel){
				
					if(getChildByName(_contextLabel.name)){
						
						border.setActualSize(unscaledWidth, unscaledHeight - _contextLabel.height);
						
						 if(_focusIsDirty){
						 
						 	_focusIsDirty = false;	
						 	drawFocus(true)
						 	
						 }
						 
					}
					
	        	 }else{
	        	 	
	        	 	border.setActualSize(unscaledWidth, unscaledHeight);
	        	 		        	 	
	        	 }
	        	
	           
	            bm = border is IRectangularBorder ? IRectangularBorder(border).borderMetrics : EdgeMetrics.EMPTY;
	        
	        }else{
	            
	            bm = EdgeMetrics.EMPTY;
	        
	        }
	                
	        var paddingLeft:Number = getStyle("paddingLeft");
	        var paddingRight:Number = getStyle("paddingRight");
	        var paddingTop:Number = getStyle("paddingTop");
	        var paddingBottom:Number = getStyle("paddingBottom");
	        var widthPad:Number = bm.left + bm.right;
	        var heightPad:Number = bm.top + bm.bottom + 1;
	        
	        textField.x = bm.left;
	        textField.y = bm.top;
	        	
	        if (FlexVersion.compatibilityVersion >= FlexVersion.VERSION_3_0){
	        	
	            textField.x += paddingLeft;
	            textField.y += paddingTop;
	            widthPad += paddingLeft + paddingRight; 
	            heightPad += paddingTop + paddingBottom;
	            
	        }
	        
	        textField.width = Math.max(0, unscaledWidth - widthPad);
	        textField.height = Math.max(0, unscaledHeight - heightPad);
						
		}
		    	
    	override public function drawFocus(isFocused:Boolean):void{
    		
    		super.drawFocus(isFocused);
    		
    		if (border){
	        	
	        	if(_contextLabel){
				
					if(getChildByName(_contextLabel.name)){
						
						focusManager.focusPane.getChildByName("focus").height -= this._addedHeight;
						
					}
					
	        	}
	        	 
	     	}
    		
    	}
		
		override protected function measure():void{
			
			super.measure();
			
			if(_contextMeasureDirty){
				
				if(_contextLabel){
					
					if(getChildByName(_contextLabel.name)){
												
						_addedHeight = _contextLabel.height;
				
						this.measuredHeight += _addedHeight;
						this.minHeight += _addedHeight; 
						
					}else{
												
						this.measuredHeight -= _addedHeight;
						this.minHeight -= _addedHeight; 
						
						this.invalidateDisplayList();
						
					}
					
				}			
				
				_contextMeasureDirty = false;
				
			}
			
			
			
		}
		
		override protected function childrenCreated():void{
			
			super.childrenCreated();
			
			
			
		}
				
		override protected function commitProperties():void{
			
			super.commitProperties();
						
			if(_contextMessageChanged){
				
				_contextMessageChanged = false;
				
				if(_contextLabel){
					
					if(getChildByName(_contextLabel.name)){
						
						removeChild(_contextLabel);
						_addedHeight = 0;
						
						measuredHeight = 22
						minHeight = 22
						textField.height = _originalTextfieldHeight;
						
					}					
					
				}
					
				if(_contextMessage != "" || _contextMessage.length > 0){
						
					if(!_originalTextfieldHeight) _originalTextfieldHeight = textField.height;
					
					_contextLabel = new Label();
					_contextLabel.setStyle("color", getStyle("errorContextColor") || getStyle("errorColor"));
					_contextLabel.width = textField.width
					_contextLabel.height = textField.height
					_contextLabel.x = textField.x;
					_contextLabel.y = textField.y + textField.height + MARGIN;
					_contextLabel.text = _contextMessage;
						
					addChild(_contextLabel);
					
				}
						
				// If the _contextLabel is removed or added the component is dirty
				_contextMeasureDirty = true;
					
				measure();
				
			}
			
		}
		
	}
}