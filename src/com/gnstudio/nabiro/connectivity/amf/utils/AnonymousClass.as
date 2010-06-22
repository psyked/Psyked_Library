package com.gnstudio.nabiro.connectivity.amf.utils
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
	
	import flash.errors.IllegalOperationError;
	
	public class AnonymousClass{
		
		public function AnonymousClass(self:AnonymousClass){
			
			if(self != this){
				//only a subclass can pass a valid reference to self
				throw new IllegalOperationError("Abstract class did not receive reference to self. AnonymousClass cannot be instantiated directly.");
				
			}
			
			
		}
		
		 public static function create(context:Object, func:Function, ...pms):Function {
		   
		   var f:Function = function():*{
		   	
		    var target:*  = arguments.callee.target;
		    var func:*    = arguments.callee.func;
		    var params:*  = arguments.callee.params;
		
		    var len:Number = arguments.length;
		    var args:Array = new Array(len);
		   
		    for(var i:Number=0; i < len; i++){
		    	
		    	 args[i] = arguments[i];
		
		   	 	args["push"].apply(args, params);
		    	return func.apply(target, args);
		    	
		   		}
		    
		   };
		
		   var _f:Object = f;
		   
		   _f.target  = context;
		   _f.func    = func;
		   _f.params  = pms;
		   
		   return f;
		   
		  }

	}
}