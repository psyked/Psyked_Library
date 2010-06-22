package com.gnstudio.nabiro.utilities.pdf.events
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
	
	import flash.events.Event;
	
	public class PDFDocumentEvent extends Event
	{
		// Event constants
		public static const LOAD_COMPLETE:String = "pdf_documentLoadComplete";
		public static const PARSE_COMPLETE:String = "pdf_documentParseComplete";
		public static const PARSE_ERROR:String = "pdf_documentParseError";
		public static const FONT_ELABORATION_COMPLETE:String = "pdf_documentFontElaborationError";
		public static const FONT_ELABORATION_ERROR:String = "pdf_documentFontElaborationError";		
		

		public function PDFDocumentEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
