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
    public class HTMLDOM extends JavascriptProxy
    {
        
        public function HTMLDOM()
        {
        }
        
        public function get language():String
        {
            if( !isAvailable() )
            {
                return null;
            }
            
            var lang:String = getProperty( "navigator.language" );
            
            if( lang == null )
            {
                lang = getProperty( "navigator.browserLanguage" );
            }
            
            return lang;
        }
        
        public function get location():String
        {
            if( !isAvailable() )
            {
                return null;
            }
            
            return getPropertyString( "document.location" );
        }
        
        public function get protocol():String
        {
            if( !isAvailable() )
            {
                return null;
            }
            
            return getProperty( "document.location.protocol" );
        }
        
        public function get host():String
        {
            if( !isAvailable() )
            {
                return null;
            }
            
            return getProperty( "document.location.host" );
        }
        
        public function get search():String
        {
            if( !isAvailable() )
            {
                return null;
            }
            
            return getProperty( "document.location.search" );
        }
        
    }
}
