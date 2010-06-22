package com.gnstudio.nabiro.pixelbender.model.dataTypes
{
	import com.gnstudio.nabiro.pixelbender.regs.PBJReg;
	
	public class PBJConditionalOperator implements IPBJOperatorCode{
		
		public var cond:PBJReg;
		
		public function PBJConditionalOperator(c:PBJReg = null){
       		
       		cond = c;
		
		}
		
		public function reset():void{
			
			cond = null;
						
		}

	}
}