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
	
	import com.gnstudio.nabiro.utilities.pdf.pdfbox.cos.COSBase;
	import com.gnstudio.nabiro.utilities.pdf.pdfbox.cos.COSDictionary;
	import com.gnstudio.nabiro.utilities.pdf.pdfbox.cos.COSDocument;
	import com.gnstudio.nabiro.utilities.pdf.pdfbox.cos.COSInteger;
	import com.gnstudio.nabiro.utilities.pdf.pdfbox.cos.COSObject;
	import com.gnstudio.nabiro.utilities.pdf.pdfbox.pdmodel.PDDocument;
	import com.gnstudio.nabiro.utilities.pdf.pdfbox.persistence.util.COSObjectKey;
	
	import flash.errors.IOError;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;

	public class PDFParser extends BaseParser
	{
		
		// PDF_HEADER is not working in Gumbo
	    private static const _PDF_HEADER:String = "%PDF-";
	    private static const _FDF_HEADER:String = "%FDF-";

		private var forceParsing:Boolean = false; 

		private var _stream:ByteArray;
		private var _document:COSDocument;
		
		private var _conflictList:ArrayCollection; 
		
		public function PDFParser(stream:ByteArray)
		{
			_stream = stream;
			_conflictList = new ArrayCollection();
			super(stream);
		}
		
		public function getPDDocument():PDDocument
		{
			return new PDDocument(_document);
		}
		
	    public function getDocument():COSDocument
	    {
	        if( _document == null )
	        {
	            throw new IOError( "You must call parse() before calling getDocument()" );
	        }
	        return _document;
	    }
    
		public function parse():void
		{
			setDocument( new COSDocument() );
			
			parseHeader();
			
            //Some PDF files have garbage between the header and the
            //first object
            skipToNextObj();
            
            var wasLastParsedObjectEOF:Boolean = false;
            try
            {
                while(true)
                {    
                    if(isEOF())
                    {
                        break;
                    }
                    
                    try 
                    {
                        wasLastParsedObjectEOF = parseObject();
                    }
                    catch(e:IOError){
                        if(forceParsing){
                            /*
                             * Warning is sent to the PDFBox.log and to the Console that
                             * we skipped over an object
                             */
                            trace ("Parsing Error, Skipping Object");
                            skipToNextObj();
                        }
                        else{ 
                            throw e;
                        }
                    }
                    skipSpaces();
                }
                
                
                //Test if we saw a trailer section. If not, look for an XRef Stream (Cross-Reference Stream) 
                //For PDF 1.5 and above 
                if( _document.getTrailer() == null ){
                    var trailer:COSDictionary = new COSDictionary();
                    
                    /*
                    Iterator xrefIter = document.getObjectsByType( "XRef" ).iterator();
                    while( xrefIter.hasNext() )
                    {
                        COSStream next = (COSStream)((COSObject)xrefIter.next()).getObject();
                        trailer.addAll( next );
                    }
                    document.setTrailer( trailer );
                    */
                }
                
                /*
                if( !_document.isEncrypted() )
                {
                    _document.dereferenceObjectStreams();
                }
                ConflictObj.resolveConflicts(document, conflictList);
                */
            }
            catch( e:IOError ){
                /*
                 * PDF files may have random data after the EOF marker. Ignore errors if
                 * last object processed is EOF. 
                 */
                if( !wasLastParsedObjectEOF ){
                    throw e;
                } 
            }

		}
		
		public function setDocument( doc:COSDocument ):void
		{
			_document = doc;
		}
		
		private function parseHeader():void
		{
	        // read first line
	        var header:String = readLine();
	        // some pdf-documents are broken and the pdf-version is in one of the following lines
	        if ((header.indexOf( _PDF_HEADER ) == -1) && (header.indexOf( _PDF_HEADER ) == -1)){
	            header = readLine();
	            while ((header.indexOf( _PDF_HEADER ) == -1) && (header.indexOf( _PDF_HEADER ) == -1)){
	                // if a line starts with a digit, it has to be the first one with data in it
	                if (isDigit (header.charAt(0)))
	                    break ;
	                header = readLine();
	            }
	        }
	
	        // nothing found
	        if ((header.indexOf( _PDF_HEADER ) == -1) && (header.indexOf( _PDF_HEADER ) == -1)){
	            throw new IOError( "Error: Header doesn't contain versioninfo" );
	        }
	        
	        //sometimes there are some garbage bytes in the header before the header
	        //actually starts, so lets try to find the header first.
	        var headerStart:int = header.indexOf( _PDF_HEADER );
	        if (headerStart == -1)
	            headerStart = header.indexOf(_FDF_HEADER);
	
	        //greater than zero because if it is zero then
	        //there is no point of trimming
	        if ( headerStart > 0 ){
	            //trim off any leading characters
	            header = header.substring( headerStart, header.length );
	        }

	        /*
	         * This is used if there is garbage after the header on the same line
	         */
			var headerGarbage:String = "";
	        if (startsWith(header, _PDF_HEADER)) {
	            if(!header.match(_PDF_HEADER + "\\d.\\d")) {
	                headerGarbage = header.substring(_PDF_HEADER.length+3, header.length) + "\n";
	                header = header.substring(0, _PDF_HEADER.length+3);
	                unreadBytes(headerGarbage.length);
	            }
	        }
	        else {
	            if(!header.match(_FDF_HEADER + "\\d.\\d")) {
	                headerGarbage = header.substring(_FDF_HEADER.length+3, header.length) + "\n";
	                header = header.substring(0, _FDF_HEADER.length+3);
	             	unreadBytes(headerGarbage.length);
	            }
	        }
	        
	        _document.setHeaderString(header);
	        
	        var pdfVersion:Number;
	        try{
	            if (startsWith(header, _PDF_HEADER ) ) {
	                pdfVersion = new Number(
	                        header.substring( _PDF_HEADER .length, Math.min( header.length, _PDF_HEADER .length+3) ) );
	                _document.setVersion( pdfVersion );
	            }
	            else {
	                pdfVersion = new Number (
	                        header.substring( _FDF_HEADER .length, Math.min ( header.length, _FDF_HEADER .length+3) ) );
	                _document.setVersion( pdfVersion );
	            }
	        }
	        catch ( e:Error ){
	            throw new IOError( "Error getting pdf version:" + e );
	        } 
			
		}
		
		private function isEOF():Boolean
		{
			return _stream.bytesAvailable == 0;
		}
		
		private function skipToNextObj():void
		{
			var b:ByteArray = new ByteArray();
			var pattern:RegExp = /\d+\s+\d+\s+obj.*/gi;
			
			while(!isEOF())
			{
				var l:int = 16;
				
				if (_stream.bytesAvailable < 1)
				{
					break;
				}
				
				if (_stream.bytesAvailable < 16)
				{
					l = _stream.bytesAvailable;
				}
				
				var s:String = _stream.readMultiByte(l, "");
				
				if (startsWith(s, "trailer") || 
						startsWith(s, "xref") || 
	                    startsWith(s, "startxref") ||
						startsWith(s, "stream") ||
						pattern.test(s) )
				{
					unreadBytes( s.length );
					break;
				} else
				{
					unreadBytes( l - 1 );
				}

			}

		} // end function
		
		private function parseObject():Boolean
		{

	        var currentObjByteOffset:int = _stream.position;
	        var isEndOfFile:Boolean = false; 
	        skipSpaces();
	        
	        //peek at the next character to determine the type of object we are parsing
	        var peekedChar:String = String.fromCharCode( peekUnsignedByte() );
	        
	        //ignore endobj and endstream sections.
	        while( peekedChar == 'e' )
	        {
	            //there are times when there are multiple endobj, so lets
	            //just read them and move on.
	            readString();
	            skipSpaces();
	            peekedChar = String.fromCharCode( peekUnsignedByte() );
	        }
	        if( isEOF())
	        {
	            //"Skipping because of EOF" );
	            //end of file we will return a false and call it a day.
	        }
	        //xref table. Note: The contents of the Xref table are currently ignored
	        else if( peekedChar == 'x')
	        {
	            parseXrefTable();
	        }
	        // Note: startxref can occur in either a trailer section or by itself 
	        else if (peekedChar == 't' || peekedChar == 's') {
	            if(peekedChar == 't'){
	                parseTrailer();
	                peekedChar = String.fromCharCode( peekUnsignedByte() ); 
	            }
	            if (peekedChar == 's'){  
	                parseStartXref();
	                //verify that EOF exists 
	                var eof:String = ""; //readExpectedString( "%%EOF" );
	                if( eof.indexOf( "%%EOF" )== -1 && !isEOF() )
	                {
	                    throw new IOError( "expected='%%EOF' actual='" + eof + "' next=" + readString() +
	                            " next=" +readString() );
	                }
	                isEndOfFile = true; 
	            }
	        }
	        //we are going to parse an normal object
	        else
	        {
	            var number:int = -1;
	            var genNum:int = -1;
	            var objectKey:String = null;
	            var missingObjectNumber:Boolean = false;
	            try
	            {
	                var peeked:String = String.fromCharCode( peekUnsignedByte() ); 
	                if( peeked == '<' )
	                {
	                    missingObjectNumber = true;
	                }
	                else
	                {
	                    number = readInt();
	                }
	            }
	            catch( e:IOError )
	            {
	                //ok for some reason "GNU Ghostscript 5.10" puts two endobj
	                //statements after an object, of course this is nonsense
	                //but because we want to support as many PDFs as possible
	                //we will simply try again
	                number = readInt();
	            }
	            if( !missingObjectNumber )
	            {
	                skipSpaces();
	                genNum = readInt();
	
	                objectKey = readStringLength( 3 );
	                //System.out.println( "parseObject() num=" + number +
	                //" genNumber=" + genNum + " key='" + objectKey + "'" );
	                if( !objectKey == "obj" )
	                {
	                    throw new IOError("expected='obj' actual='" + objectKey + "' ");
	                }
	            }
	            else
	            {
	                number = -1;
	                genNum = -1;
	            }
	
	            skipSpaces();
	            var pb:COSBase = parseDirObject();
	            var endObjectKey:String = readString();
	            
	            if( endObjectKey == "stream" )
	            {
	            	unreadBytes( endObjectKey.length + 1 );

	                if( pb is COSDictionary )
	                {
	                    pb = parseCOSStream( pb as COSDictionary, getDocument().getScratchFile() );
	                }
	                else
	                {
	                    // this is not legal
	                    // the combination of a dict and the stream/endstream forms a complete stream object
	                    throw new IOError("stream not preceded by dictionary");
	                }
	                endObjectKey = readString();
	            }
	            
	            var key:COSObjectKey = new COSObjectKey( number, genNum );
	            var pdfObject:COSObject = _document.getObjectFromPool( key );
	            if(pdfObject.baseObject == null){
	                pdfObject.baseObject = pb;
	            }
	            /*
	             * If the object we returned already has a baseobject, then we have a conflict
	             * which we will resolve using information after we parse the xref table.
	             */
	            else{
	                addObjectToConflicts(currentObjByteOffset, key, pb); 
	            }
	            
	            if( !endObjectKey == "endobj" )
	            {
	                if( !isEOF() )
	                {
	                    try{
	                        //It is possible that the endobj  is missing, there
	                        //are several PDFs out there that do that so skip it and move on.
	                        new Number ( endObjectKey );
	                        unreadBytes( endObjectKey.length + 1 );
	                    }
	                    catch( e:Error )
	                    {
	                        //we will try again incase there was some garbage which
	                        //some writers will leave behind.
	                        var secondEndObjectKey:String = readString();
	                        if( !secondEndObjectKey == "endobj" )
	                        {
	                            if( isClosingAvailable() )
	                            {
	                                //found a case with 17506.pdf object 41 that was like this
	                                //41 0 obj [/Pattern /DeviceGray] ] endobj
	                                //notice the second array close, here we are reading it
	                                //and ignoring and attempting to continue
	                                _stream.readUnsignedByte();
	                            }
	                            skipSpaces();
	                            var thirdPossibleEndObj:String = readString();
	                            if( !thirdPossibleEndObj == "endobj" )
	                            {
	                                throw new IOError("expected='endobj' firstReadAttempt='" + endObjectKey + "' " +
	                                    "secondReadAttempt='" + secondEndObjectKey + "' " );
	                            }
	                        }
	                    }
	                }
	            }
	            skipSpaces();
	        }
	        return isEndOfFile;
		} // end function
		
		private function addObjectToConflicts( offset:int, key:COSObjectKey, pb:COSBase):void
		{
		    var obj:COSObject = new COSObject(null);
		    obj.objectNumber = new COSInteger( key.number );
		    obj.generationNumber = new COSInteger( key.generation );
		    obj.baseObject = pb;
		    var conflictObj:ConflictObj = new ConflictObj(offset, key, obj);
		    _conflictList.addItem( conflictObj );
		}
		
		private function parseStartXref():Boolean
		{
			if(String.fromCharCode( peekUnsignedByte() ) != 's')
			{
            	return false; 
        	}
	        var nextLine:String = readLine();
	        if( !nextLine == "startxref" ) {
	            return false;
	        }
	        skipSpaces();
	        /* This integer is the byte offset of the first object referenced by the xref or xref stream
	         * Not needed for PDFbox
	         */
	        readInt();
	        return true;
        

		} // function end
    
	    private function parseXrefTable():Boolean
		{
	        if( String.fromCharCode( peekUnsignedByte() ) != 'x' )
	        {
	            return false;
	        }
	        var nextLine:String = readLine();
	        if( !nextLine == "xref" ) {
	            return false;
	        }
	        /*
	         * Xref tables can have multiple sections. 
	         * Each starts with a starting object id and a count.
	         */
	        while(true){
	            var currObjID:int = readInt(); // first obj id
	            var count:int = readInt(); // the number of objects in the xref table
	            skipSpaces();
	            for(var i:int = 0; i < count; i++){
	                if(isEOF() || isEndOfName( String.fromCharCode( peekUnsignedByte() ) ) )
	                {
	                    break;
	                }
	                if( String.fromCharCode( peekUnsignedByte() ) == 't'){
	                    break;
	                }
	                //Ignore table contents
	                var currentLine:String = readLine();
	                var splitString:Array = currentLine.split(" ");
	                
	                if( splitString[2] == "n" )
	                {
	                    try{
	                        var currOffset:int = int(splitString[0]);
	                        var currGenID:int = int(splitString[1]);
	                        var objKey:COSObjectKey = new COSObjectKey(currObjID, currGenID);
	                        _document.setXRef(objKey, currOffset);
	                    }
	                    catch(e:Error)
	                    {
	                        throw new IOError(e.toString());
	                    }
	                }
	                else if(!splitString[2] == "f" )
	                {
	                    throw new IOError("Corrupt XRefTable Entry - ObjID:" + currObjID);
	                }
	                currObjID++;
	                skipSpaces();
	            }
	            skipSpaces();
	            var c:String = String.fromCharCode( peekUnsignedByte() );
	            if(c < '0' || c > '9'){
	                break;
	            }
	        }
	        return true;
		} // function end
		
	    private function parseTrailer():Boolean
	    {
	        if( String.fromCharCode( peekUnsignedByte() ) != 't' )
	        {
	            return false;
	        }
	        //read "trailer"
	        var nextLine:String = readLine();
	        if( ! (nextLine == "trailer" ) )
	        {
	            // in some cases the EOL is missing and the trailer immediately continues with "<<" or with a blank character
	            // even if this does not comply with PDF reference we want to support as many PDFs as possible
	            // Acrobat reader can also deal with this.
	            if (startsWith( nextLine, "trailer"))
	            {
	                var len:int = "trailer".length;
	                unreadBytes(2 + (nextLine.length - len));
	            }
	            else {
	                return false;
	            }
	        }
	
	        // in some cases the EOL is missing and the trailer continues with " <<"
	        // even if this does not comply with PDF reference we want to support as many PDFs as possible
	        // Acrobat reader can also deal with this.
	        skipSpaces();
	
	        var parsedTrailer:COSDictionary = parseCOSDictionary();
	        var docTrailer:COSDictionary = _document.getTrailer();
	        if( docTrailer == null )
	        {
	            _document.trailer = parsedTrailer ;
	        }
	        else
	        {
	            // docTrailer.addAll( parsedTrailer );
	        }
	        skipSpaces();
	        return true;
	    }
	}
	

}
