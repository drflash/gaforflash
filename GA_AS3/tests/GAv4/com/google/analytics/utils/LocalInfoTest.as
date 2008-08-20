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
    import com.google.analytics.external.HTMLDOM;
    import com.google.analytics.utils.samples.HTMLDOM_set1;
    import com.google.analytics.utils.samples.HTMLDOM_set2;
    
    import buRRRn.ASTUce.framework.TestCase;
    
    import system.console;    

    public class LocalInfoTest extends TestCase
    {
        
        public function LocalInfoTest( name:String="" )
        {
            super(name);
        }

        public function testBasicEmpty():void
        {
            var li_empty:LocalInfo = new LocalInfo();
            
            assertEquals( Protocols.none, li_empty.protocol );
            assertEquals( "", li_empty.domainName );
        }
        
        public function testBasicLocal():void
        {
            var li_local:LocalInfo = new LocalInfo( "file://someFolder/someFile.swf" );
            
            assertEquals( Protocols.file, li_local.protocol );
            assertEquals( "", li_local.domainName );
        }
        
        public function testBasicHTTP():void
        {
            var li_http:LocalInfo = new LocalInfo( "http://www.domain.com/file.swf" );
            
            assertEquals( Protocols.HTTP, li_http.protocol );
            assertEquals( "www.domain.com", li_http.domainName );
        }
        
        public function testBasicHTTPS():void
        {
            var li_https:LocalInfo = new LocalInfo( "https://www.domain.com/secure/file.swf" );
            
            assertEquals( Protocols.HTTPS, li_https.protocol );
            assertEquals( "www.domain.com", li_https.domainName );
        }
        
        public function testLanguageUpgrade():void
        {
            // THIS TEST WILL NOT WORK ON A NON-UK MACHINE
            
            var set1:HTMLDOM = new HTMLDOM_set1(); //downcast trick
            var set2:HTMLDOM = new HTMLDOM_set2(); //downcast trick
            
            var li1:LocalInfo = new LocalInfo( "" , set1 ); //en-GB
            var li2:LocalInfo = new LocalInfo( "" , set2 ); //fr-FR
            
            //assertEquals( "en-GB" , li1.language , "The LocalInfo language attribute failed" ) ; //match, upgrade
            //assertEquals( "fr-FR" , li2.language , "The LocalInfo language attribute failed" ) ; //no match, no upgrade
            
        }
        
    }
}