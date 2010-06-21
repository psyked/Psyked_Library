package couk.psyked.pixelbender
{

	import flash.display.Shader;
	import flash.display.ShaderParameter;
	import flash.utils.ByteArray;

	/**
	 * Generated by PBJtoAS http://blog.minim.pl/PBJtoAS
	 *
	 * namespace : emile.info
	 * vendor :
	 * version : 1
	 * description : Median: Simple 3x3 median filter
	 */

	public dynamic class MediansimpleShader extends Shader
	{

		static private var instance:MediansimpleShader;

		private var data2:Object;

		public function MediansimpleShader()
		{
			var ba:ByteArray = new ByteArray();
			var bytes:Array = 'F85A6D194DEA5BD090 5 FEC5916FFEAD93264CDB1E85DC5A9ED69221BDE683AF45187A8A1D640905B41F6C31773A889ED77FD 352C792FA 1EAF4C7EAF411B6A1 4A4A81B31FD3E23B977CE96 37D4B8270F3 2CF71EAFD327D325EDC1C47D7136D49A6BEDC1C1C46 8B76B737865FAFB36435564B25E2EF6FB604A39 C77 775EE8BAB7BF4959FCE776B BA33F57 FF99F6987C5EF3E3F 9B679C751597A7C986FF1EDF5 049574F5F E9FF73B7D8ABFE09F7627386E58965C5561 857C074 740F546F559415F6CA52C3C7E462BAE12CE76BE7BBC6D62F94EE7C7784FF7 56F8AEFA369B25FC5EA8B7F616673ED61ED61FBC8EC66ED24BD61 BBC5CE759933EA7FC9FC9 F799E523E11A7677B4277 59FA069B35FC7BAB072647CC078 1708E1281738324 E11 7FDCBC7F8C778A192 7F9876950481373C361 742 F108C199FA29D99F9F2FEA47CC878B1129173A324639B4FDF EC19DDDD5D7574866BA8175F4D5FDDD238157E7A0C7D7B554B59AF11D4299E7754594EA4A6FADA2E4B95EE62FAD4E13754BA46634BEE515708E7AAF73E93D56C74C177E A4F8565FA D4F65BE 5BE6573D6FC4AED4869F21FC2F7 D1C2E6835BEE23E74D7FCB3105B10137F 116 56E9AB9E7D033 61CB36ED368B3A367CC74DA9FB1DF7A DB93473FB8873EB67F037F3E86F337EBE1F7A3DBC16735DF74EDB76537B 212FDC1493E20E4DFD032AFA85997146C8BCA7685A57BC2D6BD5997BCA82FA1 727B92DFB4639BD51EBFD44FC692F78FC1057B09F1F7B943AE74C47 7729BF27A5C2750FDA327AFFA2D F18AF7D955F9C64B7641CF31FC277 D1CF328F9C34EB977A9743911F3AEFA2D F18AF7D469C5A79BD 47935F3385BB93477D9FF1FCF7DDE9E4B796EBB67AD7B69FD 1E4DFA05997C8768512FD 1E4DFA05997C8768512FDA12B 16C8B81D45010A3609C 59E98678EC42F75654FAF7D95DF888A9A6693F21FC28F C79 4D0E1C34E107B94FAE8648CC52F759173253F62DB 042 61C8B6ED3682111F38135E8483960BE 53EB0F2AEC42F759173255F18C3BB3F 7B03FF68EF7BB 776BE6B6F73295F4BE3B95FFD673CE5BF7E1D 2FF37D8DA7AF7 A2C127EDE B77353C66737887DC8464F4'.split( '' );
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

		static public function getInstance():MediansimpleShader
		{
			if ( instance )
			{
				return instance;
			}
			else
			{
				instance = new MediansimpleShader();
				return instance;
			}
		}
	}
}