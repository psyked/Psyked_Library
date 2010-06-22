/**

Copyright (c) 2006. Adobe Systems Incorporated.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

  * Redistributions of source code must retain the above copyright notice,
    this list of conditions and the following disclaimer.
  * Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.
  * Neither the name of Adobe Systems Incorporated nor the names of its
    contributors may be used to endorse or promote products derived from this
    software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.

jaco_at_pixeldump: extended methods and fields

@ignore
*/

package com.gnstudio.nabiro.utilities {

	/**
	 * Some static methods and date relevant stuff
	 * <br />this class is based to flexlib
	 *
	 *
	 * @package nabiro
	 * @playerversion 9
	 * @productversion flex 3.2
	 */
	public class DateUtil {

		public static const GO_LIVE_MSEC:Number = new Date("2000/01/01").getTime();
		public static const DAYS_WEEK:Array = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"];

		public static const STEPPING_YEAR:String = "year";
		public static const STEPPING_MONTH:String = "month";
		public static const STEPPING_WEEK:String = "week";
		public static const STEPPING_DAY:String = "day";
		public static const STEPPING_HOUR:String = "hour";
		public static const STEPPING_MINUTE:String = "minute";

		public static const COLOR_MONTH:uint = 0x000099;
		public static const COLOR_WEEK:uint = 0x009999;
		public static const COLOR_DAY:uint = 0x009933;
		public static const COLOR_HOUR:uint = 0x669933;
		public static const COLOR_MINUTE:uint = 0x999933;

		public static const MINUTE_IN_MILLISECONDS : Number = 60 * 1000;
		public static const HOUR_IN_MILLISECONDS : Number = 60 * 60 * 1000;
		public static const DAY_IN_MILLISECONDS : Number = 24 * 60 * 60 * 1000;
		public static const WEEK_IN_MILLISECONDS : Number = 7 * 24 * 60 * 60 * 1000;
		public static const MONTH_IN_MILLISECONDS : Number = 30 * 24 * 60 * 60 * 1000;
		public static const YEAR_IN_MILLISECONDS : Number = 12 * 30 * 24 * 60 * 60 * 1000;
		public static const CENTURY_IN_MILLISECONDS : Number = 100 * 12 * 30 * 24 * 60 * 60 * 1000;
		public static const MILLENIUM_IN_MILLISECONDS : Number = 1000 * 100 * 12 * 30 * 24 * 60 * 60 * 1000;

		/**
		 * return a string label in short weekly day format
		 * @param monthIndex
		 * @return
		 */
		public static function getLabelForMonth(monthIndex:uint):String {

			var monthLabels:Array = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

			if(monthIndex < monthLabels.length) return monthLabels[monthIndex];

			return monthLabels[monthLabels.length % monthIndex];
		}

		/**
		 * return a string label in cardinal order
		 * @param weekIndex
		 * @return
		 */
		public static function getLabelForWeek(weekIndex:uint):String {

			var weekLabels:Array = ["1st", "2nd", "3rd"];

			if(weekIndex < weekLabels.length) return weekLabels[weekIndex];

			return weekLabels[weekLabels.length % weekIndex];
		}

		/**
		 * return a string label
		 * @param weekIndex
		 * @return
		 */
		public static function getLabelForDayWeek(weekIndex:uint):String {

			var weekLabels:Array = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

			return weekLabels[(weekIndex % 7)];
		}

		/**
		 * return a string label, day date for the given date
		 * @param date
		 * @return
		 */
		public static function getLabelForDay(date:Date):String {
			return DAYS_WEEK[date.getDay() % 7];
		}


		/**
		 * return uint from given the time stepping
		 * @param timeStepping
		 * @return
		 */
		public static function getTimeFromStepping(timeStepping:String):uint {

			if(timeStepping == DateUtil.STEPPING_MONTH) return DateUtil.MONTH_IN_MILLISECONDS;
			if(timeStepping == DateUtil.STEPPING_WEEK) return DateUtil.WEEK_IN_MILLISECONDS;
			if(timeStepping == DateUtil.STEPPING_DAY) return DateUtil.DAY_IN_MILLISECONDS;
			if(timeStepping == DateUtil.STEPPING_HOUR) return DateUtil.HOUR_IN_MILLISECONDS;
			if(timeStepping == DateUtil.STEPPING_MINUTE) return DateUtil.MINUTE_IN_MILLISECONDS;

			return 0;
		}

		/**
		 * return relevant color legenda from the given time stepping
		 * @param timeStepping
		 * @return
		 */
		public static function getColorFromStepping(timeStepping:String):uint {

			if(timeStepping == DateUtil.STEPPING_MONTH) return DateUtil.COLOR_MONTH;
			if(timeStepping == DateUtil.STEPPING_WEEK) return DateUtil.COLOR_WEEK;
			if(timeStepping == DateUtil.STEPPING_DAY) return DateUtil.COLOR_DAY;
			if(timeStepping == DateUtil.STEPPING_HOUR) return DateUtil.COLOR_HOUR;
			if(timeStepping == DateUtil.STEPPING_MINUTE) return DateUtil.COLOR_MINUTE;

			return 0;
		}

		/**
		 * returns the string label representing "time gap", e.g.: 2w3d1h30m
		 * @param time period duration
		 * @return
		 */
		public static function getTimeGap(duration:Number):String {

			var restDuration:Number = duration;
			var str:String = "";
			var weeks:Number = 0;
			var days:Number = 0;
			var hours:Number = 0;
			var minutes:Number = 0;

			weeks = Math.floor(duration / DateUtil.WEEK_IN_MILLISECONDS);

			if(weeks) str += "" +weeks +"w ";

			restDuration -= weeks * DateUtil.WEEK_IN_MILLISECONDS;
			days = Math.floor(restDuration / DateUtil.DAY_IN_MILLISECONDS);

			if(days) str += "" +days +"d ";

			restDuration -= days * DateUtil.DAY_IN_MILLISECONDS;
			hours = Math.floor(restDuration / DateUtil.HOUR_IN_MILLISECONDS);

			if(hours) str += "" +hours +"h ";

			restDuration -= hours * DateUtil.HOUR_IN_MILLISECONDS;
			minutes = Math.floor(restDuration / DateUtil.MINUTE_IN_MILLISECONDS);

			if(minutes) str += "" +minutes + "m ";

			return str;
		}

		/**
		 * cleanup the date
		 * @param date
		 * @return
		 */
		public static function clearTime( date : Date ) : Date
		{
			date.hours = 0;
			date.minutes = 0;
			date.seconds = 0;
			date.milliseconds = 0;

			return date;
		}

		/**
		 * copy a date to another
		 * @param date
		 * @return
		 */
		public static function copyDate( date : Date ) : Date
		{
			return new Date( date.getTime() );
		}

		/**
		 * set a date from given date and time
		 * @param date
		 * @param time
		 * @return
		 */
		public static function setTime( date : Date, time : Number ) : Date
		{
			date.hours = Math.floor(( time / (1000 * 60 * 60)) % 24);
			date.minutes = Math.floor(( time / (1000 * 60)) % 60);
			date.seconds = Math.floor(( time / 1000) % 60);
			date.milliseconds = Math.floor( time % 1000);

			return date;
		}

		/**
		 * add time to the given date
		 * @param date
		 * @param time
		 * @return
		 */
		public static function addTime( date : Date, time : Number ) : Date
		{
			date.milliseconds += time;

			return date;
		}
	}
}