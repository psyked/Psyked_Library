package com.gnstudio.nabiro.ui

{

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilter;
	import flash.system.ApplicationDomain;
	
	import mx.controls.Button;
	
	public class IconButton extends Button {
		
		private var storedIcon:DisplayObject;
		
		public function IconButton(){
			
			super();
									
		}
		
		override public function set enabled(value:Boolean):void{
			
			super.enabled = value;
			
			if(value == false){
				
				if(_disabledFilter){
										
					filters = [_disabledFilter];
					
				}
				
			}else{
				
				if(filters.length > 0) filters = [];
				
			}
			
			buttonMode = value;
			useHandCursor = value;
			
		}
		
		override protected function childrenCreated():void{
			
			super.childrenCreated();
			
			this.addEventListener(MouseEvent.MOUSE_OVER, onApplyFilter);
			this.addEventListener(MouseEvent.MOUSE_OUT, onRemoverFilter);
			
		}
		
		protected function onRemoverFilter(e:MouseEvent):void{
			
			if(enabled){
			
				if(filters.length > 0) filters = [];
			
			}
			
		}
		
		protected  function onApplyFilter(e:MouseEvent):void{
			
			if(!enabled){
			
				return;
			
			}
			
			if(_overFilter)filters = [_overFilter]
			
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		
			if(!storedIcon){
			
				if(!getStyle("icon")){
					
					visible = false;
					
				}else{
			
					var p_content:* = getStyle("icon");
				
					if (p_content is String) {
					
					try {
						
							p_content = ApplicationDomain.currentDomain.getDefinition(p_content);
					
						} catch (e:*) {}
					
					}
				
					if (p_content is Class) {
					
						p_content = new p_content();
					
					}
				
					storedIcon = p_content as DisplayObject;
					
					width = storedIcon.width;
					height = storedIcon.height;
							
					setStyle("disabledSkin", getStyle("icon"));
					setStyle("downSkin", getStyle("icon"));
					setStyle("overSkin", getStyle("icon"));
					setStyle("upSkin", getStyle("icon"));
				
				}
			
			}
			
		}
		
		/****************************************
		 *********** ACCESSOR METHODS ***********
		 ****************************************/ 
		 
		 private var _overFilter:BitmapFilter;
		 
		 public function set overFilter(value:BitmapFilter):void{
		 	
		 	_overFilter = value;
		 	
		 }
		 
		 private var _disabledFilter:BitmapFilter;
		 
		 public function set disabledFilter(value:BitmapFilter):void{
		 	
		 	_disabledFilter = value;
		 	
		 }
		
	}
}