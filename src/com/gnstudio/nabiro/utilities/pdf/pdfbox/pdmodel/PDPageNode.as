package com.gnstudio.nabiro.utilities.pdf.pdfbox.pdmodel
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
	
	import com.gnstudio.nabiro.utilities.pdf.pdfbox.cos.COSArray;
	import com.gnstudio.nabiro.utilities.pdf.pdfbox.cos.COSBase;
	import com.gnstudio.nabiro.utilities.pdf.pdfbox.cos.COSDictionary;
	import com.gnstudio.nabiro.utilities.pdf.pdfbox.cos.COSInteger;
	import com.gnstudio.nabiro.utilities.pdf.pdfbox.cos.COSName;
	
	import mx.collections.ArrayCollection;

	public class PDPageNode
	{
		
		private var _page:COSDictionary;
		
		public function PDPageNode(pages:COSDictionary=null)
		{
			if (!pages)
			{
				_page = new COSDictionary();
		        _page.setItem( COSName.TYPE, COSName.PAGES );
		        _page.setItem( COSName.KIDS, new COSArray() );
	    	    _page.setItem( COSName.COUNT, new COSInteger( 0 ) );				
			}
			else
			{
				_page = pages;
			}

		}
		
		public static function PDPageNode_PagesFactory( ):PDPageNode
		{
			return new PDPageNode();	
		}
		
		public function get page():COSDictionary
		{
			return _page;
		}

		public function getAllKids(page:COSDictionary, recurse:Boolean):ArrayCollection
		{
			var kids:COSBase = page.getDictionaryObject( COSName.KIDS );
			return new ArrayCollection();
		}
	}
}
