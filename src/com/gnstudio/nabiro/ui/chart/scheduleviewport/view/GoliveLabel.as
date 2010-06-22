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

	import flash.display.Shape;
	import flash.display.Graphics;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.effects.Fade;


	/**
	 * label offset start/end time gap to be drawn in TimelineItem child component, golive behavior
	 * not recommended to be instatiated directly
	 *
	 * @package nabiro
	 * @playerversion 9
	 * @productversion flex 3.2
	 */
	public class GoliveLabel extends UIComponent {

		import mx.core.UIComponent;

		/**
		 * @private
		 * outer|inner relevant timeline bar drawing
		 */
		private var _inner:Boolean = true;

		/**
		 * @private
		 * fading component
		 */
		private var _fade:Fade;

		/**
		 * @private
		 * label background strip to ease reading
		 */
		private var _labelBck:Shape;

		/**
		 * @private
		 * line marker
		 */
		private var _lineMarker:Shape;

		/**
		 * @private
		 * top/bottom draw policy
		 * @default true
		 */
		private var _topFlag:Boolean = true;

		/**
		 * @private
		 * left/right draw policy
		 */
		private var _leftFlag:Boolean = true;

		/**
		 * @private
		 * texField to show the timeline start/end label
		 */
		private var _label:TextField;

		/**
		 * outer|inner relevant timeline bar drawing
		 */
		public function set inner(value:Boolean):void {

			if(value != _inner){
				_inner = value;
				drawUI();
				redraw();
			}
		}

		/**
		 * text to show in label
		 */
		public function get text():String {
			return _label.text;
		}
		public function set text(value:String):void {
			_label.text = value;
			redraw();
		}

		/**
		 * whole label width, used to get draw policy
		 */
		public function get goliveLabelWidth():uint {
			return _label.textWidth + 8;
		}

		/**
		 * left/right side draw
		 */
		public function set left(value:Boolean):void {
			_leftFlag = value;
			redraw();
		}

		/**
		 * top/bottom draw
		 */
		public function set top(value:Boolean):void {
			_topFlag = value;
			redraw();
		}

		/**
		 * Constructor
		 * @param draw as top/bottom label
		 * @param draw as left/right label
		 * @param text to populate label
		 */
		public function GoliveLabel(topFlag:Boolean = true, leftFlag:Boolean = true, txt:String = "") {

			super();

			_leftFlag = leftFlag;
			_topFlag = topFlag;
			_label = new TextField();
			_label.text = txt;
			_labelBck = new Shape();
			_lineMarker = new Shape();

			drawUI();

			addChild(_lineMarker);
			addChild(_labelBck);
			addChild(_label);

			_fade = new Fade(this);
			_fade.duration = 350;
			_fade.alphaFrom = 0;
			_fade.alphaTo = 1;

			addEventListener(FlexEvent.SHOW, showLabelEffect);
			addEventListener(FlexEvent.HIDE, hideLabelEffect);

			redraw();
		}

		/**
		 * @private
		 * @event
		 * fade transition to show label
		 * @param
		 * @return
		 */
		private function showLabelEffect(evt:FlexEvent):void {
			_fade.end();
			alpha = 0;
			_fade.play();
		}

		/**
		 * @private
		 * @event
		 * fade transition to hide label
		 * @param
		 * @return
		 */
		private function hideLabelEffect(evt:FlexEvent):void {

			_fade.end();
			alpha = 1;
			_fade.play(_fade.targets, true);
		}

		/**
		 * @private
		 * UI setup
		 * @return
		 */
		private function drawUI():void{

			_label.embedFonts = true;
			_label.selectable = false;
			_label.autoSize = TextFieldAutoSize.LEFT;

			var mtf:TextFormat = new TextFormat();
			mtf.bold = true;
			mtf.size = 8;
			mtf.font = "uni0563";

			_label.defaultTextFormat = mtf;
			_label.text = _label.text;

			var g:Graphics = _lineMarker.graphics;
			g.clear();
			g.beginFill(0x666600, .8);

			if(_inner){
				g.drawRect(0, 3, 2, 13);
				g.drawRect(2, 15, 3, 1);
			}
			else {
				g.drawRect(0, 3, 2, 22);
				g.drawRect(2, 24, 3, 1);
			}
			g.endFill();
		}

		/**
		 * @private
		 * redraw the component
		 * @return
		 */
		public function redraw():void {

			var g:Graphics = _labelBck.graphics;
			g.clear();
			g.beginFill(0xFFFFFF, .4);
			g.drawRect(0, 0, _label.textWidth + 4, 10);
			g.endFill();

			_lineMarker.scaleX = 1;
			_lineMarker.scaleY = -1;
			_lineMarker.y = _inner ? 22 : 22;

			_labelBck.y  = _inner ? 3 : -7;
			_labelBck.x  = 6;

			_label.x = 6;
			_label.y  = _inner ? -2 : -11;

			if(!_topFlag){
				_labelBck.y  = _inner ? 9 : 19;
				_label.y = _inner ? 4 : 14;
				_lineMarker.y = 0;
				_lineMarker.scaleY = 1;
			}

			if(!_leftFlag){
				_label.x = -8 -_label.textWidth;
				_labelBck.x  = _label.x;
				_lineMarker.scaleX = -1;
			}
		}
	}
}