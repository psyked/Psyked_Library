package com.gnstudio.nabiro.utilities.pdf.pdfbox.parser
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
	
	import com.gnstudio.nabiro.utilities.pdf.pdfbox.cos.COSArray;
	import com.gnstudio.nabiro.utilities.pdf.pdfbox.cos.COSBase;
	import com.gnstudio.nabiro.utilities.pdf.pdfbox.cos.COSBoolean;
	import com.gnstudio.nabiro.utilities.pdf.pdfbox.cos.COSDictionary;
	import com.gnstudio.nabiro.utilities.pdf.pdfbox.cos.COSDocument;
	import com.gnstudio.nabiro.utilities.pdf.pdfbox.cos.COSInteger;
	import com.gnstudio.nabiro.utilities.pdf.pdfbox.cos.COSName;
	import com.gnstudio.nabiro.utilities.pdf.pdfbox.cos.COSNull;
	import com.gnstudio.nabiro.utilities.pdf.pdfbox.cos.COSNumber;
	import com.gnstudio.nabiro.utilities.pdf.pdfbox.cos.COSObject;
	import com.gnstudio.nabiro.utilities.pdf.pdfbox.cos.COSStream;
	import com.gnstudio.nabiro.utilities.pdf.pdfbox.cos.COSString;
	import com.gnstudio.nabiro.utilities.pdf.pdfbox.persistence.util.COSObjectKey;
	
	import flash.errors.IOError;
	import flash.events.IOErrorEvent;
	import flash.utils.ByteArray;

	public class BaseParser
	{
		private var _stream:ByteArray;
		
		private var _document:COSDocument;
		
	    public static var endStream:ByteArray;
	
	    public static var endObj:ByteArray;

	    public static var DEF:String = "def";
    
		public function BaseParser( stream:ByteArray )
		{
			
			_stream = stream;
			
			// init endStream
			endStream = new ByteArray();
			endStream.writeByte(101);
			endStream.writeByte(110);
			endStream.writeByte(100);
			endStream.writeByte(115);
			endStream.writeByte(116);
			endStream.writeByte(114);
			endStream.writeByte(101);
			endStream.writeByte(97);
			endStream.writeByte(109);
			
			// endObj
			endObj = new ByteArray();
			endObj.writeByte(101);
			endObj.writeByte(110);
			endObj.writeByte(100);
			endObj.writeByte(111);
			endObj.writeByte(98);
			endObj.writeByte(106);
			
		}
		
		private static function isHexDigit(c:String):Boolean
		{
			return isDigit( c ) || (("A" <= c) && (c <= "F")) || (("a" <= c) && (c <= "f"));
		}
		
        public static function isDigit( c:String ):Boolean
        {
	        return ("0" <= c) && (c <= "9");
        }

	    private function parseCOSDictionaryValue():COSBase
	    {
	        var retval:COSBase = null;
	        var number:COSBase = parseDirObject();
	        
	        skipSpaces();
	        
	        var next:String = String.fromCharCode( peekUnsignedByte() );
	        
	        if( next >= '0' && next <= '9' )
	        {
	            var generationNumber:COSBase = parseDirObject();
	            
	            skipSpaces();
	            
	            var r:String = String.fromCharCode( _stream.readByte() );
	            
	            if( r != 'R' )
	            {
	                throw IOError( "expected='R' actual='" + r + "' ");
	            }
	            
	            var key:COSObjectKey = new COSObjectKey( (number as COSInteger).intValue(),
	                    (generationNumber as COSInteger).intValue() );
	            retval = _document.getObjectFromPool(key);
	        }
	        else
	        {
	            retval = number;
	        }

	        return retval;
	    }
	    
	    protected function parseDirObject():COSBase
	    {

	        var retval:COSBase = null;
	
	        skipSpaces();
	        var c:String = String.fromCharCode( peekUnsignedByte() );

			// simulate unread or implement PushBackInputStream

	        switch(c)
	        {
		        case '<':
		        {
		            var leftBracket:uint = _stream.readUnsignedInt();//pull off first left bracket
		            c = String.fromCharCode( peekUnsignedByte() ); //check for second left bracket
		            unreadUnsignedByte();
		            
		            if(c == '<')
		            {
		                retval = parseCOSDictionary();
		                skipSpaces();
		            }
		            else
		            {
		                retval = parseCOSString();
		            }
		            break;
		        }
		        case '[': // array
		        {
		            retval = parseCOSArray();
		            break;
		        }
		        case '(':
		            retval = parseCOSString();
		            break;
		        case '/':   // name
		            retval = parseCOSName();
		            break;
		        case 'n':   // null
		        {
		            var nullString:String = readString();
		            if( !nullString !=  "null" )
		            {
		                throw new IOError("Expected='null' actual='" + nullString + "'");
		            }
		            retval = COSNull.getInstance();
		            break;
		        }
		        case 't':
		        {
	
		            var trueString:String = _stream.readMultiByte(4, '');
		            if( trueString ==  "true" )
		            {
		                retval = COSBoolean.TRUE;
		            }
		            else
		            {
		                throw new IOError( "expected true actual='" + trueString );
		            } 
	
		            break;
		        }
		        case 'f':
		        {
		        	
					var falseString:String = _stream.readMultiByte(5, '');
		            if( falseString ==  "false" )
		            {
		                retval = COSBoolean.FALSE;
		            }
		            else
		            {
		                throw new IOError( "expected false actual='" + falseString );
		            }
		            break;
		        }
		        case 'R':
		            _stream.readUnsignedInt();
		            retval = new COSObject(null);
		            break;
	
		        default:
		        {
		            if( BaseParser.isDigit(c) || c == '-' || c == '+' || c == '.')
		            {
		            	var buf:String = "";
						c = String.fromCharCode( _stream.readUnsignedByte() );
	
		                while( BaseParser.isDigit( c )||
		                        c == '-' ||
		                        c == '+' ||
		                        c == '.' ||
		                        c == 'E' ||
		                        c == 'e' )
		                {
		                    buf += c ;
		                    c = String.fromCharCode( _stream.readUnsignedByte() );
		                }
	
		                unreadUnsignedByte();
		                
		                retval = COSNumber.getValue( buf );
		            }
		            else
		            {
		            	/*
		                //This is not suppose to happen, but we will allow for it
		                //so we are more compatible with POS writers that don't
		                //follow the spec
		                String badString = readString();
		                //throw new IOException( "Unknown dir object c='" + c +
		                //"' peek='" + (char)pdfSource.peek() + "' " + pdfSource );
		                if( badString == null || badString.length() == 0 )
		                {
		                    int peek = pdfSource.peek();
		                    // we can end up in an infinite loop otherwise
		                    throw new IOException( "Unknown dir object c='" + c +
		                            "' cInt=" + (int)c + " peek='" + (char)peek + "' peekInt=" + peek + " " + pdfSource );
		                }
		                */
		
		            }
		        }
		    }
		    return retval;
	    }
	    
	    protected function skipSpaces():void
	    {
	    	if (_stream.bytesAvailable == 0) return;
	    	
	    	var pos:int = _stream.position;
	        var c:uint = _stream.readUnsignedByte();
	        
	        // identical to, but faster as: isWhiteSpace(c) || c == 37
	        while(c == 0 || c == 9 || c == 12  || c == 10
	                || c == 13 || c == 32 || c == 37)//37 is the % character, a comment
	        {
	            if ( c == 37 )
	            {
	                // skip past the comment section
	                c = _stream.readUnsignedByte();
	                while(!isEOL(c) && _stream.bytesAvailable != 0)
	                {
	                    c = _stream.readUnsignedByte();
	                }
	            }
	            else
	            {
	                c = _stream.readUnsignedByte();
	            }
	        }
	        
	        if (_stream.bytesAvailable != 0)
	        {
	        	_stream.position = pos;
	        }
	    }
	    
	    protected function readString():String
	    {
	        skipSpaces();
	        var c:String = String.fromCharCode( _stream.readUnsignedByte() );
	        var buffer:String = "";
	        while( !isEndOfName(c) && !isClosing(c) )
	        {
	            buffer += c;
	            c = String.fromCharCode( _stream.readUnsignedByte() );
	        }
	        
	        unreadUnsignedByte();
	        
	        return buffer;
	    }
	    
	    protected function readStringLength( length:uint ):String
	    {
	        skipSpaces();

			var i:uint = _stream.readUnsignedByte();
	        var c:String = String.fromCharCode( i );
	
	        //average string size is around 2 and the normal string buffer size is
	        //about 16 so lets save some space.
	        var buffer:String = "";
	        
	        while( !isWhitespace(i) && !isClosing(c) && buffer.length < length &&
	                c != '[' &&
	                c != '<' &&
	                c != '(' &&
	                c != '/' )
	        {
	            buffer += c;
	            c = String.fromCharCode( _stream.readUnsignedByte() );
	        }
			unreadUnsignedByte();
	        return buffer;
	    }
	    
	    protected function parseCOSDictionary():COSDictionary
	    {
	    	return null;
	    }
	    
	    protected function parseCOSArray():COSArray
	    {
	    	return null;
	    }
	    
	    protected function parseCOSName():COSName
	    {
	    	return null;
	    }
	    
	    protected function parseCOSString():COSString
	    {
	    	return null;
	    }

		protected function isEOL(c:int):Boolean
		{
			return c == 10 || c == 13;
		}
		
		protected function isEndOfName(ch:String):Boolean
		{
	        return (ch == ' ' || ch.charCodeAt(0) == 13 || ch.charCodeAt(0) == 10 || ch.charCodeAt(0) == 9 || ch == '>' || ch == '<'
	            || ch == '[' || ch =='/' || ch ==']' || ch ==')' || ch =='('
	        );
		}
		
		protected function isClosing(c:String):Boolean
		{
	        return c == ']';
		}
		
		protected function isClosingAvailable():Boolean
		{
	        return _stream.bytesAvailable == 0;
		}
		
		public function peekUnsignedByte():uint
		{
			var b:uint = _stream.readUnsignedByte();
			_stream.position -= 1;
			
			return b;
		}
		
		public function unreadUnsignedByte():void
		{
			_stream.position -= 1;
		}

		public function unreadBytes(length:int):void
		{
			_stream.position -= length;
		}
		
		public function startsWith(str:String, search:String):Boolean
		{
			if ( str.indexOf(search) == 0)
			{
				return true;
			}
			return false;
		}
		
	    protected function readLine():String
	    {
	        var buffer:String = "";
	        
	        var c:String;
	        while ( (c = String.fromCharCode( _stream.readUnsignedByte() ) ) )
	        {
	            if (isEOL(c.charCodeAt(0)))
	                break;
	            buffer += c ;
	        }
	        return buffer;
	    }
	    
	    protected function isWhitespace( c:int ):Boolean
	    {
	        return c == 0 || c == 9 || c == 12  || c == 10
	        || c == 13 || c == 32;
	    }
	    
	    protected function parseCOSStream( dic:COSDictionary, file:ByteArray ):COSStream
	    {
	    	var stream:COSStream = new COSStream( dic, file );
	    	
	    	return null;
	    }
	    
	    protected function readInt():uint
    	{
	        skipSpaces();
	        var retval:uint = 0;
	
	        var lastByte:uint = 0;
	        var intBuffer:String = new String();
	        
	        lastByte = _stream.readUnsignedByte();
	        
	        while( 	lastByte != 32 &&
	                lastByte != 10 &&
	                lastByte != 13 &&
	                lastByte != 60 && //see sourceforge bug 1714707
	                lastByte != 0  //See sourceforge bug 853328
	                )
	        {
	            intBuffer += String.fromCharCode( lastByte );
	            lastByte = _stream.readUnsignedByte();
	        }
	        
	        unreadUnsignedByte();
	
	        try
	        {
	            retval = int( intBuffer );
	        }
	        catch( e:Error )
	        {
	            unreadBytes(intBuffer.length);
	            throw new IOError( "Error: Expected an integer type, actual='" + intBuffer + "'" );
	        }
        	return retval;
    	}
	}
}
