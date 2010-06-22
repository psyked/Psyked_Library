package com.gnstudio.nabiro.utilities.pico.events
{
	import flash.events.Event;

	public class PicoContainerEvent extends Event
	{
		
		public static const ADDING_COMPONENT:String = "addingTheComponent";
		public static const COMPONENT_EXIST:String = "componentExists";
		public static const MONITOR_ERROR:String = "componentMonitor";
		public static const MONITOR_REGISTERED:String = "componentMonitorRegistered";
		
		
		public var currentComponent:*;
		public var successful:Boolean;
		
		public function PicoContainerEvent(type:String, component:*, success:Boolean, bubbles:Boolean=false, cancelable:Boolean=false){
			
			super(type, bubbles, cancelable);
			
			currentComponent = component;
			successful = success;
		
		}
		
		public override function clone():Event {
			
			return new PicoContainerEvent(type, currentComponent, successful);
			
		}

		public override function toString():String {
			
			return formatToString("PicoContainerEvent", "type", "bubbles", 
									"cancelable", "eventPhase", "currentComponent", "successful");
									
		}	
		
	}
}