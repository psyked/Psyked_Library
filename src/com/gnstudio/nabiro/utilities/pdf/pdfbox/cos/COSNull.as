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
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;

	public class COSNull extends COSBase
	{
		
	    /**
	     * The null token.
	     */
	    public static var NULL_BYTES:ByteArray;
	    
		private static var _className:String = getQualifiedClassName(super);
		private static var _target:IEventDispatcher;
	    private static var _instance:COSNull;
	    private var _eventDispatcher:EventDispatcher;
	    
    
		public function COSNull()
		{
			if (_instance != null && getQualifiedSuperclassName(this) != _className) throw new Error("This a singleton class!");
			
			_eventDispatcher = new EventDispatcher();
		}
		
		/**
		 * Method used to be sure that only an instance of the class will be created
		 * @param target IEventDispatcher
		 */ 

		public static function getInstance(tg:IEventDispatcher = null):COSNull {

			if(!_instance){
				
				_instance = new COSNull();
				NULL_BYTES = new ByteArray();
				NULL_BYTES.writeByte(110);
				NULL_BYTES.writeByte(117);
				NULL_BYTES.writeByte(108);
				NULL_BYTES.writeByte(108);
				
			}
			
			if(tg){
				
				_target = tg;
				
			}
			
			return _instance;
			
		}
	}
}
