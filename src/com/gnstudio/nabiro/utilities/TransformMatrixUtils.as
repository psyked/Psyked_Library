package com.gnstudio.nabiro.utilities
{	
	import flash.geom.Matrix;
	import flash.geom.Point;

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
	 *   @author 				Bianco Alessandro [ a.bianco@gnstudio.com ]
	 *   
	 *	 
	 */
	
	public class TransformMatrixUtils
	{
		public function TransformMatrixUtils()
		{
		}
		
		public static function getScaleX(m:Matrix):Number
		{
			return Math.sqrt(m.a*m.a + m.b*m.b);
		}
		public static function setScaleX(m:Matrix, scaleX:Number):void
		{
			var oldValue:Number = getScaleX(m);
			// avoid division by zero 
			if (oldValue)
			{
				var ratio:Number = scaleX / oldValue;
				m.a *= ratio;
				m.b *= ratio;
			}
			else
			{
				var skewYRad:Number = Math.atan2(-m.c, m.d);
				m.a = Math.cos(skewYRad) * scaleX;
				m.b = Math.sin(skewYRad) * scaleX;
				
			}
		}
		
		public static function getScaleY(m:Matrix):Number
		{
			return Math.sqrt(m.c*m.c + m.d*m.d);
		}
		public static function setScaleY(m:Matrix, scaleY:Number):void
		{
			var oldValue:Number = getScaleY(m);
			// avoid division by zero 
			if (oldValue)
			{
				var ratio:Number = scaleY / oldValue;
				m.c *= ratio;
				m.d *= ratio;
			}
			else
			{
				var skewXRad:Number = Math.atan2(-m.c, m.d);;
				m.c = -Math.sin(skewXRad) * scaleY;
				m.d =  Math.cos(skewXRad) * scaleY;
			}
		}
		
		public static function getRotation(m:Matrix):Number
		{
			return getRotationRadians(m)*(180/Math.PI);
		}
		
		public static function setRotation(m:Matrix, rotation:Number):void
		{
			setRotationRadians(m, rotation*(Math.PI/180));
		}
		public static function setRotationRadians(m:Matrix, rotation:Number):void
		{
			var oldRotation:Number = getRotationRadians(m);
			var oldSkewX:Number = getSkewXRadians(m);
			setSkewXRadians(m, oldSkewX + rotation-oldRotation);
			setSkewYRadians(m, rotation);
		}
		public static function getRotationRadians(m:Matrix):Number
		{
			var skewX:Number = getSkewXRadians(m);
			var skewY:Number = getSkewYRadians(m);
			return ( skewX != skewY ) ? NaN : skewX;
		}
		public static function rotateAroundInternalPoint(m:Matrix, x:Number, y:Number, radians:Number):void
		{
			var point:Point = new Point(x, y);
			
			point = m.transformPoint(point);
			
			m.tx -= point.x;
			m.ty -= point.y;
			m.rotate(radians);
			m.tx += point.x;
			m.ty += point.y;
		}
		
		public static function getSkewYRadians(m:Matrix):Number
		{
			return Math.atan2(m.b, m.a);
		}
		public static function setSkewYRadians(m:Matrix, skewY:Number):void
		{
			var scaleX:Number = getScaleX(m);
			m.a = scaleX * Math.cos(skewY);
			m.b = scaleX * Math.sin(skewY);
		}
		
		public static function getSkewXRadians(m:Matrix):Number
		{
			return Math.atan2(-m.c, m.d);
		}
		public static function setSkewXRadians(m:Matrix, skewX:Number):void
		{
			var scaleY:Number = getScaleY(m);
			m.c = -scaleY * Math.sin(skewX);
			m.d =  scaleY * Math.cos(skewX);
		}
	}
}