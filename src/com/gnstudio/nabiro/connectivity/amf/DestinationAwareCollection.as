package com.gnstudio.nabiro.connectivity.amf
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
	
	import com.gnstudio.nabiro.connectivity.amf.events.RemoteObjectWrapperEvent;
	
	import flash.errors.IllegalOperationError;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.messaging.ChannelSet;
	import mx.rpc.AbstractOperation;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;
	
	/**
	 * Events that can be defined on the instance
	 */ 
	[Event(name = "dataResult", type = "com.gnstudio.nabiro.connectivity.amf.events.RemoteObjectWrapperEvent")]
	[Event(name = "dataFault", type = "mx.rpc.events.FaultEvent")]
	
	[Bindable]
	public class DestinationAwareCollection extends ArrayCollection	{
		
		private var _destination:String;
		private var _channelSet:ChannelSet
		private var _method:String;
		private var _alertOnFault:Boolean;
		
		protected var defaultRemoteObject:RemoteObject;
		
		public function DestinationAwareCollection(source:Array=null){
			
			super(source);
			
		}
		
		/**
		 * Method used in order to invoke remote methods against a destination with a specific channel set
		 * @param method String
		 * @param args Array
		 * @return token AsyncToken
		 */ 
		private function invoke(method:String, args:Array):AsyncToken{
			
			// Check if the defaultRemoteObject exists
			if(!defaultRemoteObject){
				
				defineRemoteObject();
				
			}
			
			// Set the busy cursor
			CursorManager.setBusyCursor();
			
			// Define the AbstractOperation 
			var operation:AbstractOperation = defaultRemoteObject.getOperation(method);
			
			// Set the arguments
			operation.arguments = args;
			
			// Call the remote method
			var token:AsyncToken = operation.send();
			
			return token;
			
		}
		
		/**
		 * Method used to define the RemoteObject
		 */ 
		protected function defineRemoteObject():void{
			
			// Verify the destination and the channel set
			if((_destination == null || _destination == "") || !_channelSet){
				
				throw(new IllegalOperationError("No destination or channel has been defined!"));
				return;
				
			}
			
			// Create the RemoteObject
			defaultRemoteObject = new RemoteObject();
			
			// Set destination and channelSet
			defaultRemoteObject.destination = _destination;
			defaultRemoteObject.channelSet = _channelSet;
			
			// Define the listener for the result and fault events
			defaultRemoteObject.addEventListener(ResultEvent.RESULT, onDefaultResult);
			defaultRemoteObject.addEventListener(FaultEvent.FAULT, onDefaultFault);
			
		}
		
		/**
		 * Listener to the result event it populate the collection and refresh the data
		 * @param e ResultEvent
		 */ 
		private function onDefaultResult(e:ResultEvent):void{
			
			// Remove the busycursor
			CursorManager.removeBusyCursor();
			
			// Set the source
			source = e.result.source;
			
			// Refresh the data
			refresh();
			
			// Dispatch the event
			dispatchEvent(new RemoteObjectWrapperEvent(RemoteObjectWrapperEvent.RESULT, e.result, (e.currentTarget.operation as AbstractOperation).service));
			
		}
		
		/**
		 * Listener to the fault event 
		 * @param e FaultEvent
		 */ 
		private function onDefaultFault(e:FaultEvent):void{
			
			// Remove the busycursor
			CursorManager.removeBusyCursor();
			
			// Dispatch the event
			dispatchEvent(new RemoteObjectWrapperEvent(RemoteObjectWrapperEvent.FAULT, e.fault.rootCause, (e.currentTarget.operation as AbstractOperation).service));
			
			// Show the alert if the _alertOnFault is true
			if(_alertOnFault){
				
				Alert.show(e.fault.faultString, "Error calling destination:" + e.message.destination);
				
			}
			
			dispatchEvent(e);
			
		}
		
		/**
		 * Method used in order to invoke the remothe method and fill the collection
		 * @param args Array
		 */ 
		public function fill(...args):AsyncToken{
			
			var token:AsyncToken = invoke(_method, args);
			
			return token;
			
		}
		
		// =======================================================================
		// DESTINATION TO USE
		// ======================================================================= 	
		public function set destination(value:String):void{
			
			_destination = value;
			
		}
		
		public function get destination():String{
			
			return _destination;
			
		}
		
		// =======================================================================
		// METHOD TO INVOKE
		// ======================================================================= 	
		public function set method(value:String):void{
			
			_method = value;
			
		}
		
		public function get method():String{
			
			return _method;
			
		}
		
		// =======================================================================
		// SET THE ALERT
		// ======================================================================= 	
		public function set alertOnFault(value:Boolean):void{
			
			_alertOnFault = value;
			
		}
		
		public function get alertOnFault():Boolean{
			
			return _alertOnFault;
			
		}
		
		// =======================================================================
		// DEFINE THE CHANNELSET
		// ======================================================================= 	
		public function set channelSet(value:ChannelSet):void{
			
			_channelSet = value;
			
		}
		
		public function get channelSet():ChannelSet{
			
			return _channelSet;
			
		}
		
		
		
	}
}