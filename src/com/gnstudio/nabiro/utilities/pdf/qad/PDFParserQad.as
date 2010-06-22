package com.gnstudio.nabiro.utilities.pdf.qad
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
	
	import com.gnstudio.nabiro.mvp.core.SharedData;
	import com.gnstudio.nabiro.utilities.pdf.PDFDocument;
	import com.gnstudio.nabiro.utilities.pdf.PDFFont;
	import com.gnstudio.nabiro.utilities.pdf.PDFImage;
	import com.gnstudio.nabiro.utilities.pdf.PDFPage;
	
	import flash.errors.IOError;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	public class PDFParserQad
	{
		
		private var fs:FileStream;
		private var objects:SharedData = new SharedData();
		private var cancelParse:Boolean = false;

		public static var lineDelimiter:uint = 0x0A;
		public static var itemDelimiter:uint = 0x20;
		public static var propertyDelimiter:uint = 0x2F;
		
		private var _doc:PDFDocument;
		
		public function PDFParserQad( stream:FileStream )
		{
			fs = stream;
			_doc = new PDFDocument();
		}
		
		public function parse():void
		{ 
			parsePDF();
		}
		
		public function getPDFocument():PDFDocument
		{
			return _doc;
		}
		
		protected function isEOL(c:uint):Boolean
		{
			return c == 10 || c == 13;
		}
		
		private function closePDF():void
		{
			fs.close();
		}
		
		private function parsePDF():void
		{
			trace("start parse");
			
			parseHeader();
			
			doParse();
			
			parseFonts();
						
			parsePages();
			
			calculateDPI();
			
			trace("end parse");
			
			closePDF();
		}

		private function calculateDPI():void
		{
			for each (var page:PDFPage in _doc.pages)
			{
				for each (var image:PDFImage in page.images)
				{
					image.calculateDPI( page );
					trace ("Image DPI: "+ image.dpi);
				}
			}
		}
		
		private function parseFonts():void
		{
			var objectsArray:Array = objects.getAll();
			
			for ( var i:int = 0; i < objectsArray.length; i++)
			{
				var font:PDFFont = parseFont( ( objectsArray[i] as PDFObject ).objectData );
				
				if ( ( font ) && ( !fontExists( font.fontName ) ) )
				{
					_doc.fonts.push( font );
					
					trace ( "Font found --> name: " + font.fontName + ", embedded: " + font.embedded );
				}
			}
		}
		
		private function parseImages():void
		{
			var objectsArray:Array = objects.getAll();
			
			for ( var i:int = 0; i < objectsArray.length; i++)
			{
				var img:PDFImage = parseImage( ( objectsArray[i] as PDFObject ).objectData );
				
				if ( img )
				{
					_doc.images.push( img );
					
					trace ( "Image found --> width: " + img.width + ", height: " + img.height);
				}
			}
		}
		
		private function parsePages():void
		{
			var objectsArray:Array = objects.getAll();
			
			for ( var i:int = 0; i < objectsArray.length; i++)
			{
				
				var page:PDFPage = parsePage( ( objectsArray[i] as PDFObject ).objectData );
				
				if ( page )
				{
					_doc.pages.push( page );
					
					trace ( "Page found --> width: " + page.width + ", height: " + page.height);
				}
				
			}
		}
		
		private function doParse():void
		{

			var line:ByteArray = new ByteArray();
			var objstart:Boolean = false;
			var object:PDFObject;
			
			while 	( ( fs.bytesAvailable != 0 ) )
			{
				if ( cancelParse ) break;
				
				// is EOF
				if ( ( startsWithB(line, "%%EOF") ) && ( fs.bytesAvailable == 0 ) ) break;
				
				line = readLine();
				
				// traceB( line, TraceType.CHARCODEHEX );
				
				if ( objstart )
				{
					if ( isPDFObjectEnd( line ) )
					{
						object.objectData = line;
						object.id = parseId( object.objectData );
						objects.addValue( object.id, object );
						objstart = false;
						
						// traceB( object.objectData, TraceType.CHARCODEHEX );
						object = new PDFObject();
					}
					else
					{
						object.objectData = line;
					}
				}
				else
				{
					if ( isPDFObjectStart( line ) )
					{
						object = new PDFObject();
						objstart = true;
						object.objectData = line;
					}
				}
			}
			
		}
		
		private function isPDFObjectStart( line:ByteArray ):Boolean
		{
			
			var osize:int = 3;

			if ( line.bytesAvailable < osize ) return false;
			
			line.position = line.bytesAvailable - osize - 1;
			
			var test:String = line.readMultiByte( osize, "" );
			
			line.position = 0;
			
			if ( test == "obj" ) return true;

			return false;
			
		}
		
		private function isPDFObjectEnd( line:ByteArray ):Boolean
		{
			
			var osize:int = 6;
			
			if ( line.bytesAvailable < osize ) return false;
			
			line.position = line.bytesAvailable - osize - 1;
			
			var test:String = line.readMultiByte( osize, "" );
			
			line.position = 0;
			
			if ( test == "endobj" ) return true;
			
			return false;
			
		}
		
		private function parseFont( objbytes:ByteArray ):PDFFont
		{
			var f:PDFFont;
			
			objbytes.position = 0;
			
			while ( objbytes.bytesAvailable != 0 )
			{
				var p:String = nextObjectProperty( objbytes );
				
				// is font?
				if ( p == "BaseFont" )
				{
					var fontName:String = nextObjectProperty( objbytes );
					f = new PDFFont ( fontName, false );
				}

				// is embedded ( superficial )
				if ( ( p == "FontDescriptor" ) && ( f ) )
				{
					f.embedded = true;
				}
				
			}
			
			return f;
		}
		
		private function parseImage( objbytes:ByteArray ):PDFImage
		{
			var img:PDFImage;
			
			objbytes.position = 0;
			
			while ( objbytes.bytesAvailable != 0 )
			{
				var p:String = nextObjectProperty( objbytes );
				
				// is image?
				if ( p == "Subtype" )
				{
					if ( nextObjectProperty( objbytes ) == "Image" )
					{
						
						// width
						nextObjectProperty( objbytes );
 						var w:String = propertyValue( objbytes );
						
						// height
						nextObjectProperty( objbytes );
						var h:String = propertyValue( objbytes );
						
						img = new PDFImage( uint(w), uint(h) );

					}
				}
				
			}
			
			return img;
		}
		
		private function parsePage( objbytes:ByteArray ):PDFPage
		{
			var page:PDFPage;
			var mb:MediaBox;
			var images:Vector.<PDFImage> = new Vector.<PDFImage>();
	
			objbytes.position = 0;
			
			while ( objbytes.bytesAvailable != 0 )
			{

				if ( nextObjectProperty( objbytes ) == "Type" )
				{

					if ( nextObjectProperty( objbytes ) == "Page" )
					{
						
						page = new PDFPage();
						
						while ( objbytes.bytesAvailable != 0 )
						{
							var p:String = nextObjectProperty( objbytes );
							
							if ( p == "MediaBox" )
							{
								mb = parseMediaBox( objbytes );
							}
							
							if ( p == "Resources" )
							{
								// note: only one resource is parsed!
								var r:String = propertyValue( objbytes );
								var o:PDFObject = (objects.getValue( r ) as PDFObject);
								o.objectData.position = 0;
								
								// get the xobject ref
								while ( o.objectData.bytesAvailable != 0 )
								{
									var s:String = nextObjectProperty( o.objectData );
									if ( startsWith( s, "XObject" ) )
									{
										var ba:ByteArray = parseXObject( o.objectData );
										ba.position = 0;
										
										while ( ba.bytesAvailable != 0 )
										{
											nextObjectProperty( ba );

											var xobjref:String = propertyValue( ba );
											
											if ( xobjref != "" )
											{
												var xobj:PDFObject = (objects.getValue( xobjref ) as PDFObject);
												var img:PDFImage = parseImage( xobj.objectData );
												
												if ( img )
												{
													images.push( img );
													
													trace ( "Image found --> width: " + img.width + ", height: " + img.height);
												
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}

			if ( page )
			{
				// setup the page
				page.images = images;
				page.width = uint(mb.urx);
				page.height = uint(mb.ury);
			}
			
			return page;
		}
		
		private function parseMediaBox( objStream:ByteArray ):MediaBox
		{
			var mb:MediaBox;
			var c:uint;
			var ba:ByteArray = new ByteArray();
			var offset:uint;
			var length:uint;
			var statePos:uint;
			
			while ( c != 0x5D )
			{
				c = objStream.readUnsignedByte();
				
				if ( c == 0x5B )
				{
					offset = objStream.position;
				}
			}

			length = objStream.position - offset - 1;
			statePos = objStream.position;
			
			objStream.position = offset;
			var s:String = objStream.readMultiByte( length , "");
			objStream.position = statePos;

			mb = new MediaBox();
			var a:Array = s.split( String.fromCharCode( itemDelimiter ) );
			mb.llx = a[0];
			mb.lly = a[1];
			mb.urx = a[2];
			mb.ury = a[3];
			
			return mb;
		}
		
		private function parseHeader():void
		{
			if ( !startsWithB( readLine(), "%PDF-1" ) )
			{
				throw new IOError("Uknown file format");
			}
		}
		
		private function readLine():ByteArray
		{
			var start:uint = fs.position;
			var end:uint = 0;
			
			for ( ;; )
			{
				if ( 	fs.bytesAvailable == 0 || 
						isEOL( fs.readUnsignedByte() )
					) break;
			}

			var ret:ByteArray = new ByteArray();
			end = fs.position - start;
			fs.position = start;
			fs.readBytes(ret, 0, end);
			
			return ret;
		}
		
		private function startsWith(str:String, search:String):Boolean
		{
			if ( str.indexOf(search) == 0)
			{
				return true;
			}
			return false;
		}

		private function startsWithB( bytes:ByteArray, search:String ):Boolean
		{
			bytes.position = 0;
			
			if ( 	( bytes.bytesAvailable == 0 ) || 
					( bytes.bytesAvailable < search.length ) ) return false;
			
			var buff:String = bytes.readMultiByte(search.length, '');
			
			bytes.position = 0;
			
			if ( buff.indexOf(search) == 0)
			{
				return true;
			}
			
			return false;
			
		}
				
		private function fontExists( fontName:String ):Boolean
		{
			for (var i:int = 0; i < _doc.fonts.length; i++)
			{
				if ( _doc.fonts[i].fontName == fontName ) return true;
			}
			
			return false;
		}
		
		private function traceB( bytes:ByteArray, traceType:uint ):void
		{
			
			var buf:String = "";
			var pos:uint = bytes.position;
			
			while ( bytes.bytesAvailable != 0 )
			{
				switch(traceType)
				{
				    case TraceType.CHARCODEDEC:
				        buf += bytes.readUnsignedByte().toString( 10 ) + " ";
				        break;
				    case TraceType.CHARCODEHEX:
				        buf += bytes.readUnsignedByte().toString( 16 ).toUpperCase() + " ";
				        break;
				    case TraceType.CHARSEQUENCE:
				        buf += String.fromCharCode( bytes.readUnsignedByte() );
				        break;
				}
			}
			
			bytes.position = pos;
			
			trace( buf );
			
		}
		
		private function nextObjectProperty( bytes:ByteArray ):String
		{
			var buf:String = "";
			var c:uint;
			
			// get to property start
			while ( bytes.bytesAvailable != 0 )
			{
				c = bytes.readUnsignedByte();
				
				if ( ( c == propertyDelimiter ) )
				{
					break;
				}
			}
			
			// read up to property end
			while ( bytes.bytesAvailable != 0 )
			{
				c = bytes.readUnsignedByte();
				
				if ( ( c == propertyDelimiter ) || ( c == itemDelimiter ) || ( isEOL( c ) ) )
				{
					if ( c == propertyDelimiter ) bytes.position--;
					break;
				}
				
				buf += String.fromCharCode( c );
			}
			
			return buf;
		}
		
		private function propertyValue( bytes:ByteArray ):String
		{
			var buf:String = "";
			var c:uint;
			
			// read up to property end
			while ( bytes.bytesAvailable != 0 )
			{
				c = bytes.readUnsignedByte();
				
				if ( ( c == propertyDelimiter ) || ( c == itemDelimiter ) || ( isEOL( c ) ) )
				{
					break;
				}
				
				buf += String.fromCharCode( c );
			}
			
			return buf;
		}
		
		private function nextObjectItem( object:ByteArray ):String
		{
			var off:uint = object.position;
			
			if ( object.bytesAvailable == 0 ) return null;
			
			var length:uint = 0;
			
			while ( object.bytesAvailable != 0 )
			{
				var c:uint = object.readUnsignedByte();
				
				if ( ( isEOL( c ) ) || ( c == itemDelimiter ) )
				{
					length = object.position - off;
					break;
				}
			}
			
			object.position = off;
			
			return object.readMultiByte( length, "" );
		}
		
		private function parseId( bytes:ByteArray ):String
		{
			var id:String;
			
			bytes.position = 0;
			
			id = propertyValue( bytes );
			
			bytes.position = 0;
			// trace( id );
			
			return id;
		}
		
		private function parseXObject( objStream:ByteArray ):ByteArray
		{
			var ba:ByteArray = new ByteArray();
			
			var c:uint;
			var offset:uint;
			var length:uint;
			var statePos:uint;
			
			while ( c != 0x3E )
			{
				c = objStream.readUnsignedByte();
				
				if ( c == 0x3C )
				{
					objStream.position++;
					offset = objStream.position;
				}
			}

			length = objStream.position - offset - 1;
			statePos = objStream.position;
			
			objStream.position = offset;
			ba.writeBytes( objStream, offset, length);
			objStream.position = statePos;
						
			return ba;
		}
		
		public function cancel():void
		{
			
			cancelParse = true;
			
		}
		
		
		
	}
}


internal class TraceType
{
	
	public static const CHARCODEHEX:uint = 1;
	public static const CHARCODEDEC:uint = 2;
	public static const CHARSEQUENCE:uint = 3;

}

internal class MediaBox
{
	
	public var llx:String;
	public var lly:String;
	public var urx:String;
	public var ury:String;
	
}
