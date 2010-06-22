package com.gnstudio.nabiro.commands.air
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
	
	import com.gnstudio.nabiro.mvp.command.AbstractCommand;
	
	import flash.filesystem.File;

	public class RecoverFilteredFolderFiles extends AbstractCommand{
		
		/**
		 * @private
		 * Storage for folderToExplore property.
		 */
		private var _folderToExplore:File;
		
		/**
		 * Keeps the reference to the folder of our interest.
		 */
		public function get folderToExplore():File {
			
			return _folderToExplore;
		}

		public function set folderToExplore(v:File):void {
			
			_folderToExplore = v;
		}
		
		/**
		 * Array of File objects.
		 */
		public var filesList:Array;
		
		protected var filter:RegExp;// = /^\S+\.(jpg|jpeg|png)$/i;
		
		public function RecoverFilteredFolderFiles (folder:File, extension:String, isUndoable:Boolean = false){
			
			
			super();
			
			filter = new RegExp("^\\S+\\.(" + extension + ")$", "i")
			
			folderToExplore = folder;
			
			allowUndo = isUndoable;
			
			filesList = [];			
			
		}
		
		private function validateFile(file:File):Boolean{
        	
            return filter.exec( file.name ) != null;
        
        }
		
		override public function execute():void{
			
			var tmpArr:Array = folderToExplore.getDirectoryListing();
			var tmpArrLenght:int = tmpArr.length;
			
			for(var i:int = 0; i < tmpArrLenght; i++){
				
				if(validateFile((tmpArr[i] as File))){	
				//if(!(tmpArr[i] as File).isDirectory && extensionToFind.indexOf((tmpArr[i] as File).extension) >= 0){
					
					// filesList.push({name: tmpArr[i].name, url: tmpArr[i].url, nativePath: tmpArr[i].nativePath});
					filesList.push((tmpArr[i] as File));
					
				}
				
			}
			
			onCommandComplete();
			
		}
		
	}
}