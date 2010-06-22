package com.gnstudio.nabiro.ui.chart.scheduleviewport.presenter {

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

	import flash.display.Sprite;
	import flash.display.Graphics;

	import mx.core.UIComponent;

	import com.gnstudio.nabiro.utilities.DateUtil;
	import com.gnstudio.nabiro.ui.chart.scheduleviewport.model.BehaviorType;
	import com.gnstudio.nabiro.ui.chart.scheduleviewport.view.TimelineItem;
	import com.gnstudio.nabiro.ui.chart.scheduleviewport.view.TimelineScale;
	import com.gnstudio.nabiro.ui.chart.scheduleviewport.view.IViewportMono;

	/**
	 * ViewportMono class presenter provides to control the behaviour of
	 * ScheduleVieportMono component and its visual update
	 *
	 * @package nabiro
	 * @playerversion 9
	 * @productversion flex 3.2
	 */
	public class ViewportMono implements IViewportMono {

		/**
		 * @protected
		 * the view controlled UIComponent
		 */
		protected var _view:UIComponent;

		/**
		 * @protected
		 * the time scale viewport, used as a "time window" to where place the timeline
		 */
		protected var _timelineScale:TimelineScale;

		/**
		 * @private
		 * visual timeline component
		 */
		protected var _timelineItem:TimelineItem;

		/**
		 * @protected
		 * store the time stepping scale draw policy
		 */
		protected var _timeStepping:String;

		/**
		 * @protected
		 * background
		 */
		protected var _bck:Sprite;

		/**
		 * @protected
		 * background color
		 * @default 0xFFFFFF
		 */
		protected var _backgroundColor:uint = 0xFFFFFF;

		/**
		 * @protected
		 * background alpha
		 * @default 1 - opaque
		 */
		protected var _backgroundAlpha:Number = 1;

		/**
		 * @protected
		 * timeline color choosen by user or managed by component
		 * @default false
		 */
		protected var _timelineColorAuto:Boolean = false;

		/**
		 * @protected
		 * draw labels in golive behavior within o out of the bar
		 * @default true
		 */
		protected var _innerGoliveLabel:Boolean = true;

		/**
		 * @protected
		 * timeline bar color, timestepping minutes
		 * @default DateUtil.COLOR_MINUTE;
		 */
		protected var _minuteColor:uint = DateUtil.COLOR_MINUTE;

		/**
		 * @protected
		 * timeline bar color, timestepping hours
		 * @default DateUtil.COLOR_HOUR;
		 */
		protected var _hourColor:uint = DateUtil.COLOR_HOUR;

		/**
		 * @protected
		 * timeline bar color, timestepping days
		 * @default DateUtil.COLOR_DAY;
		 */
		protected var _dayColor:uint = DateUtil.COLOR_DAY;

		/**
		 * @protected
		 * timeline bar color, timestepping weeks
		 * @default DateUtil.COLOR_WEEK;
		 */
		protected var _weekColor:uint = DateUtil.COLOR_WEEK;

		/**
		 * @protected
		 * timeline bar color, timestepping months
		 * @default DateUtil.COLOR_MONTH;
		 */
		protected var _monthColor:uint = DateUtil.COLOR_MONTH;

		/**
		 * @protected
		 * timeline bar color, amount behavior
		 * @default BehaviorType.COLOR_AMOUNT;
		 */
		protected var _amountColor:uint = BehaviorType.COLOR_AMOUNT;

		/**
		 * @protected
		 * timeline bar color, description behavior
		 * @default BehaviorType.COLOR_DESCRIPTION
		 */
		protected var _descriptionColor:uint = BehaviorType.COLOR_DESCRIPTION;

		/**
		 * @protected
		 * Y timeline spacing from the top limit of the component background
		 * @default 35
		 */
		protected var _topSpacing:int = 35;

		/**
		 * @protected
		 * time scale snap
		 * @default false
		 */
		protected var _timeScaleSnap:Boolean = false;

		/**
		 * @protected
		 * redraw the scale to fit each timeline
		 * @default false
		 */
		protected var _scaleAuto:Boolean = false;

		/**
		 * @protected
		 * draw policy
		 * @default "date"
		 */
		protected var _behaviorType:String = BehaviorType.DATE;

		/**
		 * @protected
		 * used in golive context to define scale start offset
		 * unit measure is milliseconds
		 * <br />note: to ensure golive is always into the scale, this value must be >= 0
		 */
		protected var _goliveScaleOffsetStart:Number;

		/**
		 * @protected
		 * used in golive context to define scale end offset
		 * unit measure is milliseconds
		 * <br />note: to ensure golive is always into the scale, this value must be >= 0
		 */
		protected var _goliveScaleOffsetEnd:Number;

		/**
		 * @protected
		 * used in golive context to define time start offset
		 * unit measure is milliseconds
		 */
		protected var _goliveTimeOffsetStart:Number;

		/**
		 * @protected
		 * used in golive context to define Time end offset
		 * unit measure is milliseconds
		 */
		protected var _goliveTimeOffsetEnd:Number;

		/**
		 * @protected
		 * scale time from date
		 * @default null
		 */
		protected var _scaleStart:Date = null;

		/**
		 * @protected
		 * scale time to date
		 * @default null
		 */
		protected var _scaleEnd:Date = null;

		/**
		 * @protected
		 * timeline from date
		 * @default null
		 */
		protected var _timeStart:Date = null;

		/**
		 * @protected
		 * timeline to date
		 * @default null
		 */
		protected var _timeEnd:Date = null;

		/**
		 * component background color
		 */
		public function get backgroundColor():uint {
			return _backgroundColor;
		}
		public function set backgroundColor(value:uint):void {
			trace("viewportmono, setting bgcolor:", value.toString(16), _view.name);
			_backgroundColor = value;
			redrawBackground();
		}

		/**
		 * component background alpha
		 */
		public function get backgroundAlpha():Number {
			return _backgroundAlpha;
		}
		public function set backgroundAlpha(value:Number):void {
			_backgroundAlpha = value;
			redrawBackground();
		}

		/**
		 * background offset y, for amount/description behavior
		 */
		public function get backgroundOffsetY():uint{
			return _timelineItem.backgroundOffsetY;
		}
		public function set backgroundOffsetY(value:uint):void {
			_timelineItem.backgroundOffsetY = value;
		}

		/**
		 * background height, for amount/description behavior
		 */
		public function get backgroundHeight():int{
			return _timelineItem.backgroundHeight;
		}
		public function set backgroundHeight(value:int):void {
			_timelineItem.backgroundHeight = value;
		}

		/**
		 * timeline color
		 */
		public function get timelineColor():uint {
			return _timelineItem.timelineColor;
		}
		public function set timelineColor(value:uint):void {
			_timelineItem.timelineColor = value;
		}

		/**
		 * timeline color choosen by user or managed by component
		 */
		public function get timelineColorAuto():Boolean {
			return _timelineColorAuto;
		}
		public function set timelineColorAuto(value:Boolean):void {
			_timelineColorAuto = value;
			_timelineItem.colorAuto = value;
		}

		/**
		 * draw labels in golive behavior within o out of the bar
		 */
		public function get innerGoliveLabel():Boolean {
			return _innerGoliveLabel;
		}
		public function set innerGoliveLabel(value:Boolean):void {
			_innerGoliveLabel = value;
			_timelineItem.innerGoliveLabel = value;
		}

		/**
		 * timeline bar color, timestepping minutes
		 */
		public function get minuteColor():uint {
			return _minuteColor;
		}
		public function set minuteColor(value:uint):void {
			_minuteColor = value;
			_timelineItem.minuteColor = value;
		}

		/**
		 * timeline bar color, timestepping hours
		 */
		public function get hourColor():uint {
			return _hourColor;
		}
		public function set hourColor(value:uint):void {
			_hourColor = value;
			_timelineItem.hourColor = value;
		}

		/**
		 * timeline bar color, timestepping days
		 */
		public function get dayColor():uint {
			return _dayColor;
		}
		public function set dayColor(value:uint):void {
			_dayColor = value;
			_timelineItem.dayColor = value;
		}

		/**
		 * timeline bar color, timestepping weeks
		 */
		public function get weekColor():uint {
			return _weekColor;
		}
		public function set weekColor(value:uint):void {
			_weekColor = value;
			_timelineItem.weekColor = value;
		}

		/**
		 * timeline bar color, timestepping months
		 */
		public function get monthColor():uint {
			return _monthColor;
		}
		public function set monthColor(value:uint):void {
			_monthColor = value;
			_timelineItem.monthColor = value;
		}

		/**
		 * timeline bar color, amount behavior
		 */
		public function get amountColor():uint {
			return _amountColor;
		}
		public function set amountColor(value:uint):void {
			_amountColor = value;
			_timelineItem.amountColor = value
		}

		/**
		 * timeline bar color, description behavior
		 */
		public function get descriptionColor():uint {
			return _descriptionColor;
		}
		public function set descriptionColor(value:uint):void {
			_descriptionColor = value;
			_timelineItem.descriptionColor = value
		}

		/**
		 * padding between top-background limit and the drawing area
		 */
		public function get paddingTop():int {
			return _timelineScale.paddingTop;
		}
		public function set paddingTop(value:int):void {
			_timelineScale.paddingTop = value;
		}

		/**
		 * padding between bottom-background limit and the drawing area
		 */
		public function get paddingBottom():int {
			return _timelineScale.paddingBottom;
		}
		public function set paddingBottom(value:int):void {
			_timelineScale.paddingBottom = value;
		}

		/**
		 * y space between the timeline and the top limit of the component background
		 */
		public function get topSpacing():int {
			return _topSpacing;
		}
		public function set topSpacing(value:int):void {
			_topSpacing = value;
			_timelineItem.y = value;
		}

		/**
		 * scale vertical lines color
		 */
		public function get verticalLineColor():uint {
			return _timelineScale.verticalLineColor;
		}
		public function set verticalLineColor(value:uint):void {
			_timelineScale.verticalLineColor = value;
		}

		/**
		 * scale highilighted vertical lines color
		 */
		public function get verticalLineHighlightColor():uint {
			return _timelineScale.verticalLineHighlightColor;
		}
		public function set verticalLineHighlightColor(value:uint):void {
			_timelineScale.verticalLineHighlightColor = value;
		}

		/**
		 * scale vertical lines width
		 */
		public function get verticalLineWidth():Number {
			return _timelineScale.verticalLineWidth;
		}
		public function set verticalLineWidth(value:Number):void {
			_timelineScale.verticalLineWidth = value;
		}

		/**
		 * toggle scale labels draw
		 */
		public function get scaleLabel():Boolean {
			return _timelineScale.scaleLabel;
		}
		public function set scaleLabel(value:Boolean):void {
			_timelineScale.scaleLabel = value;
		}

		/**
		 * scale labels color
		 */
		public function get scaleLabelColor():uint {
			return _timelineScale.scaleLabelColor;
		}
		public function set scaleLabelColor(value:uint):void {
			_timelineScale.scaleLabelColor = value;
		}

		/**
		 * label to skip draw vs vertical line draw
		 */
		public function get labelSkipping():uint {
			return _timelineScale.labelSkipping;
		}
		public function set labelSkipping(value:uint):void {
			value = Math.max(1, value);
			_timelineScale.labelSkipping = value;
		}

		/**
		 * mouse hovering
		 */
		public function get hover():Boolean {
			return _timelineItem.hover;
		}
		public function set hover(value:Boolean):void {
			_timelineItem.hover = value;
		}

		/**
		 * time scale snap
		 */
		public function get timeScaleSnap():Boolean {
			return _timeScaleSnap;
		}
		public function set timeScaleSnap(value:Boolean):void {
			_timeScaleSnap = value;
			update_timeStepping();
		}

		/**
		 * fit scale to draw whole timeline
		 */
		public function get scaleAuto():Boolean {
			return _scaleAuto;
		}
		public function set scaleAuto(value:Boolean):void {
			_scaleAuto = value;
			update_timeStepping();
		}

		/**
		 * set golive draw policy
		 */
		public function get behaviorType():String {
			return _behaviorType;
		}
		public function set behaviorType(value:String):void {
			_behaviorType = value;
			_timelineScale.behaviorType = value;
			_timelineItem.behaviorType = value;
		}

		/**
		 * scale window from date
		 */
		public function get scaleStart():Date {

			if(_behaviorType == BehaviorType.GO_LIVE) return null;

			return _scaleStart;
		}
		public function set scaleStart(value:Date):void {

			if(_behaviorType == BehaviorType.GO_LIVE) return;

			_scaleStart = value;
			_timelineScale.scaleStart = value;
			createTimeline();
			_timelineItem.scaleStart = value;
			update_timeStepping();
		}

		/**
		 * scale window to date
		 */
		public function get scaleEnd():Date {

			if(_behaviorType == BehaviorType.GO_LIVE) return null;

			return _scaleEnd;
		}
		public function set scaleEnd(value:Date):void {

			if(_behaviorType == BehaviorType.GO_LIVE) return;

			_scaleEnd = value;
			_timelineScale.scaleEnd = value;
			createTimeline();
			_timelineItem.scaleEnd = value;
			update_timeStepping();
		}

		/**
		 * timeline from date
		 */
		public function get timeStart():Date {

			if(_behaviorType == BehaviorType.GO_LIVE) return null;

			return _timeStart;
		}
		public function set timeStart(value:Date):void {

			if(_behaviorType == BehaviorType.GO_LIVE) return;

			_timeStart = value;

			if(_timelineItem)
				_timelineItem.timeStart = value;

			update_timeStepping();
		}

		/**
		 * timeline to date
		 */
		public function get timeEnd():Date {

			if(_behaviorType == BehaviorType.GO_LIVE) return null;

			return _timeEnd;
		}
		public function set timeEnd(value:Date):void {

			if(_behaviorType == BehaviorType.GO_LIVE) return;

			_timeEnd = value;

			if(_timelineItem)
				_timelineItem.timeEnd = value;

			update_timeStepping();
		}

		/**
		 * time "mode" in period behavior
		 */
		public function get periodScaleMode():String {
			return _timelineScale.periodScaleMode;
		}
		public function set periodScaleMode(value:String):void {
			_timelineItem.periodScaleMode = _timelineItem.periodMode = value;
			_timelineScale.periodScaleMode = value;

			update_timeStepping();
		}

		/**
		 * start index in period behavior
		 */
		public function get periodIndex():uint {
			return _timelineItem.periodIndex;
		}
		public function set periodIndex(value:uint):void {
			_timelineItem.periodIndex = value;
		}

		/**
		 * units of time duration in period behavior
		 */
		public function get periodDuration():uint {
			return _timelineItem.periodDuration;
		}
		public function set periodDuration(value:uint):void {
			_timelineItem.periodDuration = value;
		}

		/**
		 * amount
		 */
		public function get amount():int {
			return _timelineItem.amount;
		}
		public function set amount(value:int):void {
			_timelineItem.amount = value;
			_timelineScale.amount = value;
		}

		/**
		 * description
		 */
		public function get description():String {
			return _timelineItem.description;
		}
		public function set description(value:String):void {
			_timelineItem.description = value;
		}

		/**
		 * used in golive context to define start offset
		 * unit measure is milliseconds
		 */
		public function get goliveScaleOffsetStart():Number {
			return _goliveScaleOffsetStart / 6000; // converts back to minutes
		}
		public function set goliveScaleOffsetStart(value:Number):void {

			value *= 60000; // granularity is minutes, so convert to milliseconds

			_goliveScaleOffsetStart = value;
			_timelineScale.goliveOffsetStart = value;
			_timelineItem.scaleStart = new Date( DateUtil.GO_LIVE_MSEC + value);

			update_timeStepping();
		}

		/**
		 * used in golive context to define end offset
		 * unit measure is milliseconds
		 */
		public function get goliveScaleOffsetEnd():Number {
			return _goliveScaleOffsetEnd / 60000; // converts back to minutes
		}
		public function set goliveScaleOffsetEnd(value:Number):void {

			value *= 60000; // granularity is minutes, so convert to milliseconds

			_goliveScaleOffsetEnd = value;
			_timelineScale.goliveOffsetEnd = value;
			_timelineItem.scaleEnd = new Date( DateUtil.GO_LIVE_MSEC + value);

			update_timeStepping();
		}

		/**
		 * used in golive context to define start offset
		 * unit measure is milliseconds
		 */
		public function get goliveTimeOffsetStart():Number {
			return _goliveTimeOffsetStart / 60000; // converts back to minutes
		}
		public function set goliveTimeOffsetStart(value:Number):void {

			value *= 60000; // granularity is minutes, so convert to milliseconds

			_goliveTimeOffsetStart = value;
			_timelineItem.timeStart = new Date( DateUtil.GO_LIVE_MSEC + value);

			update_timeStepping();
		}

		/**
		 * used in golive context to define end offset
		 * unit measure is milliseconds
		 */
		public function get goliveTimeOffsetEnd():Number {
			return _goliveTimeOffsetEnd / 6000; // converts back to minutes
		}
		public function set goliveTimeOffsetEnd(value:Number):void {

			value *= 60000; // granularity is minutes, so convert to milliseconds

			_goliveTimeOffsetEnd = value;
			_timelineItem.timeEnd = new Date( DateUtil.GO_LIVE_MSEC + value);

			update_timeStepping();
		}

		// ----------------------------

		/**
		 * Constructor
		 * @param the view component to control
		 * @param timeline item creation flag, used when invoked from inherited classes
		 */
		function ViewportMono(view:UIComponent, createTimelineFlag:Boolean = true) {

			_view = view;
			_bck = new Sprite();
			_timelineScale = new TimelineScale(view.width, view.height);

			_timelineScale.scaleStart = _scaleStart;
			_timelineScale.scaleEnd = _scaleEnd;

			_view.addChild(_bck)
			_view.addChild(_timelineScale);

			if(createTimelineFlag) createTimeline();
		}

		/**
		 * @private
		 * create the timeline item child if not already created
		 * @return
		 */
		private function createTimeline():void {

			if(_timelineItem) return;

			_timelineItem = new TimelineItem(_view.width, _view.height, _scaleStart, _scaleEnd, _timeStart, _timeEnd);
			_timelineItem.y = _topSpacing;

			update_timeStepping();
			_view.addChild(_timelineItem);
		}

		/**
		 * @protected
		 * complete component redraw
		 * @return
		 */
		private function update_timeStepping():void {

			_timelineScale.scaleWidth = _view.width;
			_timelineScale.scaleHeight = _view.height;
			_timelineScale.behaviorType = _behaviorType;

			if(_timelineItem) {
				_timelineItem.timeStepping = _timeStepping;
				_timelineItem.scaleWidth = _view.width;
			}

			if(_behaviorType == BehaviorType.AMOUNT){

				_timelineItem.behaviorType = _behaviorType;

				redrawBackground();

				return;
			}

			if(_behaviorType == BehaviorType.GO_LIVE){

				_scaleStart = new Date(DateUtil.GO_LIVE_MSEC + _goliveScaleOffsetStart);
				_scaleEnd = new Date(DateUtil.GO_LIVE_MSEC + _goliveScaleOffsetEnd);
				var goliveTimeStart:Date = new Date(DateUtil.GO_LIVE_MSEC + _goliveTimeOffsetStart);
				var goliveTimeEnd:Date = new Date(DateUtil.GO_LIVE_MSEC + _goliveTimeOffsetEnd);

				_timelineScale.scaleStart = _scaleStart;
				_timelineScale.scaleEnd = _scaleEnd;

				_timelineItem.scaleStart = _scaleStart;
				_timelineItem.scaleEnd = _scaleEnd;

				_timelineItem.goliveTimeStart = goliveTimeStart;
				_timelineItem.goliveTimeEnd = goliveTimeEnd;
			}

			if(_behaviorType == BehaviorType.PERIOD){

				return;
			}

			if(!_scaleStart || !_scaleEnd) return;

			_timeStepping = DateUtil.STEPPING_MONTH;
			var scaleDuration:Number = _scaleEnd.getTime() - _scaleStart.getTime();
			var steps:Number = scaleDuration / DateUtil.WEEK_IN_MILLISECONDS;
			var stepX:Number = (_view.width - 40) / steps;

			if(stepX >= TimelineScale.MIN_STEPX) {
				_timeStepping = DateUtil.STEPPING_WEEK;
			}

			steps = Math.ceil(scaleDuration / DateUtil.DAY_IN_MILLISECONDS);
			stepX = (_view.width - 40) / steps;

			if(stepX >= TimelineScale.MIN_STEPX) {
				_timeStepping = DateUtil.STEPPING_DAY;
			}

			steps = Math.ceil(scaleDuration / DateUtil.HOUR_IN_MILLISECONDS);
			stepX = (_view.width - 40) / steps;

			if(stepX >= TimelineScale.MIN_STEPX) {
				_timeStepping = DateUtil.STEPPING_HOUR;
			}

			_timelineScale.timeStepping = _timeStepping;

			redrawBackground();
		}

		/**
		 * @private
		 * redraw the background
		 * @return
		 */
		private function redrawBackground():void {

			var g:Graphics = _bck.graphics;
			g.clear();
			g.beginFill(_backgroundColor, _backgroundAlpha);
			g.drawRect(0, 0, _view.width, _view.height);
			g.endFill();
		}

		/**
		 * [alias method] force to redraw the component
		 * this is an optional method, not needed in conventional implementation
		 * @return
		 */
		public function redraw():void {
			update_timeStepping();
		}
	}
}