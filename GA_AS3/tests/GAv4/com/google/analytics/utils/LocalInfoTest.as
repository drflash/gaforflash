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
    import buRRRn.ASTUce.framework.TestCase;
    
    public class LocalInfoTest extends TestCase
    {
        private var _li_empty:LocalInfo;
        private var _li_local:LocalInfo;
        private var _li_http:LocalInfo;
        private var _li_https:LocalInfo;
        
        public function LocalInfoTest(name:String="")
        {
            super(name);
        }
        
        public function setUp():void
        {
            _li_empty = new LocalInfo();
            _li_local = new LocalInfo( "file://someFolder/someFile.swf" );
            _li_http  = new LocalInfo( "http://www.domain.com/file.swf" );
            _li_https = new LocalInfo( "https://www.domain.com/secure/file.swf" );
        }
        
        public function tearDown():void
        {
            _li_empty = null;
            _li_local = null;
            _li_http  = null;
            _li_https = null;
        }
        
        public function testBasicEmpty():void
        {
            assertEquals( Protocols.none, _li_empty.protocol );
            assertEquals( "", _li_empty.domainName );
        }
        
        public function testBasicLocal():void
        {
            assertEquals( Protocols.file, _li_local.protocol );
            assertEquals( "", _li_local.domainName );
        }
        
        public function testBasicHTTP():void
        {
            assertEquals( Protocols.HTTP, _li_http.protocol );
            assertEquals( "www.domain.com", _li_http.domainName );
        }
        
        public function testBasicHTTPS():void
        {
            assertEquals( Protocols.HTTPS, _li_https.protocol );
            assertEquals( "www.domain.com", _li_https.domainName );
        }
        
    }
}