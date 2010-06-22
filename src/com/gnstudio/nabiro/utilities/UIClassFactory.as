package com.gnstudio.nabiro.utilities
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
	
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.ClassFactory;
	import mx.core.IFactory;
	import mx.events.FlexEvent;
	import mx.styles.StyleProxy;
		
	public class UIClassFactory implements IFactory{
		
		
		private var factoryFunction : Function = null;
		public var styles:Object;
		public var eventListeners:Object;
		
		public function UIClassFactory(factory: * , props:Object = null, styles:Object = null, eventListeners:Object = null){
			
			var className:String;// if the class name was passed as a String
	
			if ( factory is UIClassFactory) {
			
				_classFactory =	UIClassFactory(factory).classFactory;
				
				} else if (factory is Class) {
				
					_classFactory = new ClassFactory(Class(factory));
				
				} else if (factory is String) {
				
					className = String(factory);
				
					try {
				
						var classToUse:Class = getDefinitionByName(className) as Class;
							
						_classFactory = new ClassFactory(classToUse);
							
				} catch (e:Error) {
					
					trace(" Class '"+ className + "' can't be loaded dynamically. Ensure it's explicitly referenced in the application file or specified via @rsl.");
				
					}
					
				}else{
						
					trace("'" + className + "'" + " is invalid parameter for UIClassFactory constructor.");
						
				}
				
				if (!_classFactory) {
				
					_classFactory = new ClassFactory(Object);
				
				}
				
				if (props != null){
					
					_classFactory.properties = props;
					
				} 
				
				if (styles != null){
					
					styles = styles;
					
				} 
				
				if (eventListeners != null){
				
					eventListeners = eventListeners;
					
				}
				
		}
			
		
		
		public function newInstance():* {
			
			var obj:* = _classFactory.newInstance();
					
			if (properties != null) {
					
				for (var p:String in properties) {
						
					obj[p] = properties[p];
			
				}
			}
					
			if (styles != null) {
						
				for (var s:String in styles) {
							
					obj.setStyle(s, styles[s]);
						
				}
			
			}
				
			if (eventListeners != null) {
					
				for (var e:String in eventListeners) {
						
					obj.addEventListener(e, eventListeners[e]);
					
				}
			}
				
			return obj;
				
		}
		
		
		public function set properties(v:Object):void {
			
			_classFactory.properties = v;
		
		}
		
		public function get properties():* {
			
			return _classFactory.properties || null;
		
		}
		
		
		private var _classFactory : ClassFactory;
		
		public function get classFactory():ClassFactory {
			
			return _classFactory;
			
		}
		
		

	}
}