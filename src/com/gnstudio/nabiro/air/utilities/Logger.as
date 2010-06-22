package com.gnstudio.nabiro.air.utilities
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
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	public class Logger{
		
		/**
		 * Class used to make verbose logs in the filesystem
		 */ 
		
		private static var _className:String = getQualifiedClassName(super);
		private static var _instance:Logger;
		
		private var today:Date = new Date()
		
		private const FILE_NAME:String = "Tracer.log";
		
		public function Logger(){
			
			if (_instance != null && getQualifiedSuperclassName(this) != _className) throw new Error("This a singleton class!");
						
		}
		
		public static function getInstance(start:Boolean = true):Logger{
			
			if(!_instance){
				
				_instance = new Logger();			
				
				if(start){
				
					_instance.start();	
				
				}
				
			}
			
			return _instance;
			
		}
		
		private var _fileName:String;
		
		public function set fileName(value:String):void{
			
			_fileName = value;
			
		}
		
		private var stream:FileStream;
		
		public function start():void{
			
			var file:File = File.applicationStorageDirectory.resolvePath(_fileName || FILE_NAME);
			stream = new FileStream();
			
			if(!file.exists){
				
				var wr:File = new File( file.nativePath );
				stream.openAsync(wr, FileMode.WRITE);
				stream.writeUTFBytes("APPLICATION FIRST RUN: " + today + "\r\n");
				
			}else{
				
				stream.openAsync(file, FileMode.APPEND);
				stream.writeUTFBytes("APPLICATION START:  " + today + "\r\n");
				
			}
			
		}
		
		public function addLog(value:String):void{
			
			today = new Date();
			stream.writeUTFBytes("Log " + today + ": " + value + "\r\n");
			
		}
		
		public function stop():void{
			
			today = new Date();
			
			stream.writeUTFBytes("APPLICATION CLOSE:  " + today + "\r\n============================\r\n");
			stream.close();
			
		}

	}
}