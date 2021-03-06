package couk.psyked.pixelbender
{

	import flash.display.Shader;
	import flash.display.ShaderParameter;
	import flash.utils.ByteArray;

	/**
	 * Generated by PBJtoAS http://blog.minim.pl/PBJtoAS
	 *
	 * namespace : com.rphelan
	 * vendor : Ryan Phelan
	 * version : 1
	 * description : Colored lighting effect that generates a spotlight and ambient light.
	 */

	public dynamic class SpotlightShader extends Shader
	{

		static private var instance:SpotlightShader;

		private var data2:Object;

		public function SpotlightShader()
		{
			var ba:ByteArray = new ByteArray();
			var bytes:Array = 'F85A2DD4CDEB93D194BD7351FCCC2649AC859998A838ACB445DD45E96B42 520A8882EE4CCDE5B 1E4A6E42645F6B53F403D2E5A2A6052 5BFA0CB976D5A2D749FC8F72E3C773DB7C91A36E9A986 64B3B771EF34F396F112F86 0AFF53C9A24F9AF5E5E498F5DA46A BEC90F584BAE9FFF9B858913DA841213BA712EEBA444B7DA889DE68E4EDCF8C33B8CDE0D0C3D7E41DE1BC48793C19765221688612B3CE36833135A5BAF9106FC4F930AD92B1 CF21185D11015 3 3A86986D17FDDAC12DC4116F1E418 07B7679EE3E192643AE1DAD83CD5DA4C760586A47496B2837ABB07D23F474DE259F9798FF47D6D7ECC53B3DDC159EBDBBB9155F49496911C12BB023E43BA7F0ECDCA025E3C93679 3 F97C8B687 0849B51C15C5F4DF76640B7AE43578FA55C 051C99331BEBB1F25CD912C871788C2C8829335EE1C65D15219 75FF8FAD9C02071F61C64A24962FCFF1AE0ED6917F383 1DC 0E521B9C8894D57FF732DBCB940781B3915 D1F98FF44EB2349 F64BFDC37CCE72B2B F5FFC7C7499F6B66C60483497506AE6B9FC93AB 0 73685EF6D435F 76447838A78B6BC8B23197C88FE858567DDBAD7C8C23BCA4D74B32BAACF7530CA67B97560 63A47F53F A338AFAD854FD4C4BF5BE5B1A 7D230A8CA9C61C91A643D269EF2FD29 633AA6E21DD47EFB937 E339A1DFD4A57A9DA94CD1EB74913AEF02479A1C762237DB8931CC35154F83FB141195CC7B8D36F91 AC769F1F156E01CBB61F1D957543E8D76DB6A17FBA8A4 E7B9F68E8D35DA5DE76E9323E A6ADBAAF99795AF6396B5 EF53629DF7A57F85A F4415F952C377B0E2DF6A9D546171C3A25FDE1D73 E4A5B14F7A8DA94EB949D4257553E15DEF98FA3292F2AFDD7708D96C51BF5B5477A AA64FF591B659 7 B20297548392E66EB615C457D314E9597FFCCFC 76F29BC6BEE71BEA8FA6A9E25AE56E728F7A47535EB4A4FD53E98B74EB7F43E21F87DA93F8D66F1A6FD E6E13F3B41F65283E92C76FCD79F014AED37779DAAF6BF6F4BF7799DABF79AB4A3E963FEB599F4E788BEF69AF3C46DFF8CBFF619D7D 5737C 593FF 576D74C78ABEE692F3846DFF1CBFF459D7D95737C8593FFA36DCF7DCF55267C14FE DF2 E6E637E7A553CAA3F 0F3 F5E7FBF3269129C'.split( '' );
			var i:uint = 0;

			while ( bytes.length )
			{
				ba.position = i;
				ba.writeByte( parseInt( bytes.shift() + bytes.shift(), 16 ) - 128 );
				i++;
			}
			ba.uncompress();

			super( ba );
			data2 = this[ 'data' ];
		}

		public function setDefaultParameters():void
		{
			var j:uint;

			for ( var i:String in data2 )
			{
				if ( data2[ i ] is ShaderParameter )
				{
					if ( data2[ i ].value[ 0 ] is Array )
					{
						for ( j = 0; j < data2[ i ].value.length; j++ )
						{
							ShaderParameter( data2[ i ]).value[ j ] = ShaderParameter( data2[ i ])[ 'defaultValue' ][ j ].concat();
						}
					}
					else
					{
						ShaderParameter( data2[ i ]).value = ShaderParameter( data2[ i ])[ 'defaultValue' ].concat();
					}
				}
			}
		}

		public function get azimuth():Number
		{
			return Number( data2.azimuth.value[ 0 ]);
		}

		/**
		 * @param float_ from 0 to 90
		 */
		public function set azimuth( float_:Number ):void
		{
			data2.azimuth.value[ 0 ] = float_;
		}

		public function get coneAngle():Number
		{
			return Number( data2.coneAngle.value[ 0 ]);
		}

		/**
		 * @param float_ from 0.10000000149011612 to 10
		 */
		public function set coneAngle( float_:Number ):void
		{
			data2.coneAngle.value[ 0 ] = float_;
		}

		public function get angle():Number
		{
			return Number( data2.angle.value[ 0 ]);
		}

		/**
		 * @param float_ from 0 to 360
		 */
		public function set angle( float_:Number ):void
		{
			data2.angle.value[ 0 ] = float_;
		}

		public function get intensity():Number
		{
			return Number( data2.intensity.value[ 0 ]);
		}

		/**
		 * @param float_ from 0.009999999776482582 to 50
		 */
		public function set intensity( float_:Number ):void
		{
			data2.intensity.value[ 0 ] = float_;
		}

		public function get ambientColor():Array
		{
			return new Array( data2.ambientColor.value );
		}

		/**
		 * @param float3_ from 0,0,0 to 1,1,1
		 */
		public function set ambientColor( float3_:Array ):void
		{
			data2.ambientColor.value = float3_;
		}

		public function get spotColor():Array
		{
			return new Array( data2.spotColor.value );
		}

		/**
		 * @param float3_ from 0,0,0 to 1,1,1
		 */
		public function set spotColor( float3_:Array ):void
		{
			data2.spotColor.value = float3_;
		}

		public function get position():Array
		{
			return new Array( data2.position.value );
		}

		/**
		 * @param float3_ from 0,0,0 to 1000,1000,1000
		 */
		public function set position( float3_:Array ):void
		{
			data2.position.value = float3_;
		}

		public function get distance():Number
		{
			return Number( data2.distance.value[ 0 ]);
		}

		/**
		 * @param float_ from 0.10000000149011612 to 50
		 */
		public function set distance( float_:Number ):void
		{
			data2.distance.value[ 0 ] = float_;
		}

		static public function getInstance():SpotlightShader
		{
			if ( instance )
			{
				return instance;
			}
			else
			{
				instance = new SpotlightShader();
				return instance;
			}
		}
	}
}