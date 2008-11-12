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
 *   Marc ALCARAZ <ekameleon@gmail.com>.
 *   Zwetan Kjukov <zwetan@gmail.com>.
 */
 
package com.google.analytics.core 
{
    import buRRRn.ASTUce.framework.TestCase;
    
    import com.google.analytics.v4.GoogleAnalyticsAPI;    

    public class TrackerCacheTest extends TestCase 
    {

        public function TrackerCacheTest(name:String = "")
        {
            super( name );
        }
        
        public var cache:TrackerCache ;
        
        public function setUp():void
        {
            cache = new TrackerCache() ;
        }
        
        public function tearDown():void
        {
            cache = null ;
        }
        
        public function testConstructor():void
        {
        	assertNotNull( cache , "The TrackerCache instance not must be null" ) ;
        }
        
        public function testInterface():void
        {
        	assertTrue( cache is GoogleAnalyticsAPI , "The TrackerCache instance must implement the GoogleAnalyticsAPI interface." ) ;
        }
        
        public function testCACHE_THROW_ERROR():void
        {
        	assertFalse( TrackerCache.CACHE_THROW_ERROR  , "01 - The TrackerCache.CACHE_THROW_ERROR static value must be false by default") ;
        	
        	TrackerCache.CACHE_THROW_ERROR = true ;
        	
        	assertTrue( TrackerCache.CACHE_THROW_ERROR  , "02 - The TrackerCache.CACHE_THROW_ERROR static value must be true.") ;
        	
        	TrackerCache.CACHE_THROW_ERROR = false ;
        	
        	assertFalse( TrackerCache.CACHE_THROW_ERROR  , "03 - The TrackerCache.CACHE_THROW_ERROR static value must be false.") ;
        }
        
        public function testTracker():void
        {
            var tc:GoogleAnalyticsAPI = new TrackerCache() ;
            
            cache.tracker = tc ;
            
            assertEquals( cache.tracker , tc  , "01 - The tracker property failed." ) ;
            
            cache.tracker = null ;
            
            assertNull( cache.tracker , "02 - The tracker property failed, must be null." ) ;
            
        }
        
        public function testClear():void
        {
        	cache.enqueue("myMethod", 1, 2, 3 ) ;
        	cache.enqueue("myMethod", 1, 2, 3 ) ;
        	cache.enqueue("myMethod", 1, 2, 3 ) ;
        	var oldSize:int = cache.size() ;
        	cache.clear() ;
        	assertEquals( oldSize  , 3  , "01 - TrackerCache clear method failed." ) ;
        	assertNotSame( cache.size() , oldSize  , "02 - TrackerCache clear method failed." ) ;
            assertEquals( cache.size()  , 0  , "03 - TrackerCache clear method failed." ) ;
        }
        
        public function testEnqueue():void 
        {
        	
        	assertFalse( cache.enqueue(null) , "01 - TrackerCache enqueue method failed with a name parameter null." ) ;
        	
            assertTrue( cache.enqueue("myMethod1", 1, 2, 3 ) , "02 - TrackerCache enqueue method failed." );
            
            assertEquals( cache.size() , 1  , "03 - TrackerCache enqueue method failed." ) ;
            
            assertTrue( cache.enqueue("myMethod2" ) , "04 - TrackerCache enqueue method failed." );
            
            assertEquals( cache.size() , 2  , "05 - TrackerCache enqueue method failed." ) ;            
            
            cache.clear() ;
        }
        
        public function testFlush():void
        {
        	var tc:TrackerCache = new TrackerCache() ;
        	
            cache.trackPageview("/hello1") ;
            cache.trackPageview("/hello2") ;
            cache.trackPageview("/hello3") ;
            
            cache.tracker = tc ;
            
            cache.flush() ; // the test fill an other TrackerCache
            
            assertTrue( cache.isEmpty()  , "01 - TrackerCache flush method failed, the cache must be empty." ) ;    
            assertEquals( tc.size() , 3  , "02 - TrackerCache flush method failed." ) ;  

        }
        
        public function testIsEmpty():void
        {
            assertTrue( cache.isEmpty() , "01 - The TrackerCache isEmpty method failed." ) ;
            cache.enqueue("myMethod", 1, 2, 3 ) ;
            assertFalse( cache.isEmpty() , "02 - The TrackerCache isEmpty method failed." ) ;
            cache.clear() ;
            assertTrue( cache.isEmpty() , "03 - The TrackerCache isEmpty method failed." ) ;
        }        
        
        public function testSize():void
        {
            cache.enqueue("myMethod1", 1, 2, 3 ) ;
            cache.enqueue("myMethod2", 1, 2, 3 ) ;
            cache.enqueue("myMethod3", 1, 2, 3 ) ;
            assertEquals( cache.size() , 3  , "01-02 - TrackerCache clear method failed." ) ;
            cache.clear() ;
        }        
        
        //////////////////////////// GoogleAnalyticsAPI implementation
        
        // TODO test all methods
        
//        public function testAddIgnoredOrganic():void
//        {
//            //
//        }        
//
//        public function testAddIgnoredRef():void
//        {
//            //
//        }
//        
//        public function testAddItem():void
//        {
//            //
//        }
//        
//        public function testAddOrganic():void
//        {
//            //
//        }        
//        
//        public function testAddTrans():void
//        {
//            //   
//        }
//                
//        public function testClearIgnoredOrganic():void
//        {
//            //   
//        }
//        
//        public function testClearIgnoredRef():void
//        {
//            //
//        }
//        
//        public function testClearOrganic():void
//        {
//            //
//        }
//        
//        public function testCreateEventTracker():void
//        {
//            //
//        }        
//        
//        public function testCookiePathCopy():void
//        {
//            
//        }       
//        
//        public function testGetAccount():void
//        {
//            
//        }
//        
//        public function testGetClientInfo():void
//        {
//            
//        }
//        
//        public function testGetDetectFlash():void
//        {
//            
//        }
//        
//        public function testGetDetectTitle():void
//        {
//            
//        }
//                
//        public function testGetLocalGifPath():void
//        {
//            
//        }
//        
//        public function testGetServiceMode():void
//        {
//            
//        }
//        
//        public function testGetVersion():void
//        {
//            
//        }         
//        
//        public function testInitData():void
//        {
//            
//        }
//        
//        public function testLink():void
//        {
//            
//        }
//        
//        public function testLinkByPost():void
//        {
//            
//        }        
//        
//        public function testSetAllowAnchor():void
//        {
//            
//        }
//        
//        public function testSetAllowHash():void
//        {
//            
//        }
//        
//        public function testSetAllowLinker():void
//        {
//            
//        }
//             
//        public function testSetCampContentKey():void
//        {
//            
//        }
//        
//        public function testSetCampMediumKey():void
//        {
//            
//        }
//        
//        public function testSetCampNameKey():void
//        {
//            
//        }
//        
//        public function testSetCampNOKey():void
//        {
//            
//        }
//        
//        public function testSetCampSourceKey():void
//        {
//            
//        }
//        
//        public function testSetCampTermKey():void
//        {
//            
//        }
//        
//        public function testSetCampaignTrack():void
//        {
//            
//        }
//        
//        public function testSetClientInfo():void
//        {
//            
//        }        
//        
//        public function testSetCookieTimeout():void
//        {
//            
//        }
//        
//        public function testSetCookiePath():void
//        {
//            
//        }
//        
//        public function testSetDetectFlash():void
//        {
//            
//        }
//        
//        public function testSetDetectTitle():void
//        {
//            
//        }        
//        
//        public function testSetDomainName():void
//        {
//            
//        }
//        
//        public function testSetLocalGifPath():void
//        {
//            
//        }
//        
//        public function testSetLocalRemoteServerMode():void
//        {
//            
//        }
//        
//        public function testSetLocalServerMode():void
//        {
//            
//        }
//        
//        public function testSetRemoteServerMode():void
//        {
//            
//        }
//        
//        public function testSetSampleRate():void
//        {
//            
//        }
//        
//        public function testSetSessionTimeout():void
//        {
//            
//        }
//        
//        public function testSetVar():void
//        {
//            
//        }
//         
//        public function testTrackEvent():void
//        {
//            
//        }           
//        
//        public function testTrackPageview():void
//        {
//            
//        }         
//        
//        public function testTrackTrans():void
//        {
//            
//        }         
        
    }
}
