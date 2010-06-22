package com.gnstudio.nabiro.services.facebook.events
{
	
	import flash.events.Event;

	public class ErrorDataEvent extends Event
	{
		
		/**
		 * The event dispatched if the user hasn't added the application to his account
		 */
		public static const FACEBOOK_APP_NOT_INSTALLED:String = "airbookIsNotInstalled"; 
		
		private var _result:*;
		
		public function ErrorDataEvent(type:String, result:* = null, query:String = ""){
			
			super(type, false, false);
			
			_result = result;
			
		}
		
		public override function clone():Event {
			
			return new ErrorDataEvent(type, result);
			
		}

		public override function toString():String {
			
			return formatToString("ErrorDataEvent", "type", "bubbles", "cancelable", "eventPhase", "result");
									
		}	
		
		public function get result () : *{
			
			return _result;
		
		}
		
		
	}
}