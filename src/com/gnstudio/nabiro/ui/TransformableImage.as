package com.gnstudio.nabiro.ui
{
	import com.gnstudio.nabiro.measurement.ConversionUtils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import mx.controls.Image;
	
	public class TransformableImage extends Image{
		
		
		private const DEFAULT_ZOOM_STEP:Number 		= .1;
		private const DEFAULT_ROTATION_STEP:Number 	= 5;
		
		public static const VERTICAL_FLIP:String = "verticalMode";
		public static const HORIZONTAL_FLIP:String = "horizontalMode";
		public static const CW_ROTATION:String = "cw";
		public static const CCW_ROTATION:String = "ccw";
		
		//  Matrix used to store the size transformation
		private var appliedMatrix:Matrix;
		
		// Matrix used to separately store the rotation
		private var rotationMatrix:Matrix;
		
		// Store the information dealing with the zoom
		// in a way useful for matrix calculation (i.e. is the information
		// dealing with image content and not with the overall control)
		private var _zoom:Number;
		
		// Check used to understand if the image is horizontally flipped (possible values -1 and 1)
		private var _hflip:int;
		
		// Check used to understand if the image is vertically flipped (possible values -1 and 1)
		private var _vflip:int;
		
		// Store the information dealing with content rotation
		private var _rotation:Number;
		
		// Is the original image, stored in order to handle the reset method
		private var original:BitmapData;
		
		// It's the current bitmap data, the transformed image
		private var current:BitmapData;
		
		public function TransformableImage() {
			
			super();
			
			// Initizalize the default values
			_zoom = 1;
			
			_hflip = 1;
			_vflip = 1;
			
			_rotation = 0;
			
			appliedMatrix = new Matrix();
			rotationMatrix = new Matrix();
			
			// Define the listener that hanlde the external source loading
			addEventListener(Event.COMPLETE, onExternalSourceLoaded);
			
		}
		
		protected function onExternalSourceLoaded(e:Event):void{
			
			var bmd:BitmapData
			
			try{
			
				bmd = Bitmap(content).bitmapData;
			
			}catch(error:Error){
				
				bmd = new BitmapData(content.width, content.height, true, 0x0);
				bmd.draw(content);
				
			}
			
			// Make a copy of the original image
			if(!original && bmd){
					
				original = new BitmapData(bmd.width, bmd.height, true, 0x00000000)
				original.draw(bmd);
				
			}
											
				
		}
		
		override public function unloadAndStop(invokeGarbageCollector:Boolean=true):void{
			
			super.unloadAndStop(invokeGarbageCollector);
			
			if(original){
				
				original.dispose();
				original = null;
			
			}
			
			_zoom = 1;
			
			_hflip = 1;
			_vflip = 1;
			
			_rotation = 0;
			
			appliedMatrix = new Matrix();
			rotationMatrix = new Matrix();
			
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void {
			
			
			if(content){
							
				var contentHolder:Loader = content.parent as Loader;
				
			 	trace("Applied:", appliedMatrix)
				trace("Content", content, "\n", contentHolder) 
			
				if(contentHolder){
						
					super.updateDisplayList(w, h);
				
				}else{
					
				/* 	var c:Matrix = new Matrix()
				if(rotationMatrix.tx != 0)return */
					
					var matrix:Matrix = content.transform.matrix;
					
					var bitmpapHolder:Bitmap = content as Bitmap;
					
					content.scaleX = 1.0;
        			content.scaleY = 1.0;
					
					 // Scale the content to the size of the SWFLoader, preserving aspect ratio.
		            var interiorWidth:Number = unscaledWidth;
		            var interiorHeight:Number = unscaledHeight;
		            var contentWidth:Number = bitmpapHolder.width;
		            var contentHeight:Number = bitmpapHolder.height;
		
		            var x:Number = 0;
		            var y:Number = 0;
		            
		            // bug 84294 a swf may still not have size at this point
		            var newXScale:Number = contentWidth  == 0 ? 1 : interiorWidth / contentWidth;
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
                	
              		}else{
              			
              			scale = 1;
              			
              			x = int((interiorWidth - contentWidth) * getVerticalAlignValue());
              			y = int((interiorHeight - contentHeight) * getVerticalAlignValue());
              			
              		}
					
					var p:Point = new Point(x, y);
					
					trace(rotationMatrix.tx, appliedMatrix.tx)
										
				//	x -= p.x - appliedMatrix.transformPoint(p).x
					
                	if(_hflip > 0){
                		
                		matrix.tx = x
                		
                	}else{
                		
                		matrix.tx = appliedMatrix.tx + int(bitmpapHolder.bitmapData.rect.width - (appliedMatrix.tx - x))
                		
                	}
                	
                	if(_vflip > 0){
                		
                		matrix.ty = y
                		
                	}else{
                		
                		matrix.ty = appliedMatrix.ty + int(bitmpapHolder.bitmapData.rect.height - (appliedMatrix.ty - y))
                	
                	}
                	
                	var r:Number = this.getRotation(appliedMatrix)
                	                	
                	this.setScaleX(matrix, scale)
                	this.setScaleY(matrix, scale)
                	
              //  	this.setRotation(matrix, r)
                
                	content.transform.matrix = matrix
						
				}
					
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
		
	   /**
		* Method used to flip vertically and orizontally the image, the method is
		* inspired by the GIMP source code
		* 
		case GIMP_ORIENTATION_HORIZONTAL:
			 gimp_matrix3_translate (matrix, - axis, 0.0);
		     gimp_matrix3_scale (matrix, -1.0, 1.0);
		     gimp_matrix3_translate (matrix, axis, 0.0);
		     break;
			
		case GIMP_ORIENTATION_VERTICAL:
		     gimp_matrix3_translate (matrix, 0.0, - axis);
		     gimp_matrix3_scale (matrix, 1.0, -1.0);
		     gimp_matrix3_translate (matrix, 0.0, axis);
		     break;
		* @param mode String
		*/		
		public function flip(mode:String = HORIZONTAL_FLIP):void{
			
			if(!original)return;
			
			//trace("appliedMatrix before", appliedMatrix, mode)
			
			var matrix:Matrix;
			
			switch(true){
				
				// Hanlde the horizontal flip
				case mode == HORIZONTAL_FLIP:
				
				_hflip *= -1;
				
				matrix = content.transform.matrix;
				
				var r:int = Math.round(this.getRotation(matrix));
				
				if(matrix.a > 0){
					trace("before", matrix.tx, content.x)
					matrix.a = -1*matrix.a;
					matrix.tx = content.width + content.x;	
					
					trace("bug:", r, content.width + content.x)				
					
					
				}else{
					
					matrix.a = -1*matrix.a;
					matrix.tx = content.x - content.width;
					
				}
				
				
			//	trace("\n\tthe rotation is", r, "\n")
				
				trace("debug@", this.getRotation(appliedMatrix))
				
				
				// Handle the rotation applied, it generates a skew
				var xskewRadians:Number = this.getSkewXRadians(matrix);
				
				if(xskewRadians != 0){
					
				//	setSkewXRadians(matrix, -1 * (xskewRadians));
					
					if(xskewRadians < 0){
						
						trace("xskewRadians < 0", xskewRadians)
						
					}else{
						
						trace("xskewRadians > 0", xskewRadians)
						
					}
					
					if(r > 0 && r < 90){
						
						var point:Point = new Point(matrix.tx, matrix.ty);
			
						point = matrix.transformPoint(point);
						
					//	matrix.tx -= 4*point.x;
				//		matrix.ty -= point.y;
						
												
					}
					
			//		matrix.tx *= xskewRadians;
					
					
					
				}
				
				
				
				content.transform.matrix = matrix;
				
				break;
				
				// Handle the vertical flip
				case mode == VERTICAL_FLIP:
				
				_vflip *= -1;
				
				matrix = content.transform.matrix;
				
				if(matrix.d > 0){
					
					matrix.d = -1*matrix.d;
					matrix.ty = content.y + content.height;
				
				}else{
					
					matrix.d = -1*matrix.d;
					matrix.ty = content.y - content.height;
				
				}
				
				// Handle the rotation applied, it generates a skew
				var yskewRadians:Number = this.getSkewYRadians(matrix);
				
				if(yskewRadians != 0){
					
					setSkewYRadians(matrix, -1 * (yskewRadians));
			//		matrix.ty *= yskewRadians;
					
				}
				
				content.transform.matrix = matrix;
				
				break; 
				
				// Handle no valid mode
				default:
				
				throw new IllegalOperationError("The mode has to be HORIZONTAL_FLIP or VERTICAL_FLIP");
				return;
				
			}
			
			appliedMatrix = matrix;
			
			invalidateDisplayList();
						
		}
		
		
		
		public function rotate(mode:String = CW_ROTATION):void{
			
			if(!original)return;
			
			var q:Number = ConversionUtils.degreeTOradian(_rotationStep);

			var centerX:Number = original.width / 2;
			var centerY:Number = original.height / 2;
			
			rotationMatrix = new Matrix();
				
			rotationMatrix.translate(-1 * centerX, -1 * centerY);
			
			if(mode == CW_ROTATION){
				
				q = ConversionUtils.degreeTOradian(90)
				rotationMatrix.rotate(q);
			
			}else if(mode == CCW_ROTATION){
				
				q = ConversionUtils.degreeTOradian(-90)
				rotationMatrix.rotate(-q);
				
			}
				
			rotationMatrix.translate(centerX, centerY);
		/* 	
			rotationMatrix.tx = centerX;
			rotationMatrix.ty = centerY; */
			
			var m:Matrix = content.transform.matrix
			
			appliedMatrix.concat(rotationMatrix);
			
			content.transform.matrix = appliedMatrix;
			
			invalidateDisplayList();
			
		}
		
		override public function set source(value:Object):void{
			
			if(value is Bitmap){
							
				var bmd:BitmapData = Bitmap(value).bitmapData;
			
				// Make a copy of the original image
				if(!original){
					
					original = new BitmapData(bmd.width, bmd.height, true, 0x00000000)
					original.draw(bmd);
											
					// Set as source a transparent image
					super.source = new Bitmap(original);
				
				 }
				
			}else{
				
				super.source = value;
				
			}
			
							
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
		
		
		// ********************************************
		// ************ MATRIX CALCULATIONS ***********
		// ********************************************
		protected function getScaleY(m:Matrix):Number{
				
			return Math.sqrt(m.c*m.c + m.d*m.d);
		
		}
			
		protected function getScaleX(m:Matrix):Number{
				
			return Math.sqrt(m.a*m.a + m.b*m.b);
			
		}
		
		protected function rotateAroundInternalPoint(m:Matrix, x:Number, y:Number, radians:Number):void{
			
			var point:Point = new Point(x, y);
			
			point = m.transformPoint(point);
			
			m.tx -= point.x;
			m.ty -= point.y;
			m.rotate(radians);
			m.tx += point.x;
			m.ty += point.y;
		
		}
			
		protected function setScaleX(m:Matrix, scaleX:Number):void{
				
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
			
		protected function setScaleY(m:Matrix, scaleY:Number):void{
				
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
		
		protected function getRotation(m:Matrix):Number {
			
			return getRotationRadians(m)*(180/Math.PI);
		
		}
	
		protected function setRotation(m:Matrix, rotation:Number):void {
			
			setRotationRadians(m, rotation*(Math.PI/180));
		
		}
		
		protected function setRotationRadians(m:Matrix, rotation:Number):void {
			
			var oldRotation:Number = getRotationRadians(m);
			var oldSkewX:Number = getSkewXRadians(m);
			setSkewXRadians(m, oldSkewX + rotation-oldRotation);
			setSkewYRadians(m, rotation);		
		
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
		
		protected function setSkewYRadians(m:Matrix, skewY:Number):void {
			
			var scaleX:Number = getScaleX(m);
			m.a = scaleX * Math.cos(skewY);
			m.b = scaleX * Math.sin(skewY);
		
		}
		
	}
}