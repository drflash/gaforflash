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
    
    import com.google.analytics.config;
    import com.google.analytics.external.AdSenseGlobals;
    import com.google.analytics.external.FakeAdSenseGlobals;
    import com.google.analytics.utils.FakeLocalInfo;
    import com.google.analytics.utils.LocalInfo;
    
    import flash.net.URLVariables;
    
    public class DocumentInfoTest extends TestCase
    {
        private var _emptyDocInfo0:DocumentInfo;
        private var _emptyDocInfo1:DocumentInfo;
        private var _info0:LocalInfo;
        private var _info1:LocalInfo;
        private var _adSense0:AdSenseGlobals;
        private var _adSense1:AdSenseGlobals;
        
        public function DocumentInfoTest(name:String="")
        {
            super(name);
        }
        
        public function setUp():void
        {
            _info0 = new LocalInfo( "http://www.domain.com" );
            _info1 = new FakeLocalInfo("",null,"","","a simple title","","/some/path/page.html","?a=1&b=2");
            _adSense0 = new FakeAdSenseGlobals();
            _adSense1 = new FakeAdSenseGlobals( null, "", "12345" );
            _emptyDocInfo0 = new DocumentInfo( _info0, "", null, _adSense0 );
            _emptyDocInfo1 = new DocumentInfo( _info0, "", null, _adSense1 );
            
        }
        
        public function testHitId():void
        {
            //hitId updated from docInfo
            assertEquals( "", _adSense0.hid );
            var hid:String = _emptyDocInfo0.utmhid;
            assertEquals( hid, _adSense0.hid );
            
            //HitId updated from gaGlobal
            assertEquals( "12345", _adSense1.hid );
            assertEquals( _adSense1.hid, _emptyDocInfo1.utmhid );
        }
        
        public function testPageTitle():void
        {
            var docInfo:DocumentInfo = new DocumentInfo( _info1, "", null, _adSense0 );
            
            assertEquals( "a simple title", docInfo.utmdt );
            
            if( config.detectTitle )
            {
                var vars:URLVariables = docInfo.toURLVariables();
                var vars2:URLVariables = new URLVariables();
                    vars2.utmdt = vars.utmdt;
                    
                assertEquals( "a simple title", vars.utmdt );
                assertEquals( "utmdt=a%20simple%20title", vars2.toString() );
            }
            
        }
        
        public function testPageURL():void
        {
            var docInfo0:DocumentInfo = new DocumentInfo( _info1, "", null, _adSense0 );
            var docInfo1:DocumentInfo = new DocumentInfo( _info1, "", "/some/other/path/index.html", _adSense0 );
            
            assertEquals( "/some/path/page.html?a=1&b=2", docInfo0.utmp );
            assertEquals( "/some/other/path/index.html", docInfo1.utmp );
            
        }
        
    }
}