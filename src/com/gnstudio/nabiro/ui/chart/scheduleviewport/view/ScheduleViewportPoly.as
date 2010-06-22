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

	import mx.core.UIComponent;
	import mx.styles.StyleManager;
	import mx.styles.CSSStyleDeclaration;

	import com.gnstudio.nabiro.utilities.DateUtil;
	import com.gnstudio.nabiro.utilities.StringUtil;
	import com.gnstudio.nabiro.ui.chart.scheduleviewport.model.BehaviorType;

	import com.gnstudio.nabiro.ui.chart.scheduleviewport.presenter.ViewportPoly;


	//--------------------------------------
	//  Styles
	//--------------------------------------

	/**
	 *  background color
	 *
	 *  @default #FFFFFF
	 */
	[Style(name="backgroundColor", type="uint", format="Color", inherit="no")]

	/**
	 *  background alpha
	 *
	 *  @default 1
	 */
	[Style(name="backgroundAlpha", type="Number", format="Number", inherit="no")]

	/**
	 *  amount behavior background color
	 *
	 *  @default BehaviorType.COLOR_BACKGROUND_AMOUNT
	 */
	[Style(name="amountBackgroundColor", type="Number", format="Number", inherit="no")]

	/**
	 *  description behavior background color
	 *
	 *  @default BehaviorType.COLOR_BACKGROUND_AMOUNT
	 */
	[Style(name="descriptionBackgroundColor", type="Number", format="Number", inherit="no")]

	/**
	 *  snap time scale
	 *
	 *  @default false
	 */
	[Style(name="timeScaleSnap", type="Boolean", inherit="no")]

	/**
	 *  redraw the scale to fit timeline
	 *
	 *  @default false
	 */
	[Style(name="scaleAuto", type="Boolean", inherit="no")]

	/**
	 *  set automatic height for n timelines
	 *
	 *  @default false
	 */
	[Style(name="heightAuto", type="Boolean", inherit="no")]

	/**
	 *  y coordinate of the timeline item from the top limit of the component
	 *
	 *  @default 35
	 */
	[Style(name="topSpacing", type="Number", format="length", inherit="no")]

	/**
	 *  y coordinate of the timeline item from the top limit of the component
	 *
	 *  @default 34
	 */
	[Style(name="verticalSpacing", type="Number", format="length", inherit="no")]

	/**
	 * pixel padding between top-background limit and the drawing area
	 *
	 *  @default 5
	 */
	[Style(name="paddingTop", type="Number", format="Length", inherit="no")]

	/**
	 * pixel padding between bottom-background limit and the drawing area
	 *
	 *  @default 5
	 */
	[Style(name="paddingBottom", type="Number", format="Length", inherit="no")]

	/**
	 * arbitrary timeline color or let the component choose by time stepping
	 *
	 *  @default true
	 */
	[Style(name="timelineColorAuto", type="Boolean", inherit="no")]

	/**
	 * draw labels in golive behavior within o out of the bar
	 *
	 *  @default true
	 */
	[Style(name="innerGoliveLabel", type="Boolean", inherit="no")]

	/**
	 * timeline bar color, timestepping in minutes
	 *
	 *  @default DateUtil.COLOR_MINUTE
	 */
	[Style(name="minuteColor", type="uint", format="Color", inherit="yes")]

	/**
	 * timeline bar color, timestepping in hours
	 *
	 *  @default DateUtil.COLOR_HOUR
	 */
	[Style(name="hourColor", type="uint", format="Color", inherit="yes")]

	/**
	 * timeline bar color, timestepping in days
	 *
	 *  @default DateUtil.COLOR_DAY
	 */
	[Style(name="dayColor", type="uint", format="Color", inherit="yes")]

	/**
	 * timeline bar color, timestepping in weeks
	 *
	 *  @default DateUtil.COLOR_WEEK
	 */
	[Style(name="weekColor", type="uint", format="Color", inherit="yes")]

	/**
	 * timeline bar color, timestepping in months
	 *
	 *  @default DateUtil.COLOR_MONTH
	 */
	[Style(name="monthColor", type="uint", format="Color", inherit="yes")]

	/**
	 * timeline bar color, amount behavior
	 *
	 *  @default BehaviorType.COLOR_AMOUNT;
	 */
	[Style(name="amountColor", type="uint", format="Color", inherit="yes")]

	/**
	 * timeline bar color, description behavior
	 *
	 *  @default BehaviorType.COLOR_DESCRIPTION;
	 */
	[Style(name="descriptionColor", type="uint", format="Color", inherit="yes")]

	/**
	 * timeline scale - vertical lines color
	 *
	 *  @default 0xCCCCCC
	 */
	[Style(name="verticalLineColor", type="uint", format="Color", inherit="yes")]

	/**
	 * timeline scale - vertical lines highlighted color
	 *
	 *  @default 0xCC0000
	 */
	[Style(name="verticalLineHighlightColor", type="uint", format="Color", inherit="yes")]

	/**
	 * timeline scale - vertical lines stroke width
	 *
	 *  @default 0.1
	 */
	[Style(name="verticalLineWidth", type="Number", inherit="no")]

	/**
	 * labels drawing in timeline scale
	 *
	 *  @default true
	 */
	[Style(name="scaleLabel", type="Boolean", inherit="no")]

	/**
	 * timeline scale - labels color
	 *
	 *  @default 0x333333
	 */
	[Style(name="scaleLabelColor", type="uint", format="Color", inherit="yes")]

	/**
	 * timeline scale - skip to draw labels to ease reading
	 *
	 *  @default 1 - no skip
	 */
	[Style(name="labelSkipping", type="uint", inherit="yes")]


	/**
	 * ScheduleVieportPoly component, provide to draw single timescale
	 * with multiple timelines
	 *
	 * <pre>
	 * default properties:
	 *
	 *   backgroundColor = 0xFFFFFF
	 *   backgroundAlpha = 1
	 *   amountBackgroundColor = BehaviorType.COLOR_BACKGROUND_AMOUNT
	 *   descriptionBackgroundColor = BehaviorType.COLOR_BACKGROUND_DESCRIPTION
	 *   paddingTop = 5
	 *   paddingBottom = 5
	 * 	 topSpacing = 35;
	 *   verticalSpacing = 34
	 *   scaleLabel = true
	 *   timelineColorAuto = false
	 *   innerGoliveLabel = true
	 *   verticalLineColor = 0xCCCCCC
	 *   verticalLineHighlightColor = 0xCC0000
	 *   verticalLineWidth = .1
	 *   scaleLabelColor = 0x333333
	 *   labelSkipping = 1
	 *   hover = false
	 *   timeScaleSnap = false
	 *   scaleAuto = false
	 *   heightAuto = false
	 *   behaviorType = date
	 *   goliveScaleOffsetStart = NaN
	 *   goliveScaleOffsetEnd = NaN
	 *   goliveTimeOffsetStart = NaN
	 *   goliveTimeOffsetEnd = NaN
	 *   scaleStart = null
	 *   scaleEnd = null
	 *   timeStart = null
	 *   timeEnd = null
	 * </pre>
	 *
	 *
	 * @includeExample ViewportPolySample.mxml
	 * @includeExample someTimelines_golive_demo.xml
	 * @includeExample ViewportPoly_golive_sample.mxml
	 *
	 * @package nabiro
	 * @playerversion 9
	 * @productversion flex 3.2
	 */
	public class ScheduleViewportPoly extends UIComponent implements IViewportPoly {

		/**
		 * @resource
		 * font used in the components and its child components
		 */
		[Embed(source="/../assets/fonts/uni05_63.ttf", fontName="uni0563")]
		[Bindable]
		public var uni0563:String;

		/**
		 * @private
		 * static styles initializer
		 */
		private static var svpStylesInitialized:Boolean = initilizeStyles();

		/**
		 * @private
		 * array of styles that component can accept
		 */
		private static var styles:Array = [	"backgroundColor",
											"backgroundAlpha",
											"amountBackgroundColor",
											"descriptionBackgroundColor",
											"timeScaleSnap",
											"scaleAuto",
											"heightAuto",
											"paddingTop",
											"paddingBottom",
											"topSpacing",
											"verticalSpacing",
											"timelineColorAuto",
											"innerGoliveLabel",
											"minuteColor",
											"hourColor",
											"dayColor",
											"weekColor",
											"monthColor",
											"amountColor",
											"descriptionColor",
											"verticalLineColor",
											"verticalLineHighlightColor",
											"verticalLineWidth",
											"scaleLabel",
											"scaleLabelColor",
											"labelSkipping"];

		/**
		 * @private
		 * name of the changing style property
		 * @default false
		 */
		private var _propertyStyleChangeName:String = "";

		/**
		 * @private
		 * the presenter object controller
		 */
		private var _presenter:ViewportPoly;

		/**
		 * component background color
		 */
		[Bindable]
		public function get backgroundColor():uint {
			return _presenter.backgroundColor;
		}
		public function set backgroundColor(value:uint):void{
			_presenter.backgroundColor = value;
			setStyle("backgroundColor", value);
		}

		/**
		 * component background alpha
		 */
		[Bindable]
		public function get backgroundAlpha():Number{
			return _presenter.backgroundAlpha;
		}
		public function set backgroundAlpha(value:Number):void {
			_presenter.backgroundAlpha = value;
			setStyle("backgroundAlpha", value);
		}

		/**
		 * background offset y, for amount/description behavior
		 */
		[Bindable]
		public function get backgroundOffsetY():uint{
			return _presenter.backgroundOffsetY;
		}
		public function set backgroundOffsetY(value:uint):void {
			_presenter.backgroundOffsetY = value;
		}

		/**
		 * background height, for amount/description behavior
		 */
		[Bindable]
		public function get backgroundHeight():int{
			return _presenter.backgroundHeight;
		}
		public function set backgroundHeight(value:int):void {
			_presenter.backgroundHeight = value;
		}

		/**
		 * timeline item background color, amount behavior
		 */
		[Bindable]
		public function get amountBackgroundColor():uint {
			return _presenter.amountBackgroundColor;
		}
		public function set amountBackgroundColor(value:uint):void{
			_presenter.amountBackgroundColor = value;
			setStyle("amountBackgroundColor", value);
		}

		/**
		 * timeline item background color, amount behavior
		 */
		[Bindable]
		public function get descriptionBackgroundColor():uint {
			return _presenter.descriptionBackgroundColor;
		}
		public function set descriptionBackgroundColor(value:uint):void{
			_presenter.descriptionBackgroundColor = value;
			setStyle("descriptionBackgroundColor", value);
		}

		/**
		 * draw labels in golive behavior within o out of the bar
		 */
		[Bindable]
		public function get innerGoliveLabel():Boolean {
			return _presenter.innerGoliveLabel;
		}
		public function set innerGoliveLabel(value:Boolean):void {
			_presenter.innerGoliveLabel = value;
			setStyle("innerGoliveLabel", value);
		}

		/**
		 * timele color choosen by user or managed by component
		 */
		[Bindable]
		public function get timelineColorAuto():Boolean {
			return _presenter.timelineColorAuto;
		}
		public function set timelineColorAuto(value:Boolean):void {
			_presenter.timelineColorAuto = value;
			setStyle("timelineColorAuto", value);
		}

		/**
		 * arbitrary timeline bar color
		 */
		[Bindable]
		public function get timelineColor():uint {
			return _presenter.timelineColor;
		}
		public function set timelineColor(value:uint):void {
			_presenter.timelineColor = value;
		}

		/**
		 * hide show selectedIndex timeline
		 */
		[Bindable]
		public function get timelineVisible():Boolean {
			return _presenter.timelineVisible;
		}
		public function set timelineVisible(value:Boolean):void {
			_presenter.timelineVisible = value;
		}


		/**
		 * timeline bar color, timestepping minutes
		 */
		[Bindable]
		public function get minuteColor():uint {
			return _presenter.minuteColor;
		}
		public function set minuteColor(value:uint):void {
			_presenter.minuteColor = value;
			setStyle("minuteColor", value);
		}

		/**
		 * timeline bar color, timestepping hours
		 */
		[Bindable]
		public function get hourColor():uint {
			return _presenter.hourColor;
		}
		public function set hourColor(value:uint):void {
			_presenter.hourColor = value;
			setStyle("hourColor", value);
		}

		/**
		 * timeline bar color, timestepping days
		 */
		[Bindable]
		public function get dayColor():uint {
			return _presenter.dayColor;
		}
		public function set dayColor(value:uint):void {
			_presenter.dayColor = value;
			setStyle("dayColor", value);
		}

		/**
		 * timeline bar color, timestepping weeks
		 */
		[Bindable]
		public function get weekColor():uint {
			return _presenter.weekColor;
		}
		public function set weekColor(value:uint):void {
			_presenter.weekColor = value;
			setStyle("weekColor", value);
		}

		/**
		 * timeline bar color, timestepping months
		 */
		[Bindable]
		public function get monthColor():uint {
			return _presenter.monthColor;
		}
		public function set monthColor(value:uint):void {
			_presenter.monthColor = value;
			setStyle("monthColor", value);
		}

		/**
		 * timeline bar color, amount behavior
		 */
		[Bindable]
		public function get amountColor():uint {
			return _presenter.amountColor;
		}
		public function set amountColor(value:uint):void {
			_presenter.amountColor = value;
			setStyle("amountColor", value);
		}

		/**
		 * timeline bar color, description behavior
		 */
		[Bindable]
		public function get descriptionColor():uint {
			return _presenter.descriptionColor;
		}
		public function set descriptionColor(value:uint):void {
			_presenter.descriptionColor = value;
			setStyle("descriptionColor", value);
		}

		/**
		 * padding between top-background limit and the drawing area
		 */
		[Bindable]
		public function get paddingTop():int{
			return _presenter.paddingTop;
		}
		public function set paddingTop(value:int):void {
			_presenter.paddingTop = value;
			setStyle("paddingTop", value);
		}

		/**
		 * padding between bottom-background limit and the drawing area
		 */
		[Bindable]
		public function get paddingBottom():int{
			return _presenter.paddingBottom;
		}
		public function set paddingBottom(value:int):void {
			_presenter.paddingBottom = value;
			setStyle("paddingBottom", value);
		}

		/**
		 * y space between the timeline and the top limit of the component background
		 */
		[Bindable]
		public function get topSpacing():int {
			return _presenter.topSpacing;
		}
		public function set topSpacing(value:int):void {
			_presenter.topSpacing = value;
			setStyle("topSpacing", value);
		}

		/**
		 * y space between selected timeline and the preceeding
		 */
		[Bindable]
		public function get verticalSpacing():int {
			return _presenter.verticalSpacing;
		}
		public function set verticalSpacing(value:int):void {
			_presenter.verticalSpacing = value;
			setStyle("verticalSpacing", value);
		}

		/**
		 * timeline background offset y, for amount/description behavior
		 */
		[Bindable]
		public function get timelineBackgroundOffsetY():uint {
			return _presenter.timelineBackgroundOffsetY;
		}
		public function set timelineBackgroundOffsetY(value:uint):void {
			_presenter.timelineBackgroundOffsetY = value;
		}

		/**
		 * timeline background height, for amount/description behavior
		 */
		[Bindable]
		public function get timelineBackgroundHeight():int {
			return _presenter.timelineBackgroundHeight;
		}
		public function set timelineBackgroundHeight(value:int):void {
			_presenter.timelineBackgroundOffsetY = value;
		}

		/**
		 * scale vertical lines color
		 */
		[Bindable]
		public function get verticalLineColor():uint {
			return _presenter.verticalLineColor;
		}
		public function set verticalLineColor(value:uint):void {
			_presenter.verticalLineColor = value;
			setStyle("verticalLineColor", value);
		}

		/**
		 * scale highilighted vertical lines color
		 */
		[Bindable]
		public function get verticalLineHighlightColor():uint {
			return _presenter.verticalLineHighlightColor;
		}
		public function set verticalLineHighlightColor(value:uint):void {
			_presenter.verticalLineHighlightColor = value;
			setStyle("verticalLineHighlightColor", value);
		}

		/**
		 * scale vertical lines width
		 */
		[Bindable]
		public function get verticalLineWidth():Number {
			return _presenter.verticalLineWidth;
		}
		public function set verticalLineWidth(value:Number):void {
			_presenter.verticalLineWidth = value;
			setStyle("verticalLineWidth", value);
		}

		/**
		 * toggle scale labels draw
		 */
		[Bindable]
		public function get scaleLabel():Boolean {
			return _presenter.scaleLabel;
		}
		public function set scaleLabel(value:Boolean):void {
			_presenter.scaleLabel = value;
			setStyle("scaleLabel", value);
		}

		/**
		 * scale labels color
		 */
		[Bindable]
		public function get scaleLabelColor():uint {
			return _presenter.scaleLabelColor;
		}
		public function set scaleLabelColor(value:uint):void {
			_presenter.scaleLabelColor = value;
			setStyle("scaleLabelColor", value);
		}

		/**
		 * label to skip draw vs vertical line draw
		 */
		[Bindable]
		public function get labelSkipping():uint {
			return _presenter.labelSkipping;
		}
		public function set labelSkipping(value:uint):void {
			_presenter.labelSkipping = value;
			setStyle("labelSkipping", value);
		}

		/**
		 * snap scale time
		 */
		[Bindable]
		public function get timeScaleSnap():Boolean{
			return _presenter.timeScaleSnap;
		}
		public function set timeScaleSnap(value:Boolean):void {
			_presenter.timeScaleSnap = value;
			setStyle("timeScaleSnap", value);
		}

		/**
		 * auto redraw scale
		 */
		[Bindable]
		public function get scaleAuto():Boolean{
			return _presenter.scaleAuto;
		}
		public function set scaleAuto(value:Boolean):void {
			_presenter.scaleAuto = value;
			setStyle("scaleAuto", value);
		}

		/**
		 * auto adjust height fo n timelines
		 */
		[Bindable]
		public function get heightAuto():Boolean{
			return _presenter.heightAuto;
		}
		public function set heightAuto(value:Boolean):void {
			_presenter.heightAuto = value;
			setStyle("heightAuto", value);
		}

		/**
		 * mouse hovering
		 */
		[Bindable]
		public function get hover():Boolean {
			return _presenter.hover;
		}
		public function set hover(value:Boolean):void {
			_presenter.hover = value;
		}

		/**
		 * current timelineItem index
		 */
		[Bindable]
		public function get selectedIndex():uint {
			return _presenter.selectedIndex;
		}
		public function set selectedIndex(value:uint):void {
			_presenter.selectedIndex = value;
		}

		/**
		 * name of the selected timelineItem
		 */
		public function get timelineID():String {
			return _presenter.timelineID;
		}

		/**
		 * count of timelineItem, component provide alway at least 1 timelineItem
		 */
		public function get numTimelines():uint {
			return _presenter.numTimelines;
		}

		/**
		 * behavior draw policy
		 * <p>
		 * this is a key feature, it affects most of the visualizations
		 * possibile values:
		 * <ul>
		 * <li>date - render an absolute time scale and ALL relevant timelines</li>
		 * <li>golive - render a relative time scale for an ipothetic "go-live" instant
		 * and ALL relevant timelines</li>
		 * <li>amount - affects selected timeline to render an amount on its private scale</li>
		 * <li>description - affects selected timeline to render a text description</li>
		 * </ul>
		 * NOTE: the component always return behaviorType date or golive, since scale refers always to these behavior
		 * </p>
		 */
		[Bindable]
		public function get behaviorType():String {
			return _presenter.behaviorType;
		}
		public function set behaviorType(value:String):void {
			_presenter.behaviorType = value;
		}

		/**
		 * behavior draw policy, applies to selected timeline
		 */
		public function get timelineBehaviorType():String {
			return _presenter.timelineBehaviorType;
		}
		public function set timelineBehaviorType(value:String):void {
			_presenter.timelineBehaviorType = value;
		}

		/**
		 * used in golive context to define scale start offset
		 * unit measure is milliseconds
		 */
		[Bindable]
		public function get goliveScaleOffsetStart():Number {
			return _presenter.goliveScaleOffsetStart;
		}
		public function set goliveScaleOffsetStart(value:Number):void {
			_presenter.goliveScaleOffsetStart = value;
		}

		/**
		 * used in golive context to define scale end offset
		 * unit measure is milliseconds
		 */
		[Bindable]
		public function get goliveScaleOffsetEnd():Number {
			return _presenter.goliveScaleOffsetEnd;
		}
		public function set goliveScaleOffsetEnd(value:Number):void {
			_presenter.goliveScaleOffsetEnd = value;
		}

		/**
		 * used in golive context to define time start offset
		 * unit measure is milliseconds
		 */
		[Bindable]
		public function get goliveTimeOffsetStart():Number {
			return _presenter.goliveTimeOffsetStart;
		}
		public function set goliveTimeOffsetStart(value:Number):void {
			_presenter.goliveTimeOffsetStart = value;
		}

		/**
		 * used in golive context to define time end offset
		 * unit measure is milliseconds
		 */
		[Bindable]
		public function get goliveTimeOffsetEnd():Number {
			return _presenter.goliveTimeOffsetEnd;
		}
		public function set goliveTimeOffsetEnd(value:Number):void {
			_presenter.goliveTimeOffsetEnd = value;
		}

		/**
		 * scale window from date
		 */
		[Bindable]
		public function get scaleStart():Date {
			return _presenter.scaleStart;
		}
		public function set scaleStart(value:Date):void {
			_presenter.scaleStart = value;
		}

		/**
		 * scale window to date
		 */
		[Bindable]
		public function get scaleEnd():Date {
			return _presenter.scaleEnd;
		}
		public function set scaleEnd(value:Date):void {
			_presenter.scaleEnd = value;
		}

		/**
		 * timeline from date
		 */
		[Bindable]
		public function get timeStart():Date {
			return _presenter.timeStart;
		}
		public function set timeStart(value:Date):void {
			_presenter.timeStart = value;
		}

		/**
		 * timeline to date
		 */
		[Bindable]
		public function get timeEnd():Date {
			return _presenter.timeEnd;
		}
		public function set timeEnd(value:Date):void {
			_presenter.timeEnd = value;
		}

		/**
		 * time rotation "mode" in period behavior
		 */
		[Bindable]
		public function get periodScaleMode():String {
			return _presenter.periodScaleMode;
		}
		public function set periodScaleMode(value:String):void {
			_presenter.periodScaleMode = value;
		}

		/**
		 * time "mode" in period behavior
		 */
		[Bindable]
		public function get periodMode():String {
			return _presenter.periodMode;
		}
		public function set periodMode(value:String):void {
			_presenter.periodMode = value;
		}

		/**
		 * start index in period behavior
		 */
		[Bindable]
		public function get periodIndex():uint {
			return _presenter.periodIndex;
		}
		public function set periodIndex(value:uint):void {
			_presenter.periodIndex = value;
		}

		/**
		 * units of time duration in period behavior
		 */
		[Bindable]
		public function get periodDuration():uint {
			return _presenter.periodDuration;
		}
		public function set periodDuration(value:uint):void {
			_presenter.periodDuration = value;
		}

		/**
		 * amount
		 */
		public function get amount():int {
			return _presenter.amount;
		}
		public function set amount(value:int):void {
			_presenter.amount = value;
		}

		/**
		 * description
		 */
		public function get description():String {
			return _presenter.description;
		}
		public function set description(value:String):void {
			_presenter.description = value;
		}


		//-----------------------------------------------

		/**
		 * the constructor
		 */
		function ScheduleViewportPoly() {
			_presenter = new ViewportPoly(this);
		}

		/**
		 * @private
		 * initialize css styles
		 * @return
		 */
		private static function initilizeStyles():Boolean {

			if (!StyleManager.getStyleDeclaration("ScheduleViewportPoly")) {

				var svpStyles:CSSStyleDeclaration = new CSSStyleDeclaration();

				svpStyles.defaultFactory = function():void {

                    this.backgroundColor = 0xFF0000;
                    this.timelineBackgroundOffsetY = 5;
                    this.backgroundAlpha = 1;
                    this.amountBackgroundColor = BehaviorType.COLOR_BACKGROUND_AMOUNT;
                    this.descriptionBackgroundColor = BehaviorType.COLOR_BACKGROUND_DESCRIPTION;
                    this.timeScaleSnap = false;
                    this.scaleAuto = false;
                    this.heightAuto = false;
                    this.paddingTop = 5;
                    this.paddingBottom = 5;
                    this.topSpacing = 35;
                    this.verticalSpacing = 34;
                    this.timelineColorAuto = false;
                    this.innerGoliveLabel = true;
                    this.minuteColor = DateUtil.COLOR_MINUTE;
                    this.hourColor = DateUtil.COLOR_HOUR;
                    this.dayColor = DateUtil.COLOR_DAY;
                    this.weekColor = DateUtil.COLOR_WEEK;
                    this.monthColor = DateUtil.COLOR_MONTH;
                    this.amountColor = BehaviorType.COLOR_AMOUNT;
                    this.descriptionColor = BehaviorType.COLOR_DESCRIPTION;
                    this.verticalLineColor = 0xCCCCCC;
                    this.verticalLineHighlightColor = 0xCC0000;
                    this.verticalLineWidth = .1;
                    this.scaleLabel = true;
                    this.scaleLabelColor = 0x333333;
                    this.labelSkipping = 1;
				}

				StyleManager.setStyleDeclaration("ScheduleViewportPoly", svpStyles, true);

            }

			return true;
        }

		/**
		 * @protected
		 * set minimum component size, w150 h70
		 * @return
		 */
		protected override function measure():void {

			super.measure();

			measuredWidth = 150;
			measuredMinWidth = 150;
			measuredHeight = 70;
			measuredMinHeight = 60;
		}

		/**
		 * @protected
		 * redraw the component when style is applied
		 * @param
		 * @param
		 * @return
		 */
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {

			super.updateDisplayList(unscaledWidth, unscaledHeight);

			width = unscaledWidth;
			height = unscaledHeight;

	    	if(_propertyStyleChangeName.length){

	    		if(_presenter[_propertyStyleChangeName] != getStyle(_propertyStyleChangeName)){

	    			_presenter[_propertyStyleChangeName] = getStyle(_propertyStyleChangeName);
	    		}

		    	_propertyStyleChangeName = "";
		    }
	    	else {

		    	for each(var style:String in styles){

		    		if(_presenter[style] != getStyle(style) && getStyle(style) != undefined){
		    			_presenter[style] = getStyle(style);
		    		}
		    	}
	    	}

	    	_presenter.redraw();
		}

		/**
		 * intercept style assign, check if style is in list and provides to apply
		 * @param property style name to change
		 * @return
		 */
		public override function styleChanged(styleProp:String):void {

			super.styleChanged(styleProp);

			trace(styleProp);

			if(styleProp && StringUtil.in_array(styleProp, styles)){

		    	_propertyStyleChangeName = styleProp;
		    	invalidateDisplayList();
		    }
		}

		/**
		 * change the scale limit using min or max timeStart/timeEnd in timelines,
		 * in behavior date
		 * @param use timeStart or timeEnd, default timeStart
		 * @param use minimum or maximum date, default minimum
		 * @return
		 */
		public function fitScaleLimit(startEnd:Boolean = true, minMax:Boolean = true):void {
			_presenter.fitScaleLimit(startEnd, minMax);
		}

		/**
		 * add a Timeline, update selectedIndex to reflect the addition
		 * @param start date
		 * @param end date
		 * @param Y spacing from the preceeding timeline
		 * @return name of the new timelineItem
		 */
		public function addTimeline(tlStart:Date = null, tlEnd:Date = null):String {
			return _presenter.addTimeline(tlStart, tlEnd);
		}

		/**
		 * update selectedIndex from the given timelineItem nam
		 * @param timelineItem name/string ID
		 * @return selectedIndex or -1 if not found
		 */
		public function setSelectedIndexById(timelineID:String):int {
			return _presenter.setSelectedIndexById(timelineID);
		}

		/**
		 * remove selected timeline, restore selectedIndex to 0
		 * @return
		 */
		public function removeTimeline():void {
			_presenter.removeTimeline();
		}

		/**
		 * remove timeline from given name/string id, restore selectedIndex to 0
		 * @return
		 */
		public function removeTimelineById(timelineID:String):void {
			_presenter.removeTimelineById(timelineID);
		}

		/**
		 * remove all the timelines, create a first new TimelineItem ready to receive data
		 * @return
		 */
		public function removeAllTimelines():void {
			_presenter.removeAllTimelines();
		}

		/**
		 * force complete redraw of the component, this method is intended as optional
		 * @return
		 */
		public function redraw():void {
			_presenter.redraw();
		}
	}
}