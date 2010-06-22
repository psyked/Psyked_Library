
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
	import com.gnstudio.nabiro.ui.chart.scheduleviewport.view.IViewportPoly;

	/**
	 * ViewportPoly class presenter provides to control the behaviour of
	 * ScheduleVieportPoly component and its visual update
	 *
	 * @package nabiro
	 * @playerversion 9
	 * @productversion flex 3.2
	 */
	public class ViewportPoly extends ViewportMono implements IViewportPoly {

		/**
		 * @private
		 * timeline initialization status
		 * @default false
		 */
		private var _timelineInitialized:Boolean = false;

		/**
		 * @private
		 * array of timelineItem
		 */
		private var _timelines:Array;

		/**
		 * @private
		 * current timelineItem index
		 * @default 0
		 */
		private var _selectedIndex:uint = 0;

		/**
		 * @private
		 * auto adjust height fo n timelines
		 * @default 0
		 */
		private var _heightAuto:Boolean = false;

		/**
		 * @private
		 * y distance between timelines
		 */
		private var _verticalSpacing:int = 34;

		/**
		 * @private
		 * array of timelineItem
		 * @default 5
		 */
		private var _timelineBackgroundOffsetY:int = 5;

		/**
		 * @private
		 * array of timelineItem
		 * @default 28
		 */
		private var _timelineBackgroundHeight:int = 28;

		/**
		 * @private
		 * timeline background color, amount behavior
		 * @default BehaviorType.COLOR_BACKGROUND_AMOUNT
		 */
		private var _amountBackgroundColor:uint = BehaviorType.COLOR_BACKGROUND_AMOUNT;

		/**
		 * @private
		 * timeline background color, description behavior
		 * @default BehaviorType.COLOR_BACKGROUND_DESCRIPTION
		 */
		private var _descriptionBackgroundColor:uint = BehaviorType.COLOR_BACKGROUND_DESCRIPTION;


		// -----------------
		// getters / setters
		// -----------------

		/**
		 * background offset y, for amount/description behavior
		 */
		public override function get backgroundOffsetY():uint{
			return _timelines[_selectedIndex].backgroundOffsetY;
		}
		public override function set backgroundOffsetY(value:uint):void {
			_timelines[_selectedIndex].backgroundOffsetY = value;
		}

		/**
		 * background height, for amount/description behavior
		 */
		public override function get backgroundHeight():int{
			return _timelines[_selectedIndex].backgroundHeight;
		}
		public override function set backgroundHeight(value:int):void {
			_timelines[_selectedIndex].backgroundHeight = value;
		}

		/**
		 * y space between the timeline and the top limit of the component background
		 */
		public override function set topSpacing(value:int):void {
			_topSpacing = value;
			update_timelinePositions();
		}

		/**
		 * y space between selected timeline and the preceeding
		 */
		public function get verticalSpacing():int {
			return _timelines[_selectedIndex].verticalSpacing;
		}
		public function set verticalSpacing(value:int):void {
			_verticalSpacing = value;

			if(_selectedIndex > 0){
				_timelines[_selectedIndex].verticalSpacing = value;
				update_timelinePositions();
			}
		}

		/**
		 * timeline background offset y, for amount/description behavior
		 */
		public function get timelineBackgroundOffsetY():uint {
			return _timelines[_selectedIndex].backgroundOffsetY;
		}
		public function set timelineBackgroundOffsetY(value:uint):void {
			_timelineBackgroundOffsetY = value;
			_timelines[_selectedIndex].backgroundOffsetY = value;
		}

		/**
		 * timeline background height, for amount/description behavior
		 */
		public function get timelineBackgroundHeight():int {
			return _timelines[_selectedIndex].backgroundHeight;
		}
		public function set timelineBackgroundHeight(value:int):void {
			_timelineBackgroundHeight = value;
			_timelines[_selectedIndex].backgroundHeight = value;
		}

		/**
		 * background color, amount behavior
		 */
		public function get amountBackgroundColor():uint {
			return _amountBackgroundColor;
		}
		public function set amountBackgroundColor(value:uint):void {

			_amountBackgroundColor = value;

			for each(var tlItem:TimelineItem in _timelines){
				tlItem.amountBackgroundColor = value;
			}
		}

		/**
		 * background color, description behavior
		 */
		public function get descriptionBackgroundColor():uint {
			return _descriptionBackgroundColor;
		}
		public function set descriptionBackgroundColor(value:uint):void {

			_descriptionBackgroundColor = value;

			for each(var tlItem:TimelineItem in _timelines){
				tlItem.descriptionBackgroundColor = value;
			}
		}

		/**
		 * timeline color
		 */
		public override function get timelineColor():uint {
			return _timelines[_selectedIndex].timelineColor;
		}
		public override function set timelineColor(value:uint):void {
			_timelines[_selectedIndex].timelineColor = value;
		}

		/**
		 * hide show selectedIndex timeline
		 */
		public function get timelineVisible():Boolean {
			return _timelines[_selectedIndex].timelineVisible;
		}
		public function set timelineVisible(value:Boolean):void {
			_timelines[_selectedIndex].timelineVisible = value;
		}

		/**
		 * timeline color choosen by user or managed by component
		 */
		public override function get timelineColorAuto():Boolean {
			return _timelineColorAuto;
		}
		public override function set timelineColorAuto(value:Boolean):void {

			_timelineColorAuto = value;

			for each(var tlItem:TimelineItem in _timelines){
				tlItem.colorAuto = value;
			}
		}

		/**
		 * draw labels in golive behavior within o out of the bar
		 */
		public override function set innerGoliveLabel(value:Boolean):void {

			_innerGoliveLabel = value;

			for each(var tlItem:TimelineItem in _timelines){
				tlItem.innerGoliveLabel = value;
			}
		}

		/**
		 * timeline bar color, timestepping minutes
		 */
		public override function set minuteColor(value:uint):void {

			_minuteColor = value;

			for each(var tlItem:TimelineItem in _timelines){
				tlItem.minuteColor = value;
			}
		}

		/**
		 * timeline bar color, timestepping hours
		 */
		public override function set hourColor(value:uint):void {
			_hourColor = value;

			for each(var tlItem:TimelineItem in _timelines){
				tlItem.hourColor = value;
			}
		}

		/**
		 * timeline bar color, timestepping days
		 */
		public override function set dayColor(value:uint):void {
			_dayColor = value;

			for each(var tlItem:TimelineItem in _timelines){
				tlItem.dayColor = value;
			}
		}

		/**
		 * timeline bar color, timestepping weeks
		 */
		public override function set weekColor(value:uint):void {
			_weekColor = value;

			for each(var tlItem:TimelineItem in _timelines){
				tlItem.weekColor = value;
			}
		}

		/**
		 * timeline bar color, timestepping months
		 */
		public override function set monthColor(value:uint):void {
			_monthColor = value;

			for each(var tlItem:TimelineItem in _timelines){
				tlItem.monthColor = value;
			}
		}

		/**
		 * timeline bar color, amount behavior
		 */
		public override function set amountColor(value:uint):void {

			_amountColor = value;

			for each(var tlItem:TimelineItem in _timelines){
				tlItem.amountColor = value;
			}
		}

		/**
		 * timeline bar color, description behavior
		 */
		public override function set descriptionColor(value:uint):void {
			_descriptionColor = value;

			for each(var tlItem:TimelineItem in _timelines){
				tlItem.descriptionColor = value;
			}
		}

		/**
		 * current timelineItem index
		 */
		public function get selectedIndex():uint {
			return _selectedIndex;
		}
		public function set selectedIndex(value:uint):void {
			_selectedIndex = Math.min(_timelines.length, value);
		}

		/**
		 * name of the selected timelineItem
		 */
		public function get timelineID():String {
			return _timelines[selectedIndex].name;
		}

		/**
		 * count of timelineItem, component provide alway at least 1 timelineItem
		 */
		public function get numTimelines():uint {
			return _timelines.length;
		}

		/**
		 * mouse hovering
		 */
		public override function get hover():Boolean {
			return _timelines[_selectedIndex].hover;
		}
		public override function set hover(value:Boolean):void {
			_timelines[_selectedIndex].hover = value;
		}

		/**
		 * time scale snap
		 */
		public override function set timeScaleSnap(value:Boolean):void {

			_timeScaleSnap = value;

			if(value) update_timeStepping();
		}


		/**
		 * force the scale to be redrawn to fit each timelines, useful in golive behavior
		 */
		public override function set scaleAuto(value:Boolean):void {

			_scaleAuto = value;

			if(value) update_timeStepping();
		}

		/**
		 * auto adjust height fo n timelines
		 */
		public function get heightAuto():Boolean{
			return _heightAuto;
		}
		public function set heightAuto(value:Boolean):void {
			_heightAuto = value;
			update_timelinePositions();
		}

		/**
		 * behavior draw policy
		 */
		public override function get behaviorType():String {
			return _behaviorType;
		}
		public override function set behaviorType(value:String):void {

			if(value == BehaviorType.DATE || value == BehaviorType.GO_LIVE || BehaviorType.PERIOD) {

				_behaviorType = value;
				_timelineScale.visible = true;
				_timelineScale.behaviorType = value;

				for each(var tlItem:TimelineItem in _timelines){
					if(tlItem.behaviorType != BehaviorType.AMOUNT && tlItem.behaviorType != BehaviorType.DESCRIPTION) {
						tlItem.behaviorType = value;
					}
				}
			}
			else {
				_timelines[_selectedIndex].behaviorType = value;
				//_timelineScale.visible = false;
			}

			update_timeStepping();
		}

		/**
		 * behavior draw policy, applies to selected timeline
		 */
		public function get timelineBehaviorType():String {
			return _timelines[_selectedIndex].behaviorType;
		}
		public function set timelineBehaviorType(value:String):void {
			_timelines[_selectedIndex].behaviorType = value;
			update_timeStepping();
		}

		/**
		 * scale window from date
		 */
		public override function get scaleStart():Date {
			return _scaleStart;
		}
		public override function set scaleStart(value:Date):void {

			_scaleStart = value;
			_timelineScale.scaleStart = value;

			for each(var tlItem:TimelineItem in _timelines){
				tlItem.scaleStart = value;
			}
			update_timeStepping();
		}

		/**
		 * scale window to date
		 */
		public override function get scaleEnd():Date {
			return _timelines[_selectedIndex].scaleEnd;
		}
		public override function set scaleEnd(value:Date):void {
			_scaleEnd = value;
			_timelineScale.scaleEnd = value;

			for each(var tlItem:TimelineItem in _timelines){
				tlItem.scaleEnd = value;
			}

			update_timeStepping();
		}

		/**
		 * selected timelineItem from date
		 */
		public override function get timeStart():Date {
			return _timelines[_selectedIndex].timeStart;
		}
		public override function set timeStart(value:Date):void {
			_timeStart = value;
			_timelines[_selectedIndex].timeStart = value;
			update_timeStepping();
		}

		/**
		 * selected timelineItem to date
		 */
		public override function get timeEnd():Date {
			return _timelines[_selectedIndex].timeEnd;
		}
		public override function set timeEnd(value:Date):void {
			_timeEnd = value;
			_timelines[_selectedIndex].timeEnd = value;
			update_timeStepping();
		}

		/**
		 * time rotation "mode" in period behavior
		 */
		[Bindable]
		public override function get periodScaleMode():String {
			return _timelineScale.periodScaleMode;
		}
		public override function set periodScaleMode(value:String):void {

			if(_timelineScale.periodScaleMode == value) return;

			_timelineScale.periodScaleMode = value;
			update_timeStepping();
		}

		/**
		 * time "mode" in period behavior
		 */
		public function get periodMode():String {
			return _timelines[_selectedIndex].periodMode;
		}
		public function set periodMode(value:String):void {

			_timelines[_selectedIndex].periodMode = value;

			update_timeStepping();
		}

		/**
		 * start index in period behavior
		 */
		public override function get periodIndex():uint {
			return _timelines[_selectedIndex].periodIndex;
		}
		public override function set periodIndex(value:uint):void {
			_timelines[_selectedIndex].periodIndex = value;
		}

		/**
		 * units of time duration in period behavior
		 */
		public override function get periodDuration():uint {
			return _timelines[_selectedIndex].periodDuration;
		}
		public override function set periodDuration(value:uint):void {
			_timelines[_selectedIndex].periodDuration = value;
		}

		/**
		 * amount
		 */
		public override function get amount():int {
			return _timelines[_selectedIndex].amount;
		}
		public override function set amount(value:int):void {
			_timelines[_selectedIndex].amount = value;
		}

		/**
		 * description
		 */
		public override function get description():String {
			return _timelines[_selectedIndex].description;
		}
		public override function set description(value:String):void {
			_timelines[_selectedIndex].description = value;
		}

		/**
		 * used in golive context to define start offset
		 * component uses measure is milliseconds, but user pass values in minutes
		 * <br />no need to override getter
		 */
		public override function set goliveScaleOffsetStart(value:Number):void {

			value *= 60000; // granularity is minutes, so convert to milliseconds

			_goliveScaleOffsetStart = value;
			_timelineScale.goliveOffsetStart = value;
			_timelines[_selectedIndex].scaleStart = new Date( DateUtil.GO_LIVE_MSEC + value);

			update_timeStepping();
		}

		/**
		 * used in golive context to define end offset
		 * component uses measure is milliseconds, but user pass values in minutes
		 * <br />no need to override getter
		 */
		public override function set goliveScaleOffsetEnd(value:Number):void {

			value *= 60000; // granularity is minutes, so convert to milliseconds

			_goliveScaleOffsetEnd = value;
			_timelineScale.goliveOffsetEnd = value;
			_timelines[_selectedIndex].scaleEnd = new Date( DateUtil.GO_LIVE_MSEC + value);

			update_timeStepping();
		}

		/**
		 * used in golive context to define start offset
		 * component uses measure is milliseconds, but user pass values in minutes
		 */
		public override function get goliveTimeOffsetStart():Number {

			if(!_timelines[_selectedIndex].goliveTimeStart) return 0;

			var tmStart:Number = _timelines[_selectedIndex].goliveTimeStart.getTime();
			var timeOffsetStart:Number = Math.max(tmStart, DateUtil.GO_LIVE_MSEC) - Math.min(tmStart, DateUtil.GO_LIVE_MSEC);
			var sign:Number = tmStart > DateUtil.GO_LIVE_MSEC ? 1 : -1;

			return sign * timeOffsetStart / 60000; // converts back to minutes
		}
		public override function set goliveTimeOffsetStart(value:Number):void {

			trace("viewport Poly, set goliveTimeOffsetStart:", value);
			value *= 60000; // granularity is minutes, so convert to milliseconds

			_timelines[_selectedIndex].goliveTimeStart = new Date( DateUtil.GO_LIVE_MSEC + value);

			// initialize golive time end to golive event
			if(!_timelines[_selectedIndex].goliveTimeEnd){
				_timelines[_selectedIndex].goliveTimeEnd = new Date(DateUtil.GO_LIVE_MSEC);
			}

			update_timeStepping();
		}

		/**
		 * used in golive context to define end offset
		 * component uses measure is milliseconds, but user pass values in minutes
		 */
		public override function get goliveTimeOffsetEnd():Number {

			if(!_timelines[_selectedIndex].goliveTimeEnd) return 0;

			var tmEnd:Number = _timelines[_selectedIndex].goliveTimeEnd.getTime();
			var timeOffsetEnd:Number = Math.max(tmEnd, DateUtil.GO_LIVE_MSEC) - Math.min(tmEnd, DateUtil.GO_LIVE_MSEC);
			var sign:Number = tmEnd > DateUtil.GO_LIVE_MSEC ? 1 : -1;

			return sign * timeOffsetEnd / 60000; // converts back to minutes
		}
		public override function set goliveTimeOffsetEnd(value:Number):void {

			trace("viewport Poly, set goliveTimeOffsetEnd:", value);

			value *= 60000; // granularity is minutes, so convert to milliseconds

			_timelines[_selectedIndex].goliveTimeEnd = new Date( DateUtil.GO_LIVE_MSEC + value);

			// initialize golive time start  to golive event
			if(!_timelines[_selectedIndex].goliveTimeStart){
				_timelines[_selectedIndex].goliveTimeStart = new Date(DateUtil.GO_LIVE_MSEC);
			}


			update_timeStepping();
		}

		//--------------------------------------

		/**
		 * Constructor
		 * @param view client
		 */
		function ViewportPoly(view:UIComponent) {

			super(view, false);

			_timelines = new Array();
			addTimeline();
			_timelineInitialized = false;
		}

		/**
		 * @private
		 * update each timeline Y coordinates, accordingly with topSpacing
		 * <br />and their relevant verticalSpacing
		 * @return
		 */
		private function update_timelinePositions():void {

			_timelines[0].verticalSpacing = 0; // first timeline verticalSpacing is always 0

			var offsetY:int = _topSpacing;
			var lastY:int = 0;

			for each(var tlItem:TimelineItem in _timelines){
				offsetY += tlItem.verticalSpacing;
				tlItem.y = lastY = offsetY;
			}

			if(_heightAuto) {
				_view.height = lastY + 38;
				_timelineScale.scaleHeight = _view.height;
			}
		}

		/**
		 * @private
		 * complete component redraw
		 * @return
		 */
		private function update_timeStepping():void {

			redraw_background();

			var drawScale:Boolean = false;
			var tlItem:TimelineItem;

			for each(tlItem in _timelines) {

				tlItem.scaleWidth = _view.width;

				if(tlItem.behaviorType != BehaviorType.AMOUNT &&  tlItem.behaviorType != BehaviorType.DESCRIPTION){
					drawScale = true;
				}
			}

			_timelineScale.scaleWidth = _view.width;
			_timelineScale.scaleHeight = _view.height;
			_timelineScale.visible = drawScale;

			if(_behaviorType == BehaviorType.PERIOD){

				for each(tlItem in _timelines) {
					tlItem.periodScaleMode = _timelineScale.periodScaleMode;
				}

				return;
			}

			if(_behaviorType == BehaviorType.GO_LIVE){

				if(scaleAuto) {
					fit_timeScale_golive();
				}
				else {

					_scaleStart = new Date(DateUtil.GO_LIVE_MSEC + _goliveScaleOffsetStart);
					_scaleEnd = new Date(DateUtil.GO_LIVE_MSEC + _goliveScaleOffsetEnd);

					for each(tlItem in _timelines) {

						if(tlItem.goliveTimeStart && tlItem.goliveTimeEnd){
							tlItem.scaleStart = _scaleStart;
							tlItem.scaleEnd = _scaleEnd;
						}
					}
				}
			}

			if(!_scaleStart || !_scaleEnd) return;

			if(scaleAuto && _behaviorType == BehaviorType.DATE){
				fit_timeScale_date();
			}

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

			for each(tlItem in _timelines) {
				tlItem.timeStepping = _timeStepping;
			}
		}

		/**
		 * @private
		 * redraw the scale to fit each timeline, used in golive behavior
		 * @return
		 */
		private function fit_timeScale_golive():void {

			var minDateMsec:Number = DateUtil.GO_LIVE_MSEC;
			var maxDateMsec:Number = DateUtil.GO_LIVE_MSEC;

			for each(var tlItem:TimelineItem in _timelines){

				if(tlItem.behaviorType == BehaviorType.GO_LIVE){

					if(!tlItem.goliveTimeStart) continue;
					if(!tlItem.goliveTimeEnd) continue;

					minDateMsec = Math.min(minDateMsec, tlItem.goliveTimeStart.getTime());
					maxDateMsec = Math.max(maxDateMsec, tlItem.goliveTimeEnd.getTime());
				}
			}

			_goliveScaleOffsetStart = -(DateUtil.GO_LIVE_MSEC - minDateMsec);
			_goliveScaleOffsetEnd = maxDateMsec - DateUtil.GO_LIVE_MSEC;

			_timelineScale.goliveOffsetStart = _goliveScaleOffsetStart;
			_timelineScale.goliveOffsetEnd = _goliveScaleOffsetEnd;

			_scaleStart = new Date(minDateMsec);
			_scaleEnd = new Date(maxDateMsec);

			for each(tlItem in _timelines){
				tlItem.scaleStart = _scaleStart;
				tlItem.scaleEnd = _scaleEnd;
			}
		}

		/**
		 * @private
		 * redraw the scale to fit each timeline, used in date behavior
		 * @return
		 */
		private function fit_timeScale_date():void {

			var minDateMsec:Number = (new Date(3000, 01, 01)).getTime();
			var maxDateMsec:Number = 0;

			for each(var tlItem:TimelineItem in _timelines){

				if(tlItem.behaviorType == BehaviorType.DATE){

					if(!tlItem.timeStart) continue;
					if(!tlItem.timeEnd) continue;

					minDateMsec = Math.min(minDateMsec, tlItem.timeStart.getTime());
					maxDateMsec = Math.max(maxDateMsec, tlItem.timeEnd.getTime());
				}
			}

			_scaleStart = new Date(minDateMsec);
			_scaleEnd = new Date(maxDateMsec);

			_timelineScale.scaleStart = _scaleStart;
			_timelineScale.scaleEnd = _scaleEnd;

			for each(tlItem in _timelines){
				tlItem.scaleStart = _scaleStart;
				tlItem.scaleEnd = _scaleEnd;
			}
		}

		/**
		 * @private
		 * redraw the background
		 * @return
		 */
		private function redraw_background():void {

			var g:Graphics = _bck.graphics;
			g.clear();
			g.beginFill(_backgroundColor, _backgroundAlpha);
			g.drawRect(0, 0, _view.width, _view.height);
			g.endFill();
		}

		/**
		 * change the scale limit using min or max timeStart/timeEnd in timelines,
		 * in behavior date
		 * @param use timeStart or timeEnd, default timeStart
		 * @param use minimum or maximum date, default minimum
		 * @return
		 */
		public function fitScaleLimit(startEnd:Boolean = true, minMax:Boolean = true):void {

			if(_scaleAuto) return;
			if(_behaviorType != BehaviorType.DATE) return;

			var mathMethod:String = minMax ? "min" : "max";
			var sfxProp:String = startEnd ? "Start" : "End";

			var scaleProp:String = "scale" +sfxProp;
			var timeProp:String = "time" +sfxProp;

			for each(var tlItem:TimelineItem in _timelines){

				if(tlItem.behaviorType != BehaviorType.DATE) continue;

				this["_" +scaleProp] = Math[mathMethod](tlItem[timeProp], this[scaleProp]);
			}

			_timelineScale[scaleProp] = this["_" +scaleProp];
		}

		/**
		 * add a Timeline, update selectedIndex to reflect the addition
		 * @param start date
		 * @param end date
		 * @param Y spacing from the preceeding timeline
		 * @return name of the new timelineItem
		 */
		public function addTimeline(tlStart:Date = null, tlEnd:Date = null):String {

			var tlItem:TimelineItem;

			if(_timelines.length == 1 && !_timelineInitialized){

				tlItem = _timelines[0];

				tlItem.timeStart = tlStart;
				tlItem.timeEnd = tlEnd;

				tlItem.scaleStart = _scaleStart;
				tlItem.scaleEnd = _scaleEnd;

				_timelineInitialized = true;
			}
			else {
				tlItem = new TimelineItem(_view.width, _view.height, _scaleStart, _scaleEnd, tlStart, tlEnd);
				_timelines.push(tlItem);
				_view.addChild(tlItem);
			}

			if(_timelines.length > 1) _timelineInitialized = true;

			tlItem.visible = tlItem.timelineVisible && _timelineInitialized;

			tlItem.drawBackground = true;
			tlItem.backgroundOffsetY = _timelineBackgroundOffsetY;
			tlItem.backgroundHeight = _timelineBackgroundHeight;
			tlItem.verticalSpacing = _timelines.length > 1 ? _verticalSpacing : 0;
			tlItem.behaviorType = _behaviorType;

			_selectedIndex = numTimelines - 1;

			update_timelinePositions();
			update_timeStepping();

			return tlItem.name;
		}

		/**
		 * update selectedIndex from the given timelineItem nam
		 * @param timelineItem name/string ID
		 * @return selectedIndex or -1 if not found
		 */
		public function setSelectedIndexById(timelineID:String):int {

			for(var i:uint = 0; i < numTimelines; i++){

				var tlItem:TimelineItem = _timelines[i] as TimelineItem;

				if(tlItem.name == timelineID) {
					_selectedIndex = i;
					return _selectedIndex;
				}
			}

			return -1;
		}



		/**
		 * remove selected timeline, restore selectedIndex to 0
		 * @return
		 */
		public function removeTimeline():void {

			var tlItem:TimelineItem = _timelines[_selectedIndex] as TimelineItem;

			removeTimelineById(tlItem.name);
		}

		/**
		 * remove timeline from given name/string id, restore selectedIndex to 0
		 * <br />redraw timelines
		 * @return
		 */
		public function removeTimelineById(timelineID:String):void {

			if(numTimelines == 1){
				_timelineInitialized = false;
				_timelines[0].visible = false;
				_selectedIndex = 0;

				return;
			}


			for(var i:uint = 0; i < numTimelines; i++){

				var tlItem:TimelineItem = _timelines[i] as TimelineItem;

				if(tlItem.name == timelineID){
					_view.removeChild(tlItem);
					_timelines.splice(i, 1);
					_selectedIndex = 0;

					if(!_timelines.length){
						_timelineInitialized = false;
						addTimeline();
					}

					update_timelinePositions();
					update_timeStepping();
					break;
				}
			}
		}

		/**
		 * remove all the timelines, create a new timelineItem ready to receive data
		 * @return
		 */
		public function removeAllTimelines():void {

			for each(var tlItem:TimelineItem in _timelines){
				_view.removeChild(tlItem);
			}

			_timelines = new Array();

			addTimeline(null, null);
			_timelineInitialized = false;
		}

		/**
		 * [alias method] force to redraw the component
		 * this is an optional method, not needed in conventional implementation
		 * @return
		 */
		public override function redraw():void {
			update_timeStepping();
		}
	}
}