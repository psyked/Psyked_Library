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
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	public class OpenUrlCommand extends AbstractCommand{
		
		private var _url:String;
		private var _isPopup:Boolean;
		
		public function OpenUrlCommand(url:String, popup:Boolean, isUndoable:Boolean = false){
			
			super();
			
			_url = url;
			_isPopup = popup;
			
			allowUndo = isUndoable;
			
		}
		
		 override public function execute() :void {
		 	
		 	var url:URLRequest = new URLRequest(_url);
		 	
		 	navigateToURL(url, _isPopup ? "_blank" : "_self");
		 	
		 	 onCommandComplete();
		 	
		 }
		
	}
}