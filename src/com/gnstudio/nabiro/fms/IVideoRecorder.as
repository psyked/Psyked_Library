package com.gnstudio.nabiro.fms
{
	import flash.events.IEventDispatcher;
	
	public interface IVideoRecorder extends IEventDispatcher
	{
		
		// FMS connection and functionalities
		function connect(fmsAddress:String, uid:String = ""):void;
		function recordVideo():void;
		function stopRecording():void;
		function pauseRecording():void;
		function reviewVideo(id:String = ""):void;
		function confirmVideo(id:int = 0):void;
		
		// Common functionalities
		function startPreview():void;
	//	function stopPreview():void;
		
		// Video size and appearance
		function get videoWidth():Number;
		function set videoWidth(value:Number):void;
		
		function get videoHeight():Number;
		function set videoHeight(value:Number):void;
		
		function set background(value:uint):void;
		function get background():uint;
		
		function set backgroundAlpha(value:Number):void;
		function get backgroundAlpha():Number;
		
		function set backgroundBorder(value:uint):void;
		function get backgroundBorder():uint;
		
		function set mute(value:Boolean):void;
		
	}
}