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

package com.google.analytics.utils
{
    
    import com.google.analytics.config;
    import com.google.analytics.core.ga_internal;
    import com.google.analytics.external.HTMLDOM;
    import com.google.ui.Layout;
    
    import flash.system.Capabilities;
    import flash.system.Security;
    
    
    /**
     * Local Informations provide informations for the local environment.
     */
    public class LocalInfo
    {
        /**
         * @private
         */        
        private var _dom:HTMLDOM;
        
        /**
         * @private
         */        
        private var _layout:Layout;    	
    	
        /**
         * @private
         */        
        private var _protocol:Protocols;
        
        private var _appName:String;
        
        private var _appVersion:Version;
        
        /**
         * @private
         */        
        private var _userAgent:UserAgent;

        /**
         * @private
         */
        private var _url:String;
        
        /**
         * Creates a new LocalInfo instance.
         * @param url The URL of the SWF.
         * @param app The application name
         * @param version The application version
         * @param dom the HTMLDOM
         * @param layout a Layout reference
         */
        public function LocalInfo( url:String = "", app:String = "", version:String = "", dom:HTMLDOM = null,
                                   layout:Layout = null )
        {
            var v:Version;
            
            if( app == "" )
            {
                if( isAIR() )
                {
                    app = "AIR";
                }
                else
                {
                    app = "Flash";
                }
            }
            
            if( version == "" )
            {
                v = flashVersion;
            }
            else
            {
                v = Version.fromString( version );
            }
            
            if( dom == null )
            {
                dom = new HTMLDOM();
            }
            
            _url        = url;
            _appName    = app;
            _appVersion = v;
            _dom        = dom;
            
            _layout = layout; //optional
            
            //DEBUG
            if( _layout && config.debug && config.debugVerbose )
            {
                var data:String = "";
                    data       += "dom.language: " + _dom.language + "\n" ;
                    data       += "dom.location: " + _dom.location + "\n" ;
                    data       += "dom.protocol: " + _dom.protocol + "\n" ;
                    data       += "dom.host:     " + _dom.host     + "\n" ;
                    data       += "dom.search:   " + _dom.search   + "\n" ;
                _layout.createInfo( data );
            }
            
        }
        
        /**
         * @private
         */
        private function _findProtocol():void
        {
            var p:Protocols = Protocols.none;
            
            if(_url != "")
            {
                // file://
                // http://
                // https://
                var URL:String = _url.toLowerCase();
                var test:String = URL.substr(0,5);
                
                switch( test )
                {
                    case "file:":
                    p = Protocols.file;
                    break;
                    
                    case "http:":
                    p = Protocols.HTTP;
                    break;
                    
                    case "https":
                    if(URL.charAt(5) == ":")
                    {
                        p = Protocols.HTTPS;
                    }
                    break;
                    
                    default:
                    _protocol = Protocols.none;
                }
            }
            
            /*TODO:
              if _url is not found (if someone forgot to add the tracker to the display list)
              we could use the alternative to get the dom.location and find the protocol from that string
              off course only if we have access to ExternalInterface
            */
            
            
            var _proto:String = _dom.protocol;
            
            //debug
            if( _layout )
            {
                var proto:String = (p.toString()+":").toLowerCase();
                
                if( _proto && _proto != proto )
                {
                    _layout.createWarning( "Protocol mismatch: SWF="+proto+", DOM="+_proto );
                }
                
            }
            
            _protocol = p;
        }
        
        public function get appName():String
        {
            return _appName;
        }
        
        public function set appName( value:String ):void
        {
            _appName = value;
            userAgent.applicationProduct = value;
        }
        
        public function get appVersion():Version
        {
            return _appVersion;
        }
        
        public function set appVersion( value:Version ):void
        {
            trace( "appVersion: " + value.toString(4) );
            _appVersion = value;
            userAgent.applicationVersion = value.toString(4);
        }
        
        /**
         * Sets the stage reference value of the application.
         */
        ga_internal function set url( value:String ):void
        {
            _url = value;
        }
        
        /**
         * Indicates the local domain name value.
         */
        public function get domainName():String
        {
            if( protocol == Protocols.HTTP ||
                protocol == Protocols.HTTPS )
            {
                var URL:String = _url.toLowerCase();
                var str:String;
                var end:int;
                
                if( protocol == Protocols.HTTP )
                {
                    str = URL.split( "http://" ).join( "" );
                }
                else if( protocol == Protocols.HTTPS )
                {
                    str = URL.split( "https://" ).join( "" );
                }
                
                end = str.indexOf( "/" );
                str = str.substring(0,end);
                
                return str;
            }
        
            return "";
        }
        
        /**
         * Returns the flash version object representation of the application. 
         * <p>This object contains the attributes major, minor, build and revision :</p>
         * <p><b>Example :</b></b>
         * <pre class="prettyprint">
         * import com.google.analytics.utils.LocalInfo ;
         * 
         * var info:LocalInfo = new LocalInfo( "http://www.domain.com" ) ;
         * var version:Object = info.flashVersion ;
         * 
         * trace( version.major    ) ; // 9
         * trace( version.minor    ) ; // 0
         * trace( version.build    ) ; // 124
         * trace( version.revision ) ; // 0
         * </pre>
         * @return the flash version object representation of the application.
         */
        public function get flashVersion():Version
        {
            var v:Version = Version.fromString( Capabilities.version.split( " " )[1], "," ) ;
            return v ;
        }
        
        /**
         * Returns the language string as a lowercase two-letter language code from ISO 639-1.
         * @see Capabilities.language
         */
        public function get language():String
        {

            /* 
                TODO:
                if we can bridge to JS we can return a more precise string
                from the browser as "en-GB" instead of "en".
            */

            var _lang:String = _dom.language;
            var lang:String  = Capabilities.language;
            
            if( _lang )
            {
                if( (_lang.length > lang.length) &&
                    (_lang.substr(0,lang.length) == lang) )
                {
                    lang = _lang;
                }
            }
            
            return lang;
        }
                
        /**
         * Returns the operating system string.
         * <p><b>Note:</b> The flash documentation indicate those strings</p>
         * <li>"Windows XP"</li>
         * <li>"Windows 2000"</li>
         * <li>"Windows NT"</li>
         * <li>"Windows 98/ME"</li>
         * <li>"Windows 95"</li>
         * <li>"Windows CE" (available only in Flash Player SDK, not in the desktop version)</li>
         * <li>"Linux"</li>
         * <li>"MacOS"</li>
         * <p>Other strings we can obtain ( not documented : "Mac OS 10.5.4" , "Windows Vista")</p> 
         * @see Capabilities.os
         */        
        public function get operatingSystem():String
        {
            return Capabilities.os ;
        }
                        
        /**
         * Returns the player type.
         * <p><b>Note :</b> The flash documentation indicate those strings.</p>
         * <li><b>"ActiveX"</b>    : for the Flash Player ActiveX control used by Microsoft Internet Explorer.</li>
         * <li><b>"Desktop"</b>    : for the Adobe AIR runtime (except for SWF content loaded by an HTML page, which has Capabilities.playerType set to "PlugIn").</li>
         * <li><b>"External"</b>   : for the external Flash Player "PlugIn" for the Flash Player browser plug-in (and for SWF content loaded by an HTML page in an AIR application).</li>
         * <li><b>"StandAlone"</b> : for the stand-alone Flash Player.</li>
         * @see Capabilities.playerType
         */                       
        public function get playerType():String
        {
            return Capabilities.playerType;
        }
        
        /**
         * Returns the platform, can be "Windows", "Macintosh" or "Linux"
         * @see Capabilities.manufacturer
         */            
        public function get platform():String
        {
            var p:String = Capabilities.manufacturer;
            return p.split( "Adobe " )[1];
        }
        
        /**
         * Indicates the Protocols object of this local info.
         */
        public function get protocol():Protocols
        {
            if(!_protocol)
            {
                _findProtocol();
            }
            
            return _protocol;
        }        
        
        public function get screenResolution():String
        {
            return Capabilities.screenResolutionX + "x" + Capabilities.screenResolutionY;
        }
        
        /**
         * Defines a custom user agent.
         * For case where the user would want to define its own application name and version
         * it is possible to change appName and appVersion which are in sync with
         * applicationProduct and applicationVersion properties
         */
        public function get userAgent():UserAgent
        {
            /* note:
               if we change appName then we update applicationProduct
               if we change appVersion then we update applicationVersion
               but the inverse is not true.
            */
            if( !_userAgent )
            {
                 _userAgent = new UserAgent(this, appName, appVersion.toString(4));
            }
            
            return _userAgent;
        }
        
        /**
         * @private
         */
        public function set userAgent( custom:UserAgent ):void
        {
            _userAgent = custom;
        }
        
        /**
         * Indicates if the SWF is embeded in an HTML page.
         * @return true if the SWF is embeded in an HTML page.
         */
        public function isInHTML():Boolean
        {
            return Capabilities.playerType == "PlugIn" ;
        }
        
        //are we running in AIR ?
        public function isAIR():Boolean
        {
            return (playerType == "Desktop") && (Security.sandboxType.toString() == "application");
        }
        
    }
}