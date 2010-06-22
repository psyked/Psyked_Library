package com.gnstudio.nabiro.connectivity.amf.utils
{
	import com.gnstudio.nabiro.connectivity.amf.events.RemoteObjectWrapperEvent;
	import com.gnstudio.nabiro.mvp.core.Exception;
	import com.gnstudio.nabiro.mvp.core.IView;
	import com.gnstudio.nabiro.mvp.core.PresenterChangeDetector;
	import com.gnstudio.nabiro.mvp.mapper.Mapper;
	import com.gnstudio.nabiro.utilities.HashMap;
	
	import flash.utils.describeType;
	
	public class ServiceConnectorHelper
	{
		
		private var _hash:HashMap;
		private var _hashKey:String;
		private var _mapper:Mapper;
		
		public function ServiceConnectorHelper(hash:HashMap, hashKey:String, mapper:Mapper){
		
			_hash = hash;
			_hashKey = hashKey;
			_mapper = mapper;
		
		}
		
		public function processFault(e:RemoteObjectWrapperEvent):void{

			trace("fault", e)

			if(_hash.getItem(_hashKey, e.currentService)){
				
				var tg:*;

			   	tg = _hash.getItem(_hashKey, e.currentService).target as IView;
			     
			   	var ns:Namespace;

			   	if(_hash.getItem(_hashKey, e.currentService).nameSpace){

			     	ns = _hash.getItem(_hashKey, e.currentService).nameSpace;

			   	}

			   	var watcher:PresenterChangeDetector = (_mapper.getCurrentWatcher(_hash.getItem(_hashKey, e.currentService).target));
			   	
			   	// TODO handle the exceptions
			   	var exception:Exception = new Exception(e.currentService.toString())

				watcher.notifyError(e.eventData, exception, ns);

			   	_hash.remove(_hashKey, e.currentService);

		   }

		}

		
		public function processResults(e:RemoteObjectWrapperEvent):void{

			if(_hash.getItem(_hashKey, e.currentService)){
								
				var ns:Namespace;
				
				if(_hash.getItem(_hashKey, e.currentService).nameSpace){
					
					ns = _hash.getItem(_hashKey, e.currentService).nameSpace;
					
				}
						
				if(describeType(e.eventData).@base == "Object" || describeType(e.eventData).@base == "mx.collections::ListCollectionView"){
					
					var tg:*;
					tg = _hash.getItem(_hashKey, e.currentService).target as IView;
																					
					_mapper.getCurrentWatcher(_hash.getItem(_hashKey, e.currentService).target).checkData(e.eventData, ns);
						
				}else{
					
					var watcher:PresenterChangeDetector = (_mapper.getCurrentWatcher(_hash.getItem(_hashKey, e.currentService).target as IView))
					watcher.checkData(e.eventData, ns);
					
				}
								
				_hash.remove(_hashKey, e.currentService);
				
			}
			
		}


	}
}