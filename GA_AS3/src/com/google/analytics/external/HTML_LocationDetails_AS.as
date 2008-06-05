/*
 * Copyright 2008 Adobe Systems Inc., 2008 Google Inc.Licensed under the Apache License, 
 * Version 2.0 (the "License");you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at    
 * http://www.apache.org/licenses/LICENSE-2.0Unless required by applicable law or agreed to in writing, 
 * software distributed under the License is distributed on an 
 * "AS IS" BASIS,WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, 
 * either express or implied.See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.google.analytics.external
{
	public class HTML_LocationDetails_AS
	{
		public static const LOCATION_REQUEST_STRING:String = "document.location";
		public static const LOCATION_SEARCH_STRING:String = "search";
		public static const LOCATION_HASH_STRING:String = "hash";
		public static const LOCATION_HREF_STRING:String = "href";
		public static const LOCATION_PROTOCOL_STRING:String = "protocol";
		public static const LOCATION_PATHNANE_STRING:String = "pathname";
		public static const LOCATION_HOSTNANE_STRING:String = "hostname";
		
		private var search_:String;
		private var hash_:String;
		private var href_:String;
		private var protocol_:String;
		private var hostname_:String;
		private var pathname_:String;
		
		private var externalSetSearch:String;
		private var externalSetHash:String;
		private var externalSetHref:String;
		private var externalSetProtocol:String;
		private var externalSetHostname:String;
		private var externalSetPathname:String;
		
		public function get search():String
		{
			if(externalSetSearch != null)
				return externalSetSearch;
			return search_;
		}
		public function get hash():String
		{
			if(externalSetHash != null)
				return externalSetHash;
			return hash_;
		}
		public function get href():String
		{
			if(externalSetHref != null)
				return externalSetHref;
			return href_;
		}
	
		public function get protocol():String
		{

			if(externalSetProtocol != null)
				return externalSetProtocol;
	
			if( !protocol_ )
				return "http:";  // for non dom based case we assume that it is http. 
				// (this is needed for finding the gif_reguest path -- refer the usage of
				// protocol in GA_gif_request_AS
			return protocol_;
		}
		
		public function get hostname():String
		{
			if(externalSetHostname != null)
				return externalSetHostname;

			return hostname_;
			
		}
		public function get pathname():String
		{
			if(externalSetPathname != null)
				return externalSetPathname;

			return pathname_;
		}
		public function HTML_LocationDetails_AS()
		{
			var locationObj:Object = ExternalInterfaceMethods_AS.getDetailsFromHtmlDOM(LOCATION_REQUEST_STRING);
			if(locationObj)
			{
				search_ =locationObj[LOCATION_SEARCH_STRING];
				hash_ =locationObj[LOCATION_HASH_STRING];
				href_ =locationObj[LOCATION_HREF_STRING];
				protocol_ =locationObj[LOCATION_PROTOCOL_STRING];
				hostname_ = locationObj[LOCATION_HOSTNANE_STRING];
				pathname_ = locationObj[LOCATION_PATHNANE_STRING];
			}
		}
		
		
		// special setters for the nonDOm users
		
		public function setSearch(search:String):void
		{
			externalSetSearch = search;
		}
		
		public function setHash(hash:String):void
		{
			externalSetHash = hash;
		}
		
		public function setHref(href:String):void
		{
			externalSetHref = href;
		}
		
		public function setProtocol(protocol:String):void
		{
			externalSetProtocol = protocol;
		}
		
		public function setHostName(hostname:String):void
		{
			externalSetHostname = hostname;
		}
		
		public function setPathName(pathName:String):void
		{
			externalSetPathname = pathName;
		}
	
		

	}
}