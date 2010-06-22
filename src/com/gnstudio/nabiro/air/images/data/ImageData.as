package com.gnstudio.nabiro.air.images.data{
	
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
	
    
    import flash.display.BitmapData;
    import flash.utils.ByteArray;

    public class ImageData 
    {
        private var _name:String;
        private var _filePath:String;
        private var _thumbnail:BitmapData;
        private var _thumbnailRaw:ByteArray;
        private var _id:String;
        private var _filters:Array;

        public function ImageData( name:String = "", filePath:String = "", thumbnail:BitmapData = null, filters:Array = null, id:String = ""){
        	
            _name = name;
            _filePath = filePath;
            _thumbnail = thumbnail;
            _filters = filters
            _id = id;
                        
        }
        
        public function clone():ImageData{
        	
            return new ImageData( _name, _filePath, _thumbnail.clone(), _filters, _id);
            
        }
        
        public function get fileExtension():String{
        	
            return _name.substr( _name.lastIndexOf( "." ), _name.length ).toLowerCase();
            
        }
		
		/**
		 * The name of the file
		 */ 
        [Bindable]
        public function set name(value:String):void{
        	
            _name = value;
            
        }
        
        public function get name():String{
        	
            return _name;
            
        }
        
        /**
        * The path of the file (local or remote)
        */ 
        [Bindable]
        public function set filePath(value:String):void{
        	
            _filePath = value;
            
        }
        
        public function get filePath():String{
        	
            return _filePath;
            
        }
		
		/**
		 * The bitmap data that represent the image thumb
		 */ 
        [Bindable]
        public function set thumbnail(value:BitmapData):void{
        	
            _thumbnail = value;
            
        }
        
        public function get thumbnail():BitmapData{
        	
            return _thumbnail;
            
        }
        
        /**
		 * The bitmap raw data that represent the image thumb (used when you want to store the image in a sqlite db)
		 */ 
        [Bindable]
        public function set thumbnailRaw(value:ByteArray):void{
        	
            _thumbnailRaw = value;
            
        }
        
        public function get thumbnailRaw():ByteArray{
        	
            return _thumbnailRaw;
            
        }
        
       
		/**
		 * The id that comes from the DB (optional)
		 */ 
		[Bindable]
        public function set id(value:String ):void{
        	
            _id = value;
            
        }
        
        public function get id():String{
        	
            return _id;
            
        }

		/**
		 * The filters applied to the image
		 */         
        [Bindable]
        public function set filters(value:Array):void{
        	
            _filters = value;
            
        }
        
        public function get filters():Array{
        	
            return _filters;
            
        }
    }
}