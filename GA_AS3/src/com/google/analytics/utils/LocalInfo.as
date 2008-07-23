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
                //trace( "protocol: " + test );
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
                        p = Protocols.HTTP;
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
            if(_protocol == null)
            {
                _findProtocol();
            }
            
            return _protocol;
        }
        
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
        {
            var v:String = Capabilities.version;
                v = v.split( " " )[1];
            
            var o:Array = v.split( "," );
            
            var version:Object   = {};
                version.major    = o[0];
                version.minor    = o[1];
                version.build    = o[2];
                version.revision = o[3];
           
           return version;
        }
        
        /**
         * Indicates the current language value of the application.
         * @see Capabilities.language
         */
        public static function get language():String
        {
            return Capabilities.language ;
        }
        
        /**
         * Indicates the current operating system value of the application.
         * @see Capabilities.os
         */        
        public static function get operatingSystem():String
        {
            return Capabilities.os ;
        }
        
        /**
         * Indicates the current player type value of the application.
         * @see Capabilities.playerType
         */                
        public static function get playerType():String
        {
            return Capabilities.playerType;
        }
        
        /**
         * Indicates the current platform value of the application.
         * @see Capabilities.manufacturer
         */            
        public static function get platform():String
        {
            var p:String = Capabilities.manufacturer;
            return p.split( "Adobe " )[1];
        }
        
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
        public function isInHTML():Boolean
        {
            return Capabilities.playerType == "PlugIn";
        }
        
    }
}