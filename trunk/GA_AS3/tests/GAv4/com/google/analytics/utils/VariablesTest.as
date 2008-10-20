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
    
    import flash.net.URLVariables;

    public class VariablesTest extends TestCase
    {
        public function VariablesTest(name:String="")
        {
            super(name);
        }
        
        public function testAddVariable():void
        {
            var v:Variables = new Variables();
                v.test = "hello world";
            
            assertEquals( "hello world", v.test );
        }
        
        public function testToString():void
        {
            var v0:Variables = new Variables();
                v0.test = "hello world";
            
            var v1:Variables = new Variables();
                v1.a = 123;
                v1.b = 456;
                v1.c = 789;
            
            assertEquals( "test=hello world", v0.toString() );
            assertEquals( "a=123&b=456&c=789", v1.toString() );
        }
        
        public function testToStringEncoded():void
        {
            var v:Variables = new Variables();
                v.URIencode = true;
                v.foo = "_abc_?#/-.;";
                v.bar = "one two";
            
            assertEquals( "bar=one%20two&foo=_abc_?#/-.;", v.toString() );
        }
        
        public function testToURLVariables():void
        {
            var v1:Variables = new Variables();
                v1.a = 123;
                v1.b = 456;
                v1.c = 789;
            
            var uv1:URLVariables = v1.toURLVariables();
            
            assertEquals( v1.a, uv1.a );
            assertEquals( v1.b, uv1.b );
            assertEquals( v1.c, uv1.c );
        }
        
        public function testDecode():void
        {
            var v:Variables = new Variables( "bar=one%20two&foo=_abc_?#/-.;" );
            
            assertEquals( "one two", v.bar );
            assertEquals( "_abc_?#/-.;", v.foo );
        }
        
        public function testJoin():void
        {
            var v:Variables = new Variables();
            
            var v0:Variables = new Variables();
                v0.a = 123;
            var v1:Variables = new Variables();
                v1.b = 456;
            var v2:Variables = new Variables();
                v2.c = 789;
            
            v.join( v0, v1, v2 );
            
            assertEquals( v0.a, v.a );
            assertEquals( v1.b, v.b );
            assertEquals( v2.c, v.c );
        }
        
    }
}