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
 *   Marc Alcaraz <ekameleon@gmail.com>.
 */
 
package
{
    import com.google.analytics.AnalyticsTracker;
    import com.google.analytics.GATracker;
    import com.google.analytics.core.ServerOperationMode;
    import com.google.analytics.debug.VisualDebugMode;
    
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    
    /* Stub to test the AS3 API in pure ActionScript
    */
    [SWF(width="800", height="600", backgroundColor='0xffffff', frameRate='24', pageTitle='test', scriptRecursionLimit='1000', scriptTimeLimit='60')]
    public class GA_AS3 extends Sprite
    {
        private var tracker:AnalyticsTracker;
        
        public function GA_AS3()
        {
            this.stage.align = StageAlign.TOP_LEFT;
            this.stage.scaleMode = StageScaleMode.NO_SCALE;
            
            addEventListener( Event.ADDED_TO_STAGE, onComplete );
        }
        
        public function onComplete( evt:Event ):void
        {
            removeEventListener( Event.ADDED_TO_STAGE, onComplete );
            
            //please your own UA to test
            GATracker.autobuild = false;
            tracker = new GATracker( this, "UA-111-222" );
            tracker.mode = "AS3";
            tracker.visualDebug = true;
            //tracker.debug.verbose = true;
            //tracker.debug.traceOutput = true;
            //tracker.debug.javascript = true;
            //tracker.debug.GIFRequests = true;
            
            
            //tracker.debug.mode = VisualDebugMode.geek;
            //tracker.config.sessionTimeout = 60;
            //tracker.config.conversionTimeout = 180;
            //tracker.config.serverMode = ServerOperationMode.remote;
            tracker.trackPageview( "/test" ); //test cache
            
            //tracker.config.localGIFpath = tracker.config.remoteGIFpath;
            //tracker.config.serverMode = ServerOperationMode.local;
            
            //trace( "debug mode: " + tracker.debug.mode );
            //trace( "debug verbose: " + tracker.debug.verbose );
            //trace( "local: " + tracker.config.localGIFpath );
            //trace( "serverMode: " + tracker.config.serverMode );
            
            GATracker(tracker).build();
            
            //tracker.setSampleRate( -0.5 );
            //tracker.addOrganic("google","q");
            //tracker.setDomainName( ".zwetan.com" );
            
            //ideally you would want to change the setVar for each different tests
            tracker.setVar( "hello world" );
            tracker.trackPageview( "/test/hello/world/from/AS3/API" );
            tracker.trackEvent( "videos", "play" );
            tracker.trackEvent( "say", "hello world", "test", 1 );
            //tracker.setLocalRemoteServerMode();
            //tracker.setLocalServerMode();
            //tracker.setRemoteServerMode();
        }
    }
}
