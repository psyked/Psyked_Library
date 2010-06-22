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

	import com.gnstudio.nabiro.ui.chart.scheduleviewport.model.*;
	import com.gnstudio.nabiro.utilities.DateUtil;

	/**
	 * TimelineScale child item component
	 * not recommended to be instatiated directly
	 *
	 * <p><b>note:</b> some properties cause to redraw when set</p>
	 *
	 * @package nabiro
	 * @playerversion 9
	 * @productversion flex 3.2
	 */
	public class TimelineScale extends UIComponent {

		/**
		 * minimum distance between vertical lines in scale
		 * @value 12
		 */
		public static const MIN_STEPX:int = 12;

		/**
		 * @private
		 * array of ScaleLabel
		 */
		private var _labels:Array;

		/**
		 * @private
		 * time scale width
		 */
		private var _tlsWidth:Number;

		/**
		 * @private
		 * time scale height
		 */
		private var _tlsHeight:Number;

		/**
		 * @private
		 * time step to manage policy draw
		 * @default = DateUtil.STEPPING_DAY
		 */
		private var _timeStepping:String = DateUtil.STEPPING_DAY;

		/**
		 * @private
		 * time rotation mode in period behavior
		 * @default = DateUtil.STEPPING_WEEK
		 */
		private var _periodScaleMode:String = DateUtil.STEPPING_WEEK;

		/**
		 * @private
		 * padding between top-background limit and the drawing area
		 * @default 5
		 */
		private var _paddingTop:int = 5;

		/**
		 * @private
		 * padding between bottom-background limit and the drawing area
		 * @default 5
		 */
		private var _paddingBottom:int = 5;

		/**
		 * @private
		 * toggle draw labels for scale
		 * @default true
		 */
		private var _scaleLabel:Boolean = true;

		/**
		 * @private
		 * scale labels color
		 * @default 0x333333
		 */
		private var _scaleLabelColor:uint = 0x333333;

		/**
		 * @private
		 * color for the scale vertical lines
		 * @default 0XCCCCCC
		 */
		private var _verticalLineColor:uint = 0xCCCCCC;

		/**
		 * @private
		 * color for the scale vertical highlited lines
		 * @default 0XCC0000
		 */
		private var _verticalLineHighlightColor:uint = 0xCC0000;

		/**
		 * @private
		 * width for the scale vertical lines
		 * @default .1
		 */
		private var _verticalLineWidth:Number = .1;

		/**
		 * @private
		 * to ease reading, labels can be drawn skipping n times
		 * vs vertical line draw
		 * @default 1 - no skip
		 */
		private var _labelSkipping:uint = 1;

		/**
		 * @private
		 * draw policy
		 * @default false
		 */
		private var _behaviorType:String = BehaviorType.DATE;

		/**
		 * @private
		 * golive scale offset start in milliseconds
		 */
		private var _goliveOffsetStart:Number;

		/**
		 * @private
		 * golive scale offset end in milliseconds
		 */
		private var _goliveOffsetEnd:Number;

		/**
		 * @private
		 * window scale start date
		 * @default null
		 */
		private var _scaleStart:Date = null;

		/**
		 * @private
		 * window scale end date
		 * @default null
		 */
		private var _scaleEnd:Date = null;

		/**
		 * @private
		 * window scale generic amount
		 * @default 0
		 */
		private var _amount:Number = 0;

		/**
		 * scale width, usually it is the same as parent Component width
		 */
		public function set scaleWidth(value:int):void {
			_tlsWidth = value;
			redraw();
		}
		public function get scaleWidth():int {
			return _tlsWidth;
		}

		/**
		 * scale height, usually it is the same as parent Component height
		 */
		public function set scaleHeight(value:int):void {
			_tlsHeight = value;
			redraw();
		}
		public function get scaleHeight():int {
			return _tlsHeight;
		}

		/**
		 * value used to manage draw policy, when set causes redraw
		 */
		public function get timeStepping():String {
			return _timeStepping;
		}
		public function set timeStepping(value:String):void {
			_timeStepping = value;
			redraw();
		}

		/**
		 * padding between top-background limit and the drawing area
		 */
		public function get paddingTop():int {
			return _paddingTop;
		}
		public function set paddingTop(value:int):void {
			_paddingTop = value;
			redraw();
		}

		/**
		 * padding between bottom-background limit and the drawing area
		 */
		public function get paddingBottom():int {
			return _paddingBottom;
		}
		public function set paddingBottom(value:int):void {
			_paddingBottom = value;
			redraw();
		}

		/**
		 * scale vertical lines color
		 */
		public function get verticalLineColor():uint {
			return _verticalLineColor;
		}
		public function set verticalLineColor(value:uint):void {
			_verticalLineColor = value;
			redraw();
		}

		/**
		 * scale highilighted vertical lines color
		 */
		public function get verticalLineHighlightColor():uint {
			return _verticalLineHighlightColor;
		}
		public function set verticalLineHighlightColor(value:uint):void {
			_verticalLineHighlightColor = value;
			redraw();
		}

		/**
		 * scale vertical lines width
		 */
		public function get verticalLineWidth():Number {
			return _verticalLineWidth;
		}
		public function set verticalLineWidth(value:Number):void {
			_verticalLineWidth = value;
			redraw();
		}

		/**
		 * toggle scale labels draw
		 */
		public function get scaleLabel():Boolean {
			return _scaleLabel;
		}
		public function set scaleLabel(value:Boolean):void {
			_scaleLabel = value;
			redraw();
		}

		/**
		 * scale labels color
		 */
		public function get scaleLabelColor():uint {
			return _scaleLabelColor;
		}
		public function set scaleLabelColor(value:uint):void {
			_scaleLabelColor = value;
			redraw();
		}

		/**
		 * label to skip draw vs vertical line draw
		 */
		public function get labelSkipping():uint {
			return _labelSkipping;
		}
		public function set labelSkipping(value:uint):void {
			_labelSkipping = value;
			redraw();
		}

		/**
		 * draw policy
		 */
		public function set behaviorType(value:String):void {
			_behaviorType = value;
			redraw();
		}

		/**
		 * scale window from date
		 */
		public function set scaleStart(value:Date):void {
			_scaleStart = value;
			redraw();
		}

		/**
		 * scale window to date
		 */
		public function set scaleEnd(value:Date):void {
			_scaleEnd = value;
			redraw();
		}

		/**
		 * used in golive context to define start offset
		 * unit measure is milliseconds
		 */
		public function set goliveOffsetStart(value:Number):void {
			_goliveOffsetStart = value;
		}

		/**
		 * used in golive behavior to define end offset
		 * unit measure is milliseconds
		 */
		public function set goliveOffsetEnd(value:Number):void {
			_goliveOffsetEnd = value;
		}

		/**
		 * time "mode" in period behavior
		 */
		public function get periodScaleMode():String {
			return _periodScaleMode;
		}
		public function set periodScaleMode(value:String):void {

			_periodScaleMode = value;

			redraw();
		}

		/**
		 * used in amount behavior to define the scale amount
		 */
		public function set amount(value:Number):void {
			_amount = value;
			redrawScale_amount();
		}


		// ---------------------

		/**
		 * Constructor, it need the parent width and height to manage the draw policy
		 */
		public function TimelineScale(tlsWidth:Number, tlsHeight:Number) {
			super();
			_tlsWidth = tlsWidth;
			_tlsHeight = tlsHeight;

			_labels = new Array();
		}

		/**
		 * @private
		 * cleanup the scale
		 * @return
		 */
		private function clear_scale():void {
			var g:Graphics = graphics;
			g.clear();

			for each(var label:TimelineScaleLabel in _labels){
				removeChild(label);
			}

			_labels = new Array();
		}

		/**
		 * @private
		 * complete redraw of the scale, managing draw policy
		 * @return
		 */
		private function redraw():void{

			clear_scale();

			this["redrawScale_" +_behaviorType]();
		}


		/**
		 * @private
		 * redraw in period behavior
		 * @return
		 */
		private function redrawScale_period():void {

			var g:Graphics = graphics;
			var rowOffsetTop:uint = 10;
			var cx:Number;
			var i:int;

			var tlsl:TimelineScaleLabel;
			var textLabel:String = "";
			var textLabels:Array = new Array();

			var steps:uint = 12;
			var stepX:Number = (_tlsWidth - 40) / steps;

			for(i = 0; i <= steps; i++) { // DateUtil.STEPPING_YEAR
				textLabel = DateUtil.getLabelForMonth(i);
				textLabels.push(textLabel);
			}

			if(_periodScaleMode == DateUtil.STEPPING_WEEK){

				steps = 7;
				stepX = (_tlsWidth - 40) / steps;
				textLabels = new Array();

				for(i = 0; i <= steps; i++){
					textLabel = DateUtil.getLabelForDayWeek(i + 6);
					textLabels.push(textLabel);
				}
			}
			else if(_periodScaleMode == DateUtil.STEPPING_DAY){

				rowOffsetTop = 20;
				steps = 24;
				stepX = (_tlsWidth - 40) / steps;
				textLabels = new Array();

				for(i = 0; i <= steps; i++){
					var ampm:String = i < 12 ? "\nam" : "\npm";
					textLabel = "" +i +ampm;
					textLabels.push(textLabel);
				}
			}

			g.lineStyle(_verticalLineWidth, _verticalLineColor);

			var offsetTop:int = _paddingTop + (_scaleLabel ? rowOffsetTop : 0);
			var offsetBottom:int = _tlsHeight - paddingBottom;

			for(i = 0; i <= steps; i++){

				cx = 20 + Math.round(stepX * i);

				g.moveTo(cx, offsetTop);
				g.lineTo(cx, offsetBottom);

				tlsl = new TimelineScaleLabel(cx, textLabels[i], _scaleLabelColor);
				_labels.push(tlsl);
				addChild(tlsl);
			}

		}

		/**
		 * @private
		 * redraw in description behavior
		 * @return
		 */
		private function redrawScale_description():void {

			var offsetTop:int = _paddingTop;
			var offsetBottom:int = _tlsHeight - paddingBottom;

			var g:Graphics = graphics;

			g.lineStyle(_verticalLineWidth, _verticalLineColor);
			g.moveTo(20, offsetTop);
			g.lineTo(20, offsetBottom);

			g.moveTo(_tlsWidth - 20, offsetTop);
			g.lineTo(_tlsWidth - 20, offsetBottom);
		}

		/**
		 * @private
		 * redraw in amount behavior
		 * @return
		 */
		private function redrawScale_amount():void {

			var tlsl:TimelineScaleLabel;
			var scaleBase:Number = 1;
			var cx:int;
			var g:Graphics = graphics;

			var offsetTop:int = _paddingTop + (_scaleLabel ? 10 : 0);
			var offsetBottom:int = _tlsHeight - paddingBottom;

			for(var i:int = 0, k:int = 1; i < 9; i++, k *= 10){

				if(_amount < k){
					scaleBase = k;
					break;
				}
			}

			var step:int = scaleBase / 10;
			var stepX:Number = (_tlsWidth - 40) / 10;

			for(i = 0; i <= 10; i++){

				var label:String = "" +(i * step);
				cx = 20 + Math.round(stepX * i);

				g.lineStyle(_verticalLineWidth, _verticalLineColor);
				g.moveTo(cx, offsetTop);
				g.lineTo(cx, offsetBottom);

				if(!(i % _labelSkipping) && _scaleLabel) {
					tlsl = new TimelineScaleLabel(cx, label, _scaleLabelColor);
					_labels.push(tlsl);
					addChild(tlsl);
				}
			}
		}

		/**
		 * @private
		 * redraw the scale when behaviorType is golive
		 * @return
		 */
		private function redrawScale_golive():void {

			if(!_goliveOffsetStart && !_goliveOffsetEnd){
				visible = false;
				return;
			}

			_scaleStart = new Date(DateUtil.GO_LIVE_MSEC + _goliveOffsetStart);
			_scaleEnd = new Date(DateUtil.GO_LIVE_MSEC + _goliveOffsetEnd);

			var i:int = 0;
			var tlsl:TimelineScaleLabel;
			var cx:int;
			var currentDate:Date;
			var g:Graphics = graphics;

			var msec:uint = DateUtil.getTimeFromStepping(_timeStepping);
			var duration:Number = _scaleEnd.getTime() - _scaleStart.getTime();
			var lineThickness:Number = .1;
			var lineColor:uint = _verticalLineColor;
			var offsetTop:int = _paddingTop + (_scaleLabel ? 25 : 0);
			var offsetBottom:int = _tlsHeight - paddingBottom;

			var steps:int = Math.ceil(duration / msec);
			var stepX:Number = (_tlsWidth - 40) / steps;

			for(i = 0; i <= steps; i++){

				cx = 20 + Math.round(stepX * i);

				lineThickness = _verticalLineWidth;
				lineColor = _verticalLineColor;

				g.lineStyle(lineThickness, lineColor);
				g.moveTo(cx, offsetTop);
				g.lineTo(cx, offsetBottom);
			}

			var msecOffset:Number = 0;
			var pfx:String = "";

			if(_timeStepping == DateUtil.STEPPING_MONTH){
				msecOffset = DateUtil.MONTH_IN_MILLISECONDS;
				pfx = "M";
			}
			else if(_timeStepping == DateUtil.STEPPING_WEEK){
				msecOffset = DateUtil.WEEK_IN_MILLISECONDS;
				pfx = "w";
			}
			else if(_timeStepping == DateUtil.STEPPING_DAY){
				msecOffset = DateUtil.DAY_IN_MILLISECONDS;
				pfx = "d";
			}
			else if(_timeStepping == DateUtil.STEPPING_HOUR){
				msecOffset = DateUtil.HOUR_IN_MILLISECONDS;
				pfx = "h";
			}

			var goliveDate:Date = new Date(DateUtil.GO_LIVE_MSEC);
			var lrCount:int = -(Math.floor((DateUtil.GO_LIVE_MSEC - _scaleStart.getTime()) / msecOffset));
			var sign:String = "-";
			var forceSkip:Boolean = false;

			var goliveIndex:int = 0;
			var goliveX:Number = 0;

			for(i = 0; i <= steps; i++){

				currentDate = new Date(_scaleStart.getTime() + msecOffset * i);
				cx = 20 + Math.round(stepX * i);

				var textLabel:String = "";

				/*
				if(pfx == "d" || pfx == "h"){
					textLabel = DateUtil.getLabelForDay(currentDate);
				}
				else if(pfx == "M" || pfx == "w"){
					textLabel = DateUtil.getLabelForMonth(currentDate.getMonth());
				}
				*/

				textLabel += "\n" +sign +Math.abs(lrCount++) +_timeStepping.substring(0, 1);

				lineThickness = _verticalLineWidth;
				lineColor = _verticalLineColor;

				if(currentDate.getTime() >= DateUtil.GO_LIVE_MSEC && sign == "-"){

					goliveX = cx;
					sign = "+";
					lrCount = 1;
					continue;
				}

				g.lineStyle(lineThickness, lineColor);
				g.moveTo(cx, offsetTop);
				g.lineTo(cx, offsetBottom);

				if(_scaleLabel && !(i % _labelSkipping)) {
					tlsl = new TimelineScaleLabel(cx, textLabel, _scaleLabelColor);
					_labels.push(tlsl);
					addChild(tlsl);
				}
			}

			//var glDuration:Number = DateUtil.GO_LIVE_MSEC - _scaleStart.getTime();

			lineThickness = 2;
			lineColor = 0xFF6666;
			textLabel = "start\nGo-Live";

			g.lineStyle(lineThickness, lineColor);
			g.moveTo(goliveX, offsetTop);
			g.lineTo(goliveX, offsetBottom);

			if(_scaleLabel){
				tlsl = new TimelineScaleLabel(goliveX, textLabel, 0x006600, true);
				_labels.push(tlsl);
				addChild(tlsl);
			}

			visible = true;
		}

		/**
		 * @private
		 * redraw the scale when behaviorType is date
		 * @return
		 */
		private function redrawScale_date():void {

			if(!_scaleStart || !_scaleEnd) {
				visible = false;
				return;
			}

			var i:int = 0;
			var tlsl:TimelineScaleLabel;
			var cx:int;
			var currentDate:Date;
			var g:Graphics = graphics;

			var msec:uint = DateUtil.getTimeFromStepping(_timeStepping);
			var duration:Number = _scaleEnd.getTime() - _scaleStart.getTime();
			var lineThickness:Number = .1;
			var lineColor:uint = _verticalLineColor;
			var offsetTop:int = _paddingTop + (_scaleLabel ? 25 : 0);
			var offsetBottom:int = _tlsHeight - paddingBottom;

			var steps:int = Math.ceil(duration / msec);
			var stepX:Number = (_tlsWidth - 40) / steps;

			if(_timeStepping == DateUtil.STEPPING_MONTH){

				for(i = 0; i <= steps; i++){
					currentDate = new Date(_scaleStart.getTime() + DateUtil.MONTH_IN_MILLISECONDS * i);
					var monthIndex:uint = currentDate.getMonth();
					var monthLabel:String = DateUtil.getLabelForMonth(monthIndex);

					cx = 20 + Math.round(stepX * i);

					lineThickness = _verticalLineWidth;
					lineColor = _verticalLineColor;

					g.lineStyle(lineThickness, lineColor);
					g.moveTo(cx, offsetTop);
					g.lineTo(cx, offsetBottom);

					if(!(i % _labelSkipping) && _scaleLabel) {
						tlsl = new TimelineScaleLabel(cx, monthLabel, _scaleLabelColor);
						_labels.push(tlsl);
						addChild(tlsl);
					}
				}
			}
			else if(_timeStepping == DateUtil.STEPPING_WEEK){

				for(i = 0; i <= steps; i++){

					lineThickness = _verticalLineWidth;
					lineColor = _verticalLineColor;
					cx = 20 + Math.round(stepX * i);

					currentDate = new Date(_scaleStart.getTime() + DateUtil.WEEK_IN_MILLISECONDS * i);
					var weekLabel:String = DateUtil.getLabelForMonth(currentDate.getMonth());
					weekLabel += "\n" +currentDate.getDate();

					g.lineStyle(lineThickness, lineColor);
					g.moveTo(cx, offsetTop);
					g.lineTo(cx, offsetBottom);

					if(!(i % _labelSkipping) && _scaleLabel) {
						tlsl = new TimelineScaleLabel(cx, weekLabel, _scaleLabelColor);
						_labels.push(tlsl);
						addChild(tlsl);
					}
				}
			}
			else if(_timeStepping == DateUtil.STEPPING_DAY){

				for(i = 0; i <= steps; i++){

					lineThickness = _verticalLineWidth;
					lineColor = _verticalLineColor;
					cx = 20 + Math.round(stepX * i);

					currentDate = new Date(_scaleStart.getTime() + DateUtil.DAY_IN_MILLISECONDS * i);
					var weekDayLabel:String = DateUtil.getLabelForDay(currentDate);
					weekDayLabel += "\n" + currentDate.getDate();

					if(weekDayLabel.indexOf("Su") > -1) {
						lineThickness = 2;
						lineColor = _verticalLineHighlightColor;
					}

					g.lineStyle(lineThickness, lineColor);
					g.moveTo(cx, offsetTop);
					g.lineTo(cx, offsetBottom);

					if(!(i % _labelSkipping) && _scaleLabel) {
						tlsl = new TimelineScaleLabel(cx, weekDayLabel, _scaleLabelColor);
						_labels.push(tlsl);
						addChild(tlsl);
					}
				}
			}
			else if(_timeStepping == DateUtil.STEPPING_HOUR){

				for(i = 0; i <= steps; i++){

					lineThickness = _verticalLineWidth;
					lineColor = _verticalLineColor;
					cx = 20 + Math.round(stepX * i);

					currentDate = new Date(_scaleStart.getTime() + DateUtil.HOUR_IN_MILLISECONDS * i);
					var hourLabel:String = "" +currentDate.getHours();

					if(hourLabel == "12") {
						lineThickness = 2;
						lineColor = _verticalLineHighlightColor;
					}

					g.lineStyle(lineThickness, lineColor);
					g.moveTo(cx, offsetTop);
					g.lineTo(cx, offsetBottom);

					if(!(i % _labelSkipping) && _scaleLabel) {
						tlsl = new TimelineScaleLabel(cx, hourLabel, _scaleLabelColor);
						_labels.push(tlsl);
						addChild(tlsl);
					}
				}
			}

			visible = true;
		}
	}
}