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

	import flash.display.SimpleButton;

	/**
	 *
	 */
	public class SlideCursor extends Sprite {

		public static const TYPE_LEFT:String = "cursorLeft";
		public static const TYPE_RIGHT:String = "cursorRight";

		private var _sliderWidth:Number;
		private var _cursorHeight:Number;
		private var _type:String = SlideCursor.TYPE_LEFT;

		private var _vLine:Sprite;
		private var _hitArea:SimpleButton;

		/**
		 *
		 */
		public function get vLine():Sprite {
			return _vLine;
		}

		/**
		 *
		 */
		public function set sliderWidth(v:Number):void {
			_sliderWidth = v;
			redraw_ui();
		}

		/**
		 *
		 */
		public function set cursorHeight(v:Number):void {
			_cursorHeight = v;
			redraw_ui();
		}


		public function get hitTestArea():SimpleButton {
			return _hitArea;
		}

		/**
		 *
		 */
		public function SlideCursor(sliderWidth:Number, cursorHeight:Number, type:String = SlideCursor.TYPE_LEFT) {

			_sliderWidth = sliderWidth;
			_cursorHeight = cursorHeight;
			_type = type;

			_vLine = new Sprite();
			_vLine.blendMode = BlendMode.DIFFERENCE;

			_hitArea = new SimpleButton();
			_hitArea.useHandCursor = false;

			var hitSprite:Sprite = new Sprite();

			var g:Graphics = hitSprite.graphics;
			g.beginFill(0x0);
			g.drawRect(0, 0, 5, _cursorHeight + 12);

			_hitArea.hitTestState = hitSprite;

			addChild(_vLine);
			addChild(_hitArea);

			_vLine.visible = false;

			redraw_ui();
		}

		/**
		 *
		 */
		public function redraw_ui():void {

			var g:Graphics = graphics;

			g.clear();
			g.beginFill(0x999999);

			var g1:Graphics = _vLine.graphics;

			g1.clear();
			g1.lineStyle(1, 0xFFFFFF);

			if(_type == SlideCursor.TYPE_LEFT){

				g1.moveTo(5, 6);
				g1.lineTo(5, _cursorHeight - 6);

				g.moveTo(0, _cursorHeight);
				g.lineTo(5, _cursorHeight);
				g.lineTo(5, _cursorHeight - 6);
				g.lineTo(0, _cursorHeight);
			}
			else {

				g1.moveTo(0, 6);
				g1.lineTo(0, _cursorHeight - 6);

				g.moveTo(0, 0);
				g.lineTo(5, 0);
				g.lineTo(0, 6);
			}


		}
	}
}
