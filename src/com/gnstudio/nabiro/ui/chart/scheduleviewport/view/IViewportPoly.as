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
	 * interface for ViewportPoly component
	 *
	 * @package nabiro
	 * @playerversion 9
	 * @productversion flex 3.2
	 */
	public interface IViewportPoly extends IViewportMono {

		/**
		 * behavior draw policy, applies to selected timeline
		 */
		function get timelineBehaviorType():String;
		function set timelineBehaviorType(value:String):void;

		/**
		 * selected timeline visibility
		 */
		function get timelineVisible():Boolean;
		function set timelineVisible(value:Boolean):void;

		/**
		 * timeline item background color, amount behavior
		 */
		function get amountBackgroundColor():uint;
		function set amountBackgroundColor(value:uint):void;

		/**
		 * timeline item background color, amount behavior
		 */
		function get descriptionBackgroundColor():uint;
		function set descriptionBackgroundColor(value:uint):void;

		/**
		 * timeline background offset y, for amount/description behavior
		 */
		function get timelineBackgroundOffsetY():uint;
		function set timelineBackgroundOffsetY(value:uint):void;

		/**
		 * timeline background height, for amount/description behavior
		 */
		function get timelineBackgroundHeight():int;
		function set timelineBackgroundHeight(value:int):void;

		/**
		 * Y space between current timeline and the preceding
		 */
		function get verticalSpacing():int;
		function set verticalSpacing(value:int):void;

		/**
		 * auto adjust height fo n timelines
		 */
		function get heightAuto():Boolean;
		function set heightAuto(value:Boolean):void;

		/**
		 * specific timeline time "mode" in period behavior
		 */
		function get periodMode():String;
		function set periodMode(value:String):void;

		/**
		 * name of the selected timelineItem
		 */
		function get timelineID():String;

		/**
		 * change the scale limit using min or max timeStart/timeEnd in timelines,
		 * in behavior date
		 * @param use timeStart or timeEnd, default timeStart
		 * @param use minimum or maximum date, default minimum
		 * @return
		 */
		function fitScaleLimit(startEnd:Boolean = true, minMax:Boolean = true):void;

		/**
		 * add a Timeline, update selectedIndex to reflect the addition
		 * @param start date
		 * @param end date
		 * @param Y spacing from the preceeding timeline
		 * @return name of the new timelineItem
		 */
		function addTimeline(tlStart:Date = null, tlEnd:Date = null):String;

		/**
		 * update selectedIndex from the given timelineItem nam
		 * @param timelineItem name/string ID
		 * @return selectedIndex or -1 if not found
		 */
		function setSelectedIndexById(timelineID:String):int;

		/**
		 * remove selected timeline, restore selectedIndex to 0
		 * @return
		 */
		function removeTimeline():void;

		/**
		 * remove timeline from given name/string id, restore selectedIndex to 0
		 * <br />redraw timelines
		 * @return
		 */
		function removeTimelineById(timelineID:String):void;

		/**
		 * remove all the timelines, create a new timelineItem ready receive data
		 * @return
		 */
		function removeAllTimelines():void;
	}
}