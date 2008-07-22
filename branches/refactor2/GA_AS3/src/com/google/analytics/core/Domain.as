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
    
    public class Domain
    {
        private var _mode:DomainNameMode;
        private var _name:String;
        
        public function Domain( mode:DomainNameMode = null, name:String = "" )
        {
            if( mode == null )
            {
                mode = DomainNameMode.auto;
            }
            
            _mode = mode;
            
            if( mode == DomainNameMode.custom )
            {
                this.name = name;
            }
            
        }
        
        public function get mode():DomainNameMode
        {
            return _mode;
        }
        
        public function get name():String
        {
            return _name;
        }
        
        public function set name( value:String ):void
        {
            if( value.charAt(0) != "." )
            {
                trace( "## WARNING: missing leading period \".\", cookie will only be accessible on "+value );
            }
            _name = value;
        }

    }
}