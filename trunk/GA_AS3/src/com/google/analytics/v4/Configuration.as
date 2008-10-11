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

package com.google.analytics.v4
{
    import com.google.analytics.core.Domain;
    import com.google.analytics.core.DomainNameMode;
    import com.google.analytics.core.Organic;
    import com.google.analytics.core.ServerOperationMode;
    import com.google.analytics.events.MessageEvent;
    
    import flash.events.EventDispatcher;
    
    /**
     * Dispatched when the configuration notify an info.
     * @eventType com.google.analytics.events.MessageEvent.INFO
     */
    [Event(name="info", type="com.google.analytics.events.MessageEvent")]       
    
    /**
     * Dispatched when the configuration notify a warning.
     * @eventType com.google.analytics.events.MessageEvent.WARNING
     * @see #addOrganicSource
     */
    [Event(name="warning", type="com.google.analytics.events.MessageEvent")]    
    
    /**
     * Google Analytic Tracker Code (GATC)'s configuration / state component.
     * This encapsulates all the configurations for the entire GATC module.
     */
    public class Configuration extends EventDispatcher
    {
        
        private var _version:String          = "4.3as";
        
        /**
         * Sampling percentage of visitors to track.
         * @private
         */
        private var _sampleRate:Number       = 1; //100%
        
        /**
         * @private
         */        
        private var _trackingLimitPerSession:int = 500;
        
        /**
         * @private
         */         
        private var _domain:Domain = new Domain( DomainNameMode.auto );
        
        private var _organic:Organic = new Organic();
        
        /**
         * @private
         */         
        private var _organicCache:Object  = {};
        
        /**
         * @private
         */         
        private var _organicSources:Array = [];
        
        /**
         * Automatic / Organic keyword to ignore.
         * @private
         */
        private var _organicIgnore:Array = [];
        
        /**
         * Referral domains to ignore.
         * @private
         */
        private var _referralIgnore:Array = [];
        
        /**
         * Substring of host names to ignore when auto decorating href anchor elements for outbound link tracking.
         * @private
         */
        private var _ignoredOutboundHosts:Array = [];
        
        /**
         * This is the cse path that needs to be ignored for Google.
         * All referers with path cse from google donmains will be ignored from organic and referrer campaigns.
         * @private
         */
        public  var googleCsePath:String = "cse";
        
        /**
         * The parameter used by google for the search keyword.
         * @private
         */
        public var googleSearchParam:String = "q";
        
        /**
         * Google string value.
         * @private
         */
        public var google:String = "google";
        
        /**
         * Name used by the SharedObject (read-only)
         */
        private var _cookieName:String = "analytics";
        
        /**
         * Unique domain hash for cookies.
         */
        public var allowDomainHash:Boolean  = true;
        
        /**
         * Enable use of anchors for campaigns.
         */
        public var allowAnchor:Boolean      = false ;
        
        /**
         * Enable linker functionality.
         */
        public var allowLinker:Boolean      = false ;
        
        /**
         * Indicates if has site overlay.
         */
        public var hasSiteOverlay:Boolean   = false ;
        
        /**
         * The rate of token being released into the token bucket.
         * Unit for this parameter is number of token released per second.
         * This is set to 0.20 right now, which translates to 1 token released every 5 seconds.
         */
        public var tokenRate:Number        = 0.20;
        
        /**
         * Default cookie expiration time in seconds. (6 months).
         */
        public var conversionTimeout:Number = 15768000;
        
        /**
         * Default inactive session timeout in seconds (30 minutes).
         */
        public var sessionTimeout:Number = 1800;
        
        /**
         * Upper limit for number of href anchor tags to examine.  
         * <p>If this number is set to -1, then we will examine all the href anchor tags.</p>
         * <p>In other words, a -1 value indicates that there is no upper limit.</p>
         * <p><b>Note:</b> maybe use Number.INFINITY instead of -1</p>
         */
        public var maxOutboundLinkExamined:Number = 1000;
        
        /**
         * The number of tokens available at the start of the session.
         */
        public var tokenCliff:int = 10;
        
        /**
         * Capacity of the token bucket.
         */
        public var bucketCapacity:Number = 10;
                
        /**
         * Detect client browser information flag.
         */
        public var detectClientInfo:Boolean  = true;
        
        /**
         * Flash version detection option.
         */
        public var detectFlash:Boolean = true;
        
        /**
         * Set document title detection option.
         */
        public var detectTitle:Boolean = true;
        
        /**
         * Track campaign information flag.
         */
        public var campaignTracking:Boolean = true;
        
        
        /**
         * Boolean flag to indicate if outbound links for subdomains of the current domain 
         * needs to be considered as outbound links. Default value is false.
         */
        public var isTrackOutboundSubdomains:Boolean = false;
        
        /**
         * Actual service model.
         * <p><b>Note :</b> "service" is wrong we name it server</p>
         */
        public var serverMode:ServerOperationMode = ServerOperationMode.remote;
        
        /**
         * Local service mode GIF url.
         */
        public var localGIFpath:String = "/__utm.gif";
        
        /**
         * The remote service mode GIF url.
         */
        public var remoteGIFpath:String = "http://www.google-analytics.com/__utm.gif";
        
        /**
         * The secure remote service mode GIF url.
         */
        public var secureRemoteGIFpath:String = "https://ssl.google-analytics.com/__utm.gif";
        
        /**
         * Default cookie path to set in document header.
         */
        public var cookiePath:String = "/" ; //SharedObjectPath
        
        /**
         * Delimiter for e-commerce transaction fields.
         */
        public var transactionFieldDelim:String = "|";
        
        /**
         * The domain name value.
         */
        public var domainName:String = "";
        
        
        //---- Not part of GA API ----
        
        /**
         * Indicates the debug mode activity.
         */
        public var debug:Boolean = true;
        
        //to trace infos and warnign to the output
        public var debugTrace:Boolean = true;
        
        //to show more debug used internally
        public var debugVerbose:Boolean = true;
        
        /* send a Gir Request with validation or not
           
           without validation (use sendToURL())
           it's fire and forget
           ok: send the request but does not returns any success or failure
           cancel: does not send the request
           
           with validation (use URLLoader.load())
           ok: returns success when received by the the server
               returns failure if not received by the server, or gif not found, or error etc.
           cancel: does not send the request
        */
        public var validateGIFRequest:Boolean = true;
        
        /* allow to debug the GIF Request
           if true, will show a debug panel
           and a confirmation message to send or not
           the request.
        */
        public var debugGIFRequest:Boolean = true;
        
        //to show extended info and warning messages
        //from the GA docs
        public var verbose:Boolean = true;
        
        /**
         * Indicates if show infos in the debug mode.
         */        
        public var showInfos:Boolean = true;
        
        /**
         * Indicates if show warnings in the debug mode.
         */                
        public var showWarnings:Boolean = true;
        
        //to be able to track in local mode (when protocol is file://)
        public var allowLocalTracking:Boolean = true;
        
        /**
         * Creates a new Configuration instance.
         */
        public function Configuration()
        {
            _initOrganicSources();
        }
        
        /**
         * @private
         */
        private function _initOrganicSources():void
        {
            addOrganicSource( google,            googleSearchParam );
            addOrganicSource( "yahoo",          "p"                );
            addOrganicSource( "msn",            "q"                );
            addOrganicSource( "aol",            "query"            );
            addOrganicSource( "aol",            "encquery"         );
            addOrganicSource( "lycos",          "query"            );
            addOrganicSource( "ask",            "q"                );
            addOrganicSource( "altavista",      "q"                );
            addOrganicSource( "netscape",       "query"            );
            addOrganicSource( "cnn",            "query"            );
            addOrganicSource( "looksmart",      "qt"               );
            addOrganicSource( "about",          "terms"            );
            addOrganicSource( "mamma",          "query"            );
            addOrganicSource( "alltheweb",      "q"                );
            addOrganicSource( "gigablast",      "q"                );
            addOrganicSource( "voila",          "rdata"            );
            addOrganicSource( "virgilio",       "qs"               );
            addOrganicSource( "live",           "q"                );
            addOrganicSource( "baidu",          "wd"               );
            addOrganicSource( "alice",          "qs"               );
            addOrganicSource( "yandex",         "text"             );
            addOrganicSource( "najdi",          "q"                );
            addOrganicSource( "aol",            "q"                );
            addOrganicSource( "club-internet",  "q"                );
            addOrganicSource( "mama",           "query"            );
            addOrganicSource( "seznam",         "q"                );
            addOrganicSource( "search",         "q"                );
            addOrganicSource( "wp",             "szukaj"           );
            addOrganicSource( "onet",           "qt"               );
            addOrganicSource( "netsprint",      "q"                );
            addOrganicSource( "google.interia", "q"                );
            addOrganicSource( "szukacz",        "q"                );
            addOrganicSource( "yam",            "k"                );
            addOrganicSource( "pchome",         "q"                );
            addOrganicSource( "kvasir",         "searchExpr"       );
            addOrganicSource( "sesam",          "q"                );
            addOrganicSource( "ozu",            "q"                );
            addOrganicSource( "terra",          "query"            );
            addOrganicSource( "nostrum",        "query"            );
            addOrganicSource( "mynet",          "q"                );
            addOrganicSource( "ekolay",         "q"                );
            addOrganicSource( "search.ilse",    "search_for"       );
        }
        
        /**
         * Indicates the version String representation of the application.
         */
        public function get version():String
        {
            return _version;
        }
        
        public function get cookieName():String
        {
            return _cookieName;
        }
        
        /**
        * Domain name for cookies.
        * (auto | none | domain)
        * If this variable is set to "auto",
        * then we will try to resolve the domain name
        * based on the HTMLDocument object.
        * 
        * note:
        * for Flash we try to auto detect
        * the domain name by using the URL info
        * if we are in HTTP or HTTPS
        * 
        * if we can not detect the protocol or find file://
        * then the "auto" domain is none.
        */
        public function get domain():Domain
        {
            return _domain;
        }
        
        
        /**
         * Indicates the sample rate value of the application.
         */
        public function get sampleRate():Number
        {
            return _sampleRate;
        }
        
        /**
        * Sampling percentage of visitors to track.
        *
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
        * This is the max number of tracking requests to the backend
        * allowed per session.
        */
        public function get trackingLimitPerSession():int
        {
            return _trackingLimitPerSession;
        }
        
        
        public function get organic():Organic
        {
            return _organic;
        }
        
        public function get organicSources():Array
        {
            return _organicSources;
        }
        
        public function set organicSources(sources:Array):void
        {
            _organicSources = sources;
        }
        
        
        /**
         * Adds a new organic source.
         * @param engine The engine value.
         * @param keyword The keyword of the specified engine value.
         */
        public function addOrganicSource(engine:String, keyword:String):void
        {
//            var orgref:OrganicReferrer = new OrganicReferrer(engine, keyword);
//            if( !_organicCache[orgref.toString()] )
//            {
//                _organicSources.push(orgref);
//                _organicCache[orgref.toString()] = true ;
//            }
//            else if( debug )
//            {
//                var message:String = orgref.toString()+" already exists, we don't add it";
//                trace( "## WARNING: "+message+" ##" );
//                dispatchEvent( new MessageEvent(MessageEvent.WARNING,false,true, message ) );
//            }
            
            try
            {
                _organic.addSource( engine, keyword );
            }
            catch( e:Error )
            {
                if( debug )
                {
                    trace( "## WARNING: "+e.message+" ##" );
                    dispatchEvent( new MessageEvent(MessageEvent.WARNING,false,true, e.message ) );
                }
            }
            
        }
        
        /**
         * Removes all organic sources.
         */
        public function clearOrganicSources():void
        {
            _organic.clear();
        }
        
        
    }
}