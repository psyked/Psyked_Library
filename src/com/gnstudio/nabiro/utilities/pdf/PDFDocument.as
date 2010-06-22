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
	
	import com.gnstudio.nabiro.utilities.pdf.pdfbox.cos.COSDictionary;
	import com.gnstudio.nabiro.utilities.pdf.pdfbox.parser.PDFParser;
	import com.gnstudio.nabiro.utilities.pdf.pdfbox.pdmodel.PDDocument;
	import com.gnstudio.nabiro.utilities.pdf.pdfbox.pdmodel.PDDocumentCatalog;
	
	import flash.utils.ByteArray;

	/**
	 * 
	 * @author i.varga@gnstudio.com
	 * 
	 */	
	public class PDFDocument
	{
		
		private var _fonts:Vector.<PDFFont>;
		
		private var _images:Vector.<PDFImage>;
		
		private var _pages:Vector.<PDFPage>;
		
		private var _numberOfPages:int;
		
		private var _fileName:String;
		
		private var _rawdata:ByteArray;
		
		private var _document:PDDocument;
		
		
		public function PDFDocument()
		{
			_fonts = new Vector.<PDFFont>();
			_images = new Vector.<PDFImage>();
			_pages = new Vector.<PDFPage>();
		}
		

		public function get rawdata():ByteArray
		{
			return _rawdata;
		}

		/**
		 * Name of the pdf file. 
		 */	
		public function get fileName():String
		{
			return _fileName;
		}

		/**
		 * Number of pages in the document 
		 */
		public function get numberOfPages():int
		{
			return _numberOfPages;
		}

		public function set numberOfPages(v:int):void
		{
			_numberOfPages = v;
		}
		
		/**
		 * List of all images in the document
		 */
		public function get images():Vector.<PDFImage>
		{
			return _images;
		}

		/**
		 * List of all the fonts in the document 
		 */
		public function get fonts():Vector.<PDFFont>
		{
			return _fonts;
		}

		/**
		 * List of all the fonts in the document 
		 */
		public function get pages():Vector.<PDFPage>
		{
			return _pages;
		}
		
		/**
		 * Gets the document catalog :D
		 *  
		 * @return 
		 * 
		 */		
		public function getDocumentCatalog():PDDocumentCatalog
		{
			var trailer:COSDictionary = new COSDictionary();
			return new PDDocumentCatalog(); 
		}
		
		/**
		 * Parses the bytes and generates the PDFDocument object
		 *  
		 * @param stream
		 * @return 
		 * 
		 */
		public static function parse(stream:ByteArray):PDFDocument
		{
	        var parser:PDFParser = new PDFParser( stream );
	        parser.parse();
	        var pdfdoc:PDFDocument = new PDFDocument();
	        pdfdoc._document = parser.getPDDocument();

	        return pdfdoc;
		}
		
	}
}
