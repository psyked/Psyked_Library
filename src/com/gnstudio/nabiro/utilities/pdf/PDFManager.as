package com.gnstudio.nabiro.utilities.pdf
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
	 *   @author 					Igor Varga [ i.varga@gnstudio.com ]
	 *	 
	 */
	
	import __AS3__.vec.Vector;
	
	import com.gnstudio.nabiro.utilities.pdf.PDFImage
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	/**
	 * 
	 * @author i.varga@gnstudio.com
	 * 
	 */	
	public class PDFManager implements IEventDispatcher
	{
		
		private var _pdfDocument:PDFDocument;
		
		private static var _className:String = getQualifiedClassName(super);
		private static var _instance:PDFManager;
		private static var _target:IEventDispatcher;
		
		private var _eventDispatcher:EventDispatcher;
		
		
		public function PDFManager()
		{
			if (_instance != null && getQualifiedSuperclassName(this) != _className) throw new Error("This a singleton class!");
			
			_eventDispatcher = new EventDispatcher();
		}
		
		/**
		 * Method used to be sure that only an instance of the class will be created
		 * @param target IEventDispatcher
		 */ 

		public static function getInstance(tg:IEventDispatcher = null):PDFManager{
						
			if(!_instance){
				
				_instance = new PDFManager();				
				
			}
			
			if(tg){
				
				_target = tg;
				
			}
			
			return _instance;
			
		}
		
		/************************************
		* IEventDispatcher immplementation
		*************************************/ 
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			_eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			_eventDispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return _eventDispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return _eventDispatcher.hasEventListener(type);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return _eventDispatcher.willTrigger(type);
		}
		
		
		/**
		 * Open and parse the PDF file. By default only basic information is parsed.
		 * 
		 *  
		 * @param fileName - file to parse
		 * @param loadImages - if set to true images are loaded automaticaly, if set to false only image references are stored (markers)
		 * @param elaborateFonts - if set to true, embedded fonts are elaborated during the load operation
		 * @return - PDFDocument, memory representation of the parsed PDF document 
		 * 
		 */
		public function loadFile(fileName:String, loadImages:Boolean=false, elaborateFonts:Boolean=false):void
		{

		}
		
		/**
		 * Open and parse the PDF byte stream. Only basic pdf document information is parsed.
		 * 
		 *  
		 * @param stream - stream to parse
		 * @param loadImages - stores image references only (bookmarks)
		 * @param elaborateFonts - if set to true, embedded fonts are elaborated during the load operation
		 * @return - PDFDocument, memory representation of the parsed PDF document 
		 * 
		 */
		public function loadBytes(stream:ByteArray, loadImages:Boolean=false, elaborateFonts:Boolean=false):void
		{

		}
		
		/**
		 * Clears the current document from the memory
		 * 
		 */		
		public function dispose():void
		{
			
		}
		
		/**
		 * Performs the font elaboration for the current pdf document. The fonts are available from the fonts property.
		 * 
		 * Note: Only embedded fonts are checked.
		 * 
		 * 
		 * @return - 	true if all the fonts are available, 
		 * 				false if one of the fonts are missing
		 * 
		 */
		public function elaborateFonts():void
		{

		}
		
		/**
		 * Parsed PDF document
		 * 
		 * @return 
		 * 
		 */	
		public function get pdfDocument():PDFDocument
		{
			return _pdfDocument;
		}
		
		/**
		 * Images contained inside PDF document
		 * 
		 * @return 
		 * 
		 */	
		
		public function get images():Vector.<PDFImage>
		{
			return _pdfDocument.images;
		}
		
		/**
		 * All fonts used in the PDF document
		 * 
		 * @return 
		 * 
		 */	
		public function get fonts():Vector.<PDFFont>
		{
			return _pdfDocument.fonts;
		}
		
		/**
		 * Number of pages in the PDF document
		 * 
		 * @return 
		 * 
		 */	
		public function get numberOfPages():int
		{
			return _pdfDocument.numberOfPages;
		}
		
		public function get rawData():IDataInput
		{
			return null;
		}
	}
}
