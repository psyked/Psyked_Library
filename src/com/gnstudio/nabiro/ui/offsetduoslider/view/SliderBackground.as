/**
 * @author jaco
 */
package com.gnstudio.nabiro.ui.offsetduoslider.view {

	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.display.SpreadMethod;
	import flash.display.GradientType;
	import flash.display.BlendMode;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.geom.Matrix;


	public class SliderBackground extends Sprite {

		private var _sbWidth:Number = 100;
		private var _sbHeight:Number = 10;

		private var _offsetStart:int = 0;
		private var _offsetEnd:int = 0xFF;

		private var _colorStart:uint = 0x0;
		private var _colorEnd:uint = 0xFFFFFF;

		/**
		 *
		 */
		public function get sbWidth():Number {
			return _sbWidth;
		}
		public function set sbWidth(v:Number):void {
			_sbWidth = v;
			redraw();
		}

		/**
		 *
		 */
		public function get sbHeight():Number {
			return _sbHeight;
		}
		public function set sbHeight(v:Number):void {
			_sbHeight = v;
			redraw();
		}

		/**
		 *
		 */
		public function get offsetStart():int {
			return _offsetStart;
		}
		public function set offsetStart(v:int):void {
			_offsetStart = v;
			redraw();
		}

		/**
		 *
		 */
		public function get offsetEnd():int {
			return _offsetEnd;
		}
		public function set offsetEnd(v:int):void {
			_offsetEnd = v;
			redraw();
		}

		/**
		 *
		 */
		public function get colorStart():uint {
			return _colorStart;
		}
		public function set colorStart(v:uint):void {
			_colorStart = v;
			redraw();
		}

		/**
		 *
		 */
		public function get colorEnd():uint {
			return _colorEnd;
		}
		public function set colorEnd(v:uint):void {
			_colorEnd = v;
			redraw();
		}

		/**
		 *
		 */
		public function SliderBackground(sbWidth:Number = 100, sbHeight:Number = 10) {

			_sbWidth = sbWidth;
			_sbHeight = sbHeight;

			redraw();
		}

		/**
		 *
		 */
		public function redraw(newWidth:Number = -1, newHeight:Number = -1):void {

			_sbWidth = Math.max(_sbWidth, newWidth);
			_sbHeight = Math.max(_sbHeight, newHeight);

			var g:Graphics = graphics;
			g.clear();

			var fillType:String = GradientType.LINEAR;
			var spreadMethod:String = SpreadMethod.PAD;

			var colors:Array = [_colorStart, _colorEnd];
			var alphas:Array = [1, 1];
			var ratios:Array = [_offsetStart, _offsetEnd];

			var gradientBox:Matrix = new Matrix();
			gradientBox.createGradientBox(_sbWidth, _sbHeight);

			g.beginGradientFill(fillType, colors, alphas, ratios, gradientBox, spreadMethod);
			g.drawRect(0, 0, _sbWidth, _sbHeight);
			g.endFill();
		}
	}
}
