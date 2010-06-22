package com.gnstudio.nabiro.services.model
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
	
	[Bindable]
	public class Photo{
		
		/**
		 * Photo ID
		 */ 
		private var _id:String;
		
		public function get id():String{
			
			return _id;
			
		}
		
		public function set id(value:String):void{
			
			_id = value;
			
		}
		
		/**
		 * Photo name
		 */ 
		private var _name:String;
		
		public function get name():String{
			
			return _name;
			
		}
		
		public function set name(value:String):void{
			
			_name = value;
			
		}
		
		/**
		 * Photo original
		 */ 
		private var _original:String;
		
		public function get original():String{
			
			return _original;
			
		}
		
		public function set original(value:String):void{
			
			_original = value;
			
		}
		
		/**
		 * Photo thumb
		 */ 
		private var _thumbnail:String;
		
		public function get thumbnail():String{
			
			return _thumbnail;
			
		}
		
		public function set thumbnail(value:String):void{
			
			_thumbnail = value;
			
		}
		
		/**
		 * Photo preview
		 */ 
		private var _preview:String;
		
		public function get preview():String{
			
			return _preview;
			
		}
		
		public function set preview(value:String):void{
			
			_preview = value;
			
		}
		
		/**
		 * Constructor
		 */ 
		 
		public function Photo(){
			
			// Do nothing
			
		}

	}
}