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
  	 import com.gnstudio.nabiro.pixelbender.model.PBJSamplerOperators;
  	 import com.gnstudio.nabiro.pixelbender.model.PBJConditionalOperators;
  	 import com.gnstudio.nabiro.pixelbender.model.PBJLoadOperators;
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

  public class PBJDisassembler
  {
    private static const chans:Array = [PBJChannel.R, PBJChannel.G, PBJChannel.B, PBJChannel.A, PBJChannel.M2x2, PBJChannel.M3x3, PBJChannel.M4x4];

    private static function getType(t:uint):String
    {
      switch (t)
      {
        case 0x01:
          return PBJType.TFloat;
        case 0x02:
          return PBJType.TFloat2;
        case 0x03:
          return PBJType.TFloat3;
        case 0x04:
          return PBJType.TFloat4;
        case 0x05:
          return PBJType.TFloat2x2;
        case 0x06:
          return PBJType.TFloat3x3;
        case 0x07:
          return PBJType.TFloat4x4;
        case 0x08:
          return PBJType.TInt;
        case 0x09:
          return PBJType.TInt2;
        case 0x0A:
          return PBJType.TInt3;
        case 0x0B:
          return PBJType.TInt4;
        case 0x0C:
          return PBJType.TString;
        default:
          throw new Error("Unknown type 0x" + t);
      }
    }

    private static function srcReg(src:int, size:uint):PBJReg
    {
      var sw:int = src >> 16;
      var m:Array = null;
      // 0x1B = 00 01 10 11
      if (sw != 0x1B)
      {
        m = new Array();
        for (var i:uint = 0; i < size; i++)
        {
          m.push(chans[(sw >> (6 - i * 2)) & 3]);
        }
      }
      return reg(src & 0xFFFF, m);
    }

    private static function dstReg(dst:uint, mask:uint):PBJReg
    {
      var m:Array;

      if (mask != 0xF)
      {
        m = new Array();
        if ((mask & 8) != 0)
          m.push(PBJChannel.R);
        if ((mask & 4) != 0)
          m.push(PBJChannel.G);
        if ((mask & 2) != 0)
          m.push(PBJChannel.B);
        if ((mask & 1) != 0)
          m.push(PBJChannel.A);
      }
      return reg(dst, m);
    }

    private static function mReg(r:int, matrix:uint):PBJReg
    {
      return reg(r & 0xFFFF, [chans[matrix + 3]]);
    }

    private static function reg(t:int, s:Array):PBJReg
    {
      if ((t & 0x8000) != 0)
      {
        return new RInt(t - 0x8000, s);
      }
      return new RFloat(t, s);
    }

    private static function readFloat(ba:ByteArray):Number
    {
      ba.endian = Endian.BIG_ENDIAN;
      var f:Number = ba.readFloat();
      ba.endian = Endian.LITTLE_ENDIAN;
      return f;
    }

    private static function readValue(t:String, ba:ByteArray):IPBJConstant
    {
      if (t == PBJType.TFloat)
      {
        return new PFloat(readFloat(ba));
      }
      else if (t == PBJType.TFloat2)
      {
        return new PFloat2(readFloat(ba), readFloat(ba));
      }
      else if (t == PBJType.TFloat3)
      {
        return new PFloat3(readFloat(ba), readFloat(ba), readFloat(ba));
      }
      else if (t == PBJType.TFloat4)
      {
        return new PFloat4(readFloat(ba), readFloat(ba), readFloat(ba), readFloat(ba));
      }
      else if (t == PBJType.TFloat2x2)
      {
        var a2x2:Array = new Array();
        for each (var n2x2:uint in new Array(4))
          a2x2.push(readFloat(ba));
        return new PFloat2x2(a2x2);
      }
      else if (t == PBJType.TFloat3x3)
      {
        var a3x3:Array = new Array();
        for each (var n3x3:uint in new Array(9))
          a3x3.push(readFloat(ba));
        return new PFloat3x3(a3x3);
      }
      else if (t == PBJType.TFloat4x4)
      {
        var a4x4:Array = new Array();
        for each (var n4x4:uint in new Array(16))
          a4x4.push(readFloat(ba));
        return new PFloat4x4(a4x4);
      }
      else if (t == PBJType.TInt)
      {
        return new PInt(ba.readUnsignedShort());
      }
      else if (t == PBJType.TInt2)
      {
        return new PInt2(ba.readUnsignedShort(), ba.readUnsignedShort());
      }
      else if (t == PBJType.TInt3)
      {
        return new PInt3(ba.readUnsignedShort(), ba.readUnsignedShort(), ba.readUnsignedShort());
      }
      else if (t == PBJType.TInt4)
      {
        return new PInt4(ba.readUnsignedShort(), ba.readUnsignedShort(), ba.readUnsignedShort(), ba.readUnsignedShort());
      }
      else if (t == PBJType.TString)
      {

        return new PString(readString(ba));
      }

      return null;
    }

    private static function readString(ba:ByteArray):String
    {
      var s:String = new String();

      var b:int = ba.readUnsignedByte();
      while (b != 0)
      {
        s += String.fromCharCode(b);
        b = ba.readUnsignedByte();
      }

      return s;
    }
    
    private static function readUInt24(ba:ByteArray):uint
    {
      var src:uint = ba.readShort();
      var srcMask:uint = ba.readUnsignedByte() << 16;
      src += srcMask;
      
      return src;
    }

    private static function assert(v1:Object, v2:Object):void
    {
      if (v1 != v2)
      {
        throw new Error("Assert " + v1.toString() + " != " + v2.toString());
      }
    }

    private static function readOp(o:Object, ba:ByteArray):Object
    {
      var dst:uint = ba.readUnsignedShort();
      var mask:uint = ba.readUnsignedByte();
      var size:uint = (mask & 3) + 1;
      var matrix:uint = (mask >> 2) & 3;
      var src:uint = readUInt24(ba);
      assert(ba.readUnsignedByte(), 0);
      mask >>= 4;
      
      // The first parameter is dst, the second is src
      
      if (matrix != 0)
      {
        assert(src >> 16, 0); // no swizzle
        assert(size, 1);
        var ndst:PBJReg = (mask == 0) ? mReg(dst, matrix) : dstReg(dst, mask);
        
        o.dst = ndst;
        o.src = mReg(src, matrix)

        return o;
      }
      
      o.dst = dstReg(dst, mask);
      o.src = srcReg(src, size)
      
      return o;
    }

    public static function disassemble(ba:ByteArray):PBJ
    {
      var myPBJ:PBJ = new PBJ();

      var op:int;

      ba.endian = Endian.LITTLE_ENDIAN;

      while (true)
      {
        try
        {
          op = ba.readUnsignedByte();
        }
        catch (e:Object)
        {
          break;
        }
		
		var operator:IPBJOperatorCode;
		
        switch (op)
        {
          // opcodes
          case 0x00:
            assert(ba.readInt(), 0);
            assert(ba.readShort(), 0);
            
            operator = PBJOperators.OP_NOP.data;
            operator.reset();
            
            myPBJ.code.push(operator);
            break;
          case 0x01:
          	
          	operator = PBJOperators.OP_ADD.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
            break;
          case 0x02:
          	
          	operator = PBJOperators.OP_SUB.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x03:
          	
          	operator = PBJOperators.OP_MUL.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x04:
          	
          	operator = PBJOperators.OP_RCP.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x05:
          	
          	operator = PBJOperators.OP_DIV.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x06:
          	
          	operator = PBJOperators.OP_ATAN2.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x07:
          
          	operator = PBJOperators.OP_POW.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x08:
          	
          	operator = PBJOperators.OP_MOD.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x09:
          	
          	operator = PBJOperators.OP_MIN.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x0A:
          	
          	operator = PBJOperators.OP_MAX.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x0B:
          	
          	operator = PBJOperators.OP_STEP.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x0C:
          	
          	operator = PBJOperators.OP_SIN.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x0D:
          
          	operator = PBJOperators.OP_COS.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x0E:
          	
          	operator = PBJOperators.OP_TAN.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x0F:
          	
          	operator = PBJOperators.OP_ASIN.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x10:
          
          	operator = PBJOperators.OP_ACOS.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x11:
          
          	operator = PBJOperators.OP_ATAN.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x12:
          	
          	operator = PBJOperators.OP_EXP.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x13:
          	
          	operator = PBJOperators.OP_EXP2.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x14:
          
          	operator = PBJOperators.OP_LOG.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x15:
          	
          	operator = PBJOperators.OP_LOG2.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x16:
          	
          	operator = PBJOperators.OP_SQRT.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x17:
          	
          	operator = PBJOperators.OP_R_SQRT.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x18:
          
          	operator = PBJOperators.OP_ABS.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x19:
          	
          	operator = PBJOperators.OP_SIGN.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x1A:
          	
          	operator = PBJOperators.OP_FLOOR.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x1B:
          	
          	operator = PBJOperators.OP_CEIL.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x1C:
          	
          	operator = PBJOperators.OP_FRACT.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x1D:
          	
          	operator = PBJOperators.OP_MOV.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x1E:
          	
          	operator = PBJOperators.OP_FLOAT_TO_INT.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x1F:
          	
          	operator = PBJOperators.OP_INT_TO_FLOAT.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          	
            break;
          case 0x20:
          	
          	operator = PBJOperators.OP_MATRIX_MATRIX_MULT.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x21:
          	
          	operator = PBJOperators.OP_VECTOR_MATRIX_MULT.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x22:
          	
          	operator = PBJOperators.OP_MATRIX_VECTROR_MULT.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          	
            break;
          case 0x23:
          	
          	operator = PBJOperators.OP_NORMALIZE.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          	
            break;
          case 0x24:
          	
          	operator = PBJOperators.OP_LENGTH.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          	
            break;
          case 0x25:
          	
          	operator = PBJOperators.OP_DISTANCE.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x26:
          	
          	operator = PBJOperators.OP_DOT_PRODUCT.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x27:
          	
          	operator = PBJOperators.OP_CROSS_PRODUCT.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          	
            break;
          case 0x28:
          	
          	operator = PBJOperators.OP_EQUAL.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x29:
          	
          	operator = PBJOperators.OP_NOT_EQUAL.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x2A:
          	
          	operator = PBJOperators.OP_LESS_THAN.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x2B:
          	
          	operator = PBJOperators.OP_LESS_THAN_EQUAL.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x2C:
          	
          	operator = PBJOperators.OP_LOGICAL_NOT.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x2D:
          	
          	operator = PBJOperators.OP_LOGICAL_AND.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x2E:
          	
          	operator = PBJOperators.OP_LOGICAL_OR.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x2F:
          	
          	operator = PBJOperators.OP_LOGICAL_XOR.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x30:
            var dst30:uint = ba.readUnsignedShort();
            var mask30:uint = ba.readUnsignedByte();
            var src30:uint = readUInt24(ba);
            var tf30:uint = ba.readUnsignedByte();
            assert(mask30 & 0xF, 1);
            
            operator = PBJSamplerOperators.OP_SAMPLE_NEAREST.data;
            operator.reset();
            
            operator["dst"] = dstReg(dst30, mask30 >> 4)
            operator["src"] = srcReg(src30, 2);
            operator["srcTexture"] = tf30;
            
            myPBJ.code.push(operator);
            
            break;
          case 0x31:
            var dst31:uint = ba.readUnsignedShort()
            var mask31:uint = ba.readUnsignedByte();
            var src31:uint = readUInt24(ba);
            var tf31:uint = ba.readUnsignedByte();
            assert(mask31 & 0xF, 1);
            
            operator = PBJSamplerOperators.OP_SAMPLE_LINEAR.data;
            operator.reset();
            
            operator["dst"] = dstReg(dst31, mask31 >> 4)
            operator["src"] = srcReg(src31, 2);
            operator["srcTexture"] = tf31;
            
            myPBJ.code.push(operator);
          
            break;
          case 0x32:
            var dst32:uint = ba.readUnsignedShort();
            var mask32:uint = ba.readUnsignedByte();
            assert(mask32 & 0xF, 0);
            var ndst:PBJReg = dstReg(dst32, mask32 >> 4);
            if (ndst is RInt)
            {
            	operator = PBJLoadOperators.OP_LOAD_FLOAT.data;
            	operator.reset();
            	
            	operator["dst"] = ndst;
            	operator["src"] = ba.readInt();
            	
              	myPBJ.code.push(operator);
            
            }
            else if (ndst is RFloat)
            {
            	operator = PBJLoadOperators.OP_LOAD_FLOAT.data;
            	operator.reset();
            	
            	operator["dst"] = ndst;
            	operator["src"] = readFloat(ba);
            	
              	myPBJ.code.push(operator);
            }
            break;
          case 0x33:
            throw new Error("Loops are not supported");
            break;
          case 0x34:
            assert(readUInt24(ba), 0);
            var src34:uint = readUInt24(ba);
            assert(ba.readUnsignedByte(), 0);
            
            operator = PBJConditionalOperators.OP_IF.data;
            operator.reset();
            	
            operator["cond"] = srcReg(src34, 1);                        
            
            myPBJ.code.push(operator);
            break;
          case 0x35:
            assert(ba.readUnsignedInt(), 0); // UInt30(), 0 );
            assert(readUInt24(ba), 0);
            
            operator = PBJOperators.OP_ELSE.data;
            operator.reset();
            
            myPBJ.code.push(operator);
            break;
          case 0x36:
            assert(ba.readUnsignedInt(), 0); // UInt30(), 0 );
            assert(readUInt24(ba), 0);
            
            operator = PBJOperators.OP_END_IF.data;
            operator.reset();
            
            myPBJ.code.push(operator);
           
            break;
          case 0x37:
          	
          	operator = PBJOperators.OP_FLOAT_TO_BOOLEAN.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x38:
          	
          	operator = PBJOperators.OP_BOOLEAN_TO_FLOAT.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x39:
          	
          	operator = PBJOperators.OP_INT_TO_BOOLEAN.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x3A:
          	
          	operator = PBJOperators.OP_BOOLEAN_TO_INT.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x3B:
          	
          	operator = PBJOperators.OP_VECTOR_EQUAL.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x3C:
          	
          	operator = PBJOperators.OP_VECTOR_NOT_EQUAL.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x3D:
          	
          	operator = PBJOperators.OP_BOOLEAN_ANY.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          case 0x3E:
          	
          	operator = PBJOperators.OP_BOOLEAN_ALL.data;
            operator.reset();
         
            myPBJ.code.push(readOp(operator, ba));
          
            break;
          // datas
          case 0xA0:
          case 0xA2:
            var typeA2:uint = ba.readUnsignedByte();
            var keyA2:String = readString(ba);
            var valueA2:PBJConst = readValue(getType(typeA2), ba);
            myPBJ.metadatas.push(new PBJMeta(keyA2, valueA2));
            break;
          case 0xA1:
            var qualifierA1:uint = ba.readUnsignedByte();
            var typeA1:String = getType(ba.readUnsignedByte());
            var regA1:uint = ba.readUnsignedShort();
            var maskA1:uint = ba.readUnsignedByte();
            var nameA1:String = readString(ba);
            switch (typeA1)
            {
              case PBJType.TFloat2x2:
                assert(maskA1, 2);
                maskA1 = 0xF;
                break;
              case PBJType.TFloat3x3:
                assert(maskA1, 3);
                maskA1 = 0xF;
                break;
              case PBJType.TFloat4x4:
                assert(maskA1, 4);
                maskA1 = 0xF;
                break;
              default:
                assert(maskA1 >> 4, 0);
            }

            if (qualifierA1 != 2)
            {
              assert(qualifierA1, 1);
            }

            myPBJ.parameters.push(new PBJParam(nameA1, new PBJParameter(typeA1, qualifierA1 == 2, dstReg(regA1, maskA1))));
            break;
          case 0xA3:
            var indexA3:uint = ba.readUnsignedByte();
            var channelsA3:uint = ba.readUnsignedByte();
            var nameA3:String = readString(ba);

            myPBJ.parameters.push(new PBJParam(nameA3, new Texture(channelsA3, indexA3)));
            break;
          case 0xA4:
            assert(myPBJ.name, null);
            myPBJ.name = ba.readUTF();
            break;
          case 0xA5:
            assert(myPBJ.version, 0);
            myPBJ.version = ba.readInt(); // Int31();
            break;
          default:
            throw new Error("Unknown opcode 0x" + op);
        }
      }

      return myPBJ;
    }

  }
}