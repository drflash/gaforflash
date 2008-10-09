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

package com.google.analytics.core
{
    import com.google.analytics.config;
    import com.google.analytics.utils.Environment;
    import com.google.analytics.utils.Version;
    
    import flash.net.URLVariables;
    
    public class BrowserInfo
    {
        private var _info:Environment;
        
        public function BrowserInfo( info:Environment )
        {
            _info = info;
        }
        
        /**
        * Language encoding for the browser.
        * Some browsers don't set this, in which case it is set to "-".
        * 
        * ex:
        * utmcs=ISO-8859-1
        */
        public function get utmcs():String
        {
            return _info.languageEncoding;
        }
        
        /**
        * Screen resolution
        * 
        * ex:
        * utmsr=2400x1920
        */
        public function get utmsr():String
        {
            return _info.screenWidth + "x" + _info.screenHeight;
        }
        
        /**
        * Screen color depth
        * 
        * ex:
        * utmsc=24-bit
        */
        public function get utmsc():String
        {
            return _info.screenColorDepth + "-bit";
        }
        
        /**
        * Browser language.
        * 
        * ex:
        * utmul=pt-br
        */
        public function get utmul():String
        {
            return _info.language;
        }
        
        /**
        * Indicates if browser is Java-enabled.
        * 
        * ex:
        * utmje=1
        */
        public function get utmje():String
        {
            return "0"; //not supported
        }
        
        /**
        * Flash Version.
        * 
        * ex:
        * utmfl=9.0%20r48
        */
        public function get utmfl():String
        {
            if( config.detectFlash )
            {
                var v:Version = _info.flashVersion;
                return v.major+"."+v.minor+" r"+v.build;
            }
            
            return "-";
        }
        
        public function toURLVariables():URLVariables
        {
            var variables:URLVariables = new URLVariables();
                variables.utmcs = utmcs;
                variables.utmsr = utmsr;
                variables.utmsc = utmsc;
                variables.utmul = utmul;
                variables.utmje = utmje;
                variables.utmfl = utmfl;
                
            
            return variables;
        }
        
        public function toURLString():String
        {
            var v:URLVariables = toURLVariables();
            return v.toString();
        }
    }
}
