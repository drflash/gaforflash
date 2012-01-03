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
	import library.ASTUce.framework.TestCase;

    public class URLTest extends TestCase
    {
        private var _empty:URL;
        private var _url0:URL;
        private var _url1:URL;
        private var _url2:URL;
        private var _url3:URL;
        private var _url4:URL;
        private var _url5:URL;
        private var _url6:URL;
        private var _url7:URL;
        
        public function URLTest(name:String="")
        {
            super(name);
        }
        
        public function setUp():void
        {
            _empty = new URL();
            _url0  = new URL( "http://www.domain.com" );
            _url1  = new URL( "https://sub.domain.com" );
            _url2  = new URL( "file://some/path/in/the/system" );
            _url3  = new URL( "http://www.domain.com/" );
            _url4  = new URL( "http://www.domain.com/hello/world/" );
            _url5  = new URL( "http://www.domain.com?q=hello+world" );
            _url6  = new URL( "file://some/path/in/the/system?a=1&b=2" );
            _url7  = new URL( "http://www.domain.com/hello/world/?foo=bar&test=me" );
        }
        
        public function tearDown():void
        {
            _empty = null;
            _url0  = null;
            _url1  = null;
            _url2  = null;
            _url3  = null;
            _url4  = null;
            _url5  = null;
            _url6  = null;
            _url7  = null;
        }
        
        public function testProtocol():void
        {
            assertEquals( Protocols.none,  _empty.protocol );
            assertEquals( Protocols.HTTP,  _url0.protocol );
            assertEquals( Protocols.HTTPS, _url1.protocol );
            assertEquals( Protocols.file,  _url2.protocol );
        }
        
        public function testHostName():void
        {
            assertEquals( "",                _empty.hostName );
            assertEquals( "www.domain.com",  _url0.hostName );
            assertEquals( "sub.domain.com", _url1.hostName );
            assertEquals( "",               _url2.hostName );
            assertEquals( "www.domain.com",  _url4.hostName );
            assertEquals( "www.domain.com",  _url5.hostName );
        }
        
        public function testPath():void
        {
            assertEquals( "/", _empty.path );
            assertEquals( "/some/path/in/the/system", _url2.path );
            assertEquals( "/", _url3.path );
            assertEquals( "/hello/world/", _url4.path );
            assertEquals( "/", _url0.path );
        }
        
        public function testSearch():void
        {
            assertEquals( "", _empty.search );
            assertEquals( "", _url2.search );
            assertEquals( "", _url3.search );
            assertEquals( "", _url4.search );
            assertEquals( "", _url0.search );
            
            assertEquals( "q=hello+world",  _url5.search );
            assertEquals( "a=1&b=2",        _url6.search );
            assertEquals( "foo=bar&test=me", _url7.search );
        }
        
        public function testDomain():void
        {
            var a:URL = new URL( "http://www.domain.com" );
            var b:URL = new URL( "http://www.domain.co.uk" );
            var c:URL = new URL( "http://domain.com" );
            var d:URL = new URL( "http://www.domain.co.uk" );
            var e:URL = new URL( "http://localhost" );
            
            assertEquals( "domain.com", a.domain );
            assertEquals( "domain.co.uk", b.domain );
            assertEquals( "domain.com", c.domain );
            assertEquals( "domain.co.uk", d.domain );
            assertEquals( "", e.domain );
        }
        
        public function testSubDomain():void
        {
            var a:URL = new URL( "http://www.domain.com" );
            var b:URL = new URL( "http://www.domain.co.uk" );
            var c:URL = new URL( "http://domain.com" );
            var d:URL = new URL( "http://domain.co.uk" );
            var e:URL = new URL( "http://test.domain.com" );
            
            assertEquals( "www", a.subDomain );
            assertEquals( "www", b.subDomain );
            assertEquals( "", c.subDomain );
            assertEquals( "", d.subDomain );
            assertEquals( "test", e.subDomain );
        }
        
    }
}