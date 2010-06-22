package com.gnstudio.nabiro.utilities.pdf
{
	
	/**
	 *
	 * GNstudio nabiro
	 * =====================================================================
	 * Copyright(c) 2009
	 * http://www.gnstudio.com
	 *
	 *
	 *
	 * This file is part of the nabiro flash platform framework
	 *
	 *
	 * nabiro is free software; you can redistribute it and/or modify
	 * it under the terms of the GNU Lesser General Public License as published by
	 * the Free Software Foundation; either version 3 of the License, or
	 * at your option) any later version.
	 *
	 * nabiro is distributed in the hope that it will be useful,
	 * but WITHOUT ANY WARRANTY; without even the implied warranty of
	 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	 * GNU General Public License for more details.
	 *
	 * You should have received a copy of the GNU Lesser General Public License
	 * along with Intelligere SCS; if not, write to the Free Software
	 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
	 * =====================================================================
	 *
	 *
	 *
	 *   @package  nabiro
	 *
	 *   @version  0.9
	 *   @author 					Igor Varga [ i.varga@gnstudio.com ]
	 *	 
	 */
	
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;

	public class DataStream
	{
		private static const BYTEARRAY:String = "ByteArray";
		private static const FILESTREAM:String = "FileStream";
		
		private var _streamType:String;
		
		private var _byteStream:ByteArray;
		private var _fileStream:FileStream;
		
		public function DataStream(stream:*)
		{
			if ( !setStream(stream) )
			{
				throw new Error("DataStream must be properly initialized.");
			}
		}
		
		private function setStream(stream:*):Boolean
		{
			if (stream is FileStream)
			{
				_fileStream = stream;
				_streamType = DataStream.FILESTREAM;
				return true;
			}
			
			if (stream is ByteArray)
			{
				_byteStream = stream;
				_streamType = DataStream.FILESTREAM;
				return true;
			}
			
			return false;
		}
		
		public function get streamType():String
		{
			return _streamType;
		}

		public function get dataInput():IDataInput
		{
			
			if (_fileStream) return _fileStream;
			if (_byteStream) return _byteStream;
			
			throw new Error("Unable to get data stream");
			
			return null;
			
		}
		
		public function get dataOutput():IDataOutput
		{
			
			if (_fileStream) return _fileStream;
			if (_byteStream) return _byteStream;
			
			throw new Error("Unable to get data stream");
			
			return null;
			
		}
	}
}
