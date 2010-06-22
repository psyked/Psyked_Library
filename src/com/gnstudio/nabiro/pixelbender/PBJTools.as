/*
 * Original code is from the haXe formats library with the following license:
 *
 * Copyright (c) 2008, The haXe Project Contributors
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *   - Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   - Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE HAXE PROJECT CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE HAXE PROJECT CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 *
 */
package com.gnstudio.nabiro.pixelbender
{
  import com.gnstudio.nabiro.pixelbender.model.PBJChannel;
  import com.gnstudio.nabiro.pixelbender.model.PBJOperators;
  import com.gnstudio.nabiro.pixelbender.model.PBJType;
  import com.gnstudio.nabiro.pixelbender.model.constants.*;
  import com.gnstudio.nabiro.pixelbender.model.dataTypes.IPBJOperatorCode;
  import com.gnstudio.nabiro.pixelbender.parameters.PBJParameter;
  import com.gnstudio.nabiro.pixelbender.parameters.Texture;
  import com.gnstudio.nabiro.pixelbender.regs.PBJReg;
  import com.gnstudio.nabiro.pixelbender.regs.RFloat;
  import com.gnstudio.nabiro.pixelbender.regs.RInt;
  
  import flash.display.ShaderInput;
  import flash.utils.ByteArray;
  import flash.utils.getQualifiedClassName;


  public class PBJTools
  {

    public static function ext(e:Array):String
    {
      if (e == null)
        return "";
      var str:String = ".";
      for each (var c:String in e)
      {
        switch (c)
        {
          case PBJChannel.R:
            str += "r";
            break;
          case PBJChannel.G:
            str += "g";
            break;
          case PBJChannel.B:
            str += "b";
            break;
          case PBJChannel.A:
            str += "a";
            break;
          case PBJChannel.M2x2:
            str += "2x2";
            break;
          case PBJChannel.M3x3:
            str += "3x3";
            break;
          case PBJChannel.M4x4:
            str += "4x4";
            break;
        }
      }
      return str;
    }

    public static function dumpReg(r:PBJReg):String
    {
      if (r is RInt)
          return "i" + r.value + ext(r.data);
      else if (r is RFloat)
          return "f" + r.value + ext(r.data);

      return null;
    }

    private static function call(p:String, vl:Array):String
    {
      return p + "(" + vl.join(",") + ")";
    }

    public static function dumpValue(v:IPBJConstant):String
    {
      if (v is PFloat)
        return (v as PFloat).f.toString();
      else if (v is PFloat2)
        return call("float2", [(v as PFloat2).f1, (v as PFloat2).f2]);
      else if (v is PFloat3)
        return call("float3", [(v as PFloat3).f1, (v as PFloat3).f2, (v as PFloat3).f3]);
      else if (v is PFloat4)
        return call("float4", [(v as PFloat4).f1, (v as PFloat4).f2, (v as PFloat4).f3, (v as PFloat4).f4]);
      else if (v is PFloat2x2)
        return call("float2x2", (v as PFloat2x2).f);
      else if (v is PFloat3x3)
        return call("float3x3", (v as PFloat3x3).f);
      else if (v is PFloat4x4)
        return call("float4x4", (v as PFloat4x4).f);
      else if (v is PInt)
        return new String((v as PInt).i);
      else if (v is PInt2)
        return call("int2", [(v as PInt2).i1, (v as PInt2).i2]);
      else if (v is PInt3)
        return call("int3", [(v as PInt3).i1, (v as PInt3).i2, (v as PInt3).i3]);
      else if (v is PInt4)
        return call("int4", [(v as PInt4).i1, (v as PInt4).i2, (v as PInt4).i3, (v as PInt4).i4]);
      else if (v is PString)
        return "'" + (v as PString).s + "'";

      return null;
    }

    public static function getValueType(v:IPBJConstant):String
    {
      if (v is PFloat)
        return PBJType.TFloat;
      else if (v is PFloat2)
        return PBJType.TFloat2;
      else if (v is PFloat3)
        return PBJType.TFloat3;
      else if (v is PFloat4)
        return PBJType.TFloat4;
      else if (v is PFloat2x2)
        return PBJType.TFloat2x2;
      else if (v is PFloat3x3)
        return PBJType.TFloat3x3;
      else if (v is PFloat4x4)
        return PBJType.TFloat4x4;
      else if (v is PInt)
        return PBJType.TInt;
      else if (v is PInt2)
        return PBJType.TInt2;
      else if (v is PInt3)
        return PBJType.TInt3;
      else if (v is PInt4)
        return PBJType.TInt4;
      else if (v is PString)
        return PBJType.TString;

      return null;
    }

    public static function getMatrixMaskBits(n:int):int
    {
      switch (n)
      {
        case 1:
          return 196;
        case 2:
          return 232;
        case 3:
          return 252;
        default:
          return -1;
      }
    }

    public static function dumpType(t:String):String
    {
      return t;
    }

    public static function dumpOpCode(c:Object):String
    {
    	/* NOP OPERATOR */
    	if(c.code == 0x00){
    		
    		return "nop";
    		
    	}/* ELSE OPERATOR */else if(c.code == 0x35){
    		
    		 return "else";
	        
    	}/* ENDIF OPERATOR */else if(c.code == 0x36){
    		
    		return "endif"; 
        	    		
    	}/* IF OPERATOR */else if(c.code == 0x34){
    		
    		return "if " + dumpReg(c.cond);
    	
    	}/* SAMPLE NEAREST OPERATOR */else if(c.code == 0x30){
    		
    		 return "sampleNearest " + dumpReg(c.dst) + ", t" + c.srcTexture + "[" + dumpReg(c.src) + "]";
    	
    	}/* SAMPLE LINEAR OPERATOR */else if(c.code == 0x31){
    		
    		return "sampleLinear " + dumpReg(c.dst) + ", t" + c.srcTexture + "[" + dumpReg(c.src) + "]";
    	
    	}/* LOAD INT and LOAD FLOAT OPERATOR */else if(c.code == 0x32){
    		
    		 return "loadfloat " + dumpReg(c.reg) + ", " + c.v;
    	
    	}/* ANY OPERATOR */else{
    		
    		return "generic operator " + dumpReg(c.dst) + ", " + dumpReg(c.src);
    		
    	}    	
      
      return null;
      
    }

    public static function dump(p:PBJ):String
    {
      var buf:String = new String();
      buf += "version : " + p.version + "\n";
      buf += "name : '" + p.name + "'" + "\n";
      for each (var m:PBJMeta in p.metadatas)
      {
        buf += "  meta " + m.key + " : " + dumpValue(m.value) + "\n";
      }
      for each (var pp:PBJParam in p.parameters)
      {
        if (pp.parameter is PBJParameter)
            buf += "  param " + ((pp.parameter as PBJParameter).out ? "out" : "in ") + " " + dumpReg((pp.parameter as PBJParameter).reg) + " " + dumpType((pp.parameter as PBJParameter).type) + "\t" + pp.name + "\n";
        else if(pp.parameter is Texture)
            buf += "  text" + (pp.parameter as Texture).index + " " + (pp.parameter as Texture).channels + "-channels" + "\t" + pp.name + "\n";
        
        for each (var mm:PBJMeta in pp.metadatas)
        {
          buf += "    meta " + mm.key + " : " + dumpValue(mm.value) + "\n";
        }
      }
      buf += "code :\n";
      for each (var o:IPBJOperatorCode in p.code)
      {
        buf += "  " + dumpOpCode(o) + "\n";
      }
      return buf;
    }

    public static function hexDump(ba:ByteArray):String
    {
      var s:String = "";

      ba.position = 0;

      while (ba.bytesAvailable)
      {
        s += ba.readUnsignedByte().toString(16) + " ";
      }

      ba.position = 0;

      return s;
    }

    public static function splitShaderInputFloat4(shaderInput:ShaderInput, texture:Object, defaultValue:Number):void
    {
      if (texture.length > 16777216)
      {
        throw new Error("Texture length cannot exceed 16777216.");
      }

      // adjust the texture so that it is a float4
      while (texture.length % 4 != 0)
      {
        texture.push(1);
      }

      // split into slices (height > 1)
      var sl:Number = texture.length / 4;
      var d:Number = Math.sqrt(sl);
      var w:Number = Math.ceil(sl / Math.floor(d));
      var h:Number = Math.ceil(sl / w);

      if ((w > 8192) || (h > 8192))
      {
        throw new Error("Texture width or height cannot exceed 8192");
      }

      // adjust the texture so that it fits the dimensions
      while (texture.length < (w * h * 4))
      {
        texture.push(1);
        texture.push(1);
        texture.push(1);
        texture.push(1);
      }

      shaderInput.width = w
      shaderInput.height = h
      shaderInput.input = texture;
    }
    
    public static function splitShaderInputFloat(shaderInput:ShaderInput, texture:Object, defaultValue:Number):void
    {
      if (texture.length > 16777216)
      {
        throw new Error("Texture length cannot exceed 16777216.");
      }

      var sl:Number = texture.length;
      var d:Number = Math.sqrt(sl);
      var w:Number = Math.ceil(sl / Math.floor(d));
      var h:Number = Math.ceil(sl / w);

      if ((w > 8192) || (h > 8192))
      {
        throw new Error("Texture width or height cannot exceed 8192");
      }

      // adjust the texture so that it fits the dimensions
      while (texture.length < (w * h))
      {
        texture.push(1);
      }

      shaderInput.width = w;
      shaderInput.height = h;
      shaderInput.input = texture;
    }
  }
}