package com.gnstudio.nabiro.mvp.encryption
{
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;	
	
	public class Hexadecimal
	{
		
		
		public static function toArray(hex:String):ByteArray {
			hex = hex.replace(/\s|:/gm,'');
			var a:ByteArray = new ByteArray;
			if (hex.length&1==1) hex="0"+hex;
			for (var i:uint=0;i<hex.length;i+=2) {
				a[i/2] = parseInt(hex.substr(i,2),16);
			}
			return a;
		}
		
		public static function fromArray(array:ByteArray, colons:Boolean=false):String {
			var s:String = "";
			for (var i:uint=0;i<array.length;i++) {
				s+=("0"+array[i].toString(16)).substr(-2,2);
				if (colons) {
					if (i<array.length-1) s+=":";
				}
			}
			return s;
		}
		
		public static function fromString(str:String, colons:Boolean=false):String {
			var a:ByteArray = new ByteArray;
			a.writeUTFBytes(str);
			return fromArray(a, colons);
		}
		
		public static function hash(src:ByteArray):ByteArray
		{
			var len:uint = src.length *8;
			var savedEndian:String = src.endian;
			// pad to nearest int.
			while (src.length%4!=0) {
				src[src.length]=0;
			}
			// convert ByteArray to an array of uint
			src.position=0;
			var a:Array = [];
			src.endian=Endian.LITTLE_ENDIAN
			for (var i:uint=0;i<src.length;i+=4) {
				a.push(src.readUnsignedInt());
			}
			var h:Array = MD5.binl_md5(a, len);
			var out:ByteArray = new ByteArray;
			out.endian=Endian.LITTLE_ENDIAN;
			for (i=0;i<4;i++) {
				out.writeUnsignedInt(h[i]);
			}
			// restore length!
			src.length = len/8;
			src.endian = savedEndian;
			
			return out;
		}
		
		public static function toString(hex:String):String {
			var a:ByteArray = toArray(hex);
			return a.readUTFBytes(a.length);
		}

	}
}