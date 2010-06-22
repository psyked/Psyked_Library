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

	public class COSDictionary extends COSBase
	{
		public var items:SharedData;
		public var keys:SharedData;
		
	    private static var PATH_SEPARATOR:String = "/";

		public function COSDictionary( )
		{
			
		}

		// instead of copy constructor
		public function setCOSDictionaryData( dict:COSDictionary ):void
		{
			// TODO: make a shallow copy
	        items = dict.items;
	        keys = dict.keys;
		}
		
		public function getDictionaryObject( key:COSName ):COSBase
		{
	        var retval:COSBase = items.getValue( key.toString() ) as COSBase;
	        
	        if( retval is COSObject )
	        {
	            retval = (retval as COSObject).baseObject;
	        }
	        if( retval is COSNull )
	        {
	            retval = null;
	        }
	        return retval;
		}

		public function getDictionaryObjectString( key:String ):COSBase
		{
			return new COSBase();
		}
		
		public function setItem(key:COSName, value:COSBase):void
		{
			if( value == null )
	        {
	            removeItem( key );
	        }
	        else
	        {
	            if (!items.getValue(key.toString()))
	            {
	                // insert only if not already there
	                keys.addValue( key.toString(), key );
	            }
	            items.addValue( key.toString(), value );
	        }
		}
		
		public function removeItem( key:COSName ):void
		{
			keys.deleteValue( key.toString() );
			items.deleteValue( key.toString() );
	    }
	    
	    public function addAll( dic:COSDictionary ):void
	    {
	    	
	    	for each ( var key:* in dic.keys.getAll() )
			{
	            var value:COSBase = dic.getItem( key );
	            /*
	             * If we're at a second trailer, we have a linearized 
	             * pdf file, meaning that the first Size entry represents
	             * all of the objects so we don't need to grab the second. 
	             */
	            if(!key == "Size" || !keys.getValue( COSName.getPDFName("Size") ) )
	            {
	                setItem( key, value );
	            }
			}
	    	
	    }
	    
	    public function getItem( key:COSName ):COSBase
	    {
	        return items.getValue( key.toString() ) as COSBase;
	    }
	}
}
