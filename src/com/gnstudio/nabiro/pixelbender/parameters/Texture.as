package com.gnstudio.nabiro.pixelbender.parameters{
	
  public class Texture implements IParameter {
  	
    public var channels:int;
    public var index:int;
    
    public function Texture(c:int, i:int) {
    	
      channels = c;
      index = i;
      
    }
  }
}