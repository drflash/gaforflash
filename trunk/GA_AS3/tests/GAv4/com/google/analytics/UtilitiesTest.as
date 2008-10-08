/*
 * Copyright 2008 Adobe Systems Inc., 2008 Google Inc.Licensed under the Apache License, 
 * Version 2.0 (the "License");you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at    
 * http://www.apache.org/licenses/LICENSE-2.0Unless required by applicable law or agreed to in writing, 
 * software distributed under the License is distributed on an 
 * "AS IS" BASIS,WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, 
 * either express or implied.See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.google.analytics
    {
    import buRRRn.ASTUce.framework.*;
    
    import com.google.analytics.utils.generateHash;
    import com.google.analytics.utils.joinVariables;
    
    import flash.net.URLVariables;
    
    public class UtilitiesTest extends TestCase
        {
        
        public function UtilitiesTest( name:String="" )
            {
            super( name );
            }
        
        public function testGenerateHash():void
            {
            var h0:int = generateHash(undefined);
            var h1:int = generateHash(null);
            var h2:int = generateHash("");
            var h3:int = generateHash("http://www.google.com");
            var h4:int = generateHash("https://www.google.com");
            
            assertEquals(1, h0);
            assertEquals(1, h1);
            assertEquals(1, h2);
            assertFalse(h3 == h4);
            }
        
        public function testJoinVariables():void
        {
            var vars1:URLVariables = new URLVariables();
                vars1.a = 1;
                vars1.b = 2;
            
            var vars2:URLVariables = new URLVariables();
                vars2.c = 3;
                vars2.d = 4;
            
            var varsnull:URLVariables = null;
            var varsundef:URLVariables;
            
            var test1:URLVariables = joinVariables( vars1, vars2 );
            
            assertEquals( test1.a, 1 );
            assertEquals( test1.b, 2 );
            assertEquals( test1.c, 3 );
            assertEquals( test1.d, 4 );
            
            var test2:URLVariables = joinVariables( varsnull, varsundef );
            
            assertEquals( test2.toString(), "" );
        }
        
        }
    
    }
