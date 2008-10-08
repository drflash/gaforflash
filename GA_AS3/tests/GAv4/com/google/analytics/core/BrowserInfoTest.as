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
    
    import com.google.analytics.utils.FakeLocalInfo;
    import com.google.analytics.utils.LocalInfo;
    import com.google.analytics.utils.Version;
    
    import flash.net.URLVariables;


    public class BrowserInfoTest extends TestCase
    {
        private var _browserInfo0:BrowserInfo;
        private var _info0:LocalInfo;
        
        public function BrowserInfoTest(name:String="")
        {
            super(name);
        }
        
        public function setUp():void
        {
            _info0 = new FakeLocalInfo("",null,"","","","","","",new Version(9,0,115,0),"en-GB","UTF-8","","","",null,800,600,"24");
            _browserInfo0 = new BrowserInfo( _info0 );
        }
        
        public function testFlashVersion():void
        {
            assertEquals( "9.0 r115", _browserInfo0.utmfl );
        }
        
        public function testScreenInfo():void
        {
            assertEquals( "800x600", _browserInfo0.utmsr );
            assertEquals( "24-bit", _browserInfo0.utmsc );
        }
        
        public function testLangInfo():void
        {
            assertEquals( "en-GB", _browserInfo0.utmul );
            assertEquals( "UTF-8", _browserInfo0.utmcs );
        }
        
        public function testToURLVariables():void
        {
            var vars:URLVariables = _browserInfo0.toURLVariables();
            
            assertEquals( "UTF-8",    vars.utmcs );
            assertEquals( "800x600",  vars.utmsr );
            assertEquals( "24-bit",   vars.utmsc );
            assertEquals( "en-GB",    vars.utmul );
            assertEquals( "0",        vars.utmje );
            assertEquals( "9.0 r115", vars.utmfl );
        }
        
        public function testToURLString():void
        {
            var vars:URLVariables = _browserInfo0.toURLVariables();
            
            var varsA:URLVariables = new URLVariables();
                varsA.utmcs = vars.utmcs;
            assertEquals( "utmcs=UTF%2D8", varsA.toString() );
            
            var varsB:URLVariables = new URLVariables();
                varsB.utmsr = vars.utmsr;
            assertEquals( "utmsr=800x600", varsB.toString() );
            
            var varsC:URLVariables = new URLVariables();
                varsC.utmsc = vars.utmsc;
            assertEquals( "utmsc=24%2Dbit", varsC.toString() );
            
            var varsD:URLVariables = new URLVariables();
                varsD.utmul = vars.utmul;
            assertEquals( "utmul=en%2DGB", varsD.toString() );
            
            var varsE:URLVariables = new URLVariables();
                varsE.utmje = vars.utmje;
            assertEquals( "utmje=0", varsE.toString() );
            
            var varsF:URLVariables = new URLVariables();
                varsF.utmfl = vars.utmfl;
            assertEquals( "utmfl=9%2E0%20r115", varsF.toString() );
        }
        
    }
}