package com.gnstudio.nabiro.ui.images
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
	
	import __AS3__.vec.Vector;
	
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	
	/**
	 * Tints the image using the color defined in this style
	 * @default #000000
	 **/
	[Style(name = "backgroudColor", type = "Number", format = "Color")]
	
	/**
	 * Tints the image using the color defined in this style
	 * @default #000000
	 **/
	[Style(name = "imageColor", type = "Number", format = "Color")]
	
	/**
	 * Tints the image using the color defined in this style
	 * @default #000000
	 **/
	[Style(name = "graphColor", type = "Number", format = "Color")]
	
	[Event(name = "change", type = "flash.events.Event")]

	public class Histogram extends UIComponent
	{
		private var histogramHelper:HistogramRenderer;
		
		private var backClip:Shape;
		private var selectedClip:Shape;
		
		private var handles:Vector.<Point>;
		
		public function Histogram()
		{
			super();
			
			handles = new Vector.<Point>();
		
		}
		
		
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if(handles.length == 0){
				
				handles[0] = new Point(0, 0);
				handles[1] = new Point(unscaledWidth, 0);
				
			}
				
			backClip.graphics.clear( );
			backClip.graphics.beginFill( backgroudColorWithDefault, 0.1 );
			backClip.graphics.lineStyle( 1, backgroudColorWithDefault, 0.3 );
			backClip.graphics.drawRect( 0, 1, unscaledWidth, unscaledHeight - 1 );

				
			selectedClip.graphics.clear( );
			selectedClip.graphics.beginFill( selectionColorWithDefault, 0.1 );
			selectedClip.graphics.lineStyle( 1, selectionColorWithDefault, 0.4 );
			selectedClip.graphics.drawRect(handles[ 0 ].x + 1, 1, (handles[ 1 ].x - handles[ 0 ].x) - 1, unscaledHeight - 1);
			
			
		}
		
		override protected function createChildren():void{
			
			super.createChildren();
			
			if(!selectedClip){
				
				selectedClip = new Shape();
				addChild(selectedClip);
				
			}
			
			if(!backClip){
				
				backClip = new Shape();
				addChild(backClip);
				
			}
			
			if(!histogramHelper){
				
				histogramHelper = new HistogramRenderer(unscaledWidth, unscaledHeight, graphColorWithDefault);
				
				histogramHelper.x = 1;
				histogramHelper.y = height;
				histogramHelper.blendMode = BlendMode.ADD;
				
				addChild(histogramHelper);
			}
			
		}
		
		override protected function commitProperties():void{
			
			super.commitProperties();
			
			
			if(!selectedClip){
				
				selectedClip = new Shape();
				addChild(selectedClip);
				
			}
			
			if(!backClip){
				
				backClip = new Shape();
				addChild(backClip);
				
			}
			
		}
				
		public function set handlesPoint(value:Array):void{
			
			if(value.length != 2){
				
				throw new Error("No valid cursor points");
				return;
				
			}
			
			var left:Number = value[0] / maximum * 100;
			var right:Number = value[1] / maximum * 100;
			
			var incoming:Vector.<Point> = new Vector.<Point>();
			incoming[0] = new Point((width / 100) * left, 0);
			incoming[1] = new Point((width / 100) * right, 0);
			
			if(incoming != handles){
				
				handles = incoming;
				
				invalidateDisplayList()
				
			}
			
			
		}
		
		public function setHistogram( vector : Vector.<Number> ) : void {
			
			histogramHelper.setVector( vector );
			
			handles[0] = new Point(histogramHelper.getBlackClipping(), 0);
			handles[1] = new Point(histogramHelper.getWhiteClipping(), 0);
			
			invalidateDisplayList()
			
			dispatchEvent(new Event(Event.CHANGE));
		//	handlesPoint = [histogramHelper.getBlackClipping(), histogramHelper.getWhiteClipping()];
		
		}
		
		public function get blackPoint( ) : Number {
			
			return Math.min( handles[ 0 ].x, handles[ 1 ].x ) / width;
		
		}
		
		public function get whitePoint( ) : Number {
			
			return Math.max( handles[ 0 ].x, handles[ 1 ].x ) / width;
		
		}
		
		/**
	     *  @private
	     *  Storage for the maximum property.
	     */
	    private var _maximum:Number = 10;
	
	    [Inspectable(category="General", defaultValue="10")]
	
	    /**
	     *  The maximum  value on the slider.
	     *
	     *  @default  10
	     */
	    public function get maximum():Number
	    {
	        return _maximum;
	    }
	
	    /**
	     *  @private
	     */
	    public function set maximum(value:Number):void
	    {
	    	
	    	var valueChanged:Boolean
	    	
	    	if (_maximum != value){
	            
	            valueChanged = true;
	            
	     	}
	    	
	        _maximum = value;
	        
	        if (valueChanged){
	            
	            invalidateProperties();
	        	invalidateDisplayList();
	            
	        }
	
	        
	    }
		
		protected function get backgroudColorWithDefault():uint{
			
			var result:uint = getStyle("backgroudColor");

			if(!result){

				result = 0x000000;

			}

			return result;

		}
		
		
		protected function get selectionColorWithDefault():uint{
			
			var result:uint = getStyle("imageColor");

			if(!result){

				result = 0xff0000;

			}

			return result;

		}
		
		protected function get graphColorWithDefault():uint{
			
			var result:uint = getStyle("graphColor");

			if(!result){

				result = 0x00ff00;

			}

			return result;

		}
		
		
		
	}
}