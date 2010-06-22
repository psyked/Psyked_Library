package com.gnstudio.nabiro.measurement
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
	
	public class ConversionUtils
	{
		// ---------------------------------------------------------
	    //                Angle Conversion Functions
	    // ---------------------------------------------------------
	    public static function degreeTOradian (nValue:Number):Number {
	      	
	      	return (nValue * Math.PI / 180);
	     
	    }
	    
	    public static function radianTOdegree (nValue:Number):Number {
	        
	        return (nValue * 180 / Math.PI);
	    
	    }
	    
	    public static function gradianTOdegree (nValue:Number):Number {
	        
	        return (nValue * .9);
	    }
	    
	    public static function gradianTOradian (nValue:Number):Number {
	        
	        return degreeTOradian(nValue * .9);
	    }
	    
	    public static function degreeTOgradian (nValue:Number):Number {
	        
	        return (nValue / .9);
	    
	    }
	    
	    public static function radianTOgradian (nValue:Number):Number {
	        
	        return radianTOdegree(nValue) / .9;
	    
	    }
	
	    // ---------------------------------------------------------
	    //                Temperature Conversion Functions
	    // ---------------------------------------------------------
	    public static function fahrenheitTOcelcius (nValue:Number):Number {
	        
	        return ((nValue - 32) * (5 / 9));
	    
	    }
	    
	    public static function celciusTOfahrenheit (nValue:Number):Number {
	        
	       return ((nValue * (9 / 5)) + 32);
	     
	    }
	     
	    public static function fahrenheitTOkelvin (nValue:Number):Number {
	        
	       return fahrenheitTOcelcius(nValue) + 273.15;
	      
	    }
	     
	    public static function kelvinTOfahrenheit (nValue:Number):Number {
	        
	       return fahrenheitTOcelcius(nValue) + 273.15;
	     
	    }
	     
	    public static function celciusTOkelvin (nValue:Number):Number {
	        
	        return (nValue + 273.15);
	      
	    }
	     
	    public static function kelvinTOcelcius (nValue:Number):Number {
	        
	       return nValue - 273.15;
	     
	    }
	
	    // ---------------------------------------------------------
	    //                Mass/Weight Conversion Functions
	    // ---------------------------------------------------------
	    public static function gramTOpound (nValue:Number):Number {
	        
	        return (nValue * .0022);
	    }
	    
	    public static function poundTOgram (nValue:Number):Number {
	        
	        return (nValue / .0022);
	    
	    }
	
	    // ---------------------------------------------------------
	    //                Distance Conversion Functions
	    // ---------------------------------------------------------
	    public static function footTOmeter (nValue:Number):Number {
	        
	        return (nValue / 3.2808399);
	    
	    }
	    
	    public static function meterTOfoot (nValue:Number):Number {
	        
	        return (nValue * 3.2808399);
	    
	    }
	
	    // ---------------------------------------------------------
	    //                Volume Conversion Functions
	    // ---------------------------------------------------------
	    
	    public static function gallonTOliter (nValue:Number):Number {
	        
	        return (nValue * 3.7854);
	    }
	    
	    public static function literTOgallon (nValue:Number):Number {
	        
	        return (nValue / 3.7854);
	    
	    }

	}
}