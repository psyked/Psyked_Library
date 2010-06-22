package com.gnstudio.nabiro.commands
{
	import com.gnstudio.nabiro.commands.events.DomainDataEvent;
	import com.gnstudio.nabiro.mvp.command.AbstractCommand;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;

	public class LoadDomainData extends AbstractCommand
	{
		
		private var _target:IEventDispatcher;
		private var _url:URLRequest;
		
		public function LoadDomainData(url:URLRequest, tg:IEventDispatcher)	{
			
			_url = url;
			_target = tg;			
			
		}
		
		override public function execute() :void {

           if ((_target == null) || (_url == null)) {

               onCommandFail("Cannot execute load command: "+ (!_target  ? " Targer not defined. " : "")  + (!_url ? " Url not speficied." : ""));
               return;

           }
            
           var loader:URLLoader = new URLLoader();
           loader.addEventListener(Event.COMPLETE, onResult);
           loader.addEventListener(IOErrorEvent.IO_ERROR, onResult);
           loader.dataFormat = dataFormat;
           
           loader.load(_url);

        }
        
        private function onResult(e:Event):void {

           e.target.removeEventListener(Event.COMPLETE, onResult);
           e.target.removeEventListener(IOErrorEvent.IO_ERROR, onResult);

           switch (e.type) {

               case Event.COMPLETE:
                   onCommandComplete(e.target.data);
                   break;

               case IOErrorEvent.IO_ERROR:
                   onCommandFail((e as IOErrorEvent).text);
                   break;
                    
           }
            
       }
       override protected function onCommandComplete(params:* = null):void{
         	
         	var e:DomainDataEvent = new DomainDataEvent(DomainDataEvent.COMPLETE,true,true,params);         	
  			_target.dispatchEvent(e);
        
       }
       
       override protected function onCommandFail(errorMessage:String=null):void{
       		
       		_target.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, true, true, errorMessage));
       	
       }
        
       // ------- getters and setters -------
       public function set url(value:URLRequest) :void {
        	
           _url = value;
            
       }
        
       public function get url():URLRequest {
        	
           return _url;
            
       }

       public function set target(value:IEventDispatcher) :void {
        	
           _target = value;
            
       }

       public function get target():IEventDispatcher{
            
           return _target;
            
       }
       
       private var _dataFormat:String = URLLoaderDataFormat.VARIABLES;
       public function set dataFormat(value:String):void{
       	
       		_dataFormat = value;
       	
       }
       
        public function get dataFormat():String{
       	
       		return _dataFormat;
       	
       }
		
	}
}