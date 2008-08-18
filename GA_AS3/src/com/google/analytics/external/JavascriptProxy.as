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
    import flash.external.ExternalInterface;
    
    public class JavascriptProxy
    {
        public function JavascriptProxy()
        {
        }
        
        protected function getProperty( name:String ):*
        {
            /* note:
               we use a little trick here
               we can not diretly get a property from JS
               we can only call a function
               so we use valueOf() to automatically get the property
               and yes it will work only with primitives
            */
            return ExternalInterface.call( name + ".valueOf" );
        }
        
        protected function getPropertyString( name:String ):String
        {
            return ExternalInterface.call( name + ".toString" );
        }
        
        public function isAvailable():Boolean
        {
            return ExternalInterface.available;
        }
    }
}