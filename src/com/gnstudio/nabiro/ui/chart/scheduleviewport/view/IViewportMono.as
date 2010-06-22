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

	import mx.core.IUIComponent;

	/**
	 * interface for ViewportMono component
	 *
	 * @package nabiro
	 * @playerversion 9
	 * @productversion flex 3.2
	 */
	public interface IViewportMono {

		/**
		 * component background color
		 */
		function get backgroundColor():uint;
		function set backgroundColor(value:uint):void;

		/**
		 * component background alpha
		 */
		function set backgroundAlpha(value:Number):void;
		function get backgroundAlpha():Number;

		/**
		 * selected timeline background height in amount/description behavior
		 */
		function get backgroundOffsetY():uint;
		function set backgroundOffsetY(value:uint):void;

		/**
		 * selected timeline background height in amount/description behavior
		 */
		function get backgroundHeight():int;
		function set backgroundHeight(value:int):void;

		/**
		 * draw labels in golive behavior within o out of the bar
		 */
		function get innerGoliveLabel():Boolean;
		function set innerGoliveLabel(value:Boolean):void;

		/**
		 * timeline color choosen by user or managed by component
		 */
		function get timelineColorAuto():Boolean;
		function set timelineColorAuto(value:Boolean):void;

		/**
		 * arbitrary timeline bar color
		 */
		function get timelineColor():uint;
		function set timelineColor(value:uint):void;

		/**
		 * timeline bar color, timestepping minutes
		 */
		 function get minuteColor():uint;
		 function set minuteColor(value:uint):void;

		/**
		 * timeline bar color, timestepping hours
		 */
		 function get hourColor():uint;
		 function set hourColor(value:uint):void;

		/**
		 * timeline bar color, timestepping days
		 */
		 function get dayColor():uint;
		 function set dayColor(value:uint):void;

		/**
		 * timeline bar color, timestepping weeks
		 */
		 function get weekColor():uint;
		 function set weekColor(value:uint):void;

		/**
		 * timeline bar color, timestepping months
		 */
		 function get monthColor():uint;
		 function set monthColor(value:uint):void;

		/**
		 * timeline bar color, amount behavior
		 */
		function get amountColor():uint;
		function set amountColor(value:uint):void;

		/**
		 * timeline bar color, description behavior
		 */
		function get descriptionColor():uint;
		function set descriptionColor(value:uint):void;

		/**
		 * padding between top-background limit and the drawing area
		 */
		function get paddingTop():int;
		function set paddingTop(value:int):void;

		/**
		 * padding between bottom-background limit and the drawing area
		 */
		function get paddingBottom():int;
		function set paddingBottom(value:int):void;

		/**
		 * y space between the timeline and the top limit of the component background
		 */
		function get topSpacing():int;
		function set topSpacing(value:int):void;

		/**
		 * scale vertical lines color
		 */
		function get verticalLineColor():uint;
		function set verticalLineColor(value:uint):void;

		/**
		 * scale highilighted vertical lines color
		 */
		function get verticalLineHighlightColor():uint;
		function set verticalLineHighlightColor(value:uint):void;

		/**
		 * scale vertical lines width
		 */
		function get verticalLineWidth():Number;
		function set verticalLineWidth(value:Number):void;

		/**
		 * toggle scale labels draw
		 */
		function get scaleLabel():Boolean;
		function set scaleLabel(value:Boolean):void;

		/**
		 * scale labels color
		 */
		function get scaleLabelColor():uint;
		function set scaleLabelColor(value:uint):void;

		/**
		 * label to skip draw vs vertical line draw
		 */
		function get labelSkipping():uint;
		function set labelSkipping(value:uint):void;

		/**
		 * mouse hovering
		 */
		function get hover():Boolean;
		function set hover(value:Boolean):void;

		/**
		 * snap scale time
		 */
		function get timeScaleSnap():Boolean;
		function set timeScaleSnap(value:Boolean):void;

		/**
		 * auto redraw scale
		 */
		function get scaleAuto():Boolean;
		function set scaleAuto(value:Boolean):void;

		/**
		 * draw policy
		 */
		function get behaviorType():String;
		function set behaviorType(value:String):void;

		/**
		 * used in golive context to define scale start offset
		 * unit measure is milliseconds
		 */
		function get goliveScaleOffsetStart():Number;
		function set goliveScaleOffsetStart(value:Number):void;

		/**
		 * used in golive context to define scale end offset
		 * <br />unit of measure: milliseconds
		 * <br />note: to ensure golive is always into the scale, this value must be >= 0
		 */
		function get goliveScaleOffsetEnd():Number;
		function set goliveScaleOffsetEnd(value:Number):void;

		/**
		 * used in golive context to define time start offset
		 * <br />unit of measure: milliseconds
		 * <br />note: to ensure golive is always into the scale, this value must be >= 0
		 */
		function get goliveTimeOffsetStart():Number;
		function set goliveTimeOffsetStart(value:Number):void;

		/**
		 * used in golive context to define time end offset
		 * unit measure is milliseconds
		 */
		function get goliveTimeOffsetEnd():Number;
		function set goliveTimeOffsetEnd(value:Number):void;

		/**
		 * scale window from date
		 */
		function get scaleStart():Date;
		function set scaleStart(value:Date):void;

		/**
		 * scale window to date
		 */
		function get scaleEnd():Date;
		function set scaleEnd(value:Date):void;

		/**
		 * timeline from date
		 */
		function get timeStart():Date;
		function set timeStart(value:Date):void;

		/**
		 * timeline to date
		 */
		function get timeEnd():Date;
		function set timeEnd(value:Date):void;

		/**
		 * time rotation "mode" in period behavior
		 */
		function get periodScaleMode():String;
		function set periodScaleMode(value:String):void;

		/**
		 * start index in period behavior
		 */
		function get periodIndex():uint;
		function set periodIndex(value:uint):void;

		/**
		 * units of time duration in period behavior
		 */
		function get periodDuration():uint;
		function set periodDuration(value:uint):void;

		/**
		 * amount
		 */
		 function get amount():int;
		 function set amount(value:int):void;

		/**
		 * description
		 */
		 function get description():String;
		 function set description(value:String):void;

		/**
		 * force to redraw the component
		 */
		function redraw():void;
	}
}