package com.gnstudio.nabiro.utilities.pdf.pdfbox.parser
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
	
	import com.gnstudio.nabiro.utilities.pdf.pdfbox.cos.COSDocument;
	import com.gnstudio.nabiro.utilities.pdf.pdfbox.cos.COSObject;
	import com.gnstudio.nabiro.utilities.pdf.pdfbox.persistence.util.COSObjectKey;
	
	import mx.collections.ArrayCollection;

	public class ConflictObj
	{
		public var offset:int;
        public var key:COSObjectKey;
        public var pdfObject:COSObject;
        
		public function ConflictObj( offset:int, key:COSObjectKey, pdfObject:COSObject )
		{
			this.offset = offset;
            this.key = key;
            this.pdfObject = pdfObject;
		}
		
		private static function resolveConflicts(document:COSDocument, conflictList:ArrayCollection):void
		{
			for each (var o:ConflictObj in conflictList.list)
			{
				var offset:int = o.offset as int;
				if ( document.getXrefTable().getValue( String(offset) ) != null )
				{
				    var pdfObject:COSObject = document.getObjectFromPool(o.key);
				    pdfObject.baseObject = o.pdfObject.baseObject;
				}
			}

		}
	}
}
