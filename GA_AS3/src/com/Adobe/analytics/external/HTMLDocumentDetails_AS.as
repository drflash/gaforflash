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

package com.Adobe.analytics.external
{
	public class HTMLDocumentDetails_AS
	{		
		public static const TITLE_REQUEST_STRING:String = "document.title";
		public static const DOMAIN_REQUEST_STRING:String = "document.domain";
		public static const LINKS_REQUEST_STRING:String = "document.links";
		public static const REFERRER_REQUEST_STRING:String = "document.referrer";
		public static const COOKIE_REQUEST_STRING:String = "document.cookie";
		public static const CHARACTERSET_REQUEST_STRING:String = "document.characterSet";
		public static const CHARASET_REQUEST_STRING:String = "document.charset";
		public static const UTMFORM_REQUEST_STRING:String = "document.utmform";
		public static const LOCATION_REF_STRING:String = "document.location.href";
		
	
		//*************************
		private var title_:String;
		public function get title():String
		{
			return title_;
		}
		
		
		
		//*************************
		private var domain_:String;
		public function get domain():String
		{
			domain_ = String(ExternalInterfaceMethods_AS.getDetailsFromHtmlDOM(DOMAIN_REQUEST_STRING));
			return domain_;
		}
		
		
		//*************************
		private var links_:Array;
		public function get links():Array
		{
			return links_;
		}
		
		
		//*************************
		private var referrer_:String;
		private var externalSetRefferer:String;
		public function get referrer():String
		{
			if(externalSetRefferer != null)
				return externalSetRefferer;
			return referrer_;
		}
		
		public function setReferrer(referrrer:String):void
		{
			// this function is given only for setting this values
			// externally from the application.
			// i.e this is not set referrer. it is 'setRefferer' .. i.e it is 
			// not the setter for the referrer back to DOM
			// if the user has given these values, this has higher preferance.
			externalSetRefferer = referrrer;
		}
		//*************************
		private var cookie_:String;
		public function get cookie():String
		{
			cookie_ = String(ExternalInterfaceMethods_AS.getDetailsFromHtmlDOM(COOKIE_REQUEST_STRING));
			return cookie_;
		}	
		
		public function set cookie(cookie_String:String):void
		{
			ExternalInterfaceMethods_AS.setDetailsOnHtmlDOM(COOKIE_REQUEST_STRING,cookie_String);
		}
		
		
		
		//*************************
		private var characterSet_:String;
		public function get characterSet():String
		{
			return characterSet_;
		}
		
		
		
		//*************************
		private var charset_:String;
		public function get charset():String
		{
			return charset_;
		}
		
		
		
		//*************************
		private var utmform_:Object;
		public function get utmform():Object
		{
			return utmform_;
		}
		
		
		//*************************
		private var locationObj_:HTML_LocationDetails_AS;
		public function get locationObj():HTML_LocationDetails_AS
		{
			return locationObj_;
		}
		
		
		//*************************
		private var location_search_:String;
		public function get location_search():String
		{
			return location_search_;
		}
		
		//*************************
		private var location_hash_:String;
		public function get location_hash():String
		{
			return location_hash_;
		}
		
		
		//*************************
		private var location_href_:String;
		public function get location_href():String
		{
			return location_href_;
		}
		public function set location_href(href_String:String):void
		{
			ExternalInterfaceMethods_AS.setDetailsOnHtmlDOM(LOCATION_REF_STRING,href_String);
		}
		
		
		
		//*************************
		
		private var location_protocol_:String;
		public function get location_protocol():String
		{
			return location_protocol_;
		}
		
		
		private var location_host_:String;
		public function get location_host():String
		{
			return location_host_;
		}
	
	
		private var location_pathName_:String;
		public function get location_pathName():String
		{
			return location_pathName_;
		}
	
		public function HTMLDocumentDetails_AS()
		{
			init();
		}
		
		private function init():void
		{
			title_ = String(ExternalInterfaceMethods_AS.getDetailsFromHtmlDOM(TITLE_REQUEST_STRING));
			domain_ = String(ExternalInterfaceMethods_AS.getDetailsFromHtmlDOM(DOMAIN_REQUEST_STRING));
			links_ = ExternalInterfaceMethods_AS.getDetailsFromHtmlDOM(LINKS_REQUEST_STRING) as Array;
			referrer_ = String(ExternalInterfaceMethods_AS.getDetailsFromHtmlDOM(REFERRER_REQUEST_STRING));
			cookie_ = String(ExternalInterfaceMethods_AS.getDetailsFromHtmlDOM(COOKIE_REQUEST_STRING));
			characterSet_ = String(ExternalInterfaceMethods_AS.getDetailsFromHtmlDOM(CHARACTERSET_REQUEST_STRING));
			charset_ = String(ExternalInterfaceMethods_AS.getDetailsFromHtmlDOM(CHARASET_REQUEST_STRING));
			utmform_ = ExternalInterfaceMethods_AS.getDetailsFromHtmlDOM(UTMFORM_REQUEST_STRING);
			locationObj_ = new HTML_LocationDetails_AS();
			location_search_ = locationObj.search;
			location_hash_ = locationObj.hash;
			location_href_ = locationObj.href;
			location_protocol_ = locationObj.protocol;
			location_host_ = locationObj.hostname;
			location_pathName_ = locationObj.pathname;
		}
		
		public function getElementById(idString:String):Object
		{
			return ExternalInterfaceMethods_AS.getElementById(idString);
		} 
		
		

	}
}