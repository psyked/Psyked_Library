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
	
	import com.gnstudio.nabiro.utilities.pdf.pdfbox.pdmodel.PDStream;
	import com.gnstudio.nabiro.utilities.pdf.pdfbox.pdmodel.graphics.ImageMarker;
	import com.gnstudio.nabiro.utilities.pdf.pdfbox.pdmodel.graphics.color.PDColorSpace;
	import com.gnstudio.nabiro.utilities.pdf.pdfbox.pdmodel.graphics.xobject.PDXObject;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;

	/**
	 * Represents encoded image from the pdf file
	 *  
	 * @author i.varga@gnstudio.com
	 * 
	 */	
	public class PDFImage extends PDXObject implements IEventDispatcher
	{

		public static const ENCODING_JPEG:String = "jpeg";
		public static const ENCODING_PNG:String = "png";		

		private var _eventDispatcher:EventDispatcher;

		/**
		 * Image height in pixels 
		 */
		private var _height:int;
		
		/**
		 * Image width in pixels 
		 */
		private var _width:int;
		
		/**
		 * Bits per color component 
		 */
		private var _bitsPerComponent:int;
		
		/**
		 * Color space 
		 */
		private var _colorSpace:PDColorSpace;
		
		/**
		 * Encoding type of the image
		 */		
		private var _imageType:String;
		
		/**
		 * Marker used for lazy loading the image data
		 *  
		 */		
		private var _marker:ImageMarker;
		
		/**
		 * Reference to the originating PDFDocument
		 * 
		 */		
		private var _pdfDocument:PDFDocument;
		
		/**
		 * Indicates if the image data is available
		 */	
		private var _loaded:Boolean;
		
		/**
		 * DPI of the image based on page size
		 */		
		private var _dpi:uint;
		
		
		public function PDFImage( width:uint, height:uint )
		{
			_loaded = false;
			xobject = new PDStream();
			
			_width = width;
			_height = height;
		}
		

		/**
		 * Encoded image data 
		 */
		public function get imageData():ByteArray
		{
			return xobject.stream;
		}

	
		public function get loaded():Boolean
		{
			return (this.xobject.stream as ByteArray);
		}

		public function get colorSpace():PDColorSpace
		{
			return _colorSpace;
		}

		public function get bitsPerComponent():int
		{
			return _bitsPerComponent;
		}

		public function get width():int
		{
			return _width;
		}

		public function get height():int
		{
			return _height;
		}
		
		public function get dpi():uint
		{
			return _dpi;
		}
		
		public function calculateDPI( page:PDFPage ):void
		{
			var pointInch:Number = 0.0138;
			var paged:uint;
			var imaged:uint;
			
			var pageWidthInch:Number = page.width * pointInch;
			var pageHeightInch:Number = page.height * pointInch;
			
			paged = Math.sqrt( Math.pow(pageWidthInch, 2) + Math.pow(pageHeightInch, 2 ) );
			imaged = Math.sqrt( Math.pow(_width, 2) + Math.pow(_height, 2) );
			
			_dpi = imaged / paged;
			
			// trace ( _dpi );
			
		}
		
		/**
		 * Disposes memory image byte stream content.
		 * Image is still available for on demand content reading,
		 * if the original source is available
		 * 
		 */		
		public function dispose():void
		{
			// Dummy
			xobject.stream.clear();
			xobject.stream = null;
			
		}

		/**
		 * Loads the image content
		 * 
		 */		
		private function load():void
		{
			if (!loaded)
			{
				// load from stream
				
				// TODO: load from file, store file, or use filename
			}
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
	}
}
