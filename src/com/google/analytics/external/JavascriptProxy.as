﻿﻿/*
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
    import com.google.analytics.debug.DebugConfiguration;
    
    import flash.external.ExternalInterface;
    import flash.system.Capabilities;
    
    /**
     * Javascript proxy access class.
     */
    public class JavascriptProxy
    {
        
        /**
         * The hasProperty Javascript injection.
         */
        public static var hasProperty_js:XML ;
        
        /**
         * The setProperty Javascript injection.
         */
        public static var setProperty_js:XML ;
        
        /**
         * The setPropertyReference Javascript injection.
         */
        public static var setPropertyRef_js:XML ;
        
        include "javascript_proxy_injection.txt"
        
        private var _debug:DebugConfiguration;
        private var _notAvailableWarning:Boolean = true;
        
        /**
         * Creates a new JavascriptProxy instance.
         * @param debug The DebugConfiguration reference of this object.
         */
        public function JavascriptProxy( debug:DebugConfiguration )
        {
            _debug = debug;
        }
        
        /**
         * Call a Javascript injection block (String or XML) with parameters and return the result.
         */
        public function call( functionName:String, ...args:Array ):*
        {
            if( isAvailable() )
            {
                try
                {
                    if( _debug.javascript && _debug.verbose )
                    {
                        var output:String = "";
                            output  = "Flash->JS: "+ functionName;
                            output += "( ";
                        if (args.length > 0)
                        {
                            output += args.join(",");
                        } 
                        output += " )";
                        _debug.info( output );
                    }
                    
                    args.unshift( functionName );
                    return ExternalInterface.call.apply( ExternalInterface, args );
                }
                catch( e:SecurityError )
                {
                    if( _debug.javascript )
                    {
                        _debug.warning( "ExternalInterface is not allowed.\nEnsure that allowScriptAccess is set to \"always\" in the Flash embed HTML." );
                    }
                }
                catch( e:Error )
                {
                    if( _debug.javascript )
                    {
                        _debug.warning( "ExternalInterface failed to make the call\nreason: " + e.message );
                    }
                }
            }
            return null;
        }
        
        /**
         * Execute a Javascript injection block (String or XML) without any parameters and without return values.
         */
        public function executeBlock( data:String ):void
        {
            if( isAvailable() )
            {
                try
                {
                    ExternalInterface.call( data );
                }
                catch( e:SecurityError )
                {
                    if( _debug.javascript )
                    {
                        _debug.warning( "ExternalInterface is not allowed.\nEnsure that allowScriptAccess is set to \"always\" in the Flash embed HTML." );
                    }
                }
                catch( e:Error )
                {
                    if( _debug.javascript )
                    {
                        _debug.warning( "ExternalInterface failed to make the call\nreason: " + e.message );
                    }
                }
            }
        }        
        
        /**
         * Returns the value property defines with the passed-in name value.
         * @return the value property defines with the passed-in name value.
         */        
        public function getProperty( name:String ):*
        {
            /* note:
               we use a little trick here 
               we can not diretly get a property from JS
               we can only call a function
               so we use valueOf() to automatically get the property
               and yes it will work only with primitives
            */
            return ExternalInterface.call( name + ".valueOf" ) ;
        }
        
        /**
         * Returns the String property defines with the passed-in name value.
         * @return the String property defines with the passed-in name value.
         */
        public function getPropertyString( name:String ):String
        {
            return ExternalInterface.call( name + ".toString" );
        }
        
        /**
         * Indicates if the specified path object exist.
         */
        public function hasProperty( path:String ):Boolean
        {
            return ExternalInterface.call( hasProperty_js, path );
        }        
        
        /**
         * Indicates if the javascript proxy is available.
         */
        public function isAvailable():Boolean
        {
            var available:Boolean = ExternalInterface.available;
            
            if( available && (Capabilities.playerType == "External") )
            {
                /* note:
                   ExternalInterface is available when testing
                   from the Flash IDE (publish)
                   to allow testing loally we desactivate it
                */
                available = false;
            }
            
            /* note:
               we want to notify only once that ExternalInterface is not available.
            */
            if( !available && _debug.javascript && _notAvailableWarning )
            {
                _debug.warning( "ExternalInterface is not available." );
                _notAvailableWarning = false;
            }
            
            return available;
        }
        
        /**
         * Creates a JS property.
         */
        public function setProperty( path:String, value:* ):void
        {
            ExternalInterface.call( setProperty_js, path, value );
        }
        
        /**
         * Crates a JS property by reference.
         */
        public function setPropertyByReference( path:String, target:String ):void
        {
            ExternalInterface.call( setPropertyRef_js, path, target );
        }        
        
    }
}