package com.gnstudio.nabiro.pixelbender.model.dataTypes
{
	
	import com.gnstudio.nabiro.pixelbender.regs.PBJReg;
	
  	public class PBJOperatorCode implements IPBJOperatorCode {
		
		public var dst:PBJReg;
	    public var src:PBJReg;	
	    public var code:uint;
		
		public function PBJOperatorCode(c:uint, d:PBJReg = null, s:PBJReg = null){
			
			code = c;
			dst = d;
       		src = s;
       		
			
		}
		
		public function reset():void{
			
			dst = null;
			src = null;
			
		}
			
	  }
}