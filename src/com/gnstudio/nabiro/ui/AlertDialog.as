package com.gnstudio.nabiro.ui
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
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.Button;
	import mx.controls.HRule;
	import mx.controls.Label;
	import mx.controls.VRule;
	import mx.core.UITextField;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.managers.IFocusManagerComponent;
	import mx.managers.PopUpManager;
	
	/** The amount of space, in pixels, between invidual items */
	[Style(name="dialogFont", type="String", inherit="no")]
	/** The amount of padding in all the directions in pixels */
	[Style(name="dialogColor", type="Number", inherit="no")]	
	
	/** The amount of space, in pixels, between invidual items */
	[Style(name="dialogFontSize", type="Number", inherit="no")]
	/** The amount of padding in all the directions in pixels */
	[Style(name="dialogFontWeight", type="Number", inherit="no")]	
	
	public class AlertDialog extends VBox{
		
		// =======================================================================
		// PADDING BOTTOM
		// =======================================================================
		private function get paddingBottomWidthDefault():Number {
			
			var result:Number = getStyle("paddingBottom");
			
			if(isNaN(result)){
				
				result = 10;
				
			}
				
			return result;
			
		}
		
		// =======================================================================
		// PADDING LEFT
		// =======================================================================
		private function get paddingLeftWidthDefault():Number {
			
			var result:Number = getStyle("paddingLeft");
			
			if(isNaN(result)){
				
				result = 10;
				
			}
				
			return result;
			
		}
		
		// =======================================================================
		// PADDING RIGHT
		// =======================================================================
		private function get paddingRightWidthDefault():Number {
			
			var result:Number = getStyle("paddingRight");
			
			if(isNaN(result)){
				
				result = 10;
				
			}
				
			return result;
			
		}
		
		// =======================================================================
		// PADDING TOP
		// =======================================================================
		private function get paddingTopWidthDefault():Number {
			
			var result:Number = getStyle("paddingTop");
			
			if(isNaN(result)){
				
				result = 10;
				
			}
				
			return result;
			
		}
		
		// =======================================================================
		// BACKGROUND COLOR
		// =======================================================================
		private function get backgroundWidthDefault():Number {
			
			var result:Number = getStyle("backgroundColor");
			
			if(isNaN(result)){
				
				result = BACK_GROUND_COLOR;
				
			}
				
			return result;
			
		}
		
		// =======================================================================
		// BORDER COLOR
		// =======================================================================
		private function get borderColorWidthDefault():Number {
			
			var result:Number = getStyle("borderColor");
			
			if(isNaN(result)){
				
				result = BORDER_COLOR;
				
			}
				
			return result;
			
		}
		
		// =======================================================================
		// BORDER STYLE
		// =======================================================================
		private function get borderStyleWidthDefault():String {
			
			var result:String = getStyle("borderStyle");
			
			if(!result){
				
				result = BORDER_STYLE;
				
			}
				
			return result;
			
		}
		
		// =======================================================================
		// BORDER TICKNESS
		// =======================================================================
		private function get borderTicknessWidthDefault():Number {
			
			var result:Number = getStyle("borderColor");
			
			if(isNaN(result)){
				
				result = BORDER_TICKNESS;
				
			}
				
			return result;
			
		}
		
		// =======================================================================
		// 	BACKGROUND ALPHA
		// =======================================================================
		private function get backgroundAlphaWidthDefault():Number {
			
			var result:Number = getStyle("backgroundAlpha");
			
			if(isNaN(result)){
				
				result = BORDER_TICKNESS;
				
			}
				
			return result;
			
		}
		
		
		
		
		// =======================================================================
		// DIALOG COLOR
		// =======================================================================
		private function get dialogColorWidthDefault():Number {
			
			var result:Number = getStyle("dialogColor");
			
			if(isNaN(result)){
				
				result = DIALOG_COLOR;
				
			}
				
			return result;
			
		}
		
		// =======================================================================
		// DIALOG FONT SIZE
		// =======================================================================
		private function get dialogFontSizeWithDefault():Number {
			
			var result:Number;
			
			result = getStyle("dialogFontSize");
			
			if(isNaN(result)){
				
				result = getStyle("fontSize");
				
			} 
			
			if(isNaN(result)){
				
				result = DIALOG_FONT_SIZE;
				
			}
				
			return result;
			
		}
		
		// =======================================================================
		// DIALOG FONT FAMILY
		// =======================================================================
		private function get dialogFontFamilyWidthDefault():String {
			
			var result:String = getStyle("dialogFont");
			
			if(!result){
				
				result = DIALOG_FONT_FAMILY;
				
			}
				
			return result;
			
		}
		
		// =======================================================================
		// DIALOG FONT WEIGHT
		// =======================================================================
		private function get dialogFontWeightWidthDefault():String {
			
			var result:String = getStyle("dialogFontWeight");
			
			if(!result){
				
				result = DIALOG_FONT_WEIGHT;
				
			}
				
			return result;
			
		}


		/** Constants used as default values when the component is not styled */
		private const BACK_GROUND_COLOR:uint = 0xffffff;
		private const BORDER_COLOR:uint = 0xC4CCCC;
		private const BORDER_STYLE:String = "solid";
		private const BORDER_TICKNESS:Number = 2;
		
		private const DIALOG_COLOR:uint= 0x000000;
		private const DIALOG_FONT_SIZE:int = 14;
		private const DIALOG_FONT_FAMILY:String = "Arial";		
		private const DIALOG_FONT_WEIGHT:String = "bold";
		
		//----------------------------------------------------------------------
        //
        //  Constants
        //
        //----------------------------------------------------------------------
        
        /**
         * Value for YES button.
         */  
        public static const YES:uint = 0x0001;
        
        /**
         * Value for NO button.
         */
        public static const NO:uint = 0x0002;
        
        /**
         *  Value for OPEN button.
         */
        public static const OK:uint= 0x0004;            

	    /**
	     *  Value for CANCEL button.
	     */
        public static const CANCEL:uint= 0x0008;            

        //----------------------------------------------------------------------
        //
        //  Class variables
        //
        //----------------------------------------------------------------------
		
		/**
		 * Used to handle the display list changes
		 */
		 private var textIsDirty:Boolean;
		 
		 /**
		  * Used to store the text valeu
		  */
		 private var textValue:String;
		
		/**
		 * Used to display a text inside the dialog.
		 */
		private var _text:String = "";

		/**
		 * The bitmask used to configure which buttons have to be displayed. 
		 */
		public var buttonFlags:uint = OK;
		
		/**
		 * The button width; it may be adjusted in case labels change.
		 */
		public var buttonWidth:Number = 75;
		
		/**
		 * Used to bind with a close handler function.
		 */
		[Bindable] private var _closeHandler:Function = null;
		
		/**
		 * Used to indicate which button has focus by default.
		 * Default value is CANCEL.
		 */
		public var defaultFocus:uint = CANCEL; 
		
		/**
		 * Buttons container
		 */
		 private var buttonBox:HBox; 
		 
		/**
		 * Label
		 */
		 private var alertLabel:Label;  
		 
		/**
		 * Alert text
		 */
		 private var alertText:UITextField; 

		/**
		 * Control for YES button.
		 */
		private var _btYes:Button;
		
		/**
		 * Control for NO button.
		 */
		private var _btNo:Button;

		/**
		 * Control for OK button.
		 */
		private var _btOk:Button;

		/**
		 * Control for CANCEL button.
		 */
		private var _btCancel:Button;
		
		private var heightIsDirty:Boolean;
        private var neededHeight:Number;
		
		// **************************************************
		// ******************* CONSTRUCTOR ******************
		// **************************************************
		
		public function AlertDialog(){
			
			super();
			
			this.setStyle("backgroundColor", this.backgroundWidthDefault);
			this.setStyle("borderColor", this.borderColorWidthDefault);
			this.setStyle("borderStyle", this.borderStyleWidthDefault);
			this.setStyle("borderThickness", this.borderTicknessWidthDefault);
			
			this.setStyle("paddingBottom", this.paddingBottomWidthDefault);
			this.setStyle("paddingLeft", this.paddingLeftWidthDefault);
			this.setStyle("paddingRight", this.paddingRightWidthDefault);
			this.setStyle("paddingTop", this.paddingTopWidthDefault);  			
			
			this.setStyle("backgroundAlpha", this.backgroundAlphaWidthDefault);
			
			this.verticalScrollPolicy = "none";
			this.horizontalScrollPolicy = "none";
			
			this.addEventListener(FlexEvent.PREINITIALIZE, onInitialize);
			this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			
			this.width = 320;
			
		}
		
		override public function set label(value:String):void{
			
			super.label = value;
			
			if(alertLabel){
				
				alertLabel.text = value;
			
			}			
     
    	}
		
		// Override the styleChanged() method to detect changes in your new style.
        override public function styleChanged(styleProp:String):void {

            super.styleChanged(styleProp);

            // Check to see if style changed. 
            if (styleProp == "dialogFont" || styleProp == "dialogColor" || styleProp == "dialogFontSize" || 
            	styleProp == "paddingBottom" || styleProp == "paddingLeft" || styleProp == "paddingLeft" ||
            	styleProp == "horizontalGap" || styleProp == "backgroundAlpha" ||
            	styleProp == "paddingTop" || styleProp == "dialogFontWeight") {
              
                invalidateDisplayList();
                return;
                                
            }
     
        }
        
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
        	
        	super.updateDisplayList(unscaledWidth, unscaledHeight);
        	        	        	
        	if(textIsDirty){
        		
        		textIsDirty = false;
        		
        		if(alertText){
        			
        			if(_html){
        		
	        			alertText.htmlText = textValue;
	        		
	        		}else{
	        		
	        			alertText.text = textValue;
	        			
	        			var myFormat:TextFormat = new TextFormat();
						myFormat.size = dialogFontSizeWithDefault;
						myFormat.font = dialogFontFamilyWidthDefault,
	        			
	        			alertText.validateNow();
						alertText.setTextFormat(myFormat);
	        		
	        		}
	        		
	        		alertText.validateNow()
	        		
        			this.callLater(updateHeight, [alertText.numLines]);
        			
        		}else{
        			
        			textIsDirty = true;
        			
        		}
        		
        	}
        	
        	if(heightIsDirty){
        		
        		heightIsDirty = false;
        		
        	//	trace("neededHeight", neededHeight)
        		
        		this.height += this.neededHeight;
        		this.invalidateDisplayList()
        		
        		
        	}
        	
        	
        }
        
        private var _html:Boolean = false;
        
        public function get html():Boolean{
        	
        	return _html;
        	
        }
        
        public function set html(value:Boolean):void{
        	
        	_html = value;
        	
        }
        
        [Bindable]
        public function get text():String{
        	
        	return _text;
        	
        }
        
        public function set text(value:String):void{
        	
        	if(alertText){
        		
        		if(_html){
        		
        			alertText.htmlText = value;
        		
        		}else{
        		
        			alertText.text = value;
        		
        		}
        		
        		updateHeight(alertText.numLines);
        		
        	}else{
        		
        		textValue = value;
        		
        		textIsDirty = true;
        		
        		invalidateDisplayList();
        		
        	}
        	
        }
        
        private function updateHeight(lines:int):void{
        	
        	trace(lines * dialogFontSizeWithDefault, alertText.height, lines);
        	
        	if(lines * dialogFontSizeWithDefault != alertText.height){
        		
        		heightIsDirty = true;
        		
        		neededHeight = (lines * dialogFontSizeWithDefault) + (lines * (int(alertText.getTextFormat().leading)) * 2) -  alertText.height;
        		
        		invalidateDisplayList();
        		
        	}
        	
        	
        	
        }
		
		/**
		 * Init some visual aspects.
		 */
		private function onCreationComplete(e:FlexEvent):void {
			
			e.target.removeEventListener(e.type, arguments.callee);
			
			alertLabel = new Label();
			alertLabel.setStyle("fontWeight", this.dialogFontWeightWidthDefault);
			
			addChild(alertLabel);
			
			if(label){
				
				alertLabel.text = label;
				
			}
			
			var hrule:HRule = new HRule();
			hrule.percentWidth = 100;
			
			addChild(hrule);
			
			buttonBox = new HBox();
			buttonBox.percentWidth = 100;
			buttonBox.setStyle("horizontalAlign", "right");
			buttonBox.explicitHeight = 24
			
			alertText = new UITextField();
			alertText.multiline = true;
			alertText.wordWrap = true;
			
			alertText.explicitWidth = this.width - this.paddingLeftWidthDefault - this.paddingRightWidthDefault;
			alertText.percentHeight = 100
			alertText.truncateToFit("...");
			
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = dialogFontSizeWithDefault;
			myFormat.font = dialogFontFamilyWidthDefault,
	        			
	        alertText.validateNow();
			alertText.setTextFormat(myFormat);
					
			if(text){
				
				alertText.text = text;
				
			}
			
			addChild(alertText);
			
			var vr:VRule;
			
            // add buttons
            if (buttonFlags & YES){
            	
            	trace("YES");
            	_btYes = new Button();
            	_btYes.label = yesLabel;
            	_btYes.width = buttonWidth;
            	_btYes.setStyle("padding-left", 0);
            	_btYes.setStyle("padding-right", 0);
            	
            	_btYes.addEventListener(MouseEvent.CLICK, onYes);
            	
            	buttonBox.addChild(_btYes);
            	
            }
            
            if (buttonFlags & NO) {
            	
            	trace("NO");
            	_btNo = new Button();
            	_btNo.label = noLabel;
            	_btNo.width = buttonWidth;
            	_btNo.setStyle("padding-left", 0);
            	_btNo.setStyle("padding-right", 0);
            	
            	_btNo.addEventListener(MouseEvent.CLICK, onNo);
            	
            	// if YES is visible, add a vertical rule
            	if (buttonFlags & YES){
            		
            		vr = new VRule();
            		vr.percentHeight = 100;
            		buttonBox.addChild(vr);
            		
            	}
            	
            	buttonBox.addChild(_btNo);
            	
            }
            
            if (buttonFlags & OK) {
            	
            	trace("OK");
            	
            	_btOk = new Button();
            	_btOk.label = okLabel;
            	_btOk.width = buttonWidth;
            	_btOk.setStyle("padding-left", 0);
            	_btOk.setStyle("padding-right", 0);
            	
            	_btOk.addEventListener(MouseEvent.CLICK, onOk);
            	
            	buttonBox.addChild(_btOk);
            	
            }
            
            if (buttonFlags & CANCEL){
            	
            	trace("CANCEL");
            	_btCancel = new Button();
            	_btCancel.label = cancelLabel;
            	_btCancel.width = buttonWidth;
            	_btCancel.setStyle("padding-left", 0);
            	_btCancel.setStyle("padding-right", 0);
            	
            	_btCancel.addEventListener(MouseEvent.CLICK, onCancel);
            	
            	// if OK is visible, add a vertical rule
            	if (buttonFlags & OK){
            		
            		vr = new VRule();
            		vr.percentHeight = 100;
            		buttonBox.addChild(vr);
            		
            	}

            	buttonBox.addChild(_btCancel);
            	
            }
            
            // center the popup
            PopUpManager.centerPopUp(this);
            
            // get focus on this window
            this.setFocus();

            // set default focus	
            if (defaultFocus == YES && _btYes != null){
            	
            	focusManager.setFocus(_btYes);
            	
            }else if (defaultFocus == NO && _btNo != null){
            	
            	focusManager.setFocus(_btNo);
            	
            }else if (defaultFocus == OK && _btOk != null){
            	
            	focusManager.setFocus(_btOk);
            	
            }else if (defaultFocus == CANCEL && _btCancel != null){
            	
            	focusManager.setFocus(_btCancel);
            	
            }
            
            focusManager.showFocus();

            // listen to key pressing
            addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
            
            addChild(buttonBox);
            
            PopUpManager.centerPopUp(this);
            
		}
		
		private function onInitialize(e:FlexEvent):void {
			
			e.target.removeEventListener(e.type, arguments.callee);
			
			yesLabel = resourceManager.getString("IB", "alert.yesLabel") || this.yesLabel;
			noLabel = resourceManager.getString("IB", "alert.noLabel") || this.noLabel;
			okLabel = resourceManager.getString("IB", "alert.okLabel") || this.okLabel;
			cancelLabel = resourceManager.getString("IB", "alert.cancelLabel") || this.cancelLabel;
			
			stage.addEventListener(Event.RESIZE, onResize);
			
			/* this.addEventListener(Event.REMOVED_FROM_STAGE, function(evt:Event):void{
				
				textIsDirty = false;
				
			}); */
		} 
		
		/**
         * @private
         */ 
        public function set closeHandler(value:Function):void 
        {
        	_closeHandler = value;
        	if (_closeHandler != null)
        	{
        		addEventListener(CloseEvent.CLOSE, _closeHandler);
        	}
        }
		
		/**
		 * Handle stage resizing to center this dialog.
		 */
		private function onResize(event:Event):void	{
			
			PopUpManager.centerPopUp(this);
			
		}
		
		/**
		 * Handle key press.
		 * If the user presses ESC key, invoke a cancel/close operation.
		 */
		private function onKeyUp(event:KeyboardEvent):void {
			
			if (Keyboard.ESCAPE == event.keyCode) {
				
				onCancel(null);
				
			}else if (Keyboard.SPACE == event.keyCode || Keyboard.ENTER == event.keyCode) {
				
				var comp:IFocusManagerComponent = focusManager.getFocus();

				if (comp == _btCancel){
					
					onCancel(null);
					
				}else if (comp == _btOk){
					
					onOk(null);
					
				}
			}
		}
		
		/**
         * Called on 'Yes'
         */ 
        private function onYes(event:MouseEvent):void {
        	
        	dispatchEvent(new CloseEvent(CloseEvent.CLOSE, false, false, YES));
        	closeDialog();
        	
        }

        /**
         * Called on 'No'
         */ 
        private function onNo(event:MouseEvent):void {
        	
        	dispatchEvent(new CloseEvent(CloseEvent.CLOSE, false, false, NO));
        	closeDialog();
        	
        }

        /**
         * Called on 'Ok'
         */ 
        private function onOk(event:MouseEvent):void {
        	
        	dispatchEvent(new CloseEvent(CloseEvent.CLOSE, false, false, OK));
        	closeDialog();
        	
        }
        
        /**
         * Called on 'Cancel'
         */ 
        private function onCancel(event:MouseEvent):void {
        	
        	dispatchEvent(new CloseEvent(CloseEvent.CLOSE, false, false, CANCEL));
        	closeDialog();
        	
        }
        
        //----------------------------------
	    //  yesLabel
	    //----------------------------------	

		/**
		 * Used to store the YES label.
		 */
		private var _yesLabel:String = "Yes";
		
		/**
		 * @private
		 */
		public function get yesLabel():String
		{
			return _yesLabel; 
		}  
		
		public function set yesLabel(value:String):void
		{
			_yesLabel = value != null 
						? value 
						: resourceManager.getString("IB", "alert.yesLabel");			
		}
		
	    //----------------------------------
	    //  noLabel
	    //----------------------------------	

		/**
		 * Used to store the NO label.
		 */
		private var _noLabel:String = "NO";
		
		/**
		 * @private
		 */
		public function get noLabel():String
		{
			return _noLabel; 
		}  
		
		public function set noLabel(value:String):void
		{
			_noLabel = value != null 
						? value 
						: resourceManager.getString("IB", "alert.noLabel");			
		}
		
	    //----------------------------------
	    //  okLabel
	    //----------------------------------	

		/**
		 * Used to store the OK label.
		 */
		private var _okLabel:String= "OK";
		
		/**
		 * @private
		 */
		public function get okLabel():String
		{
			return _okLabel; 
		}  
		
		public function set okLabel(value:String):void
		{
			_okLabel = value != null 
						? value 
						: resourceManager.getString("IB", "alert.okLabel");			
		}

	    //----------------------------------
	    //  cancelLabel
	    //----------------------------------	

		/**
		 * Used to store the CANCEL label.
		 */
		private var _cancelLabel:String = "Cancel";
		
		/**
		 * @private
		 */
		public function get cancelLabel():String
		{
			return _cancelLabel; 
		}  
		
		public function set cancelLabel(value:String):void
		{
			_cancelLabel = value != null 
						? value 
						: resourceManager.getString("IB", "alert.cancelLabel");			
		}

        
        //----------------------------------------------------------------------
        //
        //  Other methods
        //
        //----------------------------------------------------------------------
        
        /**
         * Close the dialog window and free unused resources.
         */ 
        private function closeDialog():void
        {
        	removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
            PopUpManager.removePopUp(this);
        }
		
	}
}