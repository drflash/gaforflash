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
    
    /**
     * Javascript proxy access class.
     */
    public class JavascriptProxy
    {

    	/**
    	 * The setProperty Javascript injection.
    	 */
        public static var setProperty_js:XML = 
            <script>
                <![CDATA[
                function( path , value )
                {
                    var paths;
                    var prop;
                    if( path.indexOf(".") > 0 )
                    {
                        paths = path.split(".");
                        prop  = paths.pop() ;
                    }
                    else
                    {
                        paths = [];
                        prop  = path;
                    }
                    var target = window ;
                    var len    = paths.length ;
                    for( var i = 0 ; i < len ; i++ )
                    {
                        target = target[ paths[i] ] ;
                    }
                    
                    target[ prop ] = value ;
                }
                ]]>
            </script>;
        
        
        /**
         * Creates a new JavascriptProxy instance.
         */
        public function JavascriptProxy()
        {
        }
        
        protected function executeBlock( data:XML ):void
        {
            ExternalInterface.call( data );
        }
        
        /**
         * Returns the value property defines with the passed-in name value.
         * @return the value property defines with the passed-in name value.
         */        
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
        
        protected function setProperty( path:String, value:* ):void
        {
            ExternalInterface.call( setProperty_js, path, value );
        }
        
        /**
         * Returns the String property defines with the passed-in name value.
         * @return the String property defines with the passed-in name value.
         */
        protected function getPropertyString( name:String ):String
        {
            return ExternalInterface.call( name + ".toString" );
        }
        
        /**
         * Indicates if the javascript proxy is available.
         */
        public function isAvailable():Boolean
        {
            return ExternalInterface.available;
        }
    }
}