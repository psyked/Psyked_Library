package com.gnstudio.nabiro.ui.vo
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
	 
	import com.gnstudio.nabiro.utilities.IDataDecorator;
	
	public class SmartRenderData implements IDataDecorator{

		/**
		 * Use this class in order to render data inside variable row
		 * list keeping save the status of the item rendere without 
		 * affecting the data
		 */
		
		public function SmartRenderData(s:String = "", d:Object = null){
			
			_state = s;
			_renderData = d;
			
		}
		
		/**
		 * The state of the renderer without any attention to the data it stores
		 */ 
		private var _state:String;
		
		public function get state():String{
			
			return _state;
			
		}
		
		public function set state(value:String):void{
			
			_state = value;
			
		}
		
		/**
		 * The data stored for the visualisation of an item render
		 */ 
		private var _renderData:Object;
		
		[Bindable]
		public function get renderData():Object{
			
			return _renderData;
			
		}
		
		public function set renderData(value:Object):void{
			
			_renderData = value;
			
		}

	}
}