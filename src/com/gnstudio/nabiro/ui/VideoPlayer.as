package com.gnstudio.nabiro.ui
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
	 *   @author 				Giorgio Natili [ g.natili@gnstudio.com ]
	 *   @request maker 		Fabio Biondi [ f.biondi@gnstudio.com ]
	 *	 
	 */
	
	import flash.events.Event;
	
	import mx.controls.VideoDisplay;
	import mx.core.mx_internal;
	
	public class VideoPlayer extends VideoDisplay{
		
		public function VideoPlayer(){
			
			super();
			
			this.addEventListener("playheadTimeChanged", test);
			
		}
		
		private function test(e:Event):void{
			
			trace("calling")
			e.stopImmediatePropagation()
			
		}
		
		public function clear():void{
			
			mx_internal.clear()
			
		}
		
	}
	
}