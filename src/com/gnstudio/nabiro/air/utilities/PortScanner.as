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
	 *
	 */


	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.Socket;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;

	public class PortScanner implements IEventDispatcher
	{

		private static var _className:String = getQualifiedClassName(super);
		private static var _instance:PortScanner;
		private static var _handler:IEventDispatcher;

		private var eventDispatcher:EventDispatcher;

		private var iStartPort:int;
		private var iEndPort:int;
		private var iPortCount:int;
		private var iCurrentPort:int;

		private var resetting:Boolean;

		private var socket:Socket;

		public static const PORT_RECOVERED:String = "onPortRecovered";
		public static const PORT_NOT_RECOVERED:String = "onPortNotRecovered";
		public static const CONNECTION_ERROR:String = "onPortScannerConnectionError";
		public static const CONNECTION_CLOSED:String = "onPortScannerConnectionClosed";


		public function PortScanner(handler:IEventDispatcher = null){

			_handler = handler;

			eventDispatcher = new EventDispatcher();

		}


		/**
		 * Method used to be sure that only an instance of the class will be created
		 * ***********************
		 * NOTE: this patch comes from Jaco, not sure if this method has to be implemented
		 * ***********************
		 */
		public static function getInstance():PortScanner{

			if(!_instance){

				_instance = new PortScanner();

			}

			return _instance;

		}

		public function startTesting(start:int, end:int):void{

			iStartPort = start;
			iEndPort =  end;
			iPortCount = iEndPort - iStartPort;
			iCurrentPort = iStartPort;

			checkPort();

		}

		/**
	     * This method is called if the socket encounters an ioError event.
	     */
		private function checkPort():void{

			socket = new Socket();

			socket.addEventListener(Event.CONNECT,onSocketConnected);
			socket.addEventListener(Event.CLOSE, onCloseHandler);
    		socket.addEventListener(ErrorEvent.ERROR, onErrorHandler);
    		socket.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);

    		try{

    			socket.connect("127.0.0.1", iCurrentPort);

   			}catch(error:Error){

   				trace("Socket Error : " + error.toString());
   				socket.close();

   			}

		}

		/**
	     * This method is called if the socket encounters an ioError event.
	     */
	    private function onIOErrorHandler(e:IOErrorEvent):void {

			trace("Port " + iCurrentPort + " is Closed ");

	        trace("Unable to connect: socket error.\n");

	        if(resetting){

	        	resetting = false;

	        	socket.removeEventListener(Event.CONNECT,onSocketConnected);
				socket.removeEventListener(Event.CLOSE, onCloseHandler);
	    		socket.removeEventListener(ErrorEvent.ERROR, onErrorHandler);
	    		socket.removeEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);

	    		socket = null;

	        }else{

	        	checkNextPort();

	        }

	    }


	    /**
	     * This method is called when the socket connection is closed by
	     * the server.
	     */
	    private function onCloseHandler(e:Event):void {

	    	trace("closed...\n");

	        if(_handler){

    			_handler.dispatchEvent(new Event(CONNECTION_CLOSED));

    		}else{

    			dispatchEvent(new Event(CONNECTION_CLOSED));

    		}

		}

	    /**
	     * This method is called if the socket throws an error.
	     */
	    private function onErrorHandler(e:ErrorEvent):void {

	    	trace(e.text + "\n");

	        if(_handler){

    			_handler.dispatchEvent(new Event(CONNECTION_ERROR));

    		}else{

    			dispatchEvent(new Event(CONNECTION_ERROR));

    		}

		}

		/**
	     * This method is called if the socket is connected
	     */
		private function onSocketConnected(e:Event):void{

			trace("Port "+ iCurrentPort + " is open ");

			if(_handler){

    			_handler.dispatchEvent(new Event(PORT_RECOVERED));

    		}else{

    			dispatchEvent(new Event(PORT_RECOVERED));

    		}

    		reset();

		}

		/**
		 * Reset the listeners used by the socket
		 */
		public function reset():void{

			if(socket){

				if (!socket.connected) {

					return;

				} else {

					socket.close();

				}

			}

			resetting = true;

		}

		/**
	     * This method is called when you get a result of previous socket
	     */
		private function checkNextPort():void{

			socket.close();

			socket.removeEventListener(Event.CONNECT,onSocketConnected);
			socket.removeEventListener(Event.CLOSE, onCloseHandler);
    		socket.removeEventListener(ErrorEvent.ERROR, onErrorHandler);
    		socket.removeEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
    		socket = null;

    		iCurrentPort++;

    		if(iCurrentPort <= iEndPort){

    			checkPort();

    		}else{

    			if(_handler){

    				_handler.dispatchEvent(new Event(PORT_NOT_RECOVERED));

    			}else{

    				dispatchEvent(new Event(PORT_NOT_RECOVERED));

    			}

    		}

		}

		public function get availablePort():int{

			return iCurrentPort;

		}

		/************************************
		* IEventDispatcher immplementation
		*************************************/
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0.0, useWeakReference:Boolean=false):void{

			eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);

		}

		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void	{

			eventDispatcher.removeEventListener(type, listener, useCapture);

		}

		public function dispatchEvent(event:Event):Boolean {

			return eventDispatcher.dispatchEvent(event);

		}

		public function hasEventListener(type:String):Boolean {

			return eventDispatcher.hasEventListener(type);

		}

		public function willTrigger(type:String):Boolean {

			return eventDispatcher.willTrigger(type);

		}

	}
}