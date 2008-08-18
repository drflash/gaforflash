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
    import com.google.analytics.core.ga_internal;
    import com.google.analytics.external.HTMLDOM;
    import com.google.ui.Layout;
    
    import flash.system.Capabilities;
    
    /**
     * Local Informations provide informations for the local environment.
     */
    public class LocalInfo
    {
        private var _url:String;
        private var _protocol:Protocols;
        private var _userAgent:UserAgent;
        private var _dom:HTMLDOM;
        private var _layout:Layout;
        
        /**
         * Creates a new LocalInfo instance.
         * @param stage The Stage reference of the application.
         */
        public function LocalInfo( url:String = "", dom:HTMLDOM = null, layout:Layout = null )
        {
            if( dom == null )
            {
                dom = new HTMLDOM();
            }
            
            _url = url;
            _dom = dom;
            
            _layout = layout; //optional
            
            if( _layout )
            {
                var data:String = "";
                    data       += "dom.language: " + _dom.language + "\n";
                    data       += "dom.location: " + _dom.location + "\n";
                    data       += "dom.protocol: " + _dom.protocol + "\n";
                    data       += "dom.host:     " + _dom.host + "\n";
                    data       += "dom.search:   " + _dom.search + "\n";
                _layout.createInfo( data );
            }
            
        }
        
        /**
         * Sets the stage reference value of the application.
         */
        ga_internal function set url( value:String ):void
        {
            _url = value;
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
         * <pre>
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
        /* Returns the flash version as an Object
           with the following properties
           major, minor, build, revision
        */
        public function get flashVersion():Version
        {
            var v:Version = Version.fromString( Capabilities.version.split( " " )[1], "," );
            
            return v;
        }
        
        /* Returns the language string
           as a lowercase two-letter language code from ISO 639-1.
           
           TODO:
           if we can bridge to JS we can return a more precise string
           from the browser as "en-GB" instead of "en".
        */
        /**
         * Indicates the current language value of the application.
         * @see Capabilities.language
         */
        public function get language():String
        {
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
        
        /* Returns the operating system string.
           
           note:
           the flash documentation indicate those strings
           "Windows XP"
           "Windows 2000"
           "Windows NT"
           "Windows 98/ME"
           "Windows 95"
           "Windows CE" (available only in Flash Player SDK, not in the desktop version)
           "Linux"
           "MacOS"
           
           other strings we can obtain (not documented(
           "Mac OS 10.5.4"
           "Windows Vista"
        */
        /**
         * Indicates the current operating system value of the application.
         * @see Capabilities.os
         */        
        public function get operatingSystem():String
        {
            return Capabilities.os ;
        }
        
        
        /* Returns the player type.
           
           note:
           the flash documentation indicate those strings
           
           "ActiveX"
            for the Flash Player ActiveX control used by Microsoft Internet Explorer
           
           "Desktop"
            for the Adobe AIR runtime (except for SWF content loaded by an HTML page,
            which has Capabilities.playerType set to "PlugIn")
           
           "External"
            for the external Flash Player
           
           "PlugIn"
            for the Flash Player browser plug-in
            (and for SWF content loaded by an HTML page in an AIR application)
           
           "StandAlone"
            for the stand-alone Flash Player
        */
        /**
         * Indicates the current player type value of the application.
         * @see Capabilities.playerType
         */                
        public function get playerType():String
        {
            return Capabilities.playerType;
        }
        
        
        /* Returns the platform.
           can be "Windows", "Macintosh" or "Linux"
        */
        /**
         * Indicates the current platform value of the application.
         * @see Capabilities.manufacturer
         */            
        public function get platform():String
        {
            var p:String = Capabilities.manufacturer;
            return p.split( "Adobe " )[1];
        }
        
        /* Returns the user agent.
        */
        public function get userAgent():UserAgent
        {
            if( !_userAgent )
            {
                 _userAgent = new UserAgent(this);
            }
            
            return _userAgent;
        }
        
        /* Define a custom user agent.
           
           For case where the user would want
           to define its own application name and version.
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
            return Capabilities.playerType == "PlugIn";
        }
        
    }
}