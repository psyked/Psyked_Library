package com.gnstudio.nabiro.pixelbender
{
	import com.gnstudio.nabiro.pixelbender.model.constants.IPBJConstant;
	
  
	  public class PBJMeta {
	  	
	    public var key:String;
	    public var value:IPBJConstant;
	    
	    public function PBJMeta(key:String, value:IPBJConstant) {
	    	
	      this.key = key;
	      this.value = value;
	      
	    }
	  }
}