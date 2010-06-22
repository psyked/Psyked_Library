package com.gnstudio.nabiro.air.data.events
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
	
	import flash.data.SQLStatement;
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;

	public class DBEvent extends Event
	{
		// DB File
		public static const CREATED:String = 'created';
		public static const CREATION_COMPLETED:String = 'completed';
		public static const OVERWRITTEN:String = 'overwritten';
		public static const DROPPED:String = 'dropped';
		public static const ALERADY_EXISTS:String = 'exists';
		public static const OPENED:String = 'opened';
		
		// Table
		public static const TABLE_CREATED:String = 'tableCreated';		
		
		// Sql execution
		public static const INSERT_ATTEMPT:String = 'insertAttempt';
		public static const INSERTED:String = 'inserted';
		public static const UPDATE_ATTEMPT:String = 'updateAttempt';
		public static const UPDATED:String = 'updated';
		public static const DELETE_ATTEMPT:String = 'deleteAttempt';
		public static const DELETED:String = 'deleted';
		public static const RECOVERING_ATTEMPT:String = 'recoverAttempt';
		public static const RECOVERED:String = 'recovered';		
		public static const CUSTOM_QUERY_ATTEMPT:String = 'customQueryAttempt';
		public static const CUSTOM_QUERIED:String = 'queried';
		public static const SUCCESS_QUERY:String = 'succesfulQuery';		
		public static const SUCCESS_QUEUE_QUERY:String = 'succesfulQueueQuery';		
		
		// General error
		public static const FAILED:String = 'failed';
		
		private var _result:ArrayCollection;
		private var _query:SQLStatement;
		private var _uid:String;
		
		public function DBEvent(type:String, query:SQLStatement = null, result:ArrayCollection = null, uid:String = ""){
			
			_result = result;
			_query = query;
			_uid = uid;
			
			super(type, false, false);
						
		}
		
		public override function clone():Event {
			
			return new DBEvent(type, query, result);
			
		}

		public override function toString():String {
			
			return formatToString("DBEvent", "type", "bubbles", 
									"cancelable", "eventPhase", "query", "result");
									
		}	
		
		public function get uid():String{
			
			return _uid;
			
		}
		
		public function get result () : ArrayCollection{
			
			return _result;
		
		}
		
		public function get query () : SQLStatement{
			
			return _query;
			
		}
		
		
	}
}