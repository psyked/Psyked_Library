package com.gnstudio.nabiro.pixelbender.model.dataTypes
{
	import com.gnstudio.nabiro.pixelbender.regs.PBJReg;

	public class PBJSamplerOperator extends PBJOperatorCode implements IPBJOperatorCode	{
		
		public var srcTexture:int;
		
		public function PBJSamplerOperator(c:uint, d:PBJReg=null, s:PBJReg=null, texture:int = 0){
			
			super(c, d, s);
			
			srcTexture = texture;
			
		}
		
		override public function reset():void{
			
			super.reset();
			srcTexture = 0;
			
		}
		
	}
}