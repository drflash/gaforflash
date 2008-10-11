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

package com.google.analytics.campaign
{
    import buRRRn.ASTUce.framework.TestCase;

    public class CampaignManagerTest extends TestCase
    {
        public function CampaignManagerTest(name:String="")
        {
            super(name);
        }
        
        public function testIsInvalidReferrer():void
        {
            assertTrue( CampaignManager.isInvalidReferrer( "" ) );
            assertTrue( CampaignManager.isInvalidReferrer( "0" ) );
            assertTrue( CampaignManager.isInvalidReferrer( "-" ) );
            assertTrue( CampaignManager.isInvalidReferrer( "file://some/local/path" ) );
            assertFalse( CampaignManager.isInvalidReferrer( "http://www.domain.com" ) );
        }
        
        public function testIsFromGoogleCSE():void
        {
            assertTrue( CampaignManager.isFromGoogleCSE( "http://www.google.com/cse?q=keyword" ) );
            assertTrue( CampaignManager.isFromGoogleCSE( "https://www.google.org/cse?q=keyword" ) );
            assertTrue( CampaignManager.isFromGoogleCSE( "http://google.com/cse?q=keyword" ) );
        }
        
    }
}