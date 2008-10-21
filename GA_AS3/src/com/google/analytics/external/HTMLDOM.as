/*
 * Copyright 2008 Adobe Systems Inc., 2008 Google Inc.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * 
 * Contributor(s):
 *   Zwetan Kjukov <zwetan@gmail.com>.
 *   Marc Alcaraz <ekameleon@gmail.com>.
 */

package com.google.analytics.external
{
	import com.google.analytics.debug;
	
	/**
	 * Object to contain HTML Document Object Model.
	 */
    public class HTMLDOM extends JavascriptProxy
    {        
	    private var _location:String = "";
        private var _protocol:String = "";   
        private var _host:String = "";
        private var _pathname:String = "";
        private var _search:String = "";
        private var _referrer:String = "";
        private var _title:String = "";
        private var _language:String = "";
        private var _characterSet:String = "";
        private var _colorDepth:String = "";
		
		/**
		 * Constructor for HTMLDOM
		 */
        public function HTMLDOM()
        {
        	getDomProperties();       	
        }
        
        /**
        * Grabs all DOM properties and sets this objects values.
        * Pulling document.location insures we also get port and hash values 
        */
        public function getDomProperties():void {
        	
        	var domString:String = "";
        	var domValues:Array = new Array();
        	
        	var domXML:XML = 
        		<script>
        			 <![CDATA[
                	function()
                	{
        				var dom = "";
						var dlim = "$";
        				
        				dom += document.location +dlim; 
        				dom += document.location.protocol +dlim;
						dom += document.location.host +dlim;
						dom += document.location.pathname +dlim;
						dom += document.location.search +dlim;
						dom += document.referrer +dlim;
						dom += document.title +dlim;
						dom += (navigator.language?navigator.language:navigator.browserLanguage) +dlim;
						dom += (document.characterSet?document.characterSet:document.charset) +dlim;
						dom += window.screen.colorDepth;
        				
        				return dom;
					}	
					]]>
        		</script>;
        	
        	domString = jsExternal( domXML );
        	domValues = domString.split('$');
        	
        	if(domValues.length < 10 && debug.verbose && isAvailable()) {
        		debug.warning("Not all browser values have been returned from HTMLDOM")
        	}
        	
        	_location 		= domValues[0];
        	_protocol 		= domValues[1]; 
        	_host 			= domValues[2];
        	_pathname 		= domValues[3];
        	_search 		= domValues[4];
        	_referrer 		= domValues[5];
            _title 			= domValues[6];        	
            _language 		= domValues[7];
            _characterSet 	= domValues[8];
            _colorDepth 	= domValues[9];
            
            if (debug.verbose) {
            	var msg:String ="";
            	msg += "document.location = "				+_location;
            	msg += "\ndocument.location.protocol = "	+ _protocol;
            	msg += "\ndocument.location.host = "		+ _host;
            	msg += "\ndocument.location.pathname = " 	+_pathname;
            	msg += "\ndocument.location.search = " 		+_search;
            	msg += "\ndocument.referrer = " 			+_referrer;
            	msg += "\ndocument.title = " 				+_title;
            	msg += "\nnavigator.language = " 			+_language;
            	msg += "\ndocument.characterSet = " 		+_characterSet;
            	msg += "\nwindow.screen.colorDepth = " 		+_colorDepth;
            	debug.info(msg);
            }
     
        }
        
        
       /**
        * Returns the 'document.location' String value from the HTML DOM.
        */     
        public function get location():String
        {
           return _location;
        }   
         
        /**
         * Returns the 'document.location.protocol' String value from the HTML DOM.
         */       
        public function get protocol():String
        {
        	return _protocol;
        } 
             
       /**
        * Returns the 'document.location.host' String value from the HTML DOM.
        */
        public function get host():String
        {
        	return _host;
        }
        
       /**
        * Returns the 'document.location.pathname' String value from the HTML DOM.
        */                
        public function get pathname():String
        {
        	return _pathname;
        }
        
        /**
        * Returns the 'document.location.search' String value from the HTML DOM.
        */        
        public function get search():String
        {
           return _search;
        }
        
        /**
        * Returns the 'document.referrer' String value from HTML DOM
        */        
        public function get referrer():String
        { 
        	return _referrer;
        }
        
       /**
        * Returns the 'document.title' String value from HTML DOM
        */ 
        public function get title():String
        {
        	return _title; 
        }
        
          
       /**
        * Returns the 'nvigator.langage' or 'navigator.browserLanguage' String value from the HTML DOM.
        */
        public function get language():String
        {
           return _language;
        }
        
                
        /**
        * Returns the 'document.characterSet' or 'document.charset' String value from the HTML DOM.
        */ 
        public function get characterSet():String
        {
        	return _characterSet;
        }
        
        /**
        * Returns the 'document.characterSet' or 'document.charset' String value from the HTML DOM.
        */       
        public function get colorDepth():String
        {
        	return _colorDepth;
        }
        
        
    }
}
