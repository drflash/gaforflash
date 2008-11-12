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
    import buRRRn.ASTUce.framework.ArrayAssert;
    import buRRRn.ASTUce.framework.TestCase;
    
    import com.google.analytics.v4.GoogleAnalyticsAPI;
    
    import flash.errors.IllegalOperationError;    

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
        
        public function testElement():void 
        {
            
            cache.enqueue("myMethod", 1, 2, 3 ) ;
            
            var element:Object = cache.element() ;
            
            assertEquals( element.name , "myMethod"  , "01 - TrackerCache element method failed." ) ;
            ArrayAssert.assertEquals( element.args as Array, [1,2,3]  , "02 - TrackerCache element method failed." ) ;
            
            cache.clear() ;
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
        
        public function testAddIgnoredOrganic():void
        {
            
            cache.addIgnoredOrganic( "keyword" ) ;
            
            assertEquals( cache.size() , 1  , "01 - TrackerCache addIgnoredOrganic method failed." ) ;
            
            var e:Object = cache.element() ;
            
            assertNotNull( e , "02 - TrackerCache addIgnoredOrganic method failed." ) ;
            
            assertEquals( e.name , "addIgnoredOrganic"  , "03 - TrackerCache addIgnoredOrganic method failed." ) ;
            ArrayAssert.assertEquals( e.args as Array, ["keyword"]  , "04 - TrackerCache addIgnoredOrganic method failed." ) ;
            
            cache.clear() ;
        }

        public function testAddIgnoredRef():void
        {
            cache.addIgnoredRef( "referrer" ) ;
            
            assertEquals( cache.size() , 1  , "01 - TrackerCache addIgnoredRef method failed." ) ;
            
            var e:Object = cache.element() ;
            
            assertNotNull( e , "02 - TrackerCache addIgnoredRef method failed." ) ;
            
            assertEquals( e.name , "addIgnoredRef"  , "03 - TrackerCache addIgnoredRef method failed." ) ;
            ArrayAssert.assertEquals( e.args as Array, ["referrer"]  , "04 - TrackerCache addIgnoredRef method failed." ) ;
            
            cache.clear() ;
        }
        
        public function testAddItem():void
        {
            cache.addItem( "item", "sku", "name", "category" , 999, 1 ) ;
            
            assertEquals( cache.size() , 1  , "01 - TrackerCache addItem method failed." ) ;
            
            var e:Object = cache.element() ;
            
            assertNotNull( e , "02 - TrackerCache addItem method failed." ) ;
            
            assertEquals( e.name , "addItem"  , "03 - TrackerCache addItem method failed." ) ;
            ArrayAssert.assertEquals
            ( 
                e.args as Array , 
                ["item", "sku", "name", "category" , 999, 1], 
                "04 - TrackerCache addItem method failed." 
            ) ;
            
            cache.clear() ;
        }
        
        public function testAddOrganic():void
        {
            cache.addOrganic( "engine", "keyword" ) ;
            
            assertEquals( cache.size() , 1  , "01 - TrackerCache addOrganic method failed." ) ;
            
            var e:Object = cache.element() ;
            
            assertNotNull( e , "02 - TrackerCache addOrganic method failed." ) ;
            
            assertEquals( e.name , "addOrganic"  , "03 - TrackerCache addOrganic method failed." ) ;
            ArrayAssert.assertEquals
            ( 
                e.args as Array , 
                ["engine", "keyword"], 
                "04 - TrackerCache addOrganic method failed." 
            ) ;
            
            cache.clear() ;
        }        
        
        public function testAddTrans():void
        {
        	       	
        	TrackerCache.CACHE_THROW_ERROR = true ;
        	
            try
            {
            	cache.addTrans("orderId" , "affiliation", 2, 1000, 3, "marseille", "bdr", "france") ;
            	fail( "02-01 - TrackerCache addTrans method failed, must throw an error." ) ;
            }
            catch( e:Error )
            {
            	assertTrue( e is IllegalOperationError , "02-02 - TrackerCache addTrans method failed, must throw an IllegalOperationError.") ;
            	assertEquals
            	( 
            	   e.message,
            	   "The tracker is not ready and you can use the 'addTrans' method for the moment." , 
            	   "02-03 - TrackerCache addTrans method failed, must throw an IllegalOperationError.") ;
            }
            
            TrackerCache.CACHE_THROW_ERROR = false ;
            
            assertNull
            (
               cache.addTrans("orderId" , "affiliation", 2, 1000, 3, "marseille", "bdr", "france") ,
                "01 - TrackerCache addTrans method failed, must return a null value if the CACHE_THROW_ERROR is true."
            );            
            
        }
                
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
