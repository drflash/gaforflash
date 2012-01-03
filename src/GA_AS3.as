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
    import com.google.analytics.core.Utils;
    import com.google.analytics.debug.VisualDebugMode;
    
    import flash.display.Shape;
    import flash.display.SimpleButton;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.events.MouseEvent;    

    /* Stub to test the AS3 API in pure ActionScript
    */
    [SWF(width="800", height="600", backgroundColor='0xffffff', frameRate='24', pageTitle='test', scriptRecursionLimit='1000', scriptTimeLimit='60')]
    public class GA_AS3 extends Sprite
    {
        private const GA_ID:String = "UA-94526-19";
		//private const GA_ID:String = "UA-111-222";
		
		private var tracker:AnalyticsTracker;
        
        public function GA_AS3()
        {
            this.stage.align = StageAlign.TOP_LEFT;
            this.stage.scaleMode = StageScaleMode.NO_SCALE;
            
            addEventListener( Event.ADDED_TO_STAGE, onComplete );
        }
        
        private function onButtonClick( event:MouseEvent = null ):void
        {
            trace( "button click" );
			tracker.trackEvent( "Button", "Click", "TEST", Math.random() );
			tracker.trackPageview( "/test/button/click/" + Math.random() );
        }
        
        public function onComplete( evt:Event ):void
        {
            removeEventListener( Event.ADDED_TO_STAGE, onComplete );
            
            /* note:
               to test clicktrough for visual debug
            */
            var b_up:Shape = new Shape();
                b_up.graphics.beginFill( 0x000000 );
                b_up.graphics.drawRect( 0, 0, 200, 40 );
                b_up.graphics.endFill();
            
            var b_over:Shape = new Shape();
                b_over.graphics.beginFill( 0xffffff );
                b_over.graphics.drawRect( 0, 0, 200, 40 );
                b_over.graphics.endFill();
            
            var b_down:Shape = new Shape();
                b_down.graphics.beginFill( 0xff0000 );
                b_down.graphics.drawRect( 0, 0, 200, 40 );
                b_down.graphics.endFill();
            
            var b_hit:Shape = new Shape();
                b_hit.graphics.beginFill( 0x000000 );
                b_hit.graphics.drawRect( 0, 0, 200, 40 );
                b_hit.graphics.endFill();
            
            
            var b:SimpleButton = new SimpleButton( b_up, b_over, b_down, b_hit );
                b.addEventListener( MouseEvent.CLICK, onButtonClick );
                b.x = 100;
                b.y = 100;
            
            addChild( b );
            
            trace( Utils.generateHash( GA_ID ) );
            
            //please your own UA to test
            GATracker.autobuild = false;
            tracker = new GATracker( this, GA_ID );
            tracker.mode = "AS3";
            tracker.visualDebug = true;
            //tracker.debug.verbose = true;
            //tracker.debug.traceOutput = true;
            //tracker.debug.javascript = true;
            tracker.debug.GIFRequests = true;
            
            tracker.debug.mode = VisualDebugMode.basic;
            //tracker.config.idleLoop       = 10 ; 
            //tracker.config.idleTimeout    = 10 ;
            //tracker.config.sessionTimeout = 60;
            //tracker.config.conversionTimeout = 180;
            //tracker.config.serverMode = ServerOperationMode.remote;
            tracker.config.serverMode = ServerOperationMode.both;
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
            //tracker.setVar( "hello world" );
            //tracker.trackPageview( "/test/hello/world/from/AS3/API" );
            //tracker.trackEvent( "videos", "play" );
            tracker.trackEvent( "say", "hello world", "test", 123 );
            //tracker.setLocalRemoteServerMode();
            //tracker.setLocalServerMode();
            //tracker.setRemoteServerMode();
        }
    }
}
