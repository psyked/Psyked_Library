package com.gnstudio.nabiro.mvp.mapper
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
	 
	import __AS3__.vec.Vector;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	public class MapperManager
	{
		
		private var _listeners:Vector.<DisplayObject>;
		private var _mapper:Mapper;
		
		public function MapperManager(listeners:Vector.<DisplayObject>, target:Mapper)	{
			
			
			_listeners = listeners;
			_mapper = target;
			
		}
		
		public function initialize():void{
			
			for(var i:int = 0; i < _listeners.length; i++){
				
				_listeners[i].addEventListener(Event.ADDED, onItemAdded)
				_listeners[i].addEventListener(Event.REMOVED, onItemRemoved)
				
			}
			
		}
		
		public function reset():void{
			
			for(var i:int = 0; i < _listeners.length; i++){
				
				_listeners[i].removeEventListener(Event.ADDED, onItemAdded)
				_listeners[i].removeEventListener(Event.REMOVED, onItemRemoved)
				
			}
			
		}
		
		/**
		 * Listeners used in order to register the IMapperCandidate visual component,
		 * these components can receive the result of a query automatically
		 * @param e Event
		 */ 
		protected function onItemAdded(e:Event):void{

			if(e.target is IMapperCandidate){
								
				_mapper.register(e.target as IMapperCandidate);
					
			}			

		}

		protected function onItemRemoved(e:Event):void{
							
			if(e.target is IMapperCandidate){

				_mapper.unregister(e.target as IMapperCandidate);

			}

		}

		/**
		 * ============ END ============ 
		 */ 

	}
}