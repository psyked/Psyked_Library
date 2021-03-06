package couk.psyked.pixelbender
{

	import flash.display.Shader;
	import flash.display.ShaderParameter;
	import flash.utils.ByteArray;

	/**
	 * Generated by PBJtoAS http://blog.minim.pl/PBJtoAS
	 *
	 * namespace : Kevin's Tutorial Filters
	 * vendor : Kevin's Filters, Inc
	 * version : 1
	 * description : Fade from color to B&W to sepia
	 */

	public dynamic class FadetohistoryShader extends Shader
	{

		static private var instance:FadetohistoryShader;

		private var data2:Object;

		public function FadetohistoryShader()
		{
			var ba:ByteArray = new ByteArray();
			var bytes:Array = 'F85A DD141EA94C1942C6E19EC8659605E94E42085 9A0 1E89045C3F647C4226241CB50E398E6FAE1E0F6FA691EDD74B6D771AEC490B6D12FA2418F488744CF88687E 178833E6E9E57CB 46DCBCD3DD7756A7166B38370E98DFBE9AE7755134254CA3F1EF52BF4A44DB84DA41E49E9D15DB4E2FFC21DA2AD45DED156D29B4C3AD3D965CAAF94EDE3C3BC2DB24C22A9FD972A82A3E5AECD26 BF1ED39CD92C32DC6A2D3255222D6E2E77D2585A347C5 AA346 16E4173C93D2B144E 953 ABC534A18A1D9F14CC6C575A2ADA7927691CDDFF91AB81A4BE1BAA96BFF A F88 D4EF044C3 64B3929F11B639750C34C701B639A36B81A7E6161FB42E4F06552B621587E7978CB9CE04EF0956B 41CB0A6D3C083295F6B1F1DFD27FEE34F9790F21C3A7A605179A65593C65BD0BD317518FB9FF318E0 B747D 7EF6EFBDD63F4369F37F3982155112FD9641DFC3DFEE15E66 7132572B622BBCB64A5 B3C373B6FAE4C B3EBDD8AA2FF363FC 9BC51567DFD393FF79C12494E8D6DAFF5A89C2EE09EFADD8FA4211C5E 01437824FE356B456F9576EC278374F5DDE277F1F4B5B39B4BFA03C877F2C1E377A96 53BC387BF5C5CCE6BDB757B87 49D4BA34CD7AC FFC1FD1BD32F5 679AA619F18A2208A'.split( '' );
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

		public function get crossfade():Number
		{
			return Number( data2.crossfade.value[ 0 ]);
		}

		/**
		 * @param float_ from 0 to 2
		 */
		public function set crossfade( float_:Number ):void
		{
			data2.crossfade.value[ 0 ] = float_;
		}

		static public function getInstance():FadetohistoryShader
		{
			if ( instance )
			{
				return instance;
			}
			else
			{
				instance = new FadetohistoryShader();
				return instance;
			}
		}
	}
}