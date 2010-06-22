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
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.text.TextFormat;
	
	import mx.controls.ProgressBar;
	import mx.core.IFlexDisplayObject;
	import mx.core.UIComponent;
	import mx.core.UITextField;
	import mx.core.mx_internal;
	
	[Style(name="overColor", type="uint", format="Color", inherit="yes")]
	
	public class SmartProgressBar extends ProgressBar{
		
		/**
		 * Over Bar placement
		 */
		private var _isOverBar:Boolean;
		
		[Event("change")]
		public function get isOverBar():Boolean{
			
			return _isOverBar;
			
		}
		
		public function set isOverBar(value:Boolean):void{
			
			_isOverBar = value;
			
		}
		
		/**
		 * Invert color
		 */
		private var _invertColor:Boolean;
		
		[Event("change")]
		public function get invertColor():Boolean{
			
			return _invertColor;
			
		}
		
		public function set invertColor(value:Boolean):void{
			
			_invertColor = value;
			
		}
		
		/**
		 * Inverted color textfield
		 */
		 protected var invertedText:UITextField;
		 
		 /** Inverted color mask
		 */
		 protected var invertedTextMask:UIComponent; 
		
		
		/**
		 * Namespace mx_internal
		 */ 
		use namespace mx_internal;
		
		public function SmartProgressBar(){
			
			super();
		
		}
		
		override protected function createChildren():void{
			
			super.createChildren();
			
			invertedText = new UITextField();
			
			invertedText.width = _labelField.width;
			invertedText.height = _labelField.height;
			invertedText.x = _labelField.x;
			invertedText.y = _labelField.y;
			invertedText.embedFonts = true;
			
			addChild(invertedText);
			
            invertedTextMask = new UIComponent();
             
            addChild(invertedTextMask);
             
            invertedText.mask = invertedTextMask;
			
		}
		
		override protected function measure():void{
			
			super.measure();
			
			if(isOverBar == true){
				
				 measuredMinHeight = measuredHeight = getStyle("trackHeight");
				
			}
			
		}
		
		override protected function childrenCreated():void{
			
			super.childrenCreated()
			
			var styles:TextFormat = _labelField.getTextFormat();
			
			invertedText.setTextFormat(styles);
			
			invertedText.textColor = 0xff0000//uint(getStyle("overColor"));
			trace(getStyle("overColor"))
			
		//	invertedText.setColor(this.getStyle(
			
			
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if(isOverBar == true){
				
				var trackHeight:Number = getStyle("trackHeight");
				
				_labelField.x = (width - _labelField.width) / 2;
				_labelField.y = _track.y + (_track.height - _labelField.height) / 2;				
				
			}
			
			if(invertColor){
				
				invertedText.x = _labelField.x;
				invertedText.y = _labelField.y;
				
				invertedText.text = _labelField.text;
				invertedText.textColor = uint(getStyle("overColor"));
				
				var g:Graphics = invertedTextMask.graphics;
                g.clear();
                g.beginFill(0xFFFF00);

                if(direction == "right"){
                	
                	g.drawRect(1, 1, _determinateBar.width - 2, _track.height - 2);
                
                }else{
                	
                	g.drawRect(_track.width - 1, 1, -(_determinateBar.width - 2), _track.height - 2);
                	
                }
                
                g.endFill();
								
			}
			
			
		}
		
	}
}