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
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.effects.Fade;

	import com.gnstudio.nabiro.utilities.DateUtil;

	/**
	 * label start/end date to be drawn in TimelineItem child component
	 * not recommended to be instatiated directly
	 *
	 * @package nabiro
	 * @playerversion 9
	 * @productversion flex 3.2
	 */
	public class DateLabel extends UIComponent {

		/**
		 * @private
		 * fading component
		 */
		private var _fade:Fade;

		/**
		 * @private
		 * background color
		 */
		private var _backgroundColor:uint;

		/**
		 * @private
		 * texField to show the timeline start/end label
		 */
		private var _label:TextField;


		/**
		 * text to show in label
		 */
		public function get text():String {
			return _label.text;
		}
		public function set text(value:String):void {
			_label.text = value;
			redrawBackground(_backgroundColor);
		}

		/**
		 * whole label width, used to get draw policy
		 */
		public function get dateLabelWidth():uint {
			return _label.textWidth + 10;
		}

		/**
		 * Constructor
		 */
		public function DateLabel()
		{
			super();

			_label = new TextField();
			_label.embedFonts = true;
			_label.selectable = false;
			_label.autoSize = TextFieldAutoSize.LEFT;
			_backgroundColor = 0xFFFFFF;

			var mtf:TextFormat = new TextFormat();
			mtf.bold = true;
			mtf.size = 8;
			mtf.font = "uni0563";

			_label.defaultTextFormat = mtf;
			_label.x = 4;
			_label.y = -2;

			addChild(_label);

			_fade = new Fade(this);
			_fade.duration = 350;
			_fade.alphaFrom = 0;
			_fade.alphaTo = 1;

			addEventListener(FlexEvent.SHOW, showLabelEffect);
			addEventListener(FlexEvent.HIDE, hideLabelEffect);
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
		 * causes the background to redraw with given color
		 * @return
		 */
		public function redrawBackground(backgroundColor:uint = 0xFFFFFF):void {
			_backgroundColor = backgroundColor;
			var g:Graphics = graphics;
			g.clear();
			g.beginFill(backgroundColor, .4);
			g.drawRoundRect(0, 0, dateLabelWidth, 14, 14, 14);
			g.endFill();
		}

	}
}