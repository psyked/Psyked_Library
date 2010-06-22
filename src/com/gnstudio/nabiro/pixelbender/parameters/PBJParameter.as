package com.gnstudio.nabiro.pixelbender.parameters
{
	import com.gnstudio.nabiro.pixelbender.regs.PBJReg;
	
  
  
	  public class PBJParameter implements IParameter {
	  	
	    public var type:String;
	    public var out:Boolean;
	    public var reg:PBJReg;
	    
	    public function PBJParameter(t: String, o:Boolean, r:PBJReg){
	    	
	      type = t;
	      out = o;
	      reg = r;
	      
	      trace(t, o, r.data, r.value)
	      
	      
	    }
	  }
}