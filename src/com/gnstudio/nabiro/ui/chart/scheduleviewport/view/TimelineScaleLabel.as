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
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.text.TextFormat;

	import mx.core.UIComponent;

	/**
	 * label date fragment to be drawn in TimelineScale child component
	 * <br />not recommended to be instatiated directly
	 * <br />it has no public methods, all params has to be provided to the constructor
	 *
	 * @package nabiro
	 * @playerversion 9
	 * @productversion flex 3.2
	 */
	public class TimelineScaleLabel extends UIComponent {

		/**
		 * @private
		 * background
		 */
		private var _bck:Shape;

		/**
		 * @private
		 * original text for label
		 */
		private var _txt:String = "";

		/**
		 * @private
		 * toggle background drawing
		 */
		private var _drawBackground:Boolean = false;

		/**
		 * @private
		 * text align: center/left
		 */
		private var _centerAlign:Boolean = true;

		/**
		 * @private
		 * first text row
		 */
		private var _row1:TextField;

		/**
		 * @private
		 * second text row
		 */
		private var _row2:TextField;

		/**
		 * @private
		 * third text row
		 */
		private var _row3:TextField;

		/**
		 * @private
		 * text leading
		 */
		private var _leading:int = 8;

		/**
		 * text align: center/left
		 */
		public function get centerAlign():Boolean {
			return _centerAlign;
		}
		public function set centerAlign(value:Boolean):void {
			_centerAlign = value;
		}

		/**
		 * maximum text width
		 */
		public function get textWidth():Number {

			var textWidth:Number = Math.max(_row1.textWidth, _row2.textWidth);
			return Math.max(textWidth, _row3.textWidth);
		}

		/**
		 * label text
		 */
		public function get text():String {
			return _txt;
		}
		public function set text(value:String):void {
			_txt = value;
			redraw();
		}

		/**
		 * Constructor
		 * @param x coordinate label
		 * @param string to show
		 * @param color label
		 * @param draw the background if required
		 */
		public function TimelineScaleLabel(baseX:Number, labelTxt:String, labelColor:uint = 0x333333, drawBackground:Boolean = false) {

			super();

			x = baseX;

			_bck = new Shape();
			_drawBackground = drawBackground;
			_txt = labelTxt;

			_row1 = new TextField();
			_row2 = new TextField();
			_row3 = new TextField();

			_row1.width = 50;
			_row2.width = 50;
			_row3.width = 50;

			_row1.y = -2;
			_row2.y = -2 + _leading;
			_row3.y = -2 + _leading * 2;

			_row1.embedFonts = true;
			_row2.embedFonts = true;
			_row3.embedFonts = true;

			_row1.textColor = labelColor;
			_row2.textColor = labelColor;
			_row3.textColor = labelColor;

			_row1.multiline = true;
			_row2.multiline = true;
			_row3.multiline = true;

			_row1.selectable = false;
			_row2.selectable = false;
			_row3.selectable = false;

			var mtf:TextFormat = new TextFormat();
			mtf.bold = true;
			mtf.font = "uni0563";
			mtf.size = 8;

			_row1.defaultTextFormat = mtf;
			_row2.defaultTextFormat = mtf;
			_row3.defaultTextFormat = mtf;

			addChild(_bck);
			addChild(_row1);
			addChild(_row2);
			addChild(_row3);

			redraw();
		}

		/**
		 * @private
		 * redraw the component
		 * @return
		 */
		private function redraw():void {

			var txt:String = _txt += "\n\n\n";
			var rowText:Array = txt.split("\n");

			_row1.text = rowText[0];
			_row2.text = rowText[1].length ? rowText[1] : "   ";
			_row3.text = rowText[2].length ? rowText[2] : "   ";

			_row1.x = _row2.x = _row3.x = 0;

			if(_centerAlign){
				_row1.x = -(Math.round(_row1.textWidth / 2));
				_row2.x = -(Math.round(_row2.textWidth / 2));
				_row3.x = -(Math.round(_row3.textWidth / 2));
			}

			var g:Graphics = _bck.graphics;
			g.clear();

			if(_drawBackground){

				var bckHeight:int = (_leading + 4) * (rowText.length - 3);
				var rowX:int = Math.min(_row1.x, _row2.x);
				rowX = Math.min(_row2.x, _row3.x);
				_bck.x = rowX;

				g.beginFill(0xFFFFFF);
				g.drawRect(0, 0, textWidth + 4, bckHeight);
				g.endFill();
			}
		}
	}
}