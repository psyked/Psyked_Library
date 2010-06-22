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
		
	import __AS3__.vec.Vector;
	
	import com.gnstudio.nabiro.air.data.LocalData;
	import com.gnstudio.nabiro.air.data.SQLCriteria;
	import com.gnstudio.nabiro.mvp.encryption.MD5;
	
	import flash.events.Event;
	
	import mx.core.IUID;
	
	public class DBQueryEvent extends Event implements IUID{
		
		public var ignoreSystemManager:Boolean;
		public var queries:Vector.<SQLCriteria>;
		public var nameSpace:Namespace;
		public var connectionName:String;
		
		public static const DATA_BASE_QUERY:String = "nabiroDataAccessQuery";
		
		public function DBQueryEvent(criteria:Vector.<SQLCriteria>, ns:Namespace= null, destination:String = "", ignore:Boolean = false, bubbles:Boolean=true, cancelable:Boolean=false){
			
			super(DATA_BASE_QUERY, bubbles, cancelable);
			
			ignoreSystemManager = ignore;
			queries = criteria;
			nameSpace = ns;
			
			destination.length > 0 ? connectionName = destination : connectionName = LocalData.DEFAULT_CONNECTION;
			
			var tmp:String = "";
				
			for each(var item:SQLCriteria in criteria){
					
				tmp += item.uid;
					
			}
				
			_uid = MD5.encrypt(tmp);
			
		}
		
		private var _uid:String;
		
		public function  get uid():String{
			
			return _uid;
			
		}
		
		public function set uid(value:String):void{
			
			_uid = value;
			
		}
		
		public override function clone():Event {
			
			return new DBQueryEvent(queries, nameSpace, connectionName, ignoreSystemManager);
		
		}

		public override function toString():String {
			
			return formatToString("DBQueryEvent", "type", "bubbles", "cancelable", "eventPhase", "queries", "nameSpace", "connectionName", "ignoreSystemManager");
		
		}	

	}
}