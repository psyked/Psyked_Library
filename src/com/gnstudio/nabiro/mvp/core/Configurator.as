package com.gnstudio.nabiro.mvp.core
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
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	dynamic public class Configurator extends Proxy implements IEventDispatcher
	{
		
		private var eventDispatcher:EventDispatcher
		private var xml:XML;
	
		static public var URL:String = "";
		static public var NS:String = "";
		
		static public const PROPERTY_UNDEFINED:String = "onPropertyUndefined";
		static public const DATA_COMPLETED:String = "onDataInit";
		static public const DATA_NOT_LOADED:String = "ioErrorEvent";
		
		static private var configurator:Configurator;
		
		public function Configurator(){
			
			eventDispatcher = new EventDispatcher();
			
			XML.ignoreWhitespace = true;
		
			var request:URLRequest = new URLRequest(URL);
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onXMLLoaded);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onXMLError);
			loader.load(request);
			
		}
		
		protected function onXMLLoaded(e:Event):void{
			
			xml = XML(e.target.data);
			
			dispatchEvent(new Event(DATA_COMPLETED));
			
		}
		
		protected function onXMLError(e:IOErrorEvent):void{
			
			dispatchEvent(new Event(DATA_NOT_LOADED));
			
		}
		
		/**
		 * Method used to recover the instance of the class
		 */
		public static function getConfigurator():Configurator{
			
			if(configurator == null){
				
				configurator = new Configurator();
				
			}
			
			return configurator;
			
		}
		
		/**
		 * Usage to the get the XML data
		 * Configurator.NS = "txt";
		 * trace(configData.text)
		 */
		override flash_proxy function getProperty(prop:*):*{
			
			var usedNameSpace:Namespace = xml.namespace(NS);
			
			default xml namespace = usedNameSpace;
						
			var returned:* = xml..property.(@id == String(prop)).value;
		
			default xml namespace = new Namespace("");
			
			if(!returned){
				
				dispatchEvent(new Event(PROPERTY_UNDEFINED));
				return null;
				
			}else{
				
				return returned;
				
			}
			
			
		}
		
		/************************************
		* IEventDispatcher immplementation
		*************************************/ 
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0.0, useWeakReference:Boolean=false):void{
			
			eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
			
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void	{
			
			eventDispatcher.removeEventListener(type, listener, useCapture);
			
		}
		
		public function dispatchEvent(event:Event):Boolean {
			
			return eventDispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean {
			
			return eventDispatcher.hasEventListener(type);
		}
		
		public function willTrigger(type:String):Boolean {
			
			return eventDispatcher.willTrigger(type);
			
		}
		
	}
}