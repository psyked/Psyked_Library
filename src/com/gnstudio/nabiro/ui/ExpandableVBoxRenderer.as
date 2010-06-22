package com.gnstudio.nabiro.ui
{
	import mx.containers.VBox;
	import mx.controls.listClasses.BaseListData;
	import mx.controls.listClasses.IDropInListItemRenderer;
	import mx.core.ScrollPolicy;
	import mx.events.FlexEvent;
	import mx.events.StateChangeEvent;

	public class ExpandableVBoxRenderer extends VBox implements IDropInListItemRenderer, ISmartRenderer{		
				 		 
		/**
	     *  @private
	     *  Storage for the listData property, used in order to recover
	     * data directly from the list
	     */
	      private var _listData:BaseListData;
	    
	    [Bindable("dataChange")]
	     public function get listData():BaseListData{
	     	
        	return _listData;
    	
    	}

	    /**
	     *  @private
	     */
	    public function set listData(value:BaseListData):void{
	    	
	        _listData = value;
	        
	    }
	    
	    /**
	     * Handle the clicked status of an item renderer
	     */
	    
	    private var _clicked:Boolean;
	    
	    public function set clicked(value:Boolean):void{
	    	
	    	_clicked = value;
	    	
	    } 
	    
	    public function get clicked():Boolean{
	    	
	    	return _clicked;
	    	
	    } 
	 
		public function ExpandableVBoxRenderer(){
			
			super();			
			
			this.addEventListener(StateChangeEvent.CURRENT_STATE_CHANGE, onStateChange);			
			this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			
			this.verticalScrollPolicy = ScrollPolicy.OFF;
			this.horizontalScrollPolicy = ScrollPolicy.OFF;
							
		}
		
		protected function onCreationComplete(e:FlexEvent):void{
			
			
			
		}
		
		protected function onStateChange(e:StateChangeEvent):void{
			
			invalidateProperties();			
				
		}		
						
		protected function recoverHeight(state:String):Number{
			
			throw(new Error("Override the recoverHeight method in order to recover the right height"));
			
		}
		
		override protected function commitProperties():void{
			
			super.commitProperties();
			
			if(!data)return;
			
			populateControl(data.renderData)
			
		}
		
		public function updateState(state:String):void{
			
			currentState = state;
			height = recoverHeight(currentState);
			measure();
			
		}
		
		protected function populateControl(data:Object):void{
			
			throw(new Error("Override the populateControl method in order to render the data"));
			
		}
		
		override protected function measure():void{
			
			super.measure();
            
            if(!data)return;
            
            
            var currentHeight:Number = recoverHeight(currentState || "");
                        
            measuredHeight = currentHeight;
			measuredMinHeight = currentHeight;
			  
			if (listData && listData.owner is VariableRowList)
				VariableRowList(listData.owner).invalidateList();
			
	//		(listData.owner as VariableRowList).invalidateList();
			
		}
		
		override public function set data(value:Object):void{
			
			super.data = value;
						
			if(!data || !visible)return;		
			
			// data.state = currentState;
			
			updateState(value.state);
			
			populateControl(data.renderData);
			invalidateProperties();
			
			dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE)); 
			
		}
		
	}
}