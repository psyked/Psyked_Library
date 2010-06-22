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
	
   	import mx.messaging.ChannelSet;
   	import mx.rpc.AbstractService;
   	import mx.rpc.remoting.mxml.RemoteObject;
   
   
	/**
	 * This class implements the singleton pattern.
	 */
   	public class ServiceLocator{
   	
	    //----------------------------------------------------------------------
	    //
	    //  Class properties
	    //
	    //----------------------------------------------------------------------

      	private var service:AbstractService;     
      	
      	private static var serviceLocator:ServiceLocator;
      
      	public var channelSet:ChannelSet;
      
	    //----------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //----------------------------------------------------------------------
	    
      	/**
      	 * Constructor.
      	 */
      	public function ServiceLocator(singleton:ServiceLocatorSingleton){
    	}      
      
	    /**
	     * Singleton method used to get the instance of the ServiceLocator
	     * class needed to get remote services
	     * 
	     * @return ServiceLocator
	     */
	    public static function getInstance():ServiceLocator{
	      	
	        if( ServiceLocator.serviceLocator == null ){
	         	
	           ServiceLocator.serviceLocator = new ServiceLocator(new ServiceLocatorSingleton());
	            
	        }
	         
	        return ServiceLocator.serviceLocator;
	    }
      
	    //----------------------------------------------------------------------
	    //
	    //  Other methods
	    //
	    //----------------------------------------------------------------------

	    /**
	     * Set the credentials for all registered services.
	     * 
	     * @param username the username to set.
	     * @param password the password to set.
	     */
	    public function setCredentials(username:String, password:String ):void{
	         
	        service.setCredentials( username, password );
	         
	    }
	      
	    /**
	     * Set the remote credentials for all registered services.
	     * 
	     * @param username the username to set.
	     * @param password the password to set.
	     */
	    public function setRemoteCredentials(username:String, password:String):void{
	        
	        service.setRemoteCredentials( username, password );
	      
	    }
	      
	      
	    /**
	     * Individual Services used by the Application.
	     * Method used in order to recover an AbstracService to use to define
	     * an AbstractOperation that can be used to perform remote calls
	     * 
	     * @param name String
	     * @param source String
	     * @return AbstractService
	     */            
	    public function getService(name:String, source:String, cs:ChannelSet = null):AbstractService{
	      	      
	       	service = new RemoteObject();
	       
	       	service.source = source;
			service.destination = name;
								
			service.channelSet = cs || channelSet;
			
			return service;
	         
	    }
	      
	}
}
	
internal class ServiceLocatorSingleton{
	
}