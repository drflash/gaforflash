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

package com.google.analytics.utils
{
    import flash.net.URLVariables;
    
    public dynamic class Variables
    {
        public var URIencode:Boolean = false;
        
        public function Variables( source:String = null )
        {
            if( source )
            {
                decode( source );
            }
        }
        
        public function decode( source:String ):void
        {
            if( source == "" )
            {
                return;
            }
            
            var data:Array;
            
            if( source.indexOf( "&" ) > -1 )
            {
                data = source.split( "&" );
            }
            else
            {
                data = [ source ];
            }
            
            var prop:String;
            var name:String;
            var value:String;
            var tmp:Array;
            
            for( var i:int = 0; i<data.length; i++ )
            {
                prop = data[i];
                if( prop.indexOf( "=" ) > -1 )
                {
                    tmp = prop.split( "=" );
                    name = tmp[0];
                    value = decodeURI( tmp[1] );
                    this[name] = value;
                }
            }
            
        }
        
        private function _join( vars:Variables ):void
        {
            if( !vars )
            {
                return;
            }
            
            for( var prop:String in vars )
            {
                this[prop] = vars[prop];
            }
        }
        
        public function join( ...variables ):void
        {
            for( var i:int = 0; i<variables.length; i++ )
            {
                if( !(variables[i] is Variables) )
                {
                    continue;
                }
                
                _join( variables[i] );
            }
        }
        
        public function toURLVariables():URLVariables
        {
            var urlvars:URLVariables = new URLVariables();
            
            for( var p:String in this )
            {
                urlvars[p] = this[p];
            }
            
            return urlvars;
        }
        
        public function toString():String
        {
            var data:Array = [];
            var value:String;
            
            for( var p:String in this )
            {
                value = this[p];
                
                if( URIencode )
                {
                    value = encodeURI( value );
                }
                
                data.push( p + "=" + value );
            }
            
            data.sort();
            
            return data.join( "&" );
        }
        
    }
}