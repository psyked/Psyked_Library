package com.gnstudio.nabiro.connectivity.amf.remote
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
	
	
	public class RemoteMethod implements IRemoteMethod{
		
		   //----------------------------------------------------------------------
	    //
	    //  Class properties
	    //
	    //----------------------------------------------------------------------

	    //----------------------------------
	    //  source
	    //----------------------------------

		/**
		 * The service endpoint.
		 */
		private var _source:String;

		/**
		 * @private
		 */
		public function set source(value:String):void {
			_source = value;
		}

		/**
		 * @private
		 */
		public function get source():String {
			return _source;
		}

	    //----------------------------------
	    //  destination
	    //----------------------------------
		
		/**
		 * The service destination.
		 */
		private var _destination:String;
		
		/**
		 * @private
		 */
		public function set destination(value:String):void {
			_destination = value;
		}
		
		/**
		 * @private
		 */
		public function get destination():String {
			return _destination;
		}
		
	    //----------------------------------
	    //  name
	    //----------------------------------
		
		/**
		 * The remote method name.
		 */
		private var _name:String;
		
		/**
		 * @private
		 */
		public function set name(value:String):void {
			_name = value;
		}
		
		/**
		 * @private
		 */
		public function get name():String {
			return _name;
		}
		
	    //----------------------------------
	    //  returnObject
	    //----------------------------------
	    	
		/**
		 * The class of the object which is returned by remote method invocation.
		 */
		private var _returnObject:Class;
		
		/**
		 * @private
		 */
		public function set returnObject(value:Class):void {
			_returnObject = value;
		}
		
		/**
		 * @private
		 */
		public function get returnObject():Class {
			return _returnObject;
		}
		
	    //----------------------------------
	    //  isList
	    //----------------------------------
		
		/**
		 * Indicates whether the object returned by the remote method invocation
		 * is a list.
		 */
		private var _isList:Boolean;

		/**
		 * @private
		 */
		public function set isList(value:Boolean):void {
			_isList = value;
		}
		
		/**
		 * @private
		 */
		public function get isList():Boolean {
			return _isList;
		}
		
	    //----------------------------------
	    //  arguments
	    //----------------------------------
		
		/**
		 * The array of arguments for the remote method.
		 */
		private var _arguments:Array;
		
		/**
		 * @private
		 */
		public function set arguments(value:Array):void {
			_arguments = value;
		}
		
		/**
		 * @private
		 */
		public function get arguments():Array {
			return _arguments;
		}
		
	    //----------------------------------------------------------------------
	    //
	    //  Contructor
	    //
	    //----------------------------------------------------------------------

		/**
		 * Constructor.
		 */
		public function RemoteMethod(source:String, destination:String, name:String, 
							objectType:Class = null, list:Boolean = false, ...rest) {
			_source = source;
			_destination = destination;
			_name = name;
			_returnObject = objectType;			
			_isList = list;	
			_arguments = rest || [];
			
		}
	}
}