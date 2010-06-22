package com.gnstudio.nabiro.commands
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
	
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	
	import mx.controls.Button;
	import mx.controls.ProgressBar;

	public class DownloadFile extends AbstractCommand{
		
		private var _url:String;
		private var _isPopup:Boolean;

	    private var fr:FileReference;
	    private var pb:ProgressBar;
	    private var btn:Button
		
		public function DownloadFile(url:String, isUndoable:Boolean = false){
			
			super();
			
			_url = url;
	
	        fr = new FileReference();
	        fr.addEventListener(Event.OPEN, openHandler);
	        //  fr.addEventListener(ProgressEvent.PROGRESS, progressHandler);
	        //  fr.addEventListener(Event.COMPLETE, completeHandler);
			allowUndo = isUndoable;
		}
		
	
	
		private function openHandler(event:Event):void
	    {
	        
	    }
	
		private function progressHandler(event:ProgressEvent):void
	    {
	      //  pb.setProgress(event.bytesLoaded, event.bytesTotal);
	    }
	    
	    
		 override public function execute() :void {
		 	
		 	var request:URLRequest = new URLRequest();
	        request.url = _url;
	        fr.download(request);
		 	
		 }
		
	}
}