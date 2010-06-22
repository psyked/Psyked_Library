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

	public class COSNumber extends COSBase
	{
		
	    /**
	     * ZERO.
	    */
	    public static var ZERO:COSInteger = new COSInteger( 0 );
	    /**
	     * ONE.
	    */
	    public static var ONE:COSInteger = new COSInteger( 1 );
	    
	    private static var COMMON_NUMBERS:SharedData = new SharedData();
    
		public function COSNumber()
		{
		}
		
		public static function getValue( number:String ):COSNumber
		{
	        var result:COSNumber = COMMON_NUMBERS.getValue( number ) as COSNumber;
	        if( result == null )
	        {
	            if (number.indexOf('.') >= 0)
	            {
	                result = COSFloat.fromString( number );
	            }
	            else
	            {
	                result = COSInteger.fromString( number );
	            }
	        }
	        return result;
		}
	}
}
