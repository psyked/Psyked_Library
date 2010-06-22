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
	
	import com.gnstudio.nabiro.utilities.SmartPopUpManager;
	
	import flash.events.MouseEvent;
	
	import mx.containers.Panel;
	import mx.controls.Button;

	public class ClosablePanel extends Panel
	{
		
		protected var _closeBtn:Button;
		
		public function ClosablePanel()
		{
			super();
		}
		
		override protected function createChildren():void{
			
			super.createChildren();
			
			if(!_closeBtn){
				
				_closeBtn = new Button();
				
				rawChildren.addChild(_closeBtn)		
				_closeBtn.label = _closeLabel;
				_closeBtn.addEventListener(MouseEvent.CLICK, onClose);
				
			}
			
		}
		
		protected function onClose(e:MouseEvent):void{
			
			SmartPopUpManager.removePopUp(this)
			
		}
		
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			
			super.updateDisplayList(unscaledWidth, unscaledHeight)
				
			_closeBtn.width = _closeBtn.measuredWidth;
			_closeBtn.height = _closeBtn.measuredHeight;
				
			_closeBtn.move(this.width - _closeBtn.measuredWidth, this.titleBar.y);
			statusTextField.x = (_closeBtn.x - statusTextField.width - 2);
			
		}
		
		private var _closeLabel:String = "x";
		
		[Inspectable(defaultValue='x', verbose=0, category="Other")]
		public function get closeLabel():String{
			
			return _closeLabel;
			
		}
		
		public function set closeLabel(value:String):void{
			
			_closeLabel = value;
			
		}
		
		
	}
}