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
    
    import flash.display.Stage;
    import flash.external.ExternalInterface;
    import flash.system.Capabilities;
    
    /**
     * Local Informations provide informations for the local environment.
     */
    public class LocalInfo
    {
<<<<<<< .mine
        private var _stage:Stage;
        private var _protocol:Protocols;
=======
>>>>>>> .r39
        
<<<<<<< .mine
        private static var _userAgent:UserAgent;
        
=======
        /**
         * @private
         */	
        private var _stage:Stage ;
        
        /**
         * @private
         */
        private var _protocol:Protocols = null ;
        
        /**
         * Creates a new LocalInfo instance.
         * @param stage The Stage reference of the application.
         */
>>>>>>> .r39
        public function LocalInfo( stage:Stage = null )
        {
            _stage = stage;
        }
        
        /**
         * Sets the stage reference value of the application.
         */
        ga_internal function set stage( value:Stage ):void
        {
            _stage = value;
        }
        /**
         * @private
         */
        private function _findProtocol():void
        {
            var p:Protocols = Protocols.none;
            
            if(_stage)
            {
                // file://
                // http://
                // https://
                var URL:String = _stage.loaderInfo.url.toLowerCase();
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
                    if(URL.charAt(6) == ":")
                    {
                        p = Protocols.HTTPS;
                    }
                    break;
                    
                    default:
                    _protocol = Protocols.none;
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
        
<<<<<<< .mine
        public function get domainName():String
=======
        /**
         * Returns the flash version object representation of the application. 
         * <p>This object contains the attributes major, minor, build and revision :</p>
         * <p><b>Example :</b></b>
         * <pre>
         * import com.google.analytics.utils.LocalInfo ;
         * 
         * var info:LocalInfo = new LocalInfo( this ) ;
         * var version:Object = info.flashVersion ;
         * 
         * trace( version.major    ) ; // 9
         * trace( version.minor    ) ; // 0
         * trace( version.build    ) ; // 124
         * trace( version.revision ) ; // 0
         * </pre>
         * @return the flash version object representation of the application.
         */
        public static function get flashVersion():Object
>>>>>>> .r39
        {
<<<<<<< .mine
            if( protocol == Protocols.HTTP ||
                protocol == Protocols.HTTPS )
            {
                var URL:String = _stage.loaderInfo.url.toLowerCase();
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
=======
            var v:String = Capabilities.version;
                v = v.split( " " )[1];
            
            var o:Array = v.split( "," );
>>>>>>> .r39
            
            return "";
        }
        
<<<<<<< .mine
        /* Returns the flash version as an Object
           with the following properties
           major, minor, build, revision
        */
        public function get flashVersion():Version
=======
        /**
         * Indicates the current language value of the application.
         * @see Capabilities.language
         */
        public static function get language():String
>>>>>>> .r39
        {
<<<<<<< .mine
            var v:Version = Version.fromString( Capabilities.version.split( " " )[1], "," );
            
            return v;
        }
        
        /* Returns the language string
           as a lowercase two-letter language code from ISO 639-1.
           
           TODO:
           if we can bridge to JS we can return a more precise string
           from the browser as "en-GB" instead of "en".
        */
        public function get language():String
        {
            return Capabilities.language;
=======
            return Capabilities.language ;
>>>>>>> .r39
        }
        
<<<<<<< .mine
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
        public function get operatingSystem():String
=======
        /**
         * Indicates the current operating system value of the application.
         * @see Capabilities.os
         */        
        public static function get operatingSystem():String
>>>>>>> .r39
        {
            return Capabilities.os ;
        }
        
<<<<<<< .mine
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
        public function get playerType():String
=======
        /**
         * Indicates the current player type value of the application.
         * @see Capabilities.playerType
         */                
        public static function get playerType():String
>>>>>>> .r39
        {
            return Capabilities.playerType;
        }
        
<<<<<<< .mine
        /* Returns the platform.
           can be "Windows", "Macintosh" or "Linux"
        */
        public function get platform():String
=======
        /**
         * Indicates the current platform value of the application.
         * @see Capabilities.manufacturer
         */            
        public static function get platform():String
>>>>>>> .r39
        {
            var p:String = Capabilities.manufacturer;
            return p.split( "Adobe " )[1];
        }
        
<<<<<<< .mine
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
        
=======
        /**
         * Indicates if the application can be bridged with the external Javascript scripts.
         * @return true if the application can be bridged with the external Javascript scripts.
         */     
        public function canBridgeToJS():Boolean
        {
            return ExternalInterface.available;
        }        
        
        /**
         * Indicates if the application is embed in a HTML application.
         * @return true if the application is embed in a HTML application.
         */
>>>>>>> .r39
        public function isInHTML():Boolean
        {
            return Capabilities.playerType == "PlugIn";
        }
        
    }
}