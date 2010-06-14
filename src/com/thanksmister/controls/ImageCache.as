/*
    ImageCache
    version 1.0.0
    Created by Michael Ritchie (Mister)
	mister@thanksmister.com
	http://www.thanksmister.com
    
	Simple component to cache Images loaded from URLs.  This could 
	easily be expanded to cache any type of information loaded into 
	the Image control. For more information, check Ely Greenfields post:
	
	http://www.quietlyscheming.com/blog/2007/01/29/new-flex-componentsample-superimage/
	
    This is release under a Creative Commons license. More information can be
    found here: 
    
    http://creativecommons.org/licenses/by/2.5/
*/

package com.thanksmister.controls
{
	import com.thanksmister.caching.ImageCacheUtility;
	
	import flash.display.Bitmap;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.system.LoaderContext;
	
	import mx.controls.Image;
	import mx.core.mx_internal;
	
	use namespace mx_internal;
	
	public class ImageCache extends Image
	{
		private var imageCache:ImageCacheUtility = ImageCacheUtility.getInstance();
		private var _sourceURL:String = "";
		private var _cacheLimit:Number = 50;
		protected var _smoothing:Boolean = false;
		
		public function get cacheLimit():Number
		{
			return _cacheLimit;
		}
		
		public function set cacheLimit(num:Number):void
		{
			_cacheLimit = num;
			imageCache.cacheLimit = num;
		}
		
		public function set smoothing(t:Boolean):void {
			_smoothing = t;
			if(content != null) {
				(content as Bitmap).smoothing = _smoothing;
			}
		}
		
		public function get smoothing():Boolean {
			return _smoothing;
		}
		
		// Clears the cached completely
		public function clearCache():void
		{
			imageCache.clear();
		}
		
		// If we have a url string, then look up the bitmap of the
		// control using the url as the identifier.  Be sure that the
		// incoming variable is a string. If the object comes in as
		// an XML node, it will not be type string. 
		public override function set source(value:Object):void
		{
			// we could have a string or an xml node, skip if class
			if(value is Class){
				// do nothing
			} else if(value is String || value is Object ){
				value = imageCache.loadImage(String(value));
				_sourceURL = String(value);
				
				var lc:LoaderContext = new LoaderContext();
				lc.checkPolicyFile = true;
				super.loaderContext = lc;
			}
			
			super.source = value;
		}
		
		// If we have a URL then cache a bitmap of this control with the
		// url string as the identifier
		override mx_internal function contentLoaderInfo_completeEventHandler(event:Event):void
		{
			if (LoaderInfo(event.target).loader != contentHolder)
				return;
			
			if(_sourceURL != ""){
				imageCache.cacheImage(_sourceURL, this); 
				(content as Bitmap).smoothing = _smoothing;
			}
			
			//var smoothLoader:Loader = event.target.loader as Loader;
           // var smoothImage:Bitmap = smoothLoader.content as Bitmap;
           // 	smoothImage.smoothing = true;
			
			super.contentLoaderInfo_completeEventHandler(event);
		}
	}
}