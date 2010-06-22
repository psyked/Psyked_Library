package com.gnstudio.nabiro.utilities.pico.visitors
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
	 */
	
	import mx.collections.ICollectionView;
	
	public interface IVisitors
	{
		
		/** 
		 * Traverse through all components of the PicoContainer hierarchy
		 */ 
		function get traverse():ICollectionView;
		
		/**
		 * Specify if a visitor is traversing a PicoContainer
		 */ 
		function set isTraversing(value:Boolean):void;
		function get isTraversing():Boolean;
		
		/**
		 * Traverse all the compoment of the PicoContainer hierarchy that are of a specific type
		 */ 
		function traverseTrough(type:Class):ICollectionView;
		
	}
}