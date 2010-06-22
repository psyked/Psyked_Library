package com.gnstudio.nabiro.ui.images {

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
	 *   @author 					Marco Fusetti [ m.fusetti@gnstudio.com ]
	 *   
	 *	 
	 */


	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.filters.*;

	public class Highliter extends MovieClip {

		public static const SELECTION_RECTANGLE:String = "rectangle";
		public static const SELECTION_ELLIPSE:String = "ellipse";

		private var drawable:Boolean = false;
		private var cx:int = 0;
		private var cy:int = 0;
		private var snapWidth:int = 0;
		private var snapHeight:int = 0;

		private var _displayObject:Loader;
		private var _selectionType:String = Highliter.SELECTION_RECTANGLE;
		private var _sprite:Sprite;
		private var _blur:Number = 0;

		private var _blurFilter:BlurFilter;

		/**
		 *
		 */
		public function get rectangleSnap():Rectangle {
			
			var rect:Rectangle = new Rectangle();
			rect.x = Math.round(cx - _blur);
			rect.y = Math.round(cy - _blur);
			rect.width = Math.round(snapWidth + _blur * 2);
			rect.height = Math.round(snapHeight + _blur * 2);
			return rect;
			
		}

		/**
		 *
		 */
		public function set selectionType(v:String):void {
			
			_selectionType = v;
			
		}

		/**
		 *
		 */
		public function get blur():Number {
			
			return _blur;
			
		}
		public function set blur(v:Number):void {
			
			_blur = v;
			redraw_hilite();
			
		}


		public function get bitmapData():BitmapData {

			var bd:BitmapData = new BitmapData(rectangleSnap.width, rectangleSnap.height);
			var g:Graphics = _sprite.graphics;

			g.clear();
			g.beginFill(0xFFFFFF);

			if(_selectionType == Highliter.SELECTION_RECTANGLE){
				
				g.drawRect(0, 0, snapWidth, snapHeight);
				
			} else {
			
				g.drawEllipse(0, 0, snapWidth, snapHeight);
			
			}

			g.endFill();
			_sprite.filters = filters;

			bd.floodFill(0, 0, 0xFFFFFFFF);
		
			var bdMask:BitmapData = new BitmapData(rectangleSnap.width, rectangleSnap.height);
			bdMask.floodFill(0, 0, 0x00FFFFFF);
			var m:Matrix = new Matrix(1,0,0,1, Math.round(_blur), Math.round(_blur));

			bdMask.draw(_sprite, m);
			var snapRect:Rectangle = new Rectangle(0, 0, rectangleSnap.width, rectangleSnap.height);
			bd.copyChannel(bdMask, snapRect, new Point(0, 0), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);

			return bd;

		}


		/**
		 * the constructor
		 */
		public function Highliter(displayObject:Loader, selectionType:String = Highliter.SELECTION_RECTANGLE) {

			_displayObject = displayObject;
			_selectionType = selectionType;

			_displayObject.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_displayObject.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_displayObject.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			addEventListener(MouseEvent.CLICK, onMouseUp);
			
			_sprite = new Sprite();
			
		}

		private function onMouseDown(evt:MouseEvent):void {

			graphics.clear();

			cx = _displayObject.mouseX;
			cy = _displayObject.mouseY;

			trace("mouse x, y:", cx, cy);
			drawable = true;
			
		}


		private function onMouseUp(evt:MouseEvent):void {
			
			trace("mouseUp");
			drawable = false;
			
		}

		private function onMouseMove(evt:MouseEvent):void {

			if(!drawable) return;

			snapWidth = _displayObject.mouseX - cx;
			snapHeight = _displayObject.mouseY - cy;

			redraw_hilite();

		}

		private function redraw_hilite():void {

			graphics.clear();
			graphics.beginFill(0xFFFFFF, .6);

			if(_selectionType == Highliter.SELECTION_RECTANGLE) {
				
				graphics.drawRect(cx, cy, snapWidth, snapHeight);
				
			} else {
				
				graphics.drawEllipse(cx, cy, snapWidth, snapHeight);
				
			}

			graphics.endFill();

			_blurFilter = new BlurFilter(_blur, _blur, BitmapFilterQuality.HIGH);
			filters = [_blurFilter];
		}

		public function clear():void {
			
			graphics.clear();
			_sprite.graphics.clear();
			
		}
	}

}