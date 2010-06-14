package couk.psyked.utils
{
	import flash.geom.ColorTransform;
	
    public class ColourUtils
    {
        public function ColourUtils()
        {
        }

        public static function tint( clip:Object, newColor:Number ):void
        {
            var colorTransform:ColorTransform = clip.transform.colorTransform;
            colorTransform.color = newColor;
            clip.transform.colorTransform = colorTransform;
        }

        public static function convertHSVtoRGB( _hue:Number, _saturation:Number, _value:Number ):String
        {
            // inital variables
            var red:Number;
            var green:Number;
            var blue:Number;

            if ( _hue == 360 )
            {
                _hue = 0;
            }
            else if ( _hue > 360 || _hue < 0 )
            {
                return ( "0" );
            }
            //_hue %= 360;

            _saturation = _saturation / 100;
            _value = _value / 100;
            _hue = _hue / 60;
            var _loc5:Number = Math.floor( _hue );
            var _loc11:Number = _hue - _loc5;
            var _loc6:Number = _value * ( 1 - _saturation );
            var _loc9:Number = _value * ( 1 - _saturation * _loc11 );
            var _loc8:Number = _value * ( 1 - _saturation * ( 1 - _loc11 ));
            if ( _loc5 == 0 )
            {
                red = _value;
                green = _loc8;
                blue = _loc6;
            }
            else if ( _loc5 == 1 )
            {
                red = _loc9;
                green = _value;
                blue = _loc6;
            }
            else if ( _loc5 == 2 )
            {
                red = _loc6;
                green = _value;
                blue = _loc8;
            }
            else if ( _loc5 == 3 )
            {
                red = _loc6;
                green = _loc9;
                blue = _value;
            }
            else if ( _loc5 == 4 )
            {
                red = _loc8;
                green = _loc6;
                blue = _value;
            }
            else if ( _loc5 == 5 )
            {
                red = _value;
                green = _loc6;
                blue = _loc9;
            }
            //trace( "HSV (", _hue, _saturation, _value, ") is", ( fracToHex( red ).toString() + fracToHex( green ).toString() + fracToHex( blue ).toString()));
            return fracToHex( red ).toString() + fracToHex( green ).toString() + fracToHex( blue ).toString();
        }

        public static function fracToHex( f:Number ):String
        {
            if ( f == 0 )
            {
                return ( "00" );
            }
            else
            {
                f = Math.round( 255 * f );
                var _loc2:String = Math.floor( f / 16 ).toString();
                var _loc1:String = ( f % 16 ).toString();
                _loc2 = getHex( parseFloat( _loc2 ));
                _loc1 = getHex( parseFloat( _loc1 ));
                return ( _loc2 + _loc1 );
            }
        }

        public static function getHex( x:Number ):String
        {
            var _loc1:String = "0123456789ABCDEF";
            return ( _loc1.charAt( x ));
        }

        private static function numToHex( val:Number ):String
        {
            var tens:Number = Math.floor( val / 16 );
            var units:Number = val % 16;
            trace( val, "=", ( getHex( tens ) + getHex( units )));
            return getHex( tens ) + getHex( units );
        }

    }
}