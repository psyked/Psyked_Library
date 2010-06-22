package com.gnstudio.nabiro.pixelbender.model.dataTypes
{
	
	import com.gnstudio.nabiro.pixelbender.regs.PBJReg;
	
	public class PBJLoadOperator implements IPBJOperatorCode{
		
		public var reg:PBJReg;
     	public var v:Number;
		
		public function PBJLoadOperator(reg:PBJReg = null, v:Number = 0){
			
	       reg = reg;
	       v = v;
						
		}
		
		public function reset():void{
			
			reg = null;
			v = 0;
			
		}
		
	}
}