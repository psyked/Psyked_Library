/**
 * @author jaco
 */
package com.gnstudio.nabiro.ui.offsetduoslider.view {

	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;

	import mx.core.UIComponent;
	import mx.styles.StyleManager;
	import mx.styles.CSSStyleDeclaration;

	import com.gnstudio.nabiro.ui.offsetduoslider.presenter.OffsetDuoSlider;

	//--------------------------------------
	//  Styles
	//--------------------------------------

	/**
	 *  minimum
	 *
	 *  @default 0
	 */
	[Style(name="minimum", type="int", format="Number", inherit="no")]


	/**
	 *  maximum
	 *
	 *  @default 0xFF
	 */
	[Style(name="maximum", type="int", format="Number", inherit="no")]

	/**
	 *  offsetStart
	 *
	 *  @default 0
	 */
	[Style(name="offsetStart", type="Number", format="Number", inherit="no")]


	/**
	 *  offsetEnd
	 *
	 *  @default 1
	 */
	[Style(name="offsetEnd", type="Number", format="Number", inherit="no")]

	/**
	 *  decimals, useful to round valued or limit the digits when values are float
	 *
	 *  @default 1
	 */
	[Style(name="decimals", type="Number", format="Number", inherit="no")]


	/**
	 *  colorStart
	 *
	 *  @default 0
	 */
	[Style(name="colorStart", type="uint", format="Color", inherit="no")]

	/**
	 *  colorEnd
	 *
	 *  @default 0XFFFFFF
	 */
	[Style(name="colorEnd", type="uint", format="Color", inherit="no")]


	// STYLED EVENTS

	/**
	 * change event
	 */
	[Event(name="change", type="flash.events.Event")]


	/**
	 *
	 */
	public class OffsetDuoSliderControl extends UIComponent implements IOffsetDuoSlider {

		import flash.events.Event;

		private static const MOUSE_OUT_DELAY:int = 20;


		/**
		 * @private
		 * static styles initializer
		 */
		private static var osdsStylesInitialized:Boolean = initializeStyles();

		/**
		 * @private
		 * array of styles that component can accept
		 */
		private static var styles:Array = ["maximum",
											"minimum",
											"offsetEnd",
											"offsetStart",
											"decimals",
											"colorEnd",
											"colorStart"];


		/**
		 * @private
		 * name of the changing style property
		 * @default false
		 */
		private var _propertyStyleChangeName:String = "";


		private var _presenter:OffsetDuoSlider;

		private var _bck:SliderBackground;
		private var _cursorLeft:SlideCursor;
		private var _cursorRight:SlideCursor;

		private var _draggingCursor:SlideCursor;
		private var _dragController:MovieClip;

		private var _checkDelay:int = OffsetDuoSliderControl.MOUSE_OUT_DELAY;
		private var mouseOffsetX:int;


		/**
		 * @private
		 *
		 */
		private var _minimum:Number = 0;

		/**
		 * @private
		 *
		 */
		private var _maximum:Number = 1;

		/**
		 * @private
		 *
		 */
		private var _offsetStart:Number = 0;

		/**
		 * @private
		 *
		 */
		private var _offsetEnd:Number = 1;

		/**
		 * @private
		 * @default 2
		 */
		private var _decimals:uint = 2;

		/**
		 * @private
		 * used internally to check if there are changes
		 */
		private var _oldOffsetStart:Number = 0;

		/**
		 * @private
		 * used internally to check if there are changes
		 */
		private var _oldOffsetEnd:Number = 0;

		/**
		 * @private
		 */
		private var _colorStart:uint = 0x0;

		/**
		 * @private
		 *
		 */
		private var _colorEnd:uint = 0xFFFFFF;

		/**
		 *
		 */
		[Bindable]
		public function get minimum():Number { 	return _minimum; }
		public function set minimum(v:Number):void {

			// if(v > _maximum){
			//	throw new Error("error: cannot set minimum greater than maximum");
			//}

			_minimum = v;
		}

		/**
		 *
		 */
		[Bindable]
		public function get maximum():Number { 	return _maximum; }
		public function set maximum(v:Number):void {

			//if(v < _minimum){
			//	throw new Error("error: cannot set maximum smaller than minimum");
			//}

			_maximum = v;
		}

		/**
		 *
		 */
		[Bindable]
		public function get offsetStart():Number { 	return _offsetStart; }
		public function set offsetStart(v:Number):void {

			if(_offsetStart < _minimum) {
				throw new Error("out of range: offsetStart cannot be smaller than minimum");
			}

			_offsetStart = v;
			invalidateDisplayList();
		}

		/**
		 *
		 */
		[Bindable]
		public function get offsetEnd():Number { return _offsetEnd; }
		public function set offsetEnd(v:Number):void {

			if(_offsetEnd > _maximum) {
				throw new Error("out of range: offsetEnd cannot be greater than maximum");
			}

			_offsetEnd = v;
			invalidateDisplayList();
		}

		/**
		 *
		 */
		[Bindable]
		public function get decimals():uint { return _decimals; }
		public function set decimals(v:uint):void { _decimals = v; }

		/**
		 *
		 */
		[Bindable]
		public function get colorStart():uint { 	return _colorStart; }
		public function set colorStart(v:uint):void {

			_colorStart = v;
			// redraw_ui();
		}

		/**
		 *
		 */
		[Bindable]
		public function get colorEnd():uint { return _colorEnd; }
		public function set colorEnd(v:uint):void {

			_colorEnd = v;
			// redraw_ui();
		}

		/**
		 * the constructor
		 */
		function OffsetDuoSliderControl() {
			/* NOP */
		}

		/**
		 *
		 */
		override protected function childrenCreated():void {

			super.childrenCreated();

			_presenter = new OffsetDuoSlider(this);

			_bck = new SliderBackground();
			_cursorLeft = new SlideCursor(width, height);
			_cursorRight = new SlideCursor(width, height, SlideCursor.TYPE_RIGHT);

			_cursorLeft.name = name +"_cursorLeft";
			_cursorRight.name = name +"_cursorRight";

			_cursorLeft.x = -5;
			_cursorRight.x = width;

			addChild(_bck);
			addChild(_cursorLeft);
			addChild(_cursorRight);

			_dragController = new MovieClip();

			_cursorLeft.hitTestArea.addEventListener(MouseEvent.MOUSE_OVER, onCursorMouseOver);
			_cursorLeft.hitTestArea.addEventListener(MouseEvent.MOUSE_OUT, onCursorMouseOut);
			_cursorLeft.hitTestArea.addEventListener(MouseEvent.MOUSE_DOWN, onCursorMouseDown);
			_cursorLeft.hitTestArea.addEventListener(MouseEvent.MOUSE_UP, onCursorMouseUp);

			_cursorRight.hitTestArea.addEventListener(MouseEvent.MOUSE_OVER, onCursorMouseOver);
			_cursorRight.hitTestArea.addEventListener(MouseEvent.MOUSE_OUT, onCursorMouseOut);
			_cursorRight.hitTestArea.addEventListener(MouseEvent.MOUSE_DOWN, onCursorMouseDown);
			_cursorRight.hitTestArea.addEventListener(MouseEvent.MOUSE_UP, onCursorMouseUp);
		}

		/**
		 * @private
		 * initialize css styles, TODO: complete
		 * @return
		 */
		private static function initializeStyles():Boolean {

			if(!StyleManager.getStyleDeclaration("OffsetDuoSliderControl")) {

				var osdsStyles:CSSStyleDeclaration = new CSSStyleDeclaration();

				osdsStyles.defaultFactory = function():void {

					this.minimum = 0;
					this.maximum = 1;
					this.decimals = 2;
					this.colorStart = 0x0;
					this.colorEnd = 0xFF;
                }

				// FIXME hog the flash player, must be investigated, so it's disabled
				StyleManager.setStyleDeclaration("OffsetDuoSliderControl", osdsStyles, true);
            }

			return true;
        }

		/**
		 * intercept style assign, check if style is in list and provides to apply
		 * @param property style name to change
		 * @return
		 */
		public override function styleChanged(styleProp:String):void {

			super.styleChanged(styleProp);

			if(styleProp && styles.indexOf(styleProp) > -1){

		    	_propertyStyleChangeName = styleProp;
		    	invalidateDisplayList();
		    }
		}

		/**
		 *
		 */
		override protected function measure():void{

			super.measure();

			measuredMinWidth = 100;
			measuredMinHeight = 30;
		}

		/**
		 *
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{

			super.updateDisplayList(unscaledWidth, unscaledHeight);

			_bck.sbWidth = unscaledWidth;
			_bck.sbHeight = unscaledHeight - 12;
			_bck.y = 6;

			redraw_ui();
		}

		/**
		 *
		 */
		private function get_sideName(completeSideName:String):String {
			return completeSideName.substring(completeSideName.lastIndexOf("_"));
		}


		/**
		 *
		 */
		private function onCursorMouseOver(evt:MouseEvent):void {

			_cursorLeft.vLine.visible = _cursorRight.vLine.visible = true;
		}

		/**
		 *
		 */
		private function onCursorMouseOut(evt:MouseEvent):void {

			if(!_dragController.hasEventListener(Event.ENTER_FRAME))
				_cursorLeft.vLine.visible = _cursorRight.vLine.visible = false;
		}

		/**
		 *
		 */
		private function onCursorMouseDown(evt:MouseEvent):void {

			_oldOffsetStart = offsetStart;
			_oldOffsetEnd = offsetEnd;

			_draggingCursor = this[get_sideName(evt.target.parent.name)];
			mouseOffsetX = _draggingCursor.mouseX;

			if(!_dragController.hasEventListener(Event.ENTER_FRAME))
				_dragController.addEventListener(Event.ENTER_FRAME, onDragMove);

		}

		/**
		 *
		 */
		private function onCursorMouseUp(evt:MouseEvent):void {

			_draggingCursor = null;
			_cursorLeft.vLine.visible = _cursorRight.vLine.visible = false;

			if(_dragController.hasEventListener(Event.ENTER_FRAME))
				_dragController.removeEventListener(Event.ENTER_FRAME, onDragMove);

			if(hasEventListener(Event.CHANGE) && (_oldOffsetStart != offsetStart || _oldOffsetEnd != offsetEnd)){
				dispatchEvent(new Event(Event.CHANGE, true));
			}
		}

		/**
		 *
		 */
		private function onDragMove(evt:Event):void {

			var sideName:String = get_sideName(_draggingCursor.name);
			var miceX:int =  mouseX - mouseOffsetX;
			var oldX:int = _draggingCursor.x;

			if(sideName == "_cursorLeft"){

				_draggingCursor.x = Math.max(-5, miceX);
				_draggingCursor.x = Math.min(width - 5, _draggingCursor.x);

				_cursorRight.x = Math.max(_draggingCursor.x + 5, _cursorRight.x);

			}
			else {
				_draggingCursor.x = Math.max(0, miceX);
				_draggingCursor.x = Math.min(width, _draggingCursor.x);

				_cursorLeft.x = Math.min(_draggingCursor.x - 5, _cursorLeft.x);
			}

			if(oldX != _draggingCursor.x) update_offsets();

			if(_draggingCursor.mouseY > 0 && _draggingCursor.mouseY < height)
				_checkDelay = OffsetDuoSliderControl.MOUSE_OUT_DELAY;

			if(mouseX < -5 || mouseX > width + 5) onCursorMouseUp(null);
			if(--_checkDelay <= 0) onCursorMouseUp(null);
		}

		/**
		 *
		 */
		private function redraw_ui():void {

			if(_bck && width) {

				_bck.colorStart = _colorStart;
				_bck.colorEnd = _colorEnd;

				var stepX:Number = width / (_maximum - _minimum);

				_cursorLeft.x = Math.round((_offsetStart - _minimum) * stepX) - 5;
				_cursorRight.x = Math.round((_offsetEnd - _minimum) * stepX);

				update_offsets();
			}
		}

		/**
		 *
		 */
		private function update_offsets():void {

			var stepX:Number = 0xFF / width;

			_bck.offsetStart = Math.round((_cursorLeft.x + 5) * stepX);
			_bck.offsetEnd = Math.round(_cursorRight.x * stepX);

			stepX = (_maximum - _minimum) / width;

			var ofs:Number = _minimum + (_cursorLeft.x + 5) * stepX;
			var ofe:Number = _minimum + _cursorRight.x * stepX;
			var roundFactor:int = Math.pow(10, _decimals);

			_offsetStart = Math.round(ofs * roundFactor) / roundFactor;
			_offsetEnd = Math.round(ofe * roundFactor) / roundFactor;
		}
	}
}
