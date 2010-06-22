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
	
	import com.gnstudio.nabiro.connectivity.amf.remote.IRemoteMethod;
	import com.gnstudio.nabiro.connectivity.amf.remote.RemoteMethod;
	
	public class MethodBuilder
	{
		
		 
		 private var _source:String;
		 private var _destination:String;
		 private var _methodName:String;
		 
		 private var _objectType:Class;
		 private var _list:Boolean;
		 private var _params:Array;
		 
		
		public function MethodBuilder(){
			
			// Do nothing
			
			
		}
		
		
		public function against(method:String):MethodBuilder{
			
			// TODO check if the empty string is passed
			
			if(method == ""){
				
				throw new Error("The method name has to be specified");
				
			}
			
			_methodName = method;
			
			return this;
			
		}
		
		public function usingParam(...rest):MethodBuilder{
			
			_params = rest;
			
			return this;
			
		}
		
		public function listBased():MethodBuilder{
			
			_list = true;
			
			return this;
			
		}
		
		public function returning(type:Class):MethodBuilder{
			
			_objectType = type;
			
			return this;
			
		}
				
		public function createOn(source:String = "", destination:String = ""):IRemoteMethod{
			
			_source = source;
			_destination = destination;
			
			if(_params != null){
				
				return new RemoteMethod(_source, _destination, _methodName, _objectType, _list, _params);
				
			}else{
				
				return new RemoteMethod(_source, _destination, _methodName, _objectType, _list);
				
			}
			
		}
		
		public function create():IRemoteMethod{
			
			if(_params != null){
				
				return new RemoteMethod(_source, _destination, _methodName, _objectType, _list, _params);
				
			}else{
				
				return new RemoteMethod(_source, _destination, _methodName, _objectType, _list);
				
			}
			
		}
	
		
		
	//	var method:RemoteMethod = new MethodBuilder().against("methodName").usingParam(params).returning(UserInfo).listBased().create();
	//		var method:RemoteMethod = new MethodBuilder().against("methodName").usingParam(params).returning(UserInfo).listBased().createOn("channel", "destination")
		

	}
}