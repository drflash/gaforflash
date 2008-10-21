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

package com.google.analytics.external
{
	import buRRRn.ASTUce.framework.TestCase;
	
	public class JavascriptProxyTest extends TestCase
	{
		
		private var _jsProxy:JavascriptProxy;
		
		public function JavascriptProxyTest(name:String="")
		{
			super( name );
		}
		
		public function setUp():void
		{
			_jsProxy = new JavascriptProxy();			
		}

		
		//
		//	note this requires flash param allowscriptaccess = always
		//
		public function testJsExternal():void
		{
			if( !_jsProxy.isAvailable() )
            {
                return;
            }
                
			var testXML2:XML =      
        		<script>
        			<![CDATA[
        				function(a, b, c, d, e){ return a + b + c + d + e; }
        			]]>
        		</script>;
        		
			assertEquals(15, _jsProxy.jsExternal(testXML2, 1,2,3,4,5));			
		
		}
		
		public function testGetProperty():void
		{
			if( !_jsProxy.isAvailable() )
            {
                return;
            }
            
			var testXML:XML = 
			    <script>
			        <![CDATA[
			            function(a){ return a; }
			        ]]>
			    </script>;			
			
			assertEquals(5, _jsProxy.jsExternal(testXML, 5));
        	assertEquals("correct", _jsProxy.jsExternal(testXML, "correct"));	
			
		}
		

	}

}