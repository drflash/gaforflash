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
 */

package com.google.analytics.v4
{
    import com.google.analytics.core.Domain;
    import com.google.analytics.core.DomainNameMode;
    import com.google.analytics.core.OrganicReferrer;
    import com.google.analytics.core.ServerOperationMode;    

    /**
     * The Configuration class.
     */
    public class Configuration
    {
        
        /**
         * @private
         */
        private var _allowDomainHash:Boolean = true;
                
        /**
         * @private
         */
        private var _domain:Domain = new Domain( DomainNameMode.auto );
        
        /**
         * @private
         */
        private var _hasSiteOverlay:Boolean  = false;        
        
        /**
         * @private
         */
        private var _localGIFpath:String = "/__utm.gif";

        /**
         * @private
         */
        private var _organicCache:Object  = {};
        
        /**
         * @private
         */
        private var _organicSources:Array = [];

        /**
         * @private
         */
        private var _remoteGIFpath:String = "http://www.google-analytics.com/__utm.gif";

        /**
         * @private
         */
        private var _sampleRate:Number       = 1; //100%

        /**
         * @private
         */
        private var _secureRemoteGIFpath:String = "https://ssl.google-analytics.com/__utm.gif";
        
        /**
         * @private
         */
        private var _serverMode:ServerOperationMode = ServerOperationMode.remote;

        /**
         * @private
         */
        private var _trackClientInfo:Boolean  = true;

        /**
         * @private
         */
        private var _trackDetectFlash:Boolean = true;

        /**
         * @private
         */
        private var _trackDetectTitle:Boolean = true;

        /**
         * @private
         */
        private var _version:String = "f4";
        
        /**
         * Creates a new Configuration instance.
         */
        public function Configuration()
        {
            
            addOrganicSource("google",         "q"         );
            addOrganicSource("yahoo",          "p"         );
            addOrganicSource("msn",            "q"         );
            addOrganicSource("aol",            "query"     );
            addOrganicSource("aol",            "encquery"  );
            addOrganicSource("lycos",          "query"     );
            addOrganicSource("ask",            "q"         );
            addOrganicSource("altavista",      "q"         );
            addOrganicSource("netscape",       "query"     );
            addOrganicSource("cnn",            "query"     );
            addOrganicSource("looksmart",      "qt"        );
            addOrganicSource("about",          "terms"     );
            addOrganicSource("mamma",          "query"     );
            addOrganicSource("alltheweb",      "q"         );
            addOrganicSource("gigablast",      "q"         );
            addOrganicSource("voila",          "rdata"     );
            addOrganicSource("virgilio",       "qs"        );
            addOrganicSource("live",           "q"         );
            addOrganicSource("baidu",          "wd"        );
            addOrganicSource("alice",          "qs"        );
            addOrganicSource("yandex",         "text"      );
            addOrganicSource("najdi",          "q"         );
            addOrganicSource("aol",            "q"         );
            addOrganicSource("club-internet",  "q"         );
            addOrganicSource("mama",           "query"     );
            addOrganicSource("seznam",         "q"         );
            addOrganicSource("search",         "q"         );
            addOrganicSource("wp",             "szukaj"    );
            addOrganicSource("onet",           "qt"        );
            addOrganicSource("netsprint",      "q"         );
            addOrganicSource("google.interia", "q"         );
            addOrganicSource("szukacz",        "q"         );
            addOrganicSource("yam",            "k"         );
            addOrganicSource("pchome",         "q"         );
            addOrganicSource("kvasir",         "searchExpr");
            addOrganicSource("sesam",          "q"         );
            addOrganicSource("ozu",            "q"         );
            addOrganicSource("terra",          "query"     );
            addOrganicSource("nostrum",        "query"     );
            addOrganicSource("mynet",          "q"         );
            addOrganicSource("ekolay",         "q"         );
            
        }
        
        /**
         * Indicates the if the domain hash is allow.
         */
        public function get allowDomainHash():Boolean
        {
            return _allowDomainHash;
        }
        
        /**
         * @private
         */
        public function set allowDomainHash(value:Boolean):void
        {
            _allowDomainHash = value;
        }
        
        /**
         * Indicates the domain name String representation.
         */
        public function get domainName():String
        {
            return _domain.name;
        }
        
        /**
         * Indicates the event tracker project id value.
         */
        public function get eventTrackerProjectId():int
        {
            return 5;
        }
                
        /**
         * Indicates the URL of __utm.gif in Urchin software.
         */
        public function get localGIFpath():String
        {
            return _localGIFpath;
        }
        
        /**
         * @private
         */
        public function set localGIFpath(path:String):void
        {
            _localGIFpath = path;
        }

        /**
         * Indicates the Array representation of all organic sources of the application.
         */
        public function get organicSources():Array
        {
            return _organicSources;
        }
        
        /**
         * @private
         */
        public function set organicSources(sources:Array):void
        {
            _organicSources = sources;
        }

        /**
         * Indicates the remote URL of __utm.gif in Urchin software.
         */        
        public function get remoteGIFpath():String
        {
            return _remoteGIFpath;
        }
        
        /**
         * Indicates the sample rate value of the application.
         */
        public function get sampleRate():Number
        {
            return _sampleRate;
        }
        
        /**
         * @private
         */
        public function set sampleRate( value:Number ):void
        {
            if( value <= 0 )
            {
                value = 0.1;
            }
            
            if( value > 1 )
            {
                value = 1;
            }
            
            value = Number( value.toFixed( 2 ) );
            
            _sampleRate = value;
        }        
        
        /**
         * Indicates the secure remote URL of __utm.gif in Urchin software.
         */
        public function get secureRemoteGIFpath():String
        {
            return _secureRemoteGIFpath;
        }
        
        /**
         * Indicates the ServerOperationMode object.
         */
        public function get serverMode():ServerOperationMode
        {
            return _serverMode;
        }        
        
        /**
         * @private
         */
        public function set serverMode(mode:ServerOperationMode):void
        {
            _serverMode = mode;
        }        
        
        /**
         * Indicates if the track has a client info.
         */
        public function get trackClientInfo():Boolean
        {
            return _trackClientInfo;
        }
        
        /**
         * @private
         */
        public function set trackClientInfo(value:Boolean):void
        {
            _trackClientInfo = value;
        }
        
        public function get trackDetectFlash():Boolean
        {
            return _trackDetectFlash;
        }

        /**
         * @private
         */
        public function set trackDetectFlash(value:Boolean):void
        {
            _trackDetectFlash = value;
        }
        
        public function get trackDetectTitle():Boolean
        {
            return _trackDetectTitle;
        }
        
        /**
         * @private
         */        
        public function set trackDetectTitle(value:Boolean):void
        {
            _trackDetectTitle = value;
        }
                
        /**
         * Indicates the version String representation of the application.
         */
        public function get version():String
        {
            return _version;
        }        
        
        /**
         * Adds a new organic source.
         * @param engine The engine value.
         * @param keyword The keyword of the specified engine value.
         */
        public function addOrganicSource(engine:String, keyword:String):void
        {
            var orgref:OrganicReferrer = new OrganicReferrer(engine, keyword);
            if( !_organicCache[orgref.toString()] )
            {
                _organicSources.push(orgref);
                _organicCache[orgref.toString()] = true ;
            }
            else
            {
                trace( "## WARNING: " + orgref.toString() + " already exists, we don't add it ##" );
            }
        }
        
        /**
         * Removes all organic sources.
         */        
        public function clearOrganicSources():void
        {
            _organicCache   = {};
            _organicSources = [];
        }
        
        
    }
}