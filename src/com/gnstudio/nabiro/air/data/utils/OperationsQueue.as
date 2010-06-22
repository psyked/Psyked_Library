package com.gnstudio.nabiro.air.data.utils
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
	
	import com.gnstudio.nabiro.air.data.SQLQueue;
	
	/**
	 * This classe defines the queue of querie to be invoked.
	 * 
	 * This class implements the singleton pattern to provide an unique instance
	 * of the queue object.
	 */
	public class OperationsQueue{
	
	    //----------------------------------------------------------------------
	    //
	    //  Class properties
	    //
	    //----------------------------------------------------------------------

		/**
		 * The singleton instance.
		 */
		private static var manager:OperationsQueue;
		
		/**
		 * Used to store queries in the queue.
		 */
		private var history:Array;
		
	    //----------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //----------------------------------------------------------------------
	    
	    /**
	     * Constructor.
	     */
		public function OperationsQueue(singleton:Enforcer) {
			
			history = [];
			
		}
		
		
		public static function getQueeManager():OperationsQueue{
			
			if(OperationsQueue.manager == null){
				
				OperationsQueue.manager = new OperationsQueue(new Enforcer());
				
			}
			
			return OperationsQueue.manager;
			
		}
		
	    //----------------------------------------------------------------------
	    //
	    //  Other methods
	    //
	    //----------------------------------------------------------------------
	    
		public function get actualElements():int {
			
			return history.length;
			
		}
		
		public function getActualStep():SQLQueue {
			
			//return history[history.length - 1];
			if (history.length > 0) return history[0];
			return null;
			
		}
		
		public function removeStep():void {
			
			// The queue follows a FIFO strategy: the first element which is
			// pushed into the queue is the first to be popped out.
			//if (history.length > 0) history.splice(history.length - 1, 1);
			if (history.length > 0) history.splice(0, 1);
			
		}
		
		public function addStep(obj:SQLQueue):void {
			
			history.push(obj);
			
		}
		
		public function clear():void {
			
			history = [];
			
		}
		
	}
	
}

internal class Enforcer {
	
	
}