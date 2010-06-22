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
    
    import flash.display.Loader;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.net.URLRequest;

    /**
     *
     *  $Id: LoadCommand.as 
     *
     */
    public class LoadCommand extends AbstractCommand {

        private var _url    :String;
        private var _loader :Loader;

        public function LoadCommand(url:String = null, loader:Loader = null, isUndoable:Boolean = false)  {

            _url    = url;
            _loader = loader;
            allowUndo = isUndoable;

        }

        override public function execute() :void {

            if ((_loader == null) || (_url == null)) {

                onCommandFail("Cannot execute load command: "+ (!_loader  ? " Loader not defined. " : "")  + (!_url ? " Url not speficied." : ""));
                return;

            }

            _loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);

            _loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadComplete);

            _loader.load(new URLRequest(_url));

        }

        private function onLoadComplete(event:Event) :void {

            _loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);

            _loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoadComplete);

            switch (event.type) {

                case Event.COMPLETE:
                    onCommandComplete();
                    break;

                case IOErrorEvent.IO_ERROR:
                    onCommandFail((event as IOErrorEvent).text);
                    break;
            }
        }

        // ------- getters and setters -------
        public function set url(value :String) :void {
        	
            _url = value;
            
        }
        
        public function get url() :String {
        	
            return _url;
            
        }

        public function set loader(value :Loader) :void {
        	
            _loader = value;
            
        }

        public function get loader() :Loader {
            
            return _loader;
            
        }
    }
}
