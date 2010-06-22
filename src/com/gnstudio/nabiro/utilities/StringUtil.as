/**
 * @author jaco
 * @ignore
 */

//////////////////
//              //
// rbidr_client //
//              //
//////////////////
//////////////////


package com.gnstudio.nabiro.utilities {

	/**
	 * Some static string utility methods
	 *
	 *
	 * @package nabiro
	 * @playerversion 9
	 * @productversion flex 3.2
	 */
	public class StringUtil 	{

		public static const PAD_LEFT:String = "padLeft";
		public static const PAD_RIGHT:String = "padRight";


		/**
		 * provides to pad left/right string with given char
		 * @param the string to pad
		 * @param padding char
		 * @param total length of the resulting padded string
		 * @param pad left or right: StringUtil.PAD_LEFT StringUtil.PAD_RIGHT
		 * @return
		 */
		public static function str_pad(str:String, padChar:String, padTotal:uint, padType:String = StringUtil.PAD_LEFT):String {

			var padStr:String = "";

			if(padTotal < str.length) return str;

			var numPad:int = padTotal - str.length;

			for(var i:int = 0; i < numPad; i++) padStr += padChar;

			if(padType == StringUtil.PAD_RIGHT) return str + padStr;

			return padStr +str;
		}

		/**
		 * check presence of a string in array
		 * @param item to check
		 * @param items to compare
		 * @return
		 */
		public static function in_array(str:String, cmpArray:Array):Boolean{

			for each(var cmp:String in cmpArray){
				if(str == cmp) return true;
			}

			return false;
		}

		/**
		 * uint to html hex string
		 * @param
		 * @return
		 */
		public static function value_toColorString(colorValue:uint):String{

			var colorStr:String = "#";
			var red:uint = colorValue >> 0x10;
			var green:uint = (colorValue >> 0x08) & 0xFF;
			var blue:uint  = colorValue & 0xFF;

			colorStr += StringUtil.str_pad(red.toString(16), "0", 2);
			colorStr += StringUtil.str_pad(green.toString(16), "0", 2);
			colorStr += StringUtil.str_pad(blue.toString(16), "0", 2);
			//colorStr += StringUtil.str_pad(alpha.toString(16), "0", 2);

			return colorStr;
		}

		/**
		 * converts a string to boolean
		 * @param
		 * @return
		 */
		public static function toBoolean(booleanStr:String):Boolean {
			return booleanStr.toLowerCase() == "true" ? true : false;
		}
		
		/**
		 * Generate a random string over the alphabet or a specific set of chars
		 * @param newLenght int
		 * @param userAlphabet String
		 * @return String
		 */ 
		public static function generateRandomString(newLength:uint = 1, userAlphabet:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"):String{
	      
	      var alphabet:Array = userAlphabet.split("");
	      var alphabetLength:int = alphabet.length;
	      var randomLetters:String = "";
	      
	      for (var i:uint = 0; i < newLength; i++){
	        
	        randomLetters += alphabet[int(Math.floor(Math.random() * alphabetLength))];
	      
	      }
	      
	      return randomLetters;
	    
	    }

		
	}
}