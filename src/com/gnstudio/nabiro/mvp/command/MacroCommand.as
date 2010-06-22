package com.gnstudio.nabiro.mvp.command {
	
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
	
    public class MacroCommand extends AbstractCommand {

        protected var _commandList :Array;

        public function MacroCommand() {
        	
            _commandList = [];
            
        }
		
		/**
		 * Add a command or a list of command to the _commandList array
		 * @param command AbstractCommand
		 * @param commands rest
		 */ 
        public function addCommand(command :ICommand, ...commands) :void {
        	
            _commandList = _commandList.concat([command].concat(commands));
            
        }
		
		/**
		 * Remove one or more commands from the queue
		 * @param command ICommand
		 * @param commands rest
		 */ 
        public function removeCommand(command:ICommand, ...commands) :void {
           
            commands.unshift(command);
            
            for (var i:int = 0; i < commands.length; i++) {
            	
                for (var j: int = 0; j < _commandList.length; j++) {
                	
                    if (_commandList[j] === commands[i]) {
                    	
                        _commandList.splice(i, 1);
                        break;
                        
                    }
                }
            }
        }
		
		/**
		 * Override of the execute method it's able to perform
		 * the execution of a list of commands
		 */ 
        public override function execute() :void {
        	
            for (var i :int = 0; i < _commandList.length; i++) {
            	
                (_commandList[i] as ICommand).execute();
                
            }
            
            onCommandComplete();
        }
    }
}
