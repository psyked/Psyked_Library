package com.gnstudio.nabiro.pixelbender
{
	import com.gnstudio.nabiro.pixelbender.parameters.IParameter;
	
  
  public class PBJParam
  {
    public var name:String;
    public var parameter:IParameter;
    public var metadatas:Array;
    
    public function PBJParam(name:String, parameter:IParameter, metadatas:Array=null)
    {
      this.name = name;
      
      this.parameter = parameter;
      
      if (metadatas != null)
        this.metadatas = metadatas;
      else
        this.metadatas = [];
    }
  }
}