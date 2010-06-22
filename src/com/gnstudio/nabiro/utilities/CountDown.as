package com.gnstudio.nabiro.utilities
{
	import com.gnstudio.nabiro.utilities.events.CountDownEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class CountDown implements IEventDispatcher
	{
		
		private var eventDispatcher:EventDispatcher;
		
		private var startdate:Date;
		private var dayEnd:int;
		private var endDate:Date;
		
		private var timer:Timer;
		
		private var target:IEventDispatcher;
		
		public function CountDown(sd:Date, end:int, tg:IEventDispatcher = null){
			
			eventDispatcher = new EventDispatcher();
			
			startdate = sd;
			dayEnd = end;
			target = tg;
			
			endDate = startdate;
			endDate.setDate(endDate.getDate() + dayEnd);
			
			timer = new Timer(25);
			timer.addEventListener(TimerEvent.TIMER, doCountDown);
			timer.start();
			
		}
		
		
		protected function doCountDown(e:TimerEvent):void{
			
			var today:Date = new Date();
    			
			var currentTime:Number = today.getTime();
			    //
			var targetDate:Date = endDate;
			var targetTime:Number = targetDate.getTime();
			  
			    //
			var timeLeft:Number = targetTime - currentTime;
			    //
			var msec:Number = timeLeft;
			var sec:Number = Math.floor(timeLeft / 1000);
			var min:Number = Math.floor(sec / 60);
			var hrs:Number = Math.floor(min / 60);
			var days:Number = Math.floor(hrs / 24);
			 	
			var msecString:String = String(msec % 1000);
			    
			if(msecString.length == 2){
			    	
			   	msecString = "0" + msecString;
			    	
			}
			    
			if(msecString.length == 1){
			    	
			 	msecString = "00" + msecString;
			    	
			}
			 	
			var secString:String = String(sec % 60);
			secString = (secString.length <2) ? "0" + secString : secString;
			   
			var minString:String = String(min % 60);
			minString = (minString.length <2) ? "0" + minString : minString;
			     //   
			var hrsString:String = String(hrs % 24);
			hrsString = (hrsString.length <2) ? "0" + hrsString : hrsString;
			   //  
			var daysString:String = String(days);
			daysString = (daysString.length <2) ? "0" + daysString : daysString;
			
			if(msec < 0){
				
				msecString = "000";
				
			}
			
			if(days < 0){
				
				daysString = "00";
				
			}
			
			if(sec < 0){
				
				secString = "00";
				
			}
			
			if(hrs < 0){
				
				hrsString = "00";
				
			}
			
			if(min < 0){
				
				minString = "00";
				
			}
			
			if(target){
				
				target.dispatchEvent(new CountDownEvent(daysString, hrsString, minString, secString, msecString));
				
			}else{
				
				dispatchEvent(new CountDownEvent(daysString, hrsString, minString, secString, msecString));
				
			}
			
		//	trace(daysString, hrsString, minString, secString)
			
		}
		
		/************************************
		* IEventDispatcher immplementation
		*************************************/ 
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0.0, useWeakReference:Boolean=false):void{
			
			eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
			
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void	{
			
			eventDispatcher.removeEventListener(type, listener, useCapture);
			
		}
		
		public function dispatchEvent(event:Event):Boolean {
			
			return eventDispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean {
			
			return eventDispatcher.hasEventListener(type);
		}
		
		public function willTrigger(type:String):Boolean {
			
			return eventDispatcher.willTrigger(type);
			
		}
		
		

	}
}