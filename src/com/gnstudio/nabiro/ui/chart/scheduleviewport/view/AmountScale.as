package com.gnstudio.nabiro.ui.chart.scheduleviewport.view {

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
	 *   @package  nabiro
	 *
	 *   @version  0.9
	 *   @author 					Marco Fusetti [ m.fusetti@gnstudio.com ]
	 */

	import flash.display.Graphics;

	import mx.core.UIComponent;

	/**
	 * scale background visualization in amount behavior
	 * <br />not recommended to be instatiated directly
	 *
	 * @package nabiro
	 * @playerversion 9
	 * @productversion flex 3.2
	 */
	public class AmountScale extends UIComponent {

		/**
		 * @private
		 * physical scale width
		 */
		private var _asWidth:int;

		/**
		 * @private
		 * scale base
		 */
		private var _scaleBase:int = 10;

		/**
		 * @private
		 * background color
		 * @default 0xDDEEFF
		 */
		private var _amountScaleColor:uint = 0xDDEEFF;

		/**
		 * @private
		 * text labels used to visualize scale steps
		 */
		private var _labels:Array;

		/**
		 * physical scale width
		 */
		public function set amountScaleWidth(value:int):void {
			_asWidth = value;
			redraw();
		}

		/**
		 * scale base
		 */
		public function set scaleBase(value:int):void {
			_scaleBase = value;
			redraw();
		}

		/**
		 * background color
		 */
		public function set amountScaleColor(value:uint):void {
			_amountScaleColor = value;
			redraw();
		}

		/**
		 * the constructor
		 * @param scale width
		 * @param scale base
		 */
		function AmountScale(asWidth:int, scaleBase:int){

			_asWidth = asWidth;
			_scaleBase = scaleBase;
			_labels = new Array();

			for(var i:int = 0; i < 10; i++){
				var labelTxt:String = "" +(i + 1);
				var tlsl:TimelineScaleLabel = new TimelineScaleLabel(0, labelTxt, 0xFFFFFF);
				tlsl.y = 2;
				tlsl.centerAlign = false;
				_labels.push(tlsl);
				addChild(tlsl);
			}

			redraw();
		}

		/**
		 * @private
		 * component redraw
		 * @return
		 */
		private function redraw():void {

			var g:Graphics = graphics;
			g.clear();
			g.beginFill(_amountScaleColor);

			var stepX:Number = _asWidth / 10;
			var scaleUnit:int = _scaleBase / 10;

			for(var i:int = 0, k:int = scaleUnit; i < 10; i++, k += scaleUnit){
				g.drawRect(stepX * i, 0, stepX - 2, 18);
				_labels[i].text = "" +k;
				_labels[i].x = (stepX * i) + stepX - 6 - _labels[i].textWidth;
			}

			g.endFill();
		}
	}
}