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
  import com.gnstudio.nabiro.pixelbender.model.PBJConditionalOperators;
  import com.gnstudio.nabiro.pixelbender.model.PBJLoadOperators;
  import com.gnstudio.nabiro.pixelbender.model.PBJOperators;
  import com.gnstudio.nabiro.pixelbender.model.PBJSamplerOperators;
  import com.gnstudio.nabiro.pixelbender.model.PBJType;
  import com.gnstudio.nabiro.pixelbender.model.constants.*;
  import com.gnstudio.nabiro.pixelbender.model.dataTypes.IPBJOperatorCode;
  import com.gnstudio.nabiro.pixelbender.parameters.PBJParameter;
  import com.gnstudio.nabiro.pixelbender.parameters.Texture;
  import com.gnstudio.nabiro.pixelbender.regs.PBJReg;
  import com.gnstudio.nabiro.pixelbender.regs.RFloat;
  import com.gnstudio.nabiro.pixelbender.regs.RInt;
  
  import flash.utils.ByteArray;
  import flash.utils.Endian;
  
  public class PBJAssembler
  {
    public static function assemble(pbj:PBJ):ByteArray
    {
      var o:ByteArray = new ByteArray();
      
      o.endian = Endian.LITTLE_ENDIAN;
      o.writeByte(0xA5);
      o.writeUnsignedInt(pbj.version);
      o.writeByte(0xA4);
      o.writeShort(pbj.name.length);
      o.writeUTFBytes(pbj.name);

      for each (var m:PBJMeta in pbj.metadatas)
      {
        o.writeByte(0xA0);
        writeMeta(m, o);
      }

      for each (var pp:PBJParam in pbj.parameters)
      {
        if (pp.parameter is PBJParameter)
        {
          o.writeByte(0xA1);
          o.writeByte((pp.parameter as PBJParameter).out ? 2 : 1);
          o.writeByte(getTypeCode((pp.parameter as PBJParameter).type));
          o.writeShort(regCode((pp.parameter as PBJParameter).reg));

          var e:Array;
          if (((pp.parameter as PBJParameter).reg is RInt) || ((pp.parameter as PBJParameter).reg is RFloat))
          {
            e = (pp.parameter as PBJParameter).reg.data;
          }

          switch ((pp.parameter as PBJParameter).type)
          {
            case PBJType.TFloat2x2:
              assert(e, null);
              o.writeByte(2);
              break;
            case PBJType.TFloat3x3:
              assert(e, null);
              o.writeByte(3);
              break;
            case PBJType.TFloat4x4:
              assert(e, null);
              o.writeByte(4);
              break;
            default:
              o.writeByte(destMask(e));
              break;
          }
        }
        else if (pp.parameter is Texture)
        {
          o.writeByte(0xA3);
          o.writeByte((pp.parameter as Texture).index);
          o.writeByte((pp.parameter as Texture).channels);
        }
        o.writeUTFBytes(pp.name);
        o.writeByte(0);

        for each (var mm:PBJMeta in pp.metadatas)
        {
          o.writeByte(0xA2);
          writeMeta(mm, o);
        }
      }

      for each (var c:IPBJOperatorCode in pbj.code)
      {
        writeCode(c, o);
      }

      return o;
    }


    private static function getTypeCode(t:String):int
    {
      switch (t)
      {
        case PBJType.TFloat:
          return 0x01;
        case PBJType.TFloat2:
          return 0x02;
        case PBJType.TFloat3:
          return 0x03;
        case PBJType.TFloat4:
          return 0x04;
        case PBJType.TFloat2x2:
          return 0x05;
        case PBJType.TFloat3x3:
          return 0x06;
        case PBJType.TFloat4x4:
          return 0x07;
        case PBJType.TInt:
          return 0x08;
        case PBJType.TInt2:
          return 0x09;
        case PBJType.TInt3:
          return 0x0A;
        case PBJType.TInt4:
          return 0x0B;
        case PBJType.TString:
          return 0x0C;
      }

      return NaN;
    }

    private static function regCode(r:PBJReg):int
    {
      if (r is RFloat)
          return r.value;
      if (r is RInt)
          return r.value + 0x8000;

      return NaN;
    }

    private static function getMatrixBits(t:String):int
    {
      switch (t)
      {
        case PBJType.TFloat2x2:
          return 1;
        case PBJType.TFloat3x3:
          return 2;
        case PBJType.TFloat4x4:
          return 3;
      }

      return 0;
    }

    private static function getSizeBits(t:String):int
    {
      switch (t)
      {
        case PBJType.TFloat:
        case PBJType.TInt:
          return 0;

        case PBJType.TFloat2:
        case PBJType.TInt2:
          return 1;

        case PBJType.TFloat3:
        case PBJType.TInt3:
          return 2;

        case PBJType.TFloat4:
        case PBJType.TInt4:
          return 3;
      }

      return 0;
    }

    private static function assert(v1:Object, v2:Object):void
    {
      if (v1 != v2)
        throw new Error("Assert " + v1 + " != " + v2);
    }

    private static function writeFloat(v:Number, o:ByteArray):void
    {
      o.endian=Endian.BIG_ENDIAN;
      o.writeFloat(v);
      o.endian=Endian.LITTLE_ENDIAN;
    }

    private static function writeValue(v:Object, o:ByteArray):void
    {
      if (v is PFloat)
      {
        writeFloat(v.f, o);
      }
      else if (v is PFloat2)
      {
        writeFloat(v.f1, o);
        writeFloat(v.f2, o);
      }
      else if (v is PFloat3)
      {
        writeFloat(v.f1, o);
        writeFloat(v.f2, o);
        writeFloat(v.f3, o);
      }
      else if (v is PFloat4)
      {
        writeFloat(v.f1, o);
        writeFloat(v.f2, o);
        writeFloat(v.f3, o);
        writeFloat(v.f4, o);
      }
      else if (v is PFloat2x2)
      {
        assert(v.a.length, 4);
        for each (var f2x2:Number in v.a)
          writeFloat(f2x2, o);
      }
      else if (v is PFloat3x3)
      {
        assert(v.a.length, 9);
        for each (var f3x3:Number in v.a)
          writeFloat(f3x3, o);
      }
      else if (v is PFloat4x4)
      {
        assert(v.a.length, 16);
        for each (var f4x4:Number in v.a)
          writeFloat(f4x4, o);
      }
      else if (v is PInt)
      {
        o.writeShort(v.i);
      }
      else if (v is PInt2)
      {
        o.writeShort(v.i1);
        o.writeShort(v.i2);
      }
      else if (v is PInt3)
      {
        o.writeShort(v.i1);
        o.writeShort(v.i2);
        o.writeShort(v.i3);
      }
      else if (v is PInt4)
      {
        o.writeShort(v.i1);
        o.writeShort(v.i2);
        o.writeShort(v.i3);
        o.writeShort(v.i4);
      }
      else if (v is PString)
      {
        o.writeUTFBytes(v.s);
        o.writeByte(0x00);
      }
    }

    private static function writeMeta(m:PBJMeta, o:ByteArray):void
    {
      var t:String = PBJTools.getValueType(m.value);
      o.writeByte(getTypeCode(t));
      o.writeUTFBytes(m.key);
      o.writeByte(0);
      writeValue(m.value, o);
    }

    private static function destMask(e:Array):int
    {
      if (e == null)
      {
        return 0xF;
      }

      var mask:int=0;
      for each (var c:String in e)
      {
        switch (c)
        {
          case PBJChannel.R:
            if (mask != 0)
              throw new Error("Can't swizzle dest reg");
            mask|=8;
            break;
          case PBJChannel.G:
            if (mask & 7 != 0)
              throw new Error("Can't swizzle dest reg");
            mask|=4;
            break;
          case PBJChannel.B:
            if (mask & 3 != 0)
              throw new Error("Can't swizzle dest reg");
            mask|=2;
            break;
          case PBJChannel.A:
            if (mask & 1 != 0)
              throw new Error("Can't swizzle dest reg");
            mask|=1;
            break;
          case PBJChannel.M4x4:
          case PBJChannel.M3x3:
          case PBJChannel.M2x2:
            return 0;
            break;
        }
      }
      return mask;
    }

    private static function srcSwizzle(e:Array, size:int):int
    {
      // 0x1B = 00 01 10 11
      if (e == null)
        return 0x1B;

      var mask:int=0;
      for each (var c:String in e)
      {
        mask<<=2;
        switch (c)
        {
          //case PBJChannel.R:
          case PBJChannel.G:
            mask|=1;
            break;
          case PBJChannel.B:
            mask|=2;
            break;
          case PBJChannel.A:
            mask|=3;
            break;
          case PBJChannel.M4x4:
          case PBJChannel.M3x3:
          case PBJChannel.M2x2:
            return 0; // no swizzle
            break;
        }
      }
      return mask << ((4 - size) * 2);
    }

    private static function writeDest(dst:PBJReg, size:int, o:ByteArray):void
    {
      var mask:int = destMask(dst.data);
      o.writeShort(regCode(dst));
      o.writeByte(mask << 4 | size);
    }

    private static function writeSrc(src:PBJReg, size:int, o:ByteArray):void
    {
      o.writeShort(regCode(src));
      o.writeByte(srcSwizzle(src.data, size));
    }

    private static function writeOp(code:int, dst:PBJReg, src:PBJReg, o:ByteArray):void
    {
      o.writeByte(code);
      o.writeShort(regCode(dst));
      var dste:Array = dst.data;
      var srce:Array = src.data;
      var maskBits:int = destMask(dste);
      var sizeBits:int = ((dste == null) ? 4 : dste.length) - 1;
      if ((srce != null) && (srce.length == 1))
      {
        switch (srce[0])
        {
          case PBJChannel.M2x2:
            sizeBits=4;
            break;
          case PBJChannel.M3x3:
            sizeBits=8;
            break;
          case PBJChannel.M4x4:
            sizeBits=12;
            break;
        }
      }
      o.writeByte((maskBits << 4 | sizeBits));
      o.writeShort(regCode(src));
      o.writeByte(srcSwizzle(srce, srce == null ? 4 : srce.length));
      o.writeByte(0);
    }

    private static function writeCode(c:Object, o:ByteArray):void{
    	
    	/* NOP OPERATOR */
    	if(c.code == 0x00){
    		
    		o.writeByte(c.code);
        	o.writeInt(0);
       	 	o.writeShort(0);
       		o.writeByte(0x00);
    		
    	}/* ELSE OPERATOR */else if(c.code == 0x35){
    		
    		o.writeByte(c.code);
	        o.writeInt(0);
	        o.writeShort(0);
	        o.writeByte(0x00);
	        
    	}/* ENDIF OPERATOR */else if(c.code == 0x36){
    		
    		o.writeByte(0x36);
        	o.writeInt(0);
        	o.writeShort(0);
        	o.writeByte(0x00);
        	    		
    	}/* IF OPERATOR */else if(c.code == 0x34){
    		
    		o.writeByte(c.code);
	        o.writeShort(0);
	        o.writeByte(0x00);
	        writeSrc(c.cond, 1, o);
	        o.writeByte(0);
    	
    	}/* SAMPLE NEAREST OPERATOR */else if(c.code == 0x30){
    		
    		o.writeByte(c.code);
        	writeDest(c.dst, 1, o);
        	writeSrc(c.src, 2, o);
        	o.writeByte(c.srcTexture);
    	
    	}/* SAMPLE LINEAR OPERATOR */else if(c.code == 0x31){
    		
    		 o.writeByte(c.code);
	        writeDest(c.dst, 1, o);
	        writeSrc(c.src, 2, o);
	        o.writeByte(c.srcTexture);
    	
    	}/* LOAD INT and LOAD FLOAT OPERATOR */else if(c.code == 0x32){
    		
    		o.writeByte(c.code);
	        writeDest(c.reg, 0, o);
	        o.writeInt(c.v);
    	
    	}/* ANY OPERATOR */else{
    		
    		writeOp(c.code, c.dst, c.src, o);
    		
    	}
    	
    }

  }
}