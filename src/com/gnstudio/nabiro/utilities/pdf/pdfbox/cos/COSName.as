package com.gnstudio.nabiro.utilities.pdf.pdfbox.cos
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
	
	import com.gnstudio.nabiro.mvp.core.SharedData;

	public class COSName extends COSBase
	{
		
	    private static var nameMap:SharedData = new SharedData();
	    
	    /**
	     * All common COSName values are stored in a simple HashMap. They are already defined as
	     * static constants and don't need to be synchronized for multithreaded environments.
	     */
	    private static var commonNameMap:SharedData = new SharedData();

		private var _name:String;
		private var _hashCode:int;

		public function COSName(name:String)
		{
			_name = name;
		}
		
		public function toString():String
		{
			return _name;
		}
		
		public function fromString( aName:String, staticValue:Boolean ):COSName
		{
			var cn:COSName = new COSName( aName );
			
	        if ( staticValue )
	        	commonNameMap.addValue( aName, cn);
	        else
	        	nameMap.addValue( aName, cn );
	        _hashCode = 0;
	        
	        return cn;
		}
		
		public static function getPDFName( aName:String ):String
		{
	        var name:COSName = null;
	        if( aName != null )
	        {
	        	// Is it a common COSName ??
	            name = commonNameMap.getValue( aName ) as COSName;
	            if( name == null )
	            {
	            	// It seems to be a document specific COSName
	            	name = nameMap.getValue( aName ) as COSName;
	            	if( name == null )
	            	{
	            		//name is added to the synchronized map in the constructor
	            		// name = new COSName( aName, false );
	            	}	
	            }
	        }
	        return name.toString();
		}
		
	    /**
	     * A common COSName value.
	     */
	    public static var A:COSName = new COSName("A");
	    /**
	     * A common COSName value.
	     */
	    public static var AA:COSName = new COSName("AA");
	    /**
	    * A common COSName value.
	    */
	    public static var ACRO_FORM:COSName = new COSName("AcroForm");
	    /**
	    * A common COSName value.
	    */
	    public static var ANNOTS:COSName = new COSName("Annots");
	    /**
	     * A common COSName value.
	     */
	    public static var ART_BOX:COSName = new COSName("ArtBox");
	    /**
	    * A common COSName value.
	    */
	    public static var ASCII85_DECODE:COSName = new COSName("ASCII85Decode");
	    /**
	    * A common COSName value.
	    */
	    public static var ASCII85_DECODE_ABBREVIATION:COSName = new COSName("A85");
	    /**
	    * A common COSName value.
	    */
	    public static var ASCII_HEX_DECODE:COSName = new COSName("ASCIIHexDecode");
	    /**
	    * A common COSName value.
	    */
	    public static var ASCII_HEX_DECODE_ABBREVIATION:COSName = new COSName("AHx");
	    /**
	    * A common COSName value.
	    */
	    public static var AP:COSName = new COSName("AP");
	    /**
	     * A common COSName value.
	     */
	    public static var B:COSName = new COSName("B");
	    /**
	    * A common COSName value.
	    */
	    public static var BASE_ENCODING:COSName = new COSName("BaseEncoding");
	    /**
	    * A common COSName value.
	    */
	    public static var BASE_FONT:COSName = new COSName("BaseFont");
	    /**
	    * A common COSName value.
	    */
	    public static var BBOX:COSName = new COSName("BBox");
	    /**
	     * A common COSName value.
	     */
	    public static var BLEED_BOX:COSName = new COSName("BleedBox");
	    /**
	    * A common COSName value.
	    */
	    public static var CATALOG:COSName = new COSName("Catalog");
	    /**
	    * A common COSName value.
	    */
	    public static var CALGRAY:COSName = new COSName("CalGray");
	    /**
	    * A common COSName value.
	    */
	    public static var CALRGB:COSName = new COSName("CalRGB");
	    /**
	    * A common COSName value.
	    */
	    public static var CCITTFAX_DECODE:COSName = new COSName("CCITTFaxDecode");
	    /**
	    * A common COSName value.
	    */
	    public static var CCITTFAX_DECODE_ABBREVIATION:COSName = new COSName("CCF");
	    /**
	    * A common COSName value.
	    */
	    public static var CHAR_PROCS:COSName = new COSName("CharProcs");
	    /**
	    * A common COSName value.
	    */
	    public static var CHAR_SET:COSName = new COSName("CharSet");
	    /**
	    * A common COSName value.
	    */
	    public static var CID_FONT_TYPE0:COSName = new COSName("CIDFontType0");
	    /**
	    * A common COSName value.
	    */
	    public static var CID_FONT_TYPE2:COSName = new COSName("CIDFontType2");
	    /**
	    * A common COSName value.
	    */
	    public static var COLORSPACE:COSName = new COSName("ColorSpace");
	    /**
	    * A common COSName value.
	    */
	    public static var CONTENTS:COSName = new COSName("Contents");
	    /**
	    * A common COSName value.
	    */
	    public static var COUNT:COSName = new COSName("Count");
	    /**
	     * A common COSName value.
	     */
	    public static var CROP_BOX:COSName = new COSName("CropBox");
	    /**
	     * A common COSName value.
	     */
	    public static var DCT_DECODE:COSName = new COSName("DCTDecode");
	    /**
	     * A common COSName value.
	     */
	    public static var DCT_DECODE_ABBREVIATION:COSName = new COSName("DCT");
	    /**
	     * A common COSName value.
	     */
	    public static var DESCENDANT_FONTS:COSName = new COSName("DescendantFonts");
	    /**
	     * A common COSName value.
	     */
	    public static var DEST:COSName = new COSName("Dest");
	    /**
	    * A common COSName value.
	    */
	    public static var DEVICECMYK:COSName = new COSName("DeviceCMYK");
	    /**
	    * A common COSName value.
	    */
	    public static var DEVICEGRAY:COSName = new COSName("DeviceGray");
	    /**
	    * A common COSName value.
	    */
	    public static var DEVICEN:COSName = new COSName("DeviceN");
	    /**
	    * A common COSName value.
	    */
	    public static var DEVICERGB:COSName = new COSName("DeviceRGB");
	    /**
	     * A common COSName value.
	     */
	    public static var DIFFERENCES:COSName = new COSName("Differences");
	    /**
	    * A common COSName value.
	    */
	    public static var DV:COSName = new COSName("DV");
	    /**
	    * A common COSName value.
	    */
	    public static var DW:COSName = new COSName("DW");
	    /**
	    * A common COSName value.
	    */
	    public static var ENCODING:COSName = new COSName("Encoding");
	    /**
	     * A common COSName value.
	     */
	    public static var ENCODING_90MS_RKSJ_H:COSName = new COSName("90ms-RKSJ-H");
	    /**
	     * A common COSName value.
	     */
	    public static var ENCODING_90MS_RKSJ_V:COSName = new COSName("90ms-RKSJ-V");
	    /**
	     * A common COSName value.
	     */
	    public static var ENCODING_ETEN_B5_H:COSName = new COSName("ETen?B5?H");
	    /**
	     * A common COSName value.
	     */
	    public static var ENCODING_ETEN_B5_V:COSName = new COSName("ETen?B5?V");
	    /**
	     * A common COSName value.
	     */
	    public static var FIELDS:COSName = new COSName("Fields");
	    /**
	    * A common COSName value.
	    */
	    public static var FILTER:COSName = new COSName("Filter");
	    /**
	    * A common COSName value.
	    */
	    public static var FIRST_CHAR:COSName = new COSName("FirstChar");
	    /**
	    * A common COSName value.
	    */
	    public static var FLATE_DECODE:COSName = new COSName("FlateDecode");
	    /**
	    * A common COSName value.
	    */
	    public static var FLATE_DECODE_ABBREVIATION:COSName = new COSName("Fl");
	    /**
	    * A common COSName value.
	    */
	    public static var FONT:COSName = new COSName("Font");
	    /**
	     * A common COSName value.
	     */
	    public static var FONT_BBOX:COSName = new COSName("FontBBox");
	    /**
	     * A common COSName value.
	     */
	    public static var FONT_FAMILY:COSName = new COSName("FontFamily");
	    /**
	     * A common COSName value.
	     */
	    public static var FONT_FILE:COSName = new COSName("FontFile");
	    /**
	     * A common COSName value.
	     */
	    public static var FONT_FILE2:COSName = new COSName("FontFile2");
	    /**
	     * A common COSName value.
	     */
	    public static var FONT_FILE3:COSName = new COSName("FontFile3");
	    /**
	     * A common COSName value.
	     */
	    public static var FONT_DESC:COSName = new COSName("FontDescriptor");
	    /**
	     * A common COSName value.
	     */
	    public static var FONT_MATRIX:COSName = new COSName("FontMatrix");
	    /**
	    * A common COSName value.
	    */
	    public static var FONT_NAME:COSName = new COSName("FontName");
	    /**
	    * A common COSName value.
	    */
	    public static var FONT_STRETCH:COSName = new COSName("FontStretch");
	    /**
	    * A common COSName value.
	    */
	    public static var FORMTYPE:COSName = new COSName("FormType");
	    /**
	    * A common COSName value.
	    */
	    public static var FRM:COSName = new COSName("FRM");
	    /**
	     * A common COSName value.
	     */
	     public static var H:COSName = new COSName("H");
	    /**
	    * A common COSName value.
	    */
	    public static var HEIGHT:COSName = new COSName("Height");
	    /**
	    * A common COSName value.
	    */
	    public static var ICCBASED:COSName = new COSName("ICCBased");
	    /**
	    * A common COSName value.
	    */
	    public static var IDENTITY_H:COSName = new COSName("Identity-H");
	    /**
	    * A common COSName value.
	    */
	    public static var IMAGE:COSName = new COSName("Image");
	    /**
	    * A common COSName value.
	    */
	    public static var INDEXED:COSName = new COSName("Indexed");
	    /**
	     * A common COSName value.
	     */
	    public static var INFO:COSName = new COSName("Info");
	    /**
	    * A common COSName value.
	    */
	    public static var JPX_DECODE:COSName = new COSName("JPXDecode");
	    /**
	    * A common COSName value.
	    */
	    public static var KIDS:COSName = new COSName("Kids");
	    /**
	    * A common COSName value.
	    */
	    public static var LAB:COSName = new COSName("Lab");
	    /**
	    * A common COSName value.
	    */
	    public static var LAST_CHAR:COSName = new COSName("LastChar");
	    /**
	    * A common COSName value.
	    */
	    public static var LENGTH:COSName = new COSName("Length");
	    /**
	     * A common COSName value.
	     */
	    public static var LENGTH1:COSName = new COSName("Length1");
	    /**
	    * A common COSName value.
	    */
	    public static var LZW_DECODE:COSName = new COSName("LZWDecode");
	    /**
	    * A common COSName value.
	    */
	    public static var LZW_DECODE_ABBREVIATION:COSName = new COSName("LZW");
	    /**
	    * A common COSName value.
	    */
	    public static var MAC_ROMAN_ENCODING:COSName = new COSName("MacRomanEncoding");
	    /**
	    * A common COSName value.
	    */
	    public static var MATRIX:COSName = new COSName("Matrix");
	    /**
	     * A common COSName value.
	     */
	    public static var MEDIA_BOX:COSName = new COSName("MediaBox");
	    /**
	     * A common COSName value.
	     */
	    public static var METADATA:COSName = new COSName("Metadata");
	    /**
	    * A common COSName value.
	    */
	    public static var MM_TYPE1:COSName = new COSName("MMType1");
	    /**
	    * A common COSName value.
	    */
	    public static var N:COSName = new COSName("N");
	    /**
	    * A common COSName value.
	    */
	    public static var NAME:COSName = new COSName("Name");
	    /**
	    * A common COSName value.
	    */
	    public static var P:COSName = new COSName("P");
	    /**
	    * A common COSName value.
	    */
	    public static var PAGE:COSName = new COSName("Page");
	    /**
	    * A common COSName value.
	    */
	    public static var PAGES:COSName = new COSName("Pages");
	    /**
	    * A common COSName value.
	    */
	    public static var PARENT:COSName = new COSName("Parent");
	    /**
	    * A common COSName value.
	    */
	    public static var PATTERN:COSName = new COSName("Pattern");
	    /**
	    * A common COSName value.
	    */
	    public static var PDF_DOC_ENCODING:COSName = new COSName("PDFDocEncoding");
	    /**
	    * A common COSName value.
	    */
	    public static var PREV:COSName = new COSName("Prev");
	    /**
	     * A common COSName value.
	     */
	     public static var R:COSName = new COSName("R");
	    /**
	    * A common COSName value.
	    */
	    public static var RESOURCES:COSName = new COSName("Resources");
	    /**
	    * A common COSName value.
	    */
	    public static var ROOT:COSName = new COSName("Root");
	    /**
	     * A common COSName value.
	     */
	    public static var ROTATE:COSName = new COSName("Rotate");
	    /**
	    * A common COSName value.
	    */
	    public static var RUN_LENGTH_DECODE:COSName = new COSName("RunLengthDecode");
	    /**
	    * A common COSName value.
	    */
	    public static var RUN_LENGTH_DECODE_ABBREVIATION:COSName = new COSName("RL");
	    /**
	    * A common COSName value.
	    */
	    public static var SEPARATION:COSName = new COSName("Separation");
	    /**
	    * A common COSName value.
	    */
	    public static var STANDARD_ENCODING:COSName = new COSName("StandardEncoding");
	    /**
	    * A common COSName value.
	    */
	    public static var SUBTYPE:COSName = new COSName("Subtype");
	    /**
	     * A common COSName value.
	     */
	    public static var TRIM_BOX:COSName = new COSName("TrimBox");
	    /**
	     * A common COSName value.
	     */
	    public static var TRUE_TYPE:COSName = new COSName("TrueType");
	    /**
	    * A common COSName value.
	    */
	    public static var TO_UNICODE:COSName = new COSName("ToUnicode");
	    /**
	    * A common COSName value.
	    */
	    public static var TYPE:COSName = new COSName("Type");
	    /**
	     * A common COSName value.
	     */
	    public static var TYPE0:COSName = new COSName("Type0");
	    /**
	    * A common COSName value.
	    */
	    public static var TYPE1:COSName = new COSName("Type1");
	    /**
	    * A common COSName value.
	    */
	    public static var TYPE3:COSName = new COSName("Type3");
	    /**
	    * A common COSName value.
	    */
	    public static var V:COSName = new COSName("V");
	    /**
	     * A common COSName value.
	     */
	     public static var VERSION:COSName = new COSName("Version");
	    /**
	     * A common COSName value.
	     */
	    public static var W:COSName = new COSName("W");
	    /**
	     * A common COSName value.
	     */
	    public static var WIDTHS:COSName = new COSName("Widths");
	    /**
	    * A common COSName value.
	    */
	    public static var WIN_ANSI_ENCODING:COSName = new COSName("WinAnsiEncoding");
	    /**
	    * A common COSName value.
	    */
	    public static var XOBJECT:COSName = new COSName("XObject");
	}
}
