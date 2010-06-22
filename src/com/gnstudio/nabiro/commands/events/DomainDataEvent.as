package com.gnstudio.nabiro.commands.events
{
	import flash.events.Event;

	public class DomainDataEvent extends Event
	{
		
		public static const COMPLETE:String="onDomainComplete"
		
		private var _data:Object;
		
		public function DomainDataEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false,data:Object=null)
		{
			super(type, bubbles, cancelable);
			_data=data
		}
		
		
		public function get data():Object{
			return _data;
		}
		
		override public function clone():Event{
			return new DomainDataEvent(type,bubbles,cancelable,_data);
		}
		
	}
}