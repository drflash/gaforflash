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
    import buRRRn.ASTUce.framework.TestCase;

    public class OrganicTest extends TestCase
    {
        private var _org0:Organic;
        
        public function OrganicTest(name:String="")
        {
            super(name);
        }
        
        public function setUp():void
        {
            _org0 = new Organic();
        }
        
        public function tearDown():void
        {
            _org0 = null;
        }
        
        public function testAddSource():void
        {
            _org0.addSource( "google", "q" );
            assertTrue( _org0.match("google") );
        }
        
        public function testAddSameSource():void
        {
            _org0.addSource( "google", "q" );
            
            try
            {
                _org0.addSource( "google", "q" );
            }
            catch( e:Error )
            {
                return;
            }
            
            fail();
        }
        
        public function testAddSource2():void
        {
            _org0.addSource( "aol", "query" );
            _org0.addSource( "aol", "encquery" );
        }
        
        public function testMatch():void
        {
            _org0.addSource( "google", "q" );
            assertTrue( _org0.match("google") );
        }
        
        public function testMatch2():void
        {
            _org0.addSource( "aol", "query" );
            _org0.addSource( "aol", "encquery" );
            
            assertTrue( _org0.match( "aol" ) );
        }
        
        public function testGetReferrerByName():void
        {
            _org0.addSource( "aol", "query" );
            _org0.addSource( "aol", "encquery" );
            
            var or:OrganicReferrer = _org0.getReferrerByName( "aol" );
            
            assertEquals( "aol", or.engine );
            assertEquals( "query", or.keyword );
            
            var notfound:OrganicReferrer = _org0.getReferrerByName( "foobar" );
            
            assertEquals( null, notfound );
        }
        
        public function testGetKeywordValueFromPath():void
        {
            var path0:String = "?q=hello+world";
            var path1:String = "query=a+b+c";
            var path2:String = "?q=bonjour+le+monde&foo=123&bar=456";
            
            assertEquals( "hello world", Organic.getKeywordValueFromPath( "q", path0 ) );
            assertEquals( "a b c", Organic.getKeywordValueFromPath( "query", path1 ) );
            assertEquals( "bonjour le monde", Organic.getKeywordValueFromPath( "q", path2 ) );
        }
        
        
    }
}