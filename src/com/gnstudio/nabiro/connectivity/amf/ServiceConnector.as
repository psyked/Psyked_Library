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
	import com.gnstudio.nabiro.connectivity.amf.remote.IRemoteMethod;
	import com.gnstudio.nabiro.connectivity.amf.utils.MethodsQueue;
	import com.gnstudio.nabiro.connectivity.amf.utils.MethodsQueueElement;
	
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.ui.Mouse;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	import mx.collections.ArrayCollection;
	import mx.managers.CursorManager;
	import mx.messaging.Channel;
	import mx.messaging.ChannelSet;
	import mx.messaging.MessageAgent;
	import mx.messaging.channels.AMFChannel;
	import mx.messaging.channels.HTTPChannel;
	import mx.messaging.channels.NetConnectionChannel;
	import mx.rpc.AbstractOperation;
	import mx.rpc.AbstractService;
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;
	
	/**
	 * This class implements the singleton pattern.
	 */
	public class ServiceConnector implements IEventDispatcher {
		
	    //----------------------------------------------------------------------
	    //
	    //  Class constants
	    //
	    //----------------------------------------------------------------------
		
		// CursorManager Events
		public static const BUSY_CURSOR:String = "onBusyCursor";
		public static const NORMAL_CURSOR:String = "onNormalCursor";
		
		// Admitted channel services
		public static const SERVICE_REMOTEOBJECT:String 			= "mx.messaging.channels.AMFChannel";
    	public static const SERVICE_NETCONNECTION:String 			= "mx.messaging.channels.NetConnectionChannel";
    	public static const SERVICE_HTTPSERVICE:String 				= "mx.messaging.channels.HTTPChannel";
    	public static const SECURE_SERVICE_REMOTEOBJECT:String 		= "mx.messaging.channels.SecureAMFChannel";
    	
    	// Default ServiceConnector settings
    	private const MAX_ALLOWED_CHANNELS:int 				= 1;
    	
    	// Service status inforrmations
    	public static const SERVICE_RUNNING:String 			= "running";
    	public static const SERVICE_STARTING:String 		= "starting";
    	public static const SERVICE_READY:String 			= "ready";
    	public static const SERVICE_LOGGED_READY:String 	= "loggedReady";
    	public static const SERVICE_LOGGED_OUT:String 		= "loggedOut";
    	public static const SERVICE_FAULT:String 			= "fault";
    	
    	// Channel information
    	protected var CHANNEL_ID:String 					= "my-amf";
    	protected var CHANNEL_CHARSET:String 				= "UTF-8";

	    //----------------------------------------------------------------------
	    //
	    //  Class variables
	    //
	    //----------------------------------------------------------------------

    	// Singleton
    	private static var connector:ServiceConnector;
    	
    	// IEventDispatcher on which the events are sent
    	private static var handler:IEventDispatcher;
    	
    	// EventDsipatcher instance used in order to implement IEventDispatcher
		private var eventDispatcher:EventDispatcher;
		
		// Channels fields
		private var channelSet:ChannelSet;
		private var channel:Channel;
		private var channelSetToken:AsyncToken;
		private var channelSetConnected:Boolean;
		private var defaultServiceConnected:Boolean;
		private var channelMessageAgent:MessageAgent;
		
		// Default call object
		private var defaultServiceRemoteObject:RemoteObject;
		
		// Default call configuration
		[Bindable]
		public var defaultSource:String;
		
		[Bindable]
		public var defaultDestination:String;
		
		// Methods queue
		private var methodsQueue:MethodsQueue;
		private var processingQueue:Boolean;
		


		private static var className:String = getQualifiedClassName(super);
		
		//----------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //----------------------------------------------------------------------

		/**
		 * Constructor.
		 */
		public function ServiceConnector(/* singleton:ServiceConnectorSingleton */) {
			
			if (connector != null && getQualifiedSuperclassName(this) != className) throw new Error("This a singleton class!");			
			
			methodsQueue = MethodsQueue.getQueeManager();
			processingQueue = false;
			
			eventDispatcher = new EventDispatcher();
			
			channelSetConnected = false;
			defaultServiceConnected = false;
			
			// Composition bug fixing
			var amf:AMFChannel = null;
			var http:HTTPChannel = null;
			var nc:NetConnectionChannel = null;
		}
		
		/**
		 * Method used to update the singleton instances defined trough sub class
		 * 
		 */
		 public function updateInstance(instance:ServiceConnector):ServiceConnector {
			
			/* var buffer:ByteArray = new ByteArray();
	        
	        buffer.writeObject(ServiceConnector.connector);
	        buffer.position = 0;
	       
	        var result:* = (buffer.readObject()  as ServiceConnector );
	        
	        buffer.position = 0;
	        
	        return result; */
			
			if (instance != null && instance is ServiceConnector){
				
				ServiceConnector.connector = instance;
				
			}else{
				
				throw new Error("Incorrect Singleton update");
				
			}
			
			/* if(target){
				
				// Define the target that will get the evens
			//	ServiceConnector.handler = target;
				
				// Define the listener for the target
				//ServiceConnector.connector.registerTarget();
				
			}  */
			
			return ServiceConnector.connector;
		
        } 
		
		/**
		 * Method used in order to get the ServiceConnector instance and
		 * in order to define the object against which the events are 
		 * dispatched;
		 * if you call the method and the ServiceConnector is already created 
		 * you'll change the object against with the events are fired
		 * 
		 * @param handler IEventDispatcher
		 * @return ServiceConnector
		 */ 
		public static function getConnector(handler:IEventDispatcher = null):ServiceConnector{
			
			trace("\t The handler is:", handler, "********************")
			
			if(!ServiceConnector.connector){
				
				// Create the new instance
				ServiceConnector.connector = new ServiceConnector();
				
				// Set the connector hanlder
				if(handler != null){
					
					ServiceConnector.handler = handler;
									
				}
				
				// Notify thet the service is starting against the handler or the class				
				if(ServiceConnector.handler){
					
					ServiceConnector.handler.dispatchEvent(new Event(ServiceConnector.SERVICE_STARTING, true, true));
					
				}else{
					
					ServiceConnector.connector.dispatchEvent(new Event(ServiceConnector.SERVICE_STARTING, true, true));
					
				}
				
			}else{
				
				// Change the connector hanlder
				if(ServiceConnector.handler != handler && handler != null){
				
					ServiceConnector.handler = handler;
					
				}
				
				// Notify thet the service is already running against the handler or the class				
				if(ServiceConnector.handler){
					
					ServiceConnector.handler.dispatchEvent(new Event(ServiceConnector.SERVICE_RUNNING, true, true));
					
				}else{
					
					ServiceConnector.connector.dispatchEvent(new Event(ServiceConnector.SERVICE_RUNNING, true, true));
					
				}
					
				
			}
			
			// Return the reference
			return ServiceConnector.connector;
		}
		
		private var _serviceRoot:String;
		
		/**
		 * Getter used to recover the default url
		 * @return String
		 */
		public function get serviceRoot():String{
			
			return _serviceRoot
			
		}
		
		/**
		 * Initialize the connector providing url and serviceType (AMFChannel, 
		 * HTTPChannel, NetConnectionChannel)
		 * and the optinal username and password needed for secure services
		 * 
		 * @param url String
		 * @param serviceType String
		 * @param username String 
		 * @param password String
		 */
		public function initializeConnector(url:String, serviceType:String, username:String = "", password:String = ""):void{
			
			_serviceRoot = url;
			
			// If the channelSet is connected
			if(channelSetConnected){
				
				// Notify thet the service is already running against the handler or the class				
				if(ServiceConnector.handler){
					
					ServiceConnector.handler.dispatchEvent(new Event(ServiceConnector.SERVICE_RUNNING, true, true));
					
				}else{
					
					ServiceConnector.connector.dispatchEvent(new Event(ServiceConnector.SERVICE_RUNNING, true, true));
					
				}
				
				// Check if the defaultRemoteObject is intialized
				if(!defaultServiceConnected){
					
					initializeDefaultRemoteObject(url);
					
				}
				
				return;
				
			}
			
			// If no channelSet is defined
			if(!channelSet){
				
				// I create a new ont
				channelSet = new ChannelSet();
				
			}
			
			// Check if too much channels have been added to the channelSet
			if(channelSet.channels.length > MAX_ALLOWED_CHANNELS){
				
				throw(new IllegalOperationError("Attention, this ServiceConnector is studied to handle only " + MAX_ALLOWED_CHANNELS + " channel!"));
				
			}else{
				
				// Get trough composition the kind of channel (AMFChannel, HTTPChannel, NetConnectionChannel)
				var channelClass:Class = getDefinitionByName(serviceType) as Class;					
				channel = new channelClass(CHANNEL_ID, url);
				
				// Add the channel to the channelSet
				channelSet.addChannel(channel);
				
				// If username and password are provided
				if(username != "" && password != ""){
					
					// The channelSet is logged in
					channelSetToken = channelSet.login(username, password, CHANNEL_CHARSET);
					channelSetToken.addResponder(new AsyncResponder(onChannelReady, onChannelFault));
					
					try{
						
						CursorManager.setBusyCursor();
					
					}catch(error:Error){
						
						flash.ui.Mouse.show();
						
						if(ServiceConnector.handler){
						
							ServiceConnector.handler.dispatchEvent(new Event(BUSY_CURSOR, true, true));
							
						}else{
						
							this.dispatchEvent(new Event(BUSY_CURSOR, true, true));
						
						}
						
					}	
					
				// If no login and password are provided	
				}else{							
					
					// Check if the default source and destination are set
					if(!defaultSource ||  defaultSource == ""){
						
						throw(new IllegalOperationError("Attention, the defaultSource is not initialized!"));
						return;
						
					}
					
					if(!defaultDestination ||  defaultDestination == ""){
						
						throw(new IllegalOperationError("Attention, the defaultDestination is not initialized!"));
						return;
						
					}
					
					// Initialize the defaultRemoteObject
					initializeDefaultRemoteObject(url);
					
					// Notify thet the the SERVICE_READY event against the handler or the class				
					if(ServiceConnector.handler){
						
						ServiceConnector.handler.dispatchEvent(new Event(ServiceConnector.SERVICE_READY, true, true));
						
					}else{
							
						ServiceConnector.connector.dispatchEvent(new Event(ServiceConnector.SERVICE_READY, true, true));
							
					}
										
				}							
				
			}		
			
		}
		
		/**
		 * Clean up all the connectors
		 */
		public function clean():void{
			
			// Set the flags used from the connector			
			channelSetConnected = false;
			defaultServiceConnected = false;
			
			// Set to null all the staff used from the service connector
			channelSet = null;
			channelSetToken = null;
			
			ServiceConnector.handler = null;
			ServiceConnector.connector = null;
			
		}
		
		/**
		 * Method used in order to logout from the services and connect with a new user
		 */				
		public function logoutConnector(clear:Boolean = false):void{
			
			// Logout from the channel
			var channelSetToken:AsyncToken = channelSet.logout();
			channelSetToken.addResponder(new AsyncResponder(onChannelLogout, onChannelFault));
			
			try{
						
				CursorManager.setBusyCursor();
					
				}catch(error:Error){
						
					flash.ui.Mouse.show();
						
				if(ServiceConnector.handler){
						
					ServiceConnector.handler.dispatchEvent(new Event(BUSY_CURSOR, true, true));
							
				}else{
						
					this.dispatchEvent(new Event(BUSY_CURSOR, true, true));
						
				}
						
			}	
			
			// Disconect channels and channelSet
			/* channel.disconnect(channelSet);
			channelSet.disconnectAll(); */
			
			if(	defaultServiceRemoteObject){
				
				defaultServiceRemoteObject.logout();
				defaultServiceRemoteObject.disconnect();
			
			}
			
			// Set the flags used from the connector			
			channelSetConnected = false;
			defaultServiceConnected = false;
			
			// Set to null all the staff used from the service connector
			channelSet = null;
			channelSetToken = null;
			
			if(clear){
				
				ServiceConnector.handler = null;
				ServiceConnector.connector = null;
				
			}			
			
		}
		
		protected function initializeDefaultRemoteObject(uri:String):void{
			
			// Set the channel uri
			channel.uri = uri;
					
			// Create the defaultServiceRemoteObject RemoteObject
			defaultServiceRemoteObject = new RemoteObject();
					
			// Define source and destionation trough the static variables
			defaultServiceRemoteObject.source = defaultSource;//"com.rbidr.latte.engine.services.UserService";
			defaultServiceRemoteObject.destination = defaultDestination;//"UserService";
					
			// Use the same channelSet
			defaultServiceRemoteObject.channelSet = channelSet;
					
			// The default service is connected 
			defaultServiceConnected = true;
			
		}
		
		public function getChannel(url:String = null):ChannelSet{
			
			// If no channelSet is defined
			if(!channelSet){
				
				throw(new IllegalOperationError("The default channelSet has not been initialized!"));
				
			}
			
			return channelSet;
			
		}
		
		/**
		 * Method used to get a service from each location of the application, 
		 * the method return an AbstractService you can use to perform 
		 * operations against a service trough the AbstractService 
		 * getOperation(param:String) method
		 * @param serviceName String
		 * @param source String
		 * @param sameChannel Boolean
		 * @param requireLogin Boolean
		 * @param newChannelSet ChannelSet
		 * @param loginData Object
 		 * @return AbstractService
		 */ 
		public function getServiceByName(serviceName:String, source:String, 
										 sameChannel:Boolean = true, 
										 requireLogin:Boolean = false, 
										 newChannelSet:ChannelSet = null, 
										 loginData:Object = null):AbstractService{
			
			
			if(!channel){
				
				throw(new IllegalOperationError("No channels are defined, call the initializeConnector method before!"));
				return;
				
			}
			
			// Get an instance of the ServiceLocator
			var serviceLocator:ServiceLocator = ServiceLocator.getInstance();
			
			// If the call has to use a different channel
			if(!sameChannel){
				
				// Check the channel parameter
				if(!newChannelSet){
					
					throw(new IllegalOperationError("If you want to change the channelSet you must supply a new one!"));
					
				}else{
					
					// and set it
					serviceLocator.channelSet = newChannelSet;
					
				}				
				
			}else{
				
				// If no different channel is set the channel of the ServiceLocator
				serviceLocator.channelSet = channelSet;
				
			}
			
			// Get the abstract service
			var service:AbstractService = serviceLocator.getService(serviceName, source);
			
			// Check if this service method need secure information
			if(requireLogin){
				
				// Check the login data information
				if(!loginData){
					
					throw(new IllegalOperationError("If you want to set credentials you have to specify login and pasword!"));
					
				}else{
					
					// Set the credentials for the service
					(service as RemoteObject).setCredentials(loginData.login, loginData.password);
					
				}
				
			}
			
			return service;
			
			
		}
		
		/**
		 * Initialize the listeners for the defaultServiceRemoteObject RemoteObject
		 */ 
		protected function intializeDefaultServiceRemoteObject():void{
			
			if(!defaultServiceRemoteObject.hasEventListener(FaultEvent.FAULT)){
				
				defaultServiceRemoteObject.addEventListener(FaultEvent.FAULT, onDefaultServiceFault);
				
			}
			
			if(!defaultServiceRemoteObject.hasEventListener(ResultEvent.RESULT)){
				
				defaultServiceRemoteObject.addEventListener(ResultEvent.RESULT, onDefaultServiceResult);
				
			}
			
		}
		
		/**
		* Method used to perform a remote call against a method that require autentication
		* @param method IRemoteMethod
		*/ 
		public function makeLoggedCall(method:IRemoteMethod):AbstractService{
			
			// trace("		makeLoggedCall:", method.name);
			
			// Check if the channel is connected
			if(!channelSetConnected){
				
				throw (new IllegalOperationError("You have to be logged in order to make a call like " + method.name + "!"));
				return;	
				
			}	
			
			// Define the remote object that is aware of the data it get
			var tmpRO:ResultAwareRemoteObject = new ResultAwareRemoteObject(method.isList, method.returnObject);
			
			// The source change if the method needs a differen source
			if(method.source != ""){
				
				tmpRO.source = method.source;
			
			}else{
				
				tmpRO.source = connector.defaultSource;
			
			}
			
			// The destination changes if the method provides a new destination
			if(method.destination != ""){
				
				tmpRO.destination = method.destination;
				
			}else{
				
				tmpRO.destination = connector.defaultDestination;
				
			}
						
			// Define the channel
			tmpRO.channelSet = channelSet;
			
			// Define the listeners for the object
			tmpRO.addEventListener(ResultEvent.RESULT, getLoggedResults);
			tmpRO.addEventListener(FaultEvent.FAULT, getLoggedFault);
			
			// Recover the operation
			var objOperation:AbstractOperation = tmpRO.getOperation(method.name);
			
			// Create the method element
			var element:MethodsQueueElement = new MethodsQueueElement(method, objOperation);
			
			// Add a method to the queue
			methodsQueue.addStep(element);
			
			// If there are more than one method to execute skip the processing to the result handler
			if(methodsQueue.getActualElements() > 1){
				
				processingQueue = true;
				return objOperation.service;
				
			}else{
				
				processingQueue = false;
				
			}
							
			// Call the remote method handling the arguments
			if(method.arguments.length > 0){
				
				objOperation.send.apply(null, method.arguments);
				
			}else {
				
				objOperation.send();
				
			}
			
			// if(!CursorManager.getInstance() is BusyCursor){
            	
            	 //	CursorManager.setBusyCursor();
            	 
            	 try{
						
						CursorManager.setBusyCursor();
					
					}catch(error:Error){
						
						flash.ui.Mouse.show();
						
						if(ServiceConnector.handler){
						
							ServiceConnector.handler.dispatchEvent(new Event(BUSY_CURSOR, true, true));
							
						}else{
						
							this.dispatchEvent(new Event(BUSY_CURSOR, true, true));
						
						}
						
					}	
            	
            //}
			
			return objOperation.service;			
			
		}
		
		/**
		* Method used in order to handle the results on the logged call
		* @param e ResultEvent
		*/ 
		private function getLoggedResults(e:ResultEvent):void {
			
			// Check if it's a list
			if((e.target as ResultAwareRemoteObject).isList == true && (e.target as ResultAwareRemoteObject).resultObject != null){
				
				// Create the arrayCollection needed to handle java list
				var tmpCollection:ArrayCollection = new ArrayCollection();
				
				for each(var item:Object in e.result){
					
					tmpCollection.addItem(item as e.target.resultObject);
					
				}
				
				// Send the data to the instance
				dispatchEvent(new RemoteObjectWrapperEvent(RemoteObjectWrapperEvent.RESULT, tmpCollection,
													      (e.target.operation as AbstractOperation).service));
					
			}else{
				
				// Send the data to the instance
				
				if(!(e.target as ResultAwareRemoteObject)){
					
					dispatchEvent(new RemoteObjectWrapperEvent(RemoteObjectWrapperEvent.RESULT, e.result as e.target.resultObject, (e.currentTarget.operation as AbstractOperation).service));
					
				}else{
					
					dispatchEvent(new RemoteObjectWrapperEvent(RemoteObjectWrapperEvent.RESULT, e.result, (e.target.operation as AbstractOperation).service));
					
				}
				
				// trace("(e.currentTarget.operation as AbstractOperation).service", (e.currentTarget.operation as AbstractOperation).service)
				
			}
			
			
			
			try{
			
				CursorManager.removeBusyCursor();
			
			}catch(error:Error){
				
				flash.ui.Mouse.show();
				
				if(ServiceConnector.handler){
				
					ServiceConnector.handler.dispatchEvent(new Event(NORMAL_CURSOR, true, true));
				
				}else{
				
					this.dispatchEvent(new Event(NORMAL_CURSOR, true, true));
					
				}
			
			}
			
			// Remove the method from the queue
			methodsQueue.removeStep();
			
			if(processingQueue){
				
				trace("Methods to be processed:", methodsQueue.getActualElements());
				
				var method:MethodsQueueElement = methodsQueue.getActualStep();
								
				if(method){
					
					trace("                    ", method.remoteMethod.name, method.remoteMethod.destination)
					
				}
				
				// If no more methods the queue processing is stopped
				if(!method){
					
					processingQueue = false;
					return; 
					
				}
				
				
			 	var tmpRO:ResultAwareRemoteObject = new ResultAwareRemoteObject(method.remoteMethod.isList, method.remoteMethod.returnObject);
				tmpRO.source = method.remoteMethod.source;
				tmpRO.destination = method.remoteMethod.destination;
				
				tmpRO.channelSet = channelSet; 
				
			//	var objOperation:AbstractOperation = tmpRO.getOperation(method.name);
				var objOperation:AbstractOperation = method.abstractOperation;
				
				tmpRO.operations = objOperation
				
				//tmpRO.addEventListener(ResultEvent.RESULT, getLoggedResults);
				
				if(method.remoteMethod.arguments.length > 0){
					
					objOperation.send.apply(null, method.remoteMethod.arguments);
					
				}else {
					
					objOperation.send();
					
				}
				
				
				
				
			//	if(!CursorManager.getInstance() is BusyCursor){
            	
            	 //	CursorManager.setBusyCursor();
            	 
            	 try{
						
						CursorManager.setBusyCursor();
					
					}catch(error:Error){
						
						flash.ui.Mouse.show();
					
						if(ServiceConnector.handler){
						
							ServiceConnector.handler.dispatchEvent(new Event(BUSY_CURSOR, true, true));
							
						}else{
						
							this.dispatchEvent(new Event(BUSY_CURSOR, true, true));
						
						}
						
					}	
            	
           	 //	}	
				
			}
			
			
		}
		
		/**
		* Method used in order to handle the fault on the logged call
		* @param e FaultEvent
		*/ 
		private function getLoggedFault(e:FaultEvent):void{
			
			trace("Logged result Fault", e)
			dispatchEvent(new RemoteObjectWrapperEvent(RemoteObjectWrapperEvent.FAULT, e.fault.rootCause, (e.currentTarget.operation as AbstractOperation).service));
		
			// CursorManager.removeBusyCursor();
			try{
			
				CursorManager.removeBusyCursor();
			
			}catch(error:Error){
				
				flash.ui.Mouse.show();
				
				if(ServiceConnector.handler){
				
					ServiceConnector.handler.dispatchEvent(new Event(NORMAL_CURSOR, true, true));
				
				}else{
				
					this.dispatchEvent(new Event(NORMAL_CURSOR, true, true));
					
				}
			
			}
			
			// Remove the method from the queue
			methodsQueue.removeStep();
			
		}
		
		/**
		* Method used to make the call against the services that doesn't need
		* the autentication on the server
		* @param method:String
		* @param args rest
		*/ 
		public function makeAnonymousCall(method:IRemoteMethod):AbstractService{
			
			// trace("anonymous call", method.name, method.arguments)
			
			// If the defaultServiceRemoteObject is not ready
			if(!defaultServiceConnected){
				
				// Throw an exception
				throw(new IllegalOperationError("The defaultServiceRemoteObject has not been initialized!"));
				return;
				
			}
			
			// Define an AbstractOperation with the required method
			var operation:AbstractOperation;
			
			// The source change if the method needs a differen source
			if(method.source != "" || method.destination != ""){
				
				// Define the remote object that is aware of the data it get
				var tmpRO:ResultAwareRemoteObject = new ResultAwareRemoteObject(method.isList, method.returnObject);
				
				// The source change if the method needs a differen source
				if(method.source != ""){
					
					tmpRO.source = method.source;
				
				}else{
					
					tmpRO.source = connector.defaultSource;
				
				}
				
				// The destination changes if the method provides a new destination
				if(method.destination != ""){
					
					tmpRO.destination = method.destination;
					
				}else{
					
					tmpRO.destination = connector.defaultDestination;
					
				}				
				
				// Define the channel
				tmpRO.channelSet = channelSet;
				
				// Define the listeners for the object
				tmpRO.addEventListener(ResultEvent.RESULT, getLoggedResults);
				tmpRO.addEventListener(FaultEvent.FAULT, getLoggedFault);
				
				// Recover the operation
				operation = tmpRO.getOperation(method.name);
			
							
			}else{
				
				// Define an AbstractOperation with the required method
				 operation = defaultServiceRemoteObject.getOperation(method.name);
				
				// Initialize the lsitener used from the defaultServiceRemoteObject
				intializeDefaultServiceRemoteObject();
				
			}		
			
			// Make the call checking if arguments are to supply
			if(method.arguments.length > 0){
                 
	               if(method.arguments.length == 1 && method.arguments[0] is Array){
	                	
	                operation.send.apply(null, method.arguments[0]);
	                	
	               }else{
	                	
	                operation.send.apply(null, method.arguments);
	                	
	               }
                             	            	
            	}else{
                 
                 operation.send();
                 
           	}
                 	 	
            try{
						
				CursorManager.setBusyCursor();
					
				}catch(error:Error){
						
					flash.ui.Mouse.show();
					
					if(ServiceConnector.handler){
						
						ServiceConnector.handler.dispatchEvent(new Event(BUSY_CURSOR, true, true));
							
					}else{
						
						this.dispatchEvent(new Event(BUSY_CURSOR, true, true));
						
					}
						
				}	
            	
          //  }          
           	
           	return operation.service;
			
		}
		
		/**
		 * RemoteObjectWrapperEvent event is fired agains the instance of the 
		 * ServiceLocator class
		 * 
		 * @param e ResultEvent
		 */ 
		private function onDefaultServiceResult(e:ResultEvent):void {
			
		
			dispatchEvent(new RemoteObjectWrapperEvent(RemoteObjectWrapperEvent.RESULT, e.result, (e.currentTarget.operation as AbstractOperation).service));
			// CursorManager.removeBusyCursor();
			
			try{
			
				CursorManager.removeBusyCursor();
			
			}catch(error:Error){
				
				flash.ui.Mouse.show();
				
				if(ServiceConnector.handler){
				
					ServiceConnector.handler.dispatchEvent(new Event(NORMAL_CURSOR, true, true));
				
				}else{
				
					this.dispatchEvent(new Event(NORMAL_CURSOR, true, true));
					
				}
			
			}
			
		}
		
		/**
		 * RemoteObjectWrapperEvent event is fired agains the instance of the 
		 * ServiceLocator class
		 * 
		 * @param e FaultEvent
		 */ 
		private function onDefaultServiceFault(e:FaultEvent):void {
						
			dispatchEvent(new RemoteObjectWrapperEvent(RemoteObjectWrapperEvent.FAULT, e.fault.rootCause, (e.currentTarget.operation as AbstractOperation).service));
			// CursorManager.removeBusyCursor();
			
			try{
			
				CursorManager.removeBusyCursor();
			
			}catch(error:Error){
				
				flash.ui.Mouse.show();
				
				if(ServiceConnector.handler){
				
					ServiceConnector.handler.dispatchEvent(new Event(NORMAL_CURSOR, true, true));
				
				}else{
				
					this.dispatchEvent(new Event(NORMAL_CURSOR, true, true));
					
				}
			
			}
			
		}
		
		/**
		 * Listener to the channel logout
		 * @param e ResultEvent
		 * @param t Object
		 */ 
		private function onChannelLogout(e:ResultEvent, t:Object):void{
			
			// The default channel is connected
			channelSetConnected = false;
			
			// The event is sent
			if(ServiceConnector.handler){
			
				ServiceConnector.handler.dispatchEvent(new Event(ServiceConnector.SERVICE_LOGGED_OUT, true, true));	
				
			}else{
				
				ServiceConnector.connector.dispatchEvent(new Event(ServiceConnector.SERVICE_LOGGED_OUT, true, true));
				
			}		
			
			// CursorManager.removeBusyCursor();
			
			try{
			
				CursorManager.removeBusyCursor();
			
			}catch(error:Error){
				
				flash.ui.Mouse.show();
			
				if(ServiceConnector.handler){
				
					ServiceConnector.handler.dispatchEvent(new Event(NORMAL_CURSOR, true, true));
				
				}else{
				
					this.dispatchEvent(new Event(NORMAL_CURSOR, true, true));
					
				}
			
			}	
			
		}
		
		
		/**
		 * Listener to the channelSetToken AsyncToken set the 
		 * channelSetConnected property and fire on the handler the 
		 * SERVICE_LOGGED_READY event
		 * 
		 * @param e ResultEvent
		 * @param t Object
		 */ 
		private function onChannelReady(e:ResultEvent, t:Object):void{
			
			// The default channel is connected
			channelSetConnected = true;
			
			// The event is sent
			if(ServiceConnector.handler){
			
				ServiceConnector.handler.dispatchEvent(new Event(ServiceConnector.SERVICE_LOGGED_READY, true, true));	
				
			}else{
				
				ServiceConnector.connector.dispatchEvent(new Event(ServiceConnector.SERVICE_LOGGED_READY, true, true));
				
			}		
			
			// CursorManager.removeBusyCursor();
			
			try{
			
				CursorManager.removeBusyCursor();
			
			}catch(error:Error){
				
				flash.ui.Mouse.show();
			
				if(ServiceConnector.handler){
				
					ServiceConnector.handler.dispatchEvent(new Event(NORMAL_CURSOR, true, true));
				
				}else{
				
					this.dispatchEvent(new Event(NORMAL_CURSOR, true, true));
					
				}
			
			}	
			
		}
		
		/**
		 * Listener to the channelSetToken AsyncToken fire on the handler the 
		 * SERVICE_FAULT event
		 * 
		 * @param e FaultEvent
		 * @param t Object
		 */ 
		private function onChannelFault(e:FaultEvent, t:Object):void{
			
			channelSet.removeChannel(channel)
			
			trace("Login Fault", e)
			// CursorManager.removeBusyCursor();
			
			try{
			
				CursorManager.removeBusyCursor();
			
			}catch(error:Error){
				
				flash.ui.Mouse.show();
				
				if(ServiceConnector.handler){
				
					ServiceConnector.handler.dispatchEvent(new Event(NORMAL_CURSOR, true, true));
				
				}else{
				
					this.dispatchEvent(new Event(NORMAL_CURSOR, true, true));
					
				}
			
			}
			
			if(ServiceConnector.handler){
			
				ServiceConnector.handler.dispatchEvent(new Event(ServiceConnector.SERVICE_FAULT, true, true));
				
			}else{
				
				ServiceConnector.connector.dispatchEvent(new Event(ServiceConnector.SERVICE_FAULT, true, true));
				
			}
			
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

internal class ServiceConnectorSingleton{
	
	
}