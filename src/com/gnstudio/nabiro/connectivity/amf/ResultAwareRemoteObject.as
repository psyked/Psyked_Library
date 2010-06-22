package com.gnstudio.nabiro.connectivity.amf
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
	
	import mx.rpc.remoting.RemoteObject;

	/**
	 * The ResultAwareRemoteObject class extends the RemoteObject class to
	 * store information about the class of the result object and the flag 
	 * indicating whether the result is a list.
	 */
	public class ResultAwareRemoteObject extends RemoteObject {
		
	    //----------------------------------------------------------------------
	    //
	    //  Class properties
	    //
	    //----------------------------------------------------------------------

		/**
		 * Indicates whether this object is a list.
		 */
		public var isList:Boolean;
		
		/**
		 * The class of the object returned.
		 */
		public var resultObject:*;
		
	    //----------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //----------------------------------------------------------------------

		/**
		 * Constructor.
		 */
		public function ResultAwareRemoteObject(l:Boolean, r:*, 
												destination:String = null) {
			super(destination);
			isList = l;
			resultObject = r;
		}
				
	}
}