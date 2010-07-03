package couk.psyked.pixelbender
{

	import flash.display.Shader;
	import flash.display.ShaderParameter;
	import flash.utils.ByteArray;

	/**
	 * Generated by PBJtoAS http://blog.minim.pl/PBJtoAS
	 *
	 * namespace : com.om-labs.filters.hsv
	 * vendor : Om Labs
	 * version : 1
	 * description : Controlling a Hue Saturation and Value of an Image
	 */

	public dynamic class HsvfilterShader extends Shader
	{

		static private var instance:HsvfilterShader;

		private var data2:Object;

		public function HsvfilterShader()
		{
			var ba:ByteArray = new ByteArray();
			var bytes:Array = 'F85A15D45D A53D0901E1C244936944C35D2B8177EE091513D75E0C1D69076E2E1EFA55B26ED20CDCA1296AF73A85DD55F40FB83BE116C8BB8B3676427E9E5B5B75379793E19FCB34DF78B803E7561626A7AC3344A43F4BF C 3F518ED 2E98853E4BDCE56AFD741CDB61EF3B69BAF339D6C 73BB01EA5A9DC2E65A7CC427EEC 739A8 9414264AC4C26E93449491FA4F11EA62BD594AFE4A0AF36213C8A72ED9AD0D28671CCDE87AB8CA6F3F46447F5308861569280434F175BFC12A4698C3E 21325D33895 E85 FE6D9 E85B834D8EEC3383356D14C8C706B8D109BFC516E 45DD9B88F362BDC 768E1281555A33499FE96878C6F A3FB188B83BC92345B2 F43AC7BFF 6D7B67C8670E164403D8DCFE0A4C0B998C7AB9DD0E4FD878A68E3DC5436 4118D857E 4 1 98F1A3822B8DA 9BFC1308572FD 4547157BDF470F9 6CE F72D6D1D08415828B2D 3F92A3359A2EFCF571D 3FE1ED6FDBAB82CABE89E4136A49EC9F864115C8763547A6D81CFC1BC2A616179245275BE7188368A9CD74FE33B4443F37944E721F5EB7E3266E71E2262D1 62778E71E6AFD4FDBFC6FB7403A18FAE4C7 B3A8A1A9DF5824DA7C9EF2C7799 7FD6884862CC389FD342E5E BA4 A91475543753C876615D4775C4C515D8365A7BFF81E833D2B78 BEA9FA7F4273CB038D36F4FFBB3F39C6DDF18BB9324C74977ACBA7DC9BF4768ED9B1D9FB77761B7FA709C7C7EA3D74FC3F85285FD6EAF582ADAEF1BF5D2F53ED54F7A623E35 E2E6E 3F85CF7514117263E4163BEFC667120203CE0DB71B02F6F 14EB32F29EB73FA2D3EAD9D7D5E 97BA75DAA9DDD2D23CF6F55561166E961E5 3E71CF28D5E709C6155E1FF3F4117862FBA784E7FCA3570223983216F20461BB978AE3A7F4B96DEB5F8E57025412BA37C21BE4A4CF7FC2F8FD95A97FF47BC739D724C5DFA745DC5EB413D 75F65BFA96A8050'.split( '' );
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

		public function get brightness():Number
		{
			return Number( data2.brightness.value[ 0 ]);
		}

		/**
		 * @param float_ from -1 to 1
		 */
		public function set brightness( float_:Number ):void
		{
			data2.brightness.value[ 0 ] = float_;
		}

		public function get saturation():Number
		{
			return Number( data2.saturation.value[ 0 ]);
		}

		/**
		 * @param float_ from -1 to 1
		 */
		public function set saturation( float_:Number ):void
		{
			data2.saturation.value[ 0 ] = float_;
		}

		public function get hue():Number
		{
			return Number( data2.hue.value[ 0 ]);
		}

		/**
		 * @param float_ from -180 to 180
		 */
		public function set hue( float_:Number ):void
		{
			data2.hue.value[ 0 ] = float_;
		}

		static public function getInstance():HsvfilterShader
		{
			if ( instance )
			{
				return instance;
			}
			else
			{
				instance = new HsvfilterShader();
				return instance;
			}
		}
	}
}