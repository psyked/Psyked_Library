package com.gnstudio.nabiro.air.utilities.events
{
	
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
	 *
	 *
	 *   @package  nabiro
	 *
	 *   @version  0.9
	 *   @idea maker 			Giorgio Natili [ g.natili@gnstudio.com ]
	 *   @author 					Ivan Varga <ivan.varga@gnstudio.com>
	 *   
	 *	 
	 */
	
	import flash.events.Event;
	import flash.filesystem.File;

	public class VolumesWatcherEvent extends Event {
		
		public static const VOLUME_ADDED:String = "onVolumeAdded";
		public static const VOLUME_REMOVED:String = "onVolumeRemoved";
		
		public var file:File;
		
		public function VolumesWatcherEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event {
			
			var c:VolumesWatcherEvent = new VolumesWatcherEvent(type, bubbles, cancelable);
			
			c.file = file;
			
			return c;
		}
	}
}