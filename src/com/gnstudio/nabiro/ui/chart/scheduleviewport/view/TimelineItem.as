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
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;

	import mx.core.UIComponent;

	import com.gnstudio.nabiro.utilities.DateUtil;
	import com.gnstudio.nabiro.utilities.StringUtil;
	import com.gnstudio.nabiro.ui.chart.scheduleviewport.model.BehaviorType;
	import com.gnstudio.nabiro.ui.chart.scheduleviewport.model.TimelineUtilData;

	/**
	 * TimelineItem child item component
	 * not recommended to be instatiated directly
	 *
	 * <p><b>note:</b> some properties cause to redraw when set</p>
	 *
	 * @package nabiro
	 * @playerversion 9
	 * @productversion flex 3.2
	 */
	public class TimelineItem extends UIComponent {

		[Embed(source="/../assets/gridbox_asset.swf", symbol="GridBox")]
		private var GridBox:Class;

		/**
		 * @private
		 * timeline minimum width
		 */
		private static const MIN_WIDTH:uint = 6;

		/**
		 * @private
		 * background
		 */
		private var _bck:Shape;

		/**
		 * @private
		 * amount scale
		 */
		private var _amountScale:AmountScale;

		/**
		 * @private
		 * timeline bar
		 */
		private var _bar:Shape;

		/**
		 * @private
		 * no-data background visualization
		 */
		private var _noDataBackground:Sprite;

		/**
		 * @private
		 * no-data background mask
		 */
		private var _noDataBackgroundMask:Sprite;

		/**
		 * @private
		 * toggle background drawing in amount/description
		 * @default false
		 */
		private var _drawBackground:Boolean = false;

		/**
		 * @private
		 * background offset y in amount/description behavior
		 * @default 5 (this value is alway intended as <= 0)
		 */
		private var _backgroundOffsetY:uint = 5;

		/**
		 * @private
		 * background height in amount/description behavior
		 * @default 28
		 */
		private var _backgroundHeight:int = 28;


		/**
		 * @private
		 * timelneColor choosen by user o managed by component
		 * @default false
		 */
		private var _colorAuto:Boolean = false;

		/**
		 * @private
		 * timelneColor color
		 * @default false
		 */
		private var _timelineColor:uint = 0x6666FF;

		/**
		 * @private
		 * timeline visibility
		 */
		private var _timelineVisible:Boolean = true;

		/**
		 * @private
		 * background color for amount behavior
		 * @default BehaviorType.COLOR_BACKGROUND_AMOUNT
		 */
		private var _amountBackgroundColor:uint = BehaviorType.COLOR_BACKGROUND_AMOUNT;

		/**
		 * @private
		 * background color for description behavior
		 * @default BehaviorType.COLOR_BACKGROUND_DESCRIPTION
		 */
		private var _descriptionBackgroundColor:uint = BehaviorType.COLOR_BACKGROUND_DESCRIPTION;

		/**
		 * @private
		 * timeline bar height, affected by behaviorType
		 */
		private var _barHeight:int = 18;

		/**
		 * @private
		 * y offset to ensure correct timeline drawing
		 */
		private var _offsetY:int = 0;

		/**
		 * @private
		 * hit area for hovering
		 */
		 private var _hitArea:SimpleButton;

		/**
		 * @private
		 * _hitAreaState DisplayObject
		 */
		 private var _hitAreaShape:Shape;

		/**
		 * @private
		 * label to show start/end timeline
		 */
		private var _dateLabel:DateLabel;

		/**
		 * @private
		 * label to show start golive start offset in timeline
		 */
		private var _goliveLabelStart:GoliveLabel;

		/**
		 * @private
		 * label to show start golive end offset in timeline
		 */
		private var _goliveLabelEnd:GoliveLabel;

		/**
		 * @private
		 * timeline width
		 */
		private var _tliWidth:Number;

		/**
		 * @private
		 * timeline bar color, timestepping minutes
		 * @default DateUtil.COLOR_MINUTE;
		 */
		private var _minuteColor:uint = DateUtil.COLOR_MINUTE;

		/**
		 * @private
		 * timeline bar color, timestepping hours
		 * @default DateUtil.COLOR_HOUR;
		 */
		private var _hourColor:uint = DateUtil.COLOR_HOUR;

		/**
		 * @private
		 * timeline bar color, timestepping days
		 * @default DateUtil.COLOR_DAY;
		 */
		private var _dayColor:uint = DateUtil.COLOR_DAY;

		/**
		 * @private
		 * timeline bar color, timestepping weeks
		 * @default DateUtil.COLOR_WEEK;
		 */
		private var _weekColor:uint = DateUtil.COLOR_WEEK;

		/**
		 * @private
		 * timeline bar color, timestepping months
		 * @default DateUtil.COLOR_MONTH;
		 */
		private var _monthColor:uint = DateUtil.COLOR_MONTH;

		/**
		 * @private
		 * timeline bar color, amount behavior
		 * @default BehaviorType.COLOR_AMOUNT
		 */
		private var _amountColor:uint = BehaviorType.COLOR_AMOUNT;

		/**
		 * @private
		 * timeline bar color, description behavior
		 * @default BehaviorType.COLOR_DESCRIPTION
		 */
		private var _descriptionColor:uint = BehaviorType.COLOR_DESCRIPTION;

		/**
		 * @private
		 * time step to manage policy draw
		 * @default DateUtil.STEPPING_DAY
		 */
		private var _timeStepping:String = DateUtil.STEPPING_DAY;

		/**
		 * @private
		 * vertical spacing, used in case of poly timelines context
		 * @default 44
		 */
		private var _verticalSpacing:int = 34;

		/**
		 * @private
		 * mouse hovering
		 * @default false
		 */
		private var _hover:Boolean = false;

		/**
		 * @private
		 * draw policy
		 * @default BehaviorType.DATE
		 */
		private var _behaviorType:String = BehaviorType.DATE;

		/**
		 * @private
		 * scale time from date
		 * @default null
		 */
		private var _scaleStart:Date = null;

		/**
		 * @private
		 * scale time to date
		 * @default null
		 */
		private var _scaleEnd:Date = null;

		/**
		 * @private
		 * timeline from date
		 * @default null
		 */
		private var _timeStart:Date = null;

		/**
		 * @private
		 * timeline to date
		 * @default null
		 */
		private var _timeEnd:Date = null;

		/**
		 * @private
		 * golive timeline from date
		 * @default null
		 */
		private var _goliveTimeStart:Date = null;

		/**
		 * @private
		 * golive timeline to date
		 * @default null
		 */
		private var _goliveTimeEnd:Date = null;


		/**
		 * @private
		 * time scale rotation mode in period behavior
		 * @default = DateUtil.STEPPING_WEEK
		 */
		private var _periodScaleMode:String = DateUtil.STEPPING_WEEK;

		/**
		 * @private
		 * time period mode in period behavior
		 * @default = DateUtil.STEPPING_WEEK
		 */
		private var _periodMode:String = DateUtil.STEPPING_WEEK;

		/**
		 * @private
		 * period time start as index
		 * @default 0
		 */
		private var _periodIndex:uint = 0;

		/**
		 * @private
		 * period time duration units
		 * @default 0
		 */
		private var _periodDuration:uint = 0;

		/**
		 * @private
		 * amount
		 * @default 0
		 */
		private var _amount:int = 0;

		/**
		 * @private
		 * description
		 * @default
		 */
		private var _description:String = "";


		/**
		 * outer|inner golive timeline bar drawing
		 */
		public function set innerGoliveLabel(value:Boolean):void {
			_goliveLabelStart.inner = value;
			_goliveLabelEnd.inner = value;
		}

		/**
		 * draw background for amount/description behavior
		 */
		public function set drawBackground(value:Boolean):void {
			_drawBackground = value;
			redraw();
		}

		/**
		 * background offset y, for amount/description behavior
		 */
		public function get backgroundOffsetY():uint{
			return _backgroundOffsetY;
		}
		public function set backgroundOffsetY(value:uint):void {
			_backgroundOffsetY = value;
			redraw();
		}

		/**
		 * background height, for amount/description behavior
		 */
		public function get backgroundHeight():int{
			return _backgroundHeight;
		}
		public function set backgroundHeight(value:int):void {
			_backgroundHeight = value;
			redraw();
		}

		/**
		 * timeline bar color, timestepping minutes
		 */
		public function set minuteColor(value:uint):void {
			_minuteColor = value;
			redraw();
		}

		/**
		 * timeline bar color, timestepping hours
		 */
		public function set hourColor(value:uint):void {
			_hourColor = value;
			redraw();
		}

		/**
		 * timeline bar color, timestepping days
		 */
		public function set dayColor(value:uint):void {
			_dayColor = value;
			redraw();
		}

		/**
		 * timeline bar color, timestepping weeks
		 */
		public function set weekColor(value:uint):void {
			_weekColor = value;
			redraw();
		}

		/**
		 * timeline bar color, timestepping months
		 */
		public function set monthColor(value:uint):void {
			_monthColor = value;
			redraw();
		}

		/**
		 * timeline bar color, amount behavior
		 */
		public function set amountColor(value:uint):void {
			_amountColor = value;
			if(_behaviorType == BehaviorType.AMOUNT) redraw();
		}

		/**
		 * background color, amount behavior
		 */
		public function set colorAuto(value:Boolean):void {
			_colorAuto = value;
			redraw();
		}

		/**
		 * background color, amount behavior
		 */
		public function get timelineColor():uint {

			if(!_colorAuto) return _timelineColor;

			if(_behaviorType == BehaviorType.GO_LIVE || _behaviorType == BehaviorType.DATE){
				return this["_" +_timeStepping +"Color"];
			}

			if(_behaviorType == BehaviorType.AMOUNT) return _amountColor;
			if(_behaviorType == BehaviorType.DESCRIPTION) return _descriptionColor;
			if(_behaviorType == BehaviorType.PERIOD) {
				if(_periodMode == DateUtil.STEPPING_YEAR) return _monthColor;
				if(_periodMode == DateUtil.STEPPING_WEEK) return _dayColor;
				if(_periodMode == DateUtil.STEPPING_DAY) return _hourColor;
			}

			return NaN;
		}
		public function set timelineColor(value:uint):void {
			_timelineColor = value;
			redraw();
		}


		/**
		 * hide show selectedIndex timeline
		 */
		public function get timelineVisible():Boolean {
			return _timelineVisible;
		}
		public function set timelineVisible(value:Boolean):void {
			_timelineVisible = value;
			redraw();
		}

		/**
		 * background color, amount behavior
		 */
		public function set amountBackgroundColor(value:uint):void {
			_amountBackgroundColor = value;
			if(_behaviorType == BehaviorType.AMOUNT) redraw();
		}

		/**
		 * timeline bar color, description behavior
		 */
		public function set descriptionColor(value:uint):void {
			_descriptionColor = value;
			if(_behaviorType == BehaviorType.DESCRIPTION) redraw();
		}

		/**
		 * background color, description behavior
		 */
		public function set descriptionBackgroundColor(value:uint):void {
			_descriptionBackgroundColor = value;
			if(_behaviorType == BehaviorType.DESCRIPTION) redraw();
		}

		/**
		 * value used to manage draw policy, when set causes redraw
		 */
		public function get timeStepping():String {
			return _timeStepping;
		}
		public function set timeStepping(value:String):void{
			_timeStepping = value;
			redraw();
		}

		/**
		 * poly timelines context, Y space from the preceding timeline,
		 * used to stack timelines
		 */
		public function get verticalSpacing():int {
			return _verticalSpacing;
		}
		public function set verticalSpacing(value:int):void{
			_verticalSpacing = value;
		}

		/**
		 * scale width, usually it is the same as parent Component width,
		 * used as a reference to draw timeline
		 */
		public function get scaleWidth():int {
			return _tliWidth;
		}
		public function set scaleWidth(value:int):void {
			_tliWidth = value;
			redraw();
		}

		/**
		 * mouse over or fixed behaviour
		 */
		public function get hover():Boolean {
			return _hover;
		}
		public function set hover(value:Boolean):void {

			_hover = value;

			if(_behaviorType != BehaviorType.GO_LIVE){
				_dateLabel.visible = !_hover;
			}
			else {
				_goliveLabelStart.visible = !_hover;
				_goliveLabelEnd.visible = !_hover;
			}

			if(value){

				if(!_hitArea.hasEventListener(MouseEvent.ROLL_OVER))
					_hitArea.addEventListener(MouseEvent.ROLL_OVER, onRollOver);

				if(!_hitArea.hasEventListener(MouseEvent.ROLL_OUT))
					_hitArea.addEventListener(MouseEvent.ROLL_OUT, onRollOut);

				return;
			}

			if(_hitArea.hasEventListener(MouseEvent.ROLL_OVER))
				_hitArea.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);

			if(_hitArea.hasEventListener(MouseEvent.ROLL_OUT))
				_hitArea.removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
		}

		/**
		 * behavior draw policy
		 */
		public function get behaviorType():String {
			return _behaviorType;
		}
		public function set behaviorType(value:String):void {

			_behaviorType = value;

			_barHeight = 18;
			_offsetY = 0;

			if(_behaviorType == BehaviorType.GO_LIVE){

				_barHeight = 16;
				_offsetY = 3;
			}

			redraw();
		}

		/**
		 * scale window from date
		 */
		public function get scaleStart():Date {
			return _scaleStart;
		}
		public function set scaleStart(value:Date):void {
			_scaleStart = value;
			redraw();
		}

		/**
		 * scale window to date
		 */
		public function get scaleEnd():Date {
			return _scaleEnd;
		}
		public function set scaleEnd(value:Date):void {
			_scaleEnd = value;
			redraw();
		}

		/**
		 * time "mode" in period behavior
		 */
		public function set periodScaleMode(value:String):void {

			_periodScaleMode = value;

			redraw();
		}

		/**
		 * time "mode" in period behavior
		 */
		public function get periodMode():String {
			return _periodMode;
		}
		public function set periodMode(value:String):void {

			_periodMode = value;

			redraw();
		}

		/**
		 * start index in period behavior
		 */
		public function get periodIndex():uint {
			return _periodIndex;
		}
		public function set periodIndex(value:uint):void {
			_periodIndex = value;
			redraw();
		}

		/**
		 * units of time duration in period behavior
		 */
		public function get periodDuration():uint {
			return _periodDuration;
		}
		public function set periodDuration(value:uint):void {
			_periodDuration = value;
			redraw();
		}

		/**
		 * amount
		 */
		public function get amount():int {
			return _amount;
		}
		public function set amount(value:int):void {
			_amount = value;
			redraw();
		}

		/**
		 * description
		 */
		public function get description():String {
			return _description;
		}
		public function set description(value:String):void {

			_description = value;
			redraw();
		}

		/**
		 * timeline from date
		 */
		public function get timeStart():Date {
			return _timeStart;
		}
		public function set timeStart(value:Date):void {
			_timeStart = value;
		}

		/**
		 * timeline to date
		 */
		public function get timeEnd():Date {
			return _timeEnd;
		}
		public function set timeEnd(value:Date):void {
			_timeEnd = value;
			redraw();
		}

		/**
		 * golive timeline from date
		 */
		public function get goliveTimeStart():Date {
			return _goliveTimeStart;
		}
		public function set goliveTimeStart(value:Date):void {
			_goliveTimeStart = value;
		}

		/**
		 * timeline to date
		 */
		public function get goliveTimeEnd():Date {
			return _goliveTimeEnd;
		}
		public function set goliveTimeEnd(value:Date):void {
			_goliveTimeEnd = value;
			redraw();
		}


		//----------------------------------

		/**
		 * Constructor, it need the parent width and height to manage the draw policy
		 */
		public function TimelineItem(tliWidth:Number, tliHeight:Number,
									 scaleStart:Date, scaleEnd:Date,
									 timeStart:Date, timeEnd:Date) {
			super();

			_tliWidth = tliWidth;
			_scaleStart = scaleStart;
			_scaleEnd = scaleEnd;
			_timeStart = timeStart;
			_timeEnd = timeEnd;

			initialize_UI();
		}

		/**
		 * @private
		 * UI setup
		 * @return
		 */
		private function initialize_UI():void {

			_bck = new Shape();
			_amountScale = new AmountScale(_tliWidth - 40, 10);
			_bar = new Shape();

			_noDataBackground = new GridBox();
			_noDataBackgroundMask = new Sprite();
			_noDataBackground.mask = _noDataBackgroundMask;

			_dateLabel = new DateLabel();
			_dateLabel.y = 2;

			_goliveLabelStart = new GoliveLabel(false, false);
			_goliveLabelEnd = new GoliveLabel(true, true);

			_hitArea = new SimpleButton();
			_hitArea.useHandCursor = false;
			_hitAreaShape = new Shape();
			_hitArea.hitTestState = _hitAreaShape;

			addChild(_bck);
			addChild(_amountScale);
			addChild(_bar);
			addChild(_noDataBackground);
			addChild(_noDataBackgroundMask);
			addChild(_dateLabel);
			addChild(_goliveLabelStart);
			addChild(_goliveLabelEnd);
			addChild(_hitArea);

			_amountScale.x = 20;

			_amountScale.visible = false;
			_dateLabel.visible = false;
			_goliveLabelStart.visible = false;
			_goliveLabelEnd.visible = false;

			redraw();
		}

		/**
		 * @private
		 * complete redraw of the timeline, managing draw policy
		 * @return
		 */
		private function redraw():void {

			visible = _timelineVisible;

			if(!visible) return;

			redraw_background();
			var g:Graphics = _bar.graphics;
			g.clear();

			_amountScale.visible = false;
			_bar.visible = false;
			_dateLabel.visible = false;
			_goliveLabelStart.visible = false;
			_goliveLabelEnd.visible = false;
			_noDataBackground.visible = false;

			this["redraw_" +_behaviorType]();
		}

		/**
		 * @private
		 * redraw the timeline when behaviorType is golive
		 * @return
		 */
		private function redraw_golive():void {

			var noDataProps:Array = ["_scaleStart", "scaleEnd", "_goliveTimeStart", "_goliveTimeEnd", "_timeStepping"];

			for each(var prop:String in noDataProps){

				if(_behaviorType != BehaviorType.GO_LIVE || !this[prop]){
					trace("no data in:", prop);
					redraw_noData();
					return;
				}
			}

			if(_goliveTimeStart >= _goliveTimeEnd){

				redraw_noData("please check data");

				return;
			}

			_bar.visible = true;
			_goliveLabelStart.visible = !_hover;
			_goliveLabelEnd.visible = !_hover;

			var ud:TimelineUtilData = new TimelineUtilData(_scaleStart, _scaleEnd, _goliveTimeStart, _goliveTimeEnd, _timeStepping, _tliWidth);
			var tlColor:uint = _colorAuto ? this["_" +_timeStepping +"Color"] : _timelineColor;

			update_goliveLabelsText();

			// timeline is out of range - left
			if(ud.timeEndMsec <= ud.scaleStartMsec){
				drawOutRange();
			}
			else if(ud.timeStartMsec >= ud.scaleEndMsec){ // timeline is out of range - right
				drawOutRange(false);
			}
			else if(ud.timeStartMsec >= ud.scaleStartMsec){
				ud.offsetX = 20 + ud.startDuration * ud.stepX;
			}
			else if(ud.timeStartMsec < ud.scaleStartMsec){
				ud.	timelineWidth -= Math.abs(ud.startDuration) * ud.stepX;
				drawOutBound();
			}

			if(ud.timeEndMsec > ud.scaleEndMsec){
				drawOutBound(false);
				ud.timelineWidth = _tliWidth - 20 - ud.offsetX;
			}

			ud.timelineWidth = Math.max(ud.timelineWidth, MIN_WIDTH);
			ud.timelineWidth = Math.min(ud.timelineWidth, (_tliWidth - 40));

			var glsX:int = ud.offsetX;
			var gleX:int = ud.offsetX + ud.timelineWidth;

			_goliveLabelStart.left = false;
			_goliveLabelEnd.left = true;

			if(glsX - _goliveLabelStart.goliveLabelWidth <= 20)
				_goliveLabelStart.left = true;

			if(gleX + _goliveLabelEnd.goliveLabelWidth >= _tliWidth - 20)
				_goliveLabelEnd.left = false;

			_goliveLabelStart.x = glsX;
			_goliveLabelEnd.x = gleX;

			redraw_timelineBar(ud.offsetX, ud.timelineWidth, tlColor);
		}

		/**
		 * @private
		 * redraw the timeline when behaviorType is date
		 * @return
		 */
		private function redraw_date():void{

			var noDataProps:Array = ["_scaleStart", "scaleEnd", "_timeStart", "_timeEnd", "_timeStepping"];

			for each(var prop:String in noDataProps){
				if(_behaviorType != BehaviorType.DATE || !this[prop]){
					redraw_noData();
					return;
				}
			}

			_bar.visible = true;
			_dateLabel.visible = !_hover;

			var ud:TimelineUtilData = new TimelineUtilData(_scaleStart, _scaleEnd, _timeStart, _timeEnd, _timeStepping, _tliWidth);
			var tlColor:uint = _colorAuto ? this["_" +_timeStepping +"Color"] : _timelineColor;

			update_dateLabelText(ud.tlDuration);

			// timeline is out of range - left
			if(ud.timeEndMsec <= ud.scaleStartMsec){
				drawOutRange();
				_dateLabel.redrawBackground(tlColor);
				_dateLabel.x = 25;
				return;
			}

			// timeline is out of range - right
			if(ud.timeStartMsec >= ud.scaleEndMsec){
				drawOutRange(false);
				_dateLabel.redrawBackground(tlColor);
				_dateLabel.x = Math.round(_tliWidth - 25 - _dateLabel.dateLabelWidth);
				return;
			}

			if(ud.timeStartMsec >= ud.scaleStartMsec){
				ud.offsetX = 20 + ud.startDuration * ud.stepX;
			}
			else if(ud.timeStartMsec < ud.scaleStartMsec){
				ud.timelineWidth -= Math.abs(ud.startDuration) * ud.stepX;
				drawOutBound();
			}

			if(ud.timeEndMsec > ud.scaleEndMsec){
				drawOutBound(false);
				ud.timelineWidth = _tliWidth - 20 - ud.offsetX;
			}

			ud.timelineWidth = Math.max(ud.timelineWidth, MIN_WIDTH);
			ud.timelineWidth = Math.min(ud.timelineWidth, _tliWidth - 40);

			place_dateLabelText(ud.offsetX, ud.timelineWidth, tlColor);

			redraw_timelineBar(ud.offsetX, ud.timelineWidth, tlColor);
		}


		/**
		 * @private
		 * component redraw in period behavior
		 */
		private function redraw_period():void {

			_bar.visible = true;
			_dateLabel.visible = !_hover;

			var periodRank:Object = {};
			periodRank[DateUtil.STEPPING_DAY] = 0;
			periodRank[DateUtil.STEPPING_WEEK] = 1;
			periodRank[DateUtil.STEPPING_YEAR] = 2;

			if(!_periodDuration){

				redraw_noData();

				return;
			}

			var steps:uint = 12;
			var stepX:Number = (_tliWidth - 40) / steps;
			var tlColor:uint = _monthColor;
			_timeStepping = DateUtil.STEPPING_MONTH;

			if(_periodMode == DateUtil.STEPPING_WEEK){
				_timeStepping = DateUtil.STEPPING_DAY;
				tlColor = _dayColor;
				steps = 7;
				stepX = (_tliWidth - 40) / steps;
			}
			else if(_periodMode == DateUtil.STEPPING_DAY){
				_timeStepping = DateUtil.STEPPING_HOUR;
				tlColor = _hourColor;
				steps = 24;
				stepX = (_tliWidth - 40) / steps;
			}

			var offsetX:Number = 20 + stepX * _periodIndex;
			var timelineWidth:Number = stepX * _periodDuration;

			update_periodLabelText();
			tlColor = _colorAuto ? tlColor : _timelineColor;

			// _periodMode differs from _periodScaleMode
			if(periodRank[_periodMode] > periodRank[_periodScaleMode]){

				drawOutBound(false);
				drawOutBound();
				offsetX = 20;
				timelineWidth = _tliWidth - 40;
			}
			else if(periodRank[_periodMode] < periodRank[_periodScaleMode]){

				var ctForm:ColorTransform = _noDataBackground.transform.colorTransform;
				ctForm.color = tlColor;
				_noDataBackground.transform.colorTransform = ctForm;

				var g:Graphics = _noDataBackgroundMask.graphics;
				g.clear();
				g.beginFill(0x0);
				g.drawRect(20, 4, _tliWidth - 40, 10);
				g.endFill();

				_dateLabel.redrawBackground(tlColor);
				_dateLabel.x = Math.round((_tliWidth - _dateLabel.dateLabelWidth) / 2);

				_noDataBackground.visible = true;
				return;
			}

			if(offsetX + timelineWidth > _tliWidth - 20){
				timelineWidth = _tliWidth - 20 - offsetX;
				drawOutBound(false);
			}

			place_dateLabelText (offsetX, timelineWidth, tlColor);
			redraw_timelineBar(offsetX, timelineWidth, tlColor);
		}

		/**
		 * @private
		 * component redraw in amount behavior
		 */
		private function redraw_amount():void {

			_dateLabel.visible = true;
			_amountScale.visible = true;
			_bar.visible = true;

			var tlColor:uint = _colorAuto ? _amountColor : _timelineColor;
			var timelineWidth:int = 0;

			if(_amount){

				for(var i:int = 0, k:int = 1; i < 9; i++, k *= 10){

					if(_amount < k){
						var steps:Number = (_tliWidth - 40) / k;
						timelineWidth = _amount * steps;
						break;
					}
				}
			}

			_amountScale.amountScaleWidth = _tliWidth - 40;
			_amountScale.scaleBase = k;

			timelineWidth = Math.max(MIN_WIDTH, timelineWidth);
			redraw_timelineBar(20, timelineWidth, tlColor);

			_dateLabel.text = "" +_amount;
			_dateLabel.redrawBackground();

			var dlX:int = 20 + timelineWidth - _dateLabel.dateLabelWidth - 5;

			if(dlX <= 20) {
				dlX = 20 + timelineWidth + 5;
				_dateLabel.redrawBackground(tlColor);
			}

			_dateLabel.x = Math.round(dlX);
		}

		/**
		 * @private
		 * component redraw in description behavior
		 */
		private function redraw_description():void {

			_bar.visible = true;
			_dateLabel.visible = true;

			var tlColor:uint = _colorAuto ? _descriptionColor : _timelineColor;
			var timelineWidth:int = (_tliWidth - 40) / 2;

			redraw_timelineBar(20, timelineWidth, tlColor);

			_dateLabel.text = _description;
			_dateLabel.redrawBackground();

			var dlX:int = 20 + timelineWidth - _dateLabel.dateLabelWidth - 5;

			if(dlX <= 20){
				dlX = 20 + timelineWidth + 5;

				if(dlX + _dateLabel.dateLabelWidth > _tliWidth - 20){
					redraw_timelineBar(20, MIN_WIDTH, tlColor);
					dlX = 25 + MIN_WIDTH;
				}

				_dateLabel.redrawBackground(tlColor);
			}

			_dateLabel.x = Math.round(dlX);
		}

		/**
		 * @private
		 * redraw the timeline bar and mouse hovering area
		 * @param the initial x coordinate
		 * @param the timeline width
		 * @return
		 */
		private function redraw_timelineBar(offsetX:int, timelineWidth:int, tlColor:uint):void {

			var g:Graphics = _bar.graphics;

			g.beginFill(tlColor, .9);
			g.drawRect(offsetX, _offsetY, timelineWidth, _barHeight);
			g.endFill();

			g = _hitAreaShape.graphics;
			g.clear();
			g.beginFill(0x0);
			g.drawRect(0, _offsetY, _tliWidth, _barHeight);
			g.endFill();
		}

		/**
		 * @private
		 * draw out-of-bounds marker to left/right limit of the timeline scale
		 * @param left or right flag
		 * @return
		 */
		private function drawOutBound(leftFlag:Boolean = true):void {

			var tlColor:uint = _colorAuto ? this["_" +_timeStepping +"Color"] : _timelineColor;
			var xOffsets:Array = ["p1", "d1", "p1", "d2", "p1", "d3", "p1", "d4", "p1", "d5"];
			var startX:int = 0;

			if(!leftFlag){
				xOffsets.reverse();
				startX = _tliWidth - 20;
			}

			var g:Graphics = _bar.graphics;

			g.beginFill(tlColor, .9);

			for each(var i:String in xOffsets){

				var ofst:uint = parseInt(i.substring(1));

				if(i.charAt(0) == "d"){
					g.drawRect(startX, _offsetY, ofst, _barHeight);
				}

				startX += ofst;
			}

			g.endFill();
		}

		/**
		 * @private
		 * draw out-of-range marker to left/right limit of the timeline scale
		 * @param left or right flag
		 * @return
		 */
		private function drawOutRange(leftFlag:Boolean = true):void {

			var startX:uint = leftFlag ? 0 : _tliWidth - 20;
			var g:Graphics = _bar.graphics;

			//g.clear();

			g.beginFill(0xCC0000);
			g.moveTo(startX, _offsetY + _barHeight / 2);
			g.lineTo(startX + 6, _offsetY);
			g.lineTo(startX + 9, _offsetY);
			g.lineTo(startX + 9, _offsetY + _barHeight);
			g.lineTo(startX + 6, _offsetY + _barHeight);
			g.lineTo(startX, _offsetY + _barHeight / 2);

			g.moveTo(startX + 11, _offsetY);
			g.lineTo(startX + 14, _offsetY);
			g.lineTo(startX + 20, _offsetY + _barHeight / 2);
			g.lineTo(startX + 14, _offsetY + _barHeight);
			g.lineTo(startX + 11, _offsetY + _barHeight);
			g.lineTo(startX + 11, _offsetY);
			g.endFill();
		}

		/**
		 * @private
		 * component redraw in no-data state
		 */
		private function redraw_noData(msg:String = "no data available"):void {

			_amountScale.visible = false;
			_bar.visible = false;
			_goliveLabelStart.visible = false;
			_goliveLabelEnd.visible = false;

			var ctForm:ColorTransform = _noDataBackground.transform.colorTransform;
			ctForm.color = 0x0;
			_noDataBackground.transform.colorTransform = ctForm;

			_noDataBackground.visible = true;
			_noDataBackground.alpha = .2;
			_dateLabel.redrawBackground();
			_dateLabel.visible = true;

			_dateLabel.text = msg;
			_dateLabel.x = 30;
			_dateLabel.redrawBackground();

			var g:Graphics = _noDataBackgroundMask.graphics;
			g.clear();
			g.beginFill(0x0);
			g.drawRect(20, 0, _tliWidth - 40, 18);
			g.endFill();
		}

		/**
		 * @private
		 * redraw the background
		 */
		private function redraw_background():void {

			if(_behaviorType !=  BehaviorType.AMOUNT && _behaviorType !=  BehaviorType.DESCRIPTION){
				_bck.visible = false;
				return;
			}

			_bck.visible = _drawBackground;

			if(!_drawBackground) return;

			_bck.y = -_backgroundOffsetY;

			var bgColor:uint = (_behaviorType == BehaviorType.AMOUNT) ? _amountBackgroundColor : _descriptionBackgroundColor

			var g:Graphics = _bck.graphics;
			g.clear();

			g.beginFill(bgColor);
			g.drawRect(20, 0, _tliWidth - 40, _backgroundHeight);
			g.endFill();
		}

		/**
		 * @private
		 * place dateLabelText in appropriate x coor and provide correct background color
		 * @param offsetX
		 * @param timelineWidth
		 * @return
		 */
		private function place_dateLabelText(offsetX:Number, timelineWidth:Number, tlColor:uint):void {

			var dlBgColor:uint = 0xFFFFFF;
			var dlX:Number = offsetX + timelineWidth - dlWidth;
			var dlWidth:uint = _dateLabel.dateLabelWidth + 5;

			if(offsetX + timelineWidth >= _tliWidth - 20){
				dlX = _tliWidth - 20 - dlWidth;

				if(dlX < offsetX){
					dlBgColor = tlColor;
					dlX = offsetX - dlWidth;
				}
			}
			else if(dlWidth >= timelineWidth) {

				dlBgColor = tlColor;
				dlX = offsetX + timelineWidth + 5;
				dlX = Math.min(_tliWidth - 20 - timelineWidth - dlWidth, dlX);

				if(dlX > 25 + dlWidth + timelineWidth){
					dlX = Math.min(offsetX - dlWidth, dlX);
				}
				else if(dlX > offsetX - dlWidth){
					dlX = offsetX - dlWidth;
				}

				if(dlX < 25) dlX = offsetX + timelineWidth + 5;
			}
			else if(dlWidth < timelineWidth){
				dlX = offsetX + timelineWidth - dlWidth;
			}

			_dateLabel.redrawBackground(dlBgColor);
			_dateLabel.x = Math.round(dlX);
		}

		/**
		 * @private
		 * update the label text and background in perdiod behavior
		 * @return
		 */
		private function update_periodLabelText():void {

			var str:String = "";

			if(_periodMode == DateUtil.STEPPING_YEAR){
				str = DateUtil.getLabelForMonth(_periodIndex);
				str += " - " +DateUtil.getLabelForMonth(_periodIndex + _periodDuration);
			}
			else if(_periodMode == DateUtil.STEPPING_WEEK){
				str = DateUtil.getLabelForDayWeek(_periodIndex);
				str += " - " +DateUtil.getLabelForDayWeek(_periodIndex + _periodDuration);
			}
			else if(_periodMode == DateUtil.STEPPING_DAY){
				str = "" +_periodIndex +":00";
				str += " - " +(_periodIndex + _periodDuration) +":00";
			}

			_dateLabel.text = str;
		}

		/**
		 * @private
		 * update the label text and background, in date behavior
		 * @param timeline duration
		 * @return
		 */
		private function update_dateLabelText(tlDuration:Number):void {

			var str:String = DateUtil.getTimeGap(tlDuration);

			str += " (" +(StringUtil.str_pad("" +(_timeStart.getMonth() + 1), "0", 2)) +".";
			str += StringUtil.str_pad("" +_timeStart.getDate(), "0", 2);
			str += " - ";
			str +=  StringUtil.str_pad("" +(_timeEnd.getMonth() + 1), "0", 2) +".";
			str += StringUtil.str_pad("" +_timeEnd.getDate(), "0", 2) +")";
			_dateLabel.text = str;
		}

		/**
		 * @private
		 * redraw the labels when behaviorType is golive
		 * @return
		 */
		private function update_goliveLabelsText():void {

			var str:String = "just in";

			var startDateMsec:Number = _goliveTimeStart.getTime();
			var endDateMsec:Number = _goliveTimeEnd.getTime();

			var sfx:String = DateUtil.getTimeGap(Math.abs(startDateMsec - DateUtil.GO_LIVE_MSEC));

			if(startDateMsec == DateUtil.GO_LIVE_MSEC) {
				str = "just in ";
				sfx = "";
			}else {
				str = startDateMsec < DateUtil.GO_LIVE_MSEC ? "before " : "after ";
			}

			_goliveLabelStart.text = sfx +str + "go-live";

			sfx = DateUtil.getTimeGap(Math.abs(endDateMsec - DateUtil.GO_LIVE_MSEC));

			if(endDateMsec == DateUtil.GO_LIVE_MSEC) {
				str = "just in ";
			}else {
				str = endDateMsec < DateUtil.GO_LIVE_MSEC ? "before " : "after ";
			}

			_goliveLabelEnd.text = sfx +str +"go-live";
		}

		/**
		 * @private
		 * @event
		 * manage mouse hovering: roll over
		 * @param
		 * @return
		 */
		private function onRollOver(evt:MouseEvent):void {

			if(_behaviorType == BehaviorType.GO_LIVE) {
				_goliveLabelStart.visible = _hover;
				_goliveLabelEnd.visible = _hover;
				return;
			}
			_dateLabel.visible = _hover;
		}

		/**
		 * @private
		 * @event
		 * manage mouse hovering: roll out
		 * @param
		 * @return
		 */
		private function onRollOut(evt:MouseEvent):void {

			if(_behaviorType == BehaviorType.GO_LIVE) {
				_goliveLabelStart.visible = false;
				_goliveLabelEnd.visible = false;
				return;
			}
			_dateLabel.visible = false;
		}
	}
}