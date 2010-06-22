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
	
	import com.gnstudio.nabiro.measurement.ConversionUtils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import mx.core.UIComponent;
	
	/**
	 *  The horizontal alignment of the content when it does not have
	 *  a one-to-one aspect ratio.
	 *  Possible values are <code>"left"</code>, <code>"center"</code>,
	 *  and <code>"right"</code>.
	 *  @default "left"
	 */
	[Style(name="horizontalAlign", type="String", enumeration="left,center,right", inherit="no")]
	
	/**
	 *  The vertical alignment of the content when it does not have
	 *  a one-to-one aspect ratio.
	 *  Possible values are <code>"top"</code>, <code>"middle"</code>,
	 *  and <code>"bottom"</code>.
	 *  @default "top"
	 */
	[Style(name="verticalAlign", type="String", enumeration="bottom,middle,top", inherit="no")]

	public class SmartBitmapRenderer extends UIComponent
	{
		
		/**
		 * Rotation kinds
		 */ 
		public static const CW_ROTATION:String = "cw";
		public static const CCW_ROTATION:String = "ccw";
		
		/**
		 * Flipping kinds
		 */ 
		public static const VERTICAL_FLIP:String = "verticalMode";
		public static const HORIZONTAL_FLIP:String = "horizontalMode";
		
		/**
		 * Zoom kinds
		 */ 
		public static const ZOOM_IN:String = "zoomIn";
		public static const ZOOM_OUT:String = "zoomOut";
		
		/**
		 * Zoom and rotation steps default values
		 */ 
		private const DEFAULT_ZOOM_STEP:Number 		= .1;
		private const DEFAULT_ROTATION_STEP:Number 	= 5;
		
		
		private const DEFAULT_SHOW_TRIANGLES:Boolean = false;
		
		private const MIN_ZOOM_ALLOWED:Number = .2;
		public static const MIN_ZOOM_REACHED:String = "onMinZoomReached";
		
		private const MAX_ZOOM_ALLOWED:Number = 2.5;
		public static const MAX_ZOOM_REACHED:String = "onMaxZoomReached";
		
		private var loader:Loader;
		private var original:BitmapData;
		private var currentBitmpap:Bitmap;
		
		private var appliedMatrix:Matrix;
		private var rotationMatrix:Matrix;
		
		private var content:Sprite;
		
		/**
		 * Data used to render the image triangles
		 */ 
		private var verticies:Vector.<Number>;
		private var uvtData:Vector.<Number>;
		private var indices:Vector.<int>;
		
		/**
		 * Value used to determine the number of triangles to render
		 */ 
		protected const RES:int = 20;
		
		
		// Check used to understand if the image is horizontally flipped (possible values -1 and 1)
		private var _hflip:int;
		
		// Check used to understand if the image is vertically flipped (possible values -1 and 1)
		private var _vflip:int;
		
		private var _zoomer:Number;
				
		private var _sourceChanged:Boolean;
		private var _distorsionChanged:Boolean;
		
		public function SmartBitmapRenderer(){
			
			super();
			
			_scaleContent = false;
			
		}
		
		
		private function initTransformation():void{
			
			appliedMatrix = new Matrix()
			rotationMatrix = new Matrix()
			
			_zoomer = 1;
			
		}
		
		private function initDiscriminants():void{
			
			_hflip = 1;
			_vflip = 1;
			
		}
		
		override protected function commitProperties():void{
			
			if(_sourceChanged){
				
				trace("Really need to load image")
				
				processImageData(_source);
				
				_sourceChanged = false;
				
			}
			
			if(_distorsionChanged){
				
				if(original){
				
					if(_distorsionEnabled){
						
						
						
						
						
					}else{
						
					
						
					}
				
				}
				
				_distorsionChanged = false;
				
			}
			
		}
		
		private function processImageData(data:Object):void{
			
			if(loader){
				
				loader.unload();
				
			}
			
			switch(true){
				
				case data is String:
				
				var url:URLRequest = new URLRequest(String(data));
				loader = new Loader();
				
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onDataReady);
				// TODO handle progress and fault
				
				loader.load(url);
				
				break;
				
				case data is Bitmap:
				
				resetContent();
				
				original = data.bitmapData;
				renderData(original, appliedMatrix);
				
				invalidateDisplayList();
				
				break;
				
				case data is ByteArray:
				
				loader = new Loader();
				
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onDataReady);
				
				var ba:ByteArray = new ByteArray();
				
				ba.writeObject(data);
				ba.position = 0;
								
				loader.loadBytes(ByteArray(data));
				
				break;
				
				default:
				throw new Error("The used source is not valid");
				
			}
			
			
		}		
		
		protected function onDataReady(e:Event):void{
			
			resetContent();
			
			e.target.removeEventListener(e.type, arguments.callee);
			
			try{
			
				original = Bitmap(e.target.content).bitmapData;
				
			}catch(error:Error){
				
				var bmd:BitmapData = new BitmapData(e.target.content.width, e.target.content.height, true, 0x00);
				bmd.draw(e.target.content)
				
				original = bmd;
				
			}
			
			renderData(original, appliedMatrix);
			
			invalidateDisplayList();
			
		}
		
		private function resetContent():void{
			
			if(content){
				
				removeChild(content);
				
			}
			
			if(original){
				
				original.dispose();
				
			}
			
		}
		
		protected function renderData(bmd:BitmapData, matrix:Matrix, clearContent:Boolean = true):void{
			
			var bitmap:BitmapData = new BitmapData(bmd.width, bmd.height, false, 0x00);
			bitmap.draw(original)
			
			// trace(matrix)
			
			var j:int;
			
			var i:int;
			
			var indStep:int = 0;
		
			var hStep:Number = bmd.width / RES;
			
			var vStep:Number = bmd.height / RES;
			
			verticies = new Vector.<Number>();
			
		    uvtData = new Vector.<Number>();
		     
		    indices = new Vector.<int>();
		    
		    var imgX:Number = original.rect.x;
		    var imgY:Number = original.rect.y;
		   
			for(j=0; j < RES; j++){
				
				for(i = 0; i < RES; i++){
					
					var point1:Point = new Point(imgX + i *hStep, imgY + j * vStep);
					point1 = matrix.transformPoint(point1);
					
					var point2:Point = new Point(imgX + (i + 1) * hStep, imgY + j * vStep);
					point2 = matrix.transformPoint(point2);
					
					var point3:Point = new Point(imgX + (i + 1) * hStep, imgY + (j + 1) * vStep);
					point3 = matrix.transformPoint(point3);
					
					var point4:Point = new Point(imgX + i * hStep, imgY + (j + 1) * vStep);
					point4 = matrix.transformPoint(point4);
					
					verticies.push(point1.x, point1.y, point2.x, point2.y, point3.x, point3.y, point4.x, point4.y);
					
					uvtData.push(i/RES, j/RES, (i + 1) / RES, j / RES, (i + 1) / RES, (j + 1) / RES, i / RES, (j + 1) / RES);
				
					indices.push(indStep, indStep + 1, indStep + 3, indStep + 1, indStep + 2, indStep + 3);
					
					indStep += 4;
					
				}
							
			}
			
			
			if(clearContent == true){	
			
				content = new Sprite();
				
			}else{
				
				content.graphics.clear();
				
			}
			
			if(showTriangles){
				
				content.graphics.lineStyle(1, 0xff0000);
			
			}
			
			if(distorsionEnabled){
				
				setUpListeners(!distorsionEnabled);
				
			}
					
			content.graphics.beginBitmapFill(bitmap);
			content.graphics.drawTriangles(verticies, indices, uvtData);
			content.graphics.endFill()
						
			if(clearContent == true){	
			
				addChild(content)
				
			}
			
			//content = addChild(new Bitmap(bitmap))
			
		}
				
		private function setUpListeners(remove:Boolean = false):void {
			
			if(remove){
				
				content.removeEventListener(MouseEvent.MOUSE_MOVE, onDetectCorners)
				
				/* content.removeEventListener(MouseEvent.MOUSE_DOWN, startCornerMove);
				content.removeEventListener(MouseEvent.MOUSE_UP, startCornerMove);
				content.removeEventListener(MouseEvent.ROLL_OUT, stopDragging); */
				
			}else{
				
				content.addEventListener(MouseEvent.MOUSE_MOVE, onDetectCorners)
				
				/* content.addEventListener(MouseEvent.MOUSE_DOWN, startCornerMove);
				content.addEventListener(MouseEvent.MOUSE_UP, startCornerMove);
				content.addEventListener(MouseEvent.ROLL_OUT, stopDragging); */
				
			}
	
		}
		
		protected function onDetectCorners(e:MouseEvent):void{
			
			var bounds:Rectangle = getBounds(content);
			var theta:Number = getRotation(appliedMatrix);
			
			var points:Vector.<Point> = new Vector.<Point>();

			points[0] = new Point(bounds.x, bounds.y);
			points[1] = new Point(bounds.x + bounds.width, bounds.y);
			points[2] = new Point(bounds.x + bounds.width, bounds.y + bounds.height);
			points[3] = new Point(bounds.x, bounds.y + bounds.height);
			
			var a:Point = new Point(appliedMatrix.tx, appliedMatrix.ty)
			
			points[0] = a;
			points[1] = new Point(points[1].x, points[1].y + (original.width * Math.sin(theta * Math.PI / 180)))
			points[2] = new Point(points[2].x - (a.x - bounds.x), points[2].y)
			points[3] = new Point(bounds.x, bounds.y + (bounds.y + (bounds.height - points[1].y)))
			
			// trace(points)
			
			// Top left check
			if((e.localX < points[0].x + RES && e.localX > points[0].x) && (e.localY > points[0].y && e.localY < (points[0].y + RES))){
				
				content.useHandCursor = true
				content.buttonMode = true
				
				return
				
			}else{
				
				content.useHandCursor = false
				content.buttonMode = false
				
			}
			
			// Top right check
			if((e.localX < points[1].x && e.localX > points[1].x - RES) && (e.localY > points[1].y && e.localY < (points[1].y + RES))){
				
				content.useHandCursor = true
				content.buttonMode = true
				
				return
				
			}else{
				
				content.useHandCursor = false
				content.buttonMode = false
				
			}
			
			// Bottom right check
			if((e.localX < points[2].x && e.localX > points[2].x - RES) && (e.localY < points[2].y && e.localY > (points[2].y - RES))){
				
				content.useHandCursor = true
				content.buttonMode = true
				
				return
				
			}else{
				
				content.useHandCursor = false
				content.buttonMode = false
				
			}
			
			// Bottom left check
			if((e.localX > points[3].x && e.localX < points[3].x + RES) && (e.localY < points[3].y && e.localY > (points[3].y - RES))){
				
				content.useHandCursor = true
				content.buttonMode = true
				
				return
				
			}else{
				
				content.useHandCursor = false
				content.buttonMode = false
				
			}
			
		}
		
		protected function stopDragging(e:MouseEvent):void{
			
			
			
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void{
			
			super.updateDisplayList(w, h);
			trace(arguments)
			
			if(content){
				
				// Reset the scale in order to get right positionin
				content.scaleX = 1;
              	content.scaleY = 1;
				
         		var bounds:Rectangle = getBounds(content);
    			
				var interiorWidth:Number = unscaledWidth;
		        var interiorHeight:Number = unscaledHeight;
		        var contentWidth:Number = content.width;
		        var contentHeight:Number = content.height;
		        
		        trace(contentWidth, w, bounds)
		
				var x:Number = 0;
		        var y:Number = 0;
		        
		        // bug 84294 a swf may still not have size at this point
		        var newXScale:Number = contentWidth  == 0 ? 1 : interiorWidth / original.width;
		        var newYScale:Number = contentHeight == 0 ? 1 : interiorHeight / contentHeight;
		            
		        var scale:Number;
		            
		        if(scaleContent){
		            
			    	if (newXScale > newYScale){
	                    	
	                	x = int((interiorWidth - contentWidth * newYScale) * getHorizontalAlignValue());
	                    scale = newYScale;
	                	
	                }else{
	                    	
	                    y = int((interiorHeight - contentHeight * newXScale) * getVerticalAlignValue());
	                    scale = newXScale;
	                	
	                }
	                
	                 trace("STO A SCAL'", newYScale, newXScale)
	                 
	                /*  if(_zoomer >= 1){
              			
              			// x += Math.abs(bounds.x);
              			x += -1*(bounds.x);
              		
              		}else{
              			
              			x -= bounds.x;
              			
              		}
              		
              		if(_zoomer >= 1){
              			
              			// y += Math.abs(bounds.y);
              			y += -1*(bounds.y);
              		
              		}else{
              			
              			y -= bounds.y;
              			
              		} */
                	
              	}else{
              			
              		scale = 1;
              		
              		x = int((interiorWidth - contentWidth)) * getHorizontalAlignValue();
              		
              		if(_zoomer >= 1){
              			
              			// x += Math.abs(bounds.x);
              			x += -1*(bounds.x);
              		
              		}else{
              			
              			x -= bounds.x;
              			
              		}
              		
              		y = int((interiorHeight - contentHeight)) * getVerticalAlignValue();
              		
              		if(_zoomer >= 1){
              			
              			// y += Math.abs(bounds.y);
              			y += -1*(bounds.y);
              		
              		}else{
              			
              			y -= bounds.y;
              			
              		}
              		
              			
              	}
              	
              	
              	content.scaleX = scale;
              	content.scaleY = scale;
              	
          //    	trace("wwwwwwwwwwwwwwwwwwwww", scale, scaleContent)
              	
              	content.x = x;
              	content.y = y;
              	
          //    	trace("getVerticalAlignValue()", getVerticalAlignValue())
              	
          //    	trace(content.width, w, unscaledWidth)
          //    	trace("=======", (w - content.width) / 2, x)
          //    	trace(bounds)
              	
			}
			
			if(distorsionEnabled){
				
						//addChild(distorsionTopRight);
						//addChild(distorsionBottomLeft);
						//addChild(distorsionBottomRight);
				
			}
			
		}
		
		/**
     	 * @private
     	 * Recover the value used to calculate x and y 
	     * accorningly to the kind of alignment used for the component
	     */
	    private function getHorizontalAlignValue():Number{
	    	
	        var horizontalAlign:String = getStyle("horizontalAlign");
	
	        if (horizontalAlign == "left"){
	            
	            return 0;
	            
	        }else if (horizontalAlign == "right"){
	            
	            return 1;
	            
	        }else{
	
	        	// default = center
	        	return 0.5;
	        	
	        }
	    }

	    /**
	     * @private
	     * Recover the value used to calculate x and y 
	     * accorningly to the kind of alignment used for the component
	     */
	    private function getVerticalAlignValue():Number {
	    	
	        var verticalAlign:String = getStyle("verticalAlign");
	
	        if (verticalAlign == "top"){
	            
	            return 0;
	        
	        }else if (verticalAlign == "bottom"){
	            
	            return 1;
	        
	        }else{
	        
	        	// default = middle
	        	return 0.5;
	        
	        }
	    }
	    
	    
	    public function flip(mode:String = HORIZONTAL_FLIP):void{
	    	
	    	trace("FLIPPING", appliedMatrix.tx)
	    	
			if(mode == HORIZONTAL_FLIP){
				
				// Hanlde the horizontal flip
				/* _hflip *= -1;
				
				
				var r:int = Math.round(this.getRotation(appliedMatrix));
				
				if(appliedMatrix.a > 0){
					
					appliedMatrix.a = -1*appliedMatrix.a;
					appliedMatrix.tx = content.width + content.x;	
										
				}else{
					
					appliedMatrix.a = -1*appliedMatrix.a;
					appliedMatrix.tx = content.x - content.width;
					
				}
				
			
				// Handle the rotation applied, it generates a skew
				var xskewRadians:Number = this.getSkewXRadians(appliedMatrix);
				
				if(xskewRadians != 0){
					
					setSkewXRadians(appliedMatrix, -1 * (xskewRadians));
									
				} */
								
				appliedMatrix.scale(-1, 1);
			
				appliedMatrix.translate(original.width * getScaleX(appliedMatrix), 0);
				
				_hflip *= -1; 
				
			}else{
				
				appliedMatrix.scale(1, -1);
			
				appliedMatrix.translate(0, original.height * getScaleY(appliedMatrix));
				
				_vflip *= -1;
				
			}
			
			if(content){
				
				removeChild(content);
				
			}
			
			trace("FLIPPED", appliedMatrix.tx, getScaleX(appliedMatrix))
			
		//	appliedMatrix.tx = 700
			
			trace("FLIPPED", appliedMatrix.tx)
			
			renderData(original, appliedMatrix);
			
			invalidateDisplayList()
	    	
	    }
	    
	   
	    
	    public function zoom(mode:String = ZOOM_IN):void{
	    	
	    	// If the image fits the component no zoom is allowed
	    	if(_scaleContent){
	    		
	    		return;
	    		
	    	}
	    	
	    	var zoomArea:Rectangle = original.rect;
				
			if(mode == ZOOM_IN){
				
				if(_zoomer >= MAX_ZOOM_ALLOWED){
					
					dispatchEvent(new Event(MAX_ZOOM_REACHED));
					return;
					
				}
				
				_zoomer += _zoomStep;
					
			}else{
				
				if(_zoomer <= MIN_ZOOM_ALLOWED){
					
					dispatchEvent(new Event(MIN_ZOOM_REACHED));
					return;
					
				}
				
				_zoomer += -_zoomStep;
										
			}
			
			var oldWidth:Number = getScaleX(appliedMatrix)*original.width;
			var oldHeight:Number = getScaleY(appliedMatrix)*original.height;
			
			var originX:Number = zoomArea.width / 2;
			var originY:Number = zoomArea.height / 2;
			
			appliedMatrix.translate( -originX, -originY );
			
			setScaleX(appliedMatrix, _zoomer)
			setScaleY(appliedMatrix, _zoomer)
			
			appliedMatrix.translate( originX, originY ) ;
			
			// Start calculation to center the image
			var newWidth:Number = getScaleX(appliedMatrix)*original.width;
			var newHeight:Number = getScaleY(appliedMatrix)*original.height;
			
			// Use the _hflip and _vflip to handle sign in the translation 
			appliedMatrix.translate(_hflip * ((oldWidth - newWidth) * content.scaleX) / 2,  _vflip * ((oldHeight - newHeight) * content.scaleY) / 2);  
				
			if(content){
				
				removeChild(content);
				
			}
				
			renderData(original, appliedMatrix);
			
			invalidateDisplayList()
	    	
	    }
		
		public function rotate(mode:String = CW_ROTATION):void{
			
			if(!original)return;
			
			var rotateArea:Rectangle = original.rect;
			
			var q:Number = ConversionUtils.degreeTOradian(rotationStep);
				
			var centerX:Number = rotateArea.width / 2;
			var centerY:Number = rotateArea.height / 2;
				
			rotationMatrix = new Matrix();
				
			rotationMatrix.translate(-1 * centerX, -1 * centerY);
			
			if(mode == CW_ROTATION){
			
				rotationMatrix.rotate(q);
				
			}else{
				
				rotationMatrix.rotate(-q);
				
			}
				
			rotationMatrix.translate(centerX, centerY);
				
			appliedMatrix.concat(rotationMatrix);
			
			if(content){
				
				removeChild(content);
				
			}
			
			renderData(original, appliedMatrix);
			
			invalidateDisplayList();
			
		}
		
		private var _source:Object;
		
		public function set source(value:Object):void{
			
			if(value != _source){
				
				initTransformation();
				
				initDiscriminants();
				
				_source = value;
				_sourceChanged = true;
				
				invalidateProperties();
				
			}
			
		}
		
		public function get source():Object{
			
			return _source;
			
		}
		
		// ********************************************
		// ************ MATRIX CALCULATIONS ***********
		// ********************************************
		private function setScaleX(m:Matrix, scaleX:Number):void{
				
			var oldValue:Number = getScaleX(m);
			// avoid division by zero 
			if (oldValue){
					
				var ratio:Number = scaleX / oldValue;
				m.a *= ratio;
				m.b *= ratio;
				
			}else{
					
				var skewYRad:Number = Math.atan2(-m.c, m.d);
				m.a = Math.cos(skewYRad) * scaleX;
				m.b = Math.sin(skewYRad) * scaleX;
					
			}
		}
			
		private function setScaleY(m:Matrix, scaleY:Number):void{
				
			var oldValue:Number = getScaleY(m);
			// avoid division by zero 
			if (oldValue){
					
				var ratio:Number = scaleY / oldValue;
				m.c *= ratio;
				m.d *= ratio;
				
			}else{
					
				var skewXRad:Number = Math.atan2(-m.c, m.d);;
				m.c = -Math.sin(skewXRad) * scaleY;
				m.d =  Math.cos(skewXRad) * scaleY;
					
			}
			
		}
		
		protected function getScaleY(m:Matrix):Number{
				
			return Math.sqrt(m.c*m.c + m.d*m.d);
		
		}
			
		protected function getScaleX(m:Matrix):Number{
				
			return Math.sqrt(m.a*m.a + m.b*m.b);
			
		}
		
		protected function getRotation(m:Matrix):Number {
			
			return getRotationRadians(m)*(180/Math.PI);
		
		}
		
		protected function getRotationRadians(m:Matrix):Number {
			
			return getSkewYRadians(m);
		
		}
			
		protected function getSkewYRadians(m:Matrix):Number	{
			
			return Math.atan2(m.b, m.a);
		
		}
		
		protected function setSkewXRadians(m:Matrix, skewX:Number):void {

			var scaleY:Number = getScaleY(m);
			m.c = -scaleY * Math.sin(skewX);
			m.d =  scaleY * Math.cos(skewX);
		
		}
		
		protected function getSkewXRadians(m:Matrix):Number {
			
			return Math.atan2(-m.c, m.d);
		
		}
		
		// ********************************************
		// ************* ACCESSOR METHODS ************
		// ********************************************
		
		private var _zoomStep:Number = DEFAULT_ZOOM_STEP;
		
		[Bindable]
		public function set zoomStep(value:Number):void{
			
			_zoomStep = value;
			
		}
		
		public function get zoomStep():Number{
			
			return _zoomStep;
			
		}
		
		
		private var _rotationStep:Number = DEFAULT_ROTATION_STEP;
		
		[Bindable]
		public function set rotationStep(value:Number):void{
			
			_rotationStep = value;
			
		}
		
		public function get rotationStep():Number{
			
			return _rotationStep;
			
		}
		
		private var _scaleContent:Boolean;
		
		/**
     	 *  @private
     	 */
     	[Bindable]
    	public function set scaleContent(value:Boolean):void {
    		
        	if (_scaleContent != value){
        	
            	_scaleContent = value;
            	
            	appliedMatrix.identity()
            	
            	renderData(original, appliedMatrix, false);

            	invalidateDisplayList();
        	
        	}

    	}
		
		public function get scaleContent():Boolean{
		 	
        	return _scaleContent;
    	
    	}

    	private var _showTriangles:Boolean = DEFAULT_SHOW_TRIANGLES;
    	
    	[Bindable]
    	public function set showTriangles(value:Boolean):void{
    		
    		if(_showTriangles != value){
    			
    			_showTriangles = value;
    			
    			renderData(original, appliedMatrix, false);
    			
    		}
    		
    	}
    	
    	public function get showTriangles():Boolean{
    		
    		return _showTriangles;
    		
    	}
    	
    	private var _distorsionEnabled:Boolean;
    	
    	[Bindable]
    	public function set distorsionEnabled(value:Boolean):void{
    		
    		if(_distorsionEnabled != value){
    			
    			_distorsionEnabled = value;
    			
    			setUpListeners(!_distorsionEnabled)
    			
    		}
    		
    	}
    	
    	public function get distorsionEnabled():Boolean{
    		
    		return _distorsionEnabled;
    		
    	}
		
	}
}

