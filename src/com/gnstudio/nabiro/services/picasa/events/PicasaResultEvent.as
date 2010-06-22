package com.gnstudio.nabiro.services.picasa.events
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
	 *   @author 					Giorgio Natili [ g.natili@gnstudio.com ]
	 *   
	 *	 
	 */
	 
	import flash.events.Event;
	
	public class PicasaResultEvent extends Event{
		
		
		public static var LOGIN_SUCCESS:String = 'onLoginSucces';
		public static var LOGIN_FAULT:String = 'onLoginFault';
		public static var ALBUM_DATA:String = 'onAlbumData';
		public static var NO_ALBUM_DATA:String = 'onNoAlbumData';
		public static var ALBUM_DETAILS:String = 'onAlbumDetails';
		public static var NO_ALBUM_DETAILS:String = 'onNoAlbumDetails';
		public static var CALL_ERROR:String = 'onCallError';
		
		public function PicasaResultEvent(type:String){
			
			super(type, false, false);
			
		}
		
		public override function clone():Event {
			
			return new PicasaResultEvent(type);
			
		}

		public override function toString():String {
			
			return formatToString("PicasaResultEvent", "type", "bubbles", "cancelable", "eventPhase");
									
		}	

	}
}