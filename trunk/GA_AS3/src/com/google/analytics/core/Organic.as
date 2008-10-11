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
    import flash.net.URLVariables;
    
    public class Organic
    {
        private var _sources:Array;
        private var _sourcesCache:Array;
        private var _sourcesEngine:Array;
        
        public function Organic()
        {
            _sources       = [];
            _sourcesCache  = [];
            _sourcesEngine = [];
        }
        
        public static function getKeywordValueFromPath( keyword:String, path:String ):String
        {
            var value:String;
            
            if( path.indexOf( keyword+"=" ) > -1 )
            {
                if( path.charAt(0) == "?" )
                {
                    path = path.substr(1);
                }
                
                var vars:URLVariables = new URLVariables( path );
                value = vars[keyword];
            }
            
            return value;
        }
        
        public function get count():int
        {
            return _sources.length;
        }
        
        public function get sources():Array
        {
            return _sources;
        }
        
        public function addSource( engine:String, keyword:String ):void
        {
            var orgref:OrganicReferrer = new OrganicReferrer(engine, keyword);
            
            if( _sourcesCache[ orgref.toString() ] == undefined )
            {
                _sources.push( orgref );
                _sourcesCache[ orgref.toString() ] = _sources.length-1;
                if( _sourcesEngine[ orgref.engine ] == undefined )
                {
                    _sourcesEngine[ orgref.engine ] = [ _sources.length-1 ];
                }
                else
                {
                    _sourcesEngine[ orgref.engine ].push( _sources.length-1 );
                }
            }
            else
            {
                throw new Error( orgref.toString()+" already exists, we don't add it." )
            }
        }
        
        public function clear():void
        {
            _sources      = [];
            _sourcesCache = [];
        }
        
        public function match( name:String ):Boolean
        {
            if( name == "" )
            {
                return false;
            }
            
            name = name.toLowerCase();
            
            if( _sourcesEngine[ name ] != undefined )
            {
                return true;
            }
            
            return false;
        }
        
        public function getReferrerByName( name:String ):OrganicReferrer
        {
            if( match( name ) )
            {
                //by default return the first referrer found
                var index:int = _sourcesEngine[ name ][0];
                return _sources[ index ];
            }
            
            return null;
        }
        
        public function getKeywordValue( or:OrganicReferrer, path:String ):String
        {
            var keyword:String = or.keyword;
            return getKeywordValueFromPath( keyword, path );
        }
        
    }
}