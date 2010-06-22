package com.gnstudio.nabiro.utilities {
	
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
	
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class JPGSize extends ByteArray implements IGetImageSize {
		
		// _________________________________________________________________________
		// CLASS CONSTANTS
		
		/**
		 * JPEG Start Of Frame 0 identifier FFC0 + length & bitdepth
		 */
		protected static const SOF0	: Array = [ 0xFF, 0xC0 , 0x00 , 0x11 , 0x08 ];
		
		// _________________________________________________________________________
		// VARIABLES
		
		protected var dataLoaded						: uint;
		protected var jpgWidth							: uint;
		protected var jpgHeight							: uint;
		protected var jumpLength						: uint;
	
		// _________________________________________________________________________
		// CONSTRUCTOR
		
		
		function JPGSize( ) {
			
			endian = Endian.BIG_ENDIAN;
			
		}
		
		// _________________________________________________________________________
		// PROTECTED METHODS
		
		/**
		 * Easy way to skip bytes, since URLStream doesn't have position implemented as in ByteArray
		 */
		protected function jumpBytes( count : uint ) : void {
			
			for ( var i : uint = 0; i < count; i++ ) {
				
				readByte( );
			
			}
		}
		
		// _________________________________________________________________________
		// PUBLIC API METHODS		
		
		/**
		 * Get the rectangle that represnts the size of the image
		 */
		public function extractSize():Rectangle{
			
			dataLoaded = bytesAvailable;
			var APPSections : Array = new Array( );
			
			for ( var i : int = 1; i < 16; i++ ) {
				
				APPSections[ i ] = [ 0xFF, 0xE0 + i ];
				
			}
			
			var index : uint = 0;
			var byte : int = 0;
			var address : int = 0;
			
			while ( bytesAvailable >= SOF0.length + 4 ) {
				
				var match : Boolean = false;
				// Only look for new APP table if no jump is in queue
				if ( jumpLength == 0 ) {
					byte = readUnsignedByte( );
					address++;
					// Check for APP table
					for each ( var APP : Array in APPSections ) {
						if ( byte == APP[ index ] ) {
							
							// trace(byte , APP[ index ] )
							
							match = true;
							if ( index+1 >= APP.length ) {
								
								// APP table found, skip it as it may contain thumbnails in JPG (we don't want their SOF's)
								jumpLength = readUnsignedShort( ) - 2; // -2 for the short we just read
								
							}
						}
					}
				}
				
				// Jump here, so that data has always loaded
				if ( jumpLength > 0 ) {
					
					//if ( traceDebugInfo ) trace( "Trying to jump " + jumpLength + " bytes (available " + Math.round( Math.min( bytesAvailable / jumpLength, 1 ) * 100 ) + "%)" );
					if ( bytesAvailable >= jumpLength ) {
						
						jumpBytes( jumpLength );
						match = false;
						jumpLength = 0;
					} else break; // Load more data and continue
				
				} else {
					
					// Check for SOF
					if ( byte == SOF0[ index ] ) {
						match = true;
						if ( index+1 >= SOF0.length ) {
							
							// Matched SOF0
							
							jpgHeight = readUnsignedShort( );
							jpgWidth = readUnsignedShort( );
							break;
							
						}
					}
					
					if ( match ) {
						
						index++;
						
					} else {
						
						index = 0;
						
					}
				}
			}
			
			return new Rectangle(0, 0, jpgWidth, jpgHeight);
			
		}
				
		/**
		 * The width of the parsed image 
		 */
		public function get width():uint {
			
			return jpgWidth;
		
		}
		
		/**
		 * The height of the parsed image 
		 */
		public function get height():uint {
			
			return jpgHeight;
		
		}
		
	}
}