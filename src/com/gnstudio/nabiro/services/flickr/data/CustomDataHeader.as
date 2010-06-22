package com.gnstudio.nabiro.services.flickr.data
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
	
        import com.gnstudio.nabiro.mvp.encryption.MD5;
        
        import flash.utils.ByteArray;
        import flash.utils.Endian;
        
        /**
        * The class needs to create a request that works with the facebook api that follow this format
        * 
        * 	Content-Type: multipart/form-data; boundary=SoMeTeXtWeWiLlNeVeRsEe 
		*	MIME-version: 1.0 
		*	
		*	--SoMeTeXtWeWiLlNeVeRsEe 
		*	Content-Disposition: form-data; name="method"
		*	
		*	facebook.photos.upload 
		*	--SoMeTeXtWeWiLlNeVeRsEe 
		*	Content-Disposition: form-data; name="v" 
		*	
		*	API VERSION
		*	--SoMeTeXtWeWiLlNeVeRsEe 
		*	Content-Disposition: form-data; name="api_key" 
		*	
		*	YOUR API KEY
		*	--SoMeTeXtWeWiLlNeVeRsEe 
		*	Content-Disposition: form-data; name="session_key" 
		*	
		*	THE SESSION KEY (MANDATORY FOR DESKTOP APPLICATIONS) 
		*	--SoMeTeXtWeWiLlNeVeRsEe 
		*	Content-Disposition: form-data; name="call_id" 
		*	
		*	THE CALL ID
		*	--SoMeTeXtWeWiLlNeVeRsEe 
		*	Content-Disposition: form-data; name="caption" 
		*	
		*	OPTIONAL CAPTION
		*	--SoMeTeXtWeWiLlNeVeRsEe 
		*	Content-Disposition: form-data; name="aid"
		*	
		*	ALBUM ID
		*	--SoMeTeXtWeWiLlNeVeRsEe 
		*	Content-Disposition: form-data; name="sig"
		*	
		*	THE SIG VALUE
		*	--SoMeTeXtWeWiLlNeVeRsEe 
		*	Content-Disposition: form-data; filename="FILE_NAME.EXT" Content-Type: image/jpg
		*	
		*	[Raw file data here] 
		*	--SoMeTeXtWeWiLlNeVeRsEe--
        * 
        */         
        
        public class CustomDataHeader
        {
                private var boundary:String = MD5.encrypt(String(Math.random()));
                private var header:ByteArray;
                
                public function CustomDataHeader() {
                	
                	header = new ByteArray();
                    header.endian = Endian.BIG_ENDIAN;
                              
                }                
                               
                private function writeLineBreak():void {
                	
                    header.writeShort(0x0d0a);
                
                }
                
                private function writeQuotationMark():void {
                    
                    header.writeByte(0x22);
                
                }
                
                private function writeDashes():void{
                  	
                  	header.writeShort(0x2d2d);
                
                }
                
                private function writeBoundary():void {
                        
                   	writeDashes();
                        
                    for (var i:Number=0; i<boundary.length; i++){
                        	
                    	header.writeByte(boundary.charCodeAt(i));
                                              
                     }
                     
                }             
                
                public function writePostData(name:String, value:*):void {
                	
               		var bytes:String;
                    writeBoundary();
                    writeLineBreak();
                        
                    bytes = 'Content-Disposition: form-data; name="' + name + '"';
                        
                    for (var i:Number=0; i<bytes.length; i++){
                        	
                        header.writeByte(bytes.charCodeAt(i));
                        
                    }
                        
                    writeLineBreak();
                    writeLineBreak();
                    header.writeUTFBytes(value);
                        
                    writeLineBreak();
                    
                }
                
                public function writeFileData(filename:String, data:ByteArray):void{
                	
                  	var bytes:String;
                    writeBoundary();
                    writeLineBreak();
                        
                    bytes = 'Content-Disposition: form-data; filename="';
                        
                    var i:int;
                        
                    for (i = 0; i < bytes.length; i++){
                          	
                     	header.writeByte(bytes.charCodeAt(i));
                        
                    }
                        
                    header.writeUTFBytes(filename);
                    writeQuotationMark();
                    writeLineBreak();
                        
                    bytes = 'Content-Type: image/jpg';
                        
                    for (i = 0; i < bytes.length; i++){
                           	
                     	header.writeByte(bytes.charCodeAt(i));
                        
                    }
                        
                    writeLineBreak();
                    writeLineBreak();
                    data.position = 0;
                        
                    header.writeBytes(data, 0, data.length);
                    writeLineBreak();
                        
                }
                
                public function closeData():String{
                  	
                  	writeBoundary();
                    writeDashes();
                    
                    return boundary;
                
                }
                
                public function getData():ByteArray{
                  	
                  	header.position = 0;
                    return header;
                
                }
        }
}
