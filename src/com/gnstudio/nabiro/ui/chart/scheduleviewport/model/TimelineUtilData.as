package com.gnstudio.nabiro.ui.chart.scheduleviewport.model {

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

	import com.gnstudio.nabiro.utilities.DateUtil;

	/**
	 * Some timeline utility methods, intended to be used by TimelineItem class
	 *
	 *
	 * @package nabiro
	 * @playerversion 9
	 * @productversion flex 3.2
	 */
	public class TimelineUtilData {

		/**
		 * scale start in milliseconds
		 */
		public var scaleStartMsec:Number;

		/**
		 * scale end in milliseconds
		 */
		public var scaleEndMsec:Number;

		/**
	 	* time start in milliseconds
	 	*/
		public var timeStartMsec:Number;


		/**
		 * time start in milliseconds
		 */
		public var timeEndMsec:Number;

		/**
		 * scale duration in milliseconds
		 */
		public var baseDuration:Number;

		/**
		 * timeline duration in milliseconds
		 */
		public var tlDuration:Number;

		/**
		 * timeline duration vs scale start in milliseconds
		 */
		public var startDuration:Number;

		/**
		 * x step to compute timeline width
		 */
		public var stepX:Number;

		/**
		 * number of steps in scale
		 */
		public var steps:Number;

		/**
		 * timeline bar x coordinate
		 */
		public var offsetX:uint = 20;

		/**
		 * timeline width
		 */
		public var timelineWidth:Number;

		/**
		 * a reference step from timeStepping, used to apply the correct time calculus
		 */
		public var msec:uint;


		/**
		 * the constructor
		 * @param scale start
		 * @param scale end
		 * @param time start
		 * @param time end
		 * @param the time base (week, day, hour)
		 * @param viewport width
		 */
		public function TimelineUtilData(scaleStart:Date, scaleEnd:Date, timeStart:Date, timeEnd:Date, timeStepping:String, width:int) {

			scaleStartMsec = scaleStart.getTime();
			scaleEndMsec = scaleEnd.getTime();
			timeStartMsec = timeStart.getTime();
			timeEndMsec = timeEnd.getTime();

			timelineWidth = width - 40;
			msec = DateUtil.getTimeFromStepping(timeStepping);

			baseDuration = scaleEndMsec - scaleStartMsec;
			tlDuration = timeEndMsec - timeStartMsec;
			stepX = (width - 40) / baseDuration;
			steps = Math.round(baseDuration / msec);
			startDuration = timeStartMsec - scaleStartMsec;

			timelineWidth = tlDuration * stepX;
		}
	}

}