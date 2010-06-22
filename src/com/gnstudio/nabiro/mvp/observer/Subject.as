package com.gnstudio.nabiro.mvp.observer
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
	
	
	
	public class Subject
	{
		
		protected var _observers:Array;
		
		public function Subject(enforcer:AbstractEnforcer){
			
			if (enforcer == null){
  
             	throw new Error("AbstractException");
         	
         	}
         	
         	_observers = [];
			
		}
		
		public function attach(item:IObserver):void{
			
			_observers.push(item);	
			
		}
		
		public function detach(item:IObserver):void{
			
			var limit:int = _observers.length;
			
			for(var i:int = 0; i < limit; i++){
				
				if(_observers[i] == item){
					
					_observers.splice(i, 1); 
					break;
					
				}
				
			}
			
		}
		
		public function notify():void{
			
			var limit:int = _observers.length;
			
			for(var i:int = 0; i < limit; i++){
				
				(_observers[i] as IObserver).update(this);		
				
			}
			
		}
				
		protected static function getAccess():AbstractEnforcer{
			
          return new AbstractEnforcer();
     	
     	}

	}
}



internal class AbstractEnforcer{
	
	// Do nothing
	
}