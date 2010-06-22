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

	import com.gnstudio.nabiro.ui.chart.scheduleviewport.presenter.ViewportMono;


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
	 *  mouse hovering
	 *
	 *  @default false
	 */
	[Style(name="hover", type="Boolean", inherit="no")]

	/**
	 *  y coordinate of the timeline item from the top limit of the component
	 *
	 *  @default 35
	 */
	[Style(name="topSpacing", type="Number", format="length", inherit="no")]

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
	 * ScheduleVieportMono component<br />
	 * provide to show a single timescale and single timeline
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
	 * 	 topSpacing = 35
	 * 	 timelineColorAuto = false
	 *   innerGoliveLabel = true
	 *   scaleLabel = true
	 *   verticalLineColor = 0xCCCCCC
	 *   verticalLineHighlightColor = 0xCC0000
	 *   verticalLineWidth = .1
	 *   scaleLabelColor = 0x333333
	 *   labelSkipping = 1
	 *   hover = false
	 *   timeScaleSnap = false
	 *   scaleAuto = false
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
	 * @includeExample someTimelinesDemo.xml
	 * @includeExample ViewportMonoSample.mxml
	 * @includeExample someTimelines_golive_demo.xml
	 * @includeExample ViewportMono_golive_sample.mxml
	 *
	 * @package nabiro
	 * @playerversion 9
	 * @productversion flex 3.2
	 */
	public class ScheduleViewportMono extends UIComponent implements IViewportMono {


		//--------------------------------------
		//  Fields
		//--------------------------------------

		/**
		 * @resource
		 * font used for the component and child components
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
											"timeScaleSnap",
											"scaleAuto",
											"hover",
											"paddingTop",
											"paddingBottom",
											"topSpacing",
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
		private var _presenter:ViewportMono;


		//--------------------------------------
		//  getters/setters
		//--------------------------------------

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
		 * timeline color choosen by user or managed by component
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
		 * mouse hovering
		 */
		[Bindable]
		public function get hover():Boolean {
			return _presenter.hover;
		}
		public function set hover(value:Boolean):void {
			_presenter.hover = value;
			setStyle("hover", value);
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
		 * behavioral draw policy
		 */
		[Bindable]
		public function get behaviorType():String {
			return _presenter.behaviorType;
		}
		public function set behaviorType(value:String):void {
			_presenter.behaviorType = value;
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
		function ScheduleViewportMono() {

			super();

			_presenter = new ViewportMono(this);
		}

		/**
		 * @private
		 * initialize css styles, TODO: complete
		 * @return
		 */
		private static function initilizeStyles():Boolean {

			if (!StyleManager.getStyleDeclaration("ScheduleViewportMono")) {

				var svpStyles:CSSStyleDeclaration = new CSSStyleDeclaration();

				svpStyles.defaultFactory = function():void {

                    this.paddingTop = 5;
                    this.paddingBottom = 5;
                    this.backgroundColor = 0xFFFFFF;
                    this.topSpacing = 35;
                }

				StyleManager.setStyleDeclaration("ScheduleViewportMono", svpStyles, true);

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
            measuredMinHeight = 70;
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
		 * force complete component redraw, its use is intended as optional
		 */
		public function redraw():void {
			_presenter.redraw();
		}
	}
}
