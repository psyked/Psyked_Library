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
	import com.gnstudio.nabiro.utilities.HashMap;
	import com.gnstudio.nabiro.utilities.pdf.pdfbox.persistence.util.COSObjectKey;
	
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;

	public class COSDocument
	{
		private var _trailer:COSDictionary;
		
	    private var objectPool:HashMap = new HashMap();
	    
	    private var objects:ArrayCollection = new ArrayCollection();
	    
	    private var _headerString:String = "%PDF-1.4";
	    
	    private var _version:Number;
		
		private var _scratchFile:ByteArray;
		
		private var _tmpFile:ByteArray;

		private var _xrefTable:SharedData = new SharedData();

		public function COSDocument()
		{
			
			_scratchFile = new ByteArray();
			_tmpFile = new ByteArray();
			
		}

		public function get trailer():COSDictionary
		{
			return _trailer;
		}

		public function set trailer(v:COSDictionary):void
		{
			_trailer = v;
		}
		
		public function getObjectFromPool(key:COSObjectKey):COSObject
		{

		    var obj:COSObject = null;
		    
		    if( key != null )
		    {
		        obj = objectPool.getItem(key.toString(), null) as COSObject;
		    }
		    if (obj == null)
		    {
		        // this was a forward reference, make "proxy" object
		        obj = new COSObject( null );
		        
		        if( key != null )
		        {
		            obj.objectNumber = new COSInteger( key.number );
		            obj.generationNumber = new COSInteger( key.generation );
		            objectPool.addItem(obj);
		        }
		        objects.addItem( obj );
		    }

		    return obj;
		}
		
		public function isEncrypted():Boolean
	    {
	        var encrypted:Boolean = false;
	        if( _trailer != null )
	        {
	            encrypted = _trailer.getDictionaryObjectString( "Encrypt" ) != null;
	        }
	        return encrypted;
	    }
	    
	    public function setHeaderString(header:String):void{
	    	_headerString = header;
	    }
	    
	    public function setVersion( version:Number ):void
	    {
	    	_version = version;
	    }

	    public function getTrailer():COSDictionary
	    {
	        return _trailer;
	    }
	    
	    public function getScratchFile():ByteArray
	    {
	        return _scratchFile;
	    }
	    
	    public function getXrefTable():SharedData
	    {
	    	return _xrefTable;
	    }
	    
	    public function setXRef(objKey:COSObjectKey, offset:int):void
	    {
	        _xrefTable.addValue( objKey.toString(), int(offset) );
	    }
	}
}
