package com.gnstudio.nabiro.utilities.pico.helpers
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
	 */
	
	/**
	 * Builder for a method to call against a component contained in a container
	 */ 
	 
	 import __AS3__.vec.Vector;
	 
	 import com.gnstudio.nabiro.utilities.pico.exceptions.MethodNotConfigured;
	
	public class PicoMethodBuilder
	{
		
		private var _method:IPicoMethod;
		
		public function PicoMethodBuilder()
		{
		}
		
		/**
		 * Define the kind of class to use in the builder, the ComponentMethod
		 * is the default used if you simply create a new instance of the 
		 * MethodConfiguration class
		 * @param value MethodConfiguration
		 * @return PicoMethodBuilder
		 */ 
		public function kind(value:MethodConfiguration):PicoMethodBuilder{
			
			_method = value.getMethod();
			
			return this;
			
		}
		
		/**
		 * Specify the method name
		 * @param name String
		 * @return PicoMethodBuilder
		 */ 
		public function name(name:String):PicoMethodBuilder{
			
			_method.name = name;
			
			return this;
			
		}
		
		/**
		 * Specify the arguments of the method
		 * @param arguments Vector.<IParameter>
		 * @return PicoMethodBuilder
		 */ 
		public function withArguments(arguments: Vector.<IPicoParameter>):PicoMethodBuilder{
			
			_method.parameters = arguments;
			
			return this;
			
		}
		
		/**
		 * Once the method has been completely configured the builder return it
		 * @return IPicoMehtod
		 */ 
		public function create():IPicoMethod{
			
			if(!_method || !_method.name){
				
				throw new MethodNotConfigured();
				
			}
			
			return _method;
			
		}

	}
}