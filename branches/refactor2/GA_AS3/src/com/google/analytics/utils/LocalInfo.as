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

package com.google.analytics.utils
{
    import com.google.analytics.core.ga_internal;
    
    import flash.display.Stage;
    import flash.system.Capabilities;
    import flash.external.ExternalInterface;
    
    public class LocalInfo
    {
        private var _stage:Stage;
        private var _protocol:Protocols = null;
        
        public function LocalInfo( stage:Stage = null )
        {
            _stage = stage;
        }
        
        ga_internal function set stage( value:Stage ):void
        {
            _stage = value;
        }
        
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
        
        public function get protocol():Protocols
        {
            if(_protocol == null)
            {
                _findProtocol();
            }
            
            return _protocol;
        }
        
        public function isInHTML():Boolean
        {
            return Capabilities.playerType == "PlugIn";
        }
        
        public function canBridgeToJS():Boolean
        {
            return ExternalInterface.available;
        }

    }
}