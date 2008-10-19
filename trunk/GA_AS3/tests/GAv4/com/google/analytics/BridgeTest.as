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

/*
 * Note these test suites require the following code to be in the HTML 
 * in flexbuilder you can add this into the html-template/GA_Testrunner.html file 
 *
		<script src="http://www.google-analytics.com/ga.js"></script>
		<script language="JavaScript" type="text/javascript">
		var pT = _gat._getTracker("UA-332-1");
		var _GATracker = {};
		_GATracker['test'] = pT;
		</script>
 *
 */  


package com.google.analytics
{
	import buRRRn.ASTUce.framework.TestCase;
	
	import com.google.analytics.v4.Bridge;
	
	public class BridgeTest extends TestCase
	{
		private var _bridge:Bridge;
		
		public function BridgeTest(name:String="")
    	{
        	super(name);
    	}
    	public function setUp():void
    	{
    		_bridge = new Bridge("pT");
    	}
    	
    	public function testCreateJSTrackingObject():void
    	{
    		var acct:String = "UA-5555-1";
    		var b0:Bridge = new Bridge(acct);
    		var test0:Boolean = _bridge.jsTrackingObjExisits("_GATracker['"+acct+"']");
    		
    		assertEquals(true, test0);
    	}
    	
    	public function testJSObjExists():void
		{
			
			var o1:Boolean = _bridge.jsTrackingObjExisits("pT");
			var o2:Boolean = _bridge.jsTrackingObjExisits("_GATracker['test']");
			var o3:Boolean = _bridge.jsTrackingObjExisits("_GATracker.test");
			var o4:Boolean = _bridge.jsTrackingObjExisits("document");		
			var o5:Boolean = _bridge.jsTrackingObjExisits("_GATracker['testBig']");

			assertEquals(true, o1);
			assertEquals(true, o2);
			assertEquals(true, o3);
			assertEquals(false, o4);	
			assertEquals(false, o5);
		}
    	
		
		public function testIsAccountID():void
   		{
   			var id1:String = "UA-012345-1";
   			var id2:String = "UA12345-1";
   			var id3:String = "UA123451";
   			var id4:String = "A1234-1";
   			var id5:String = "UA-12";
   			var id6:String = "UA-12-12-1";
   			
   			assertEquals(true, _bridge.isAccountId(id1));
   			assertEquals(false, _bridge.isAccountId(id2));
   			assertEquals(false, _bridge.isAccountId(id3));
			assertEquals(false, _bridge.isAccountId(id4));
			assertEquals(false, _bridge.isAccountId(id5));
			assertEquals(false, _bridge.isAccountId(id6));
			
		}

    	public function testCreateTrackingObject():void
		{
			var acctID:String = "UA-8-3";
			var oName1:String = _bridge.createJSTrackingObject(acctID);
		
			assertEquals("_GAtrack['"+acctID+"']", oName1);
		} 			


	}
}