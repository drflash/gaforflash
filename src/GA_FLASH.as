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
    import com.google.analytics.components.FlashTracker;
    import com.google.analytics.events.AnalyticsEvent;
    
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    
    /* Stub to test the AS3 API in pure ActionScript
       but compiled with mxmlc
    */
    [SWF(width="800", height="600", backgroundColor='0xffffff', frameRate='24', pageTitle='test', scriptRecursionLimit='1000', scriptTimeLimit='60')]
    public class GA_FLASH extends Sprite
    {
        private var tracker:AnalyticsTracker;
        
        public function GA_FLASH()
        {
            this.stage.align = StageAlign.TOP_LEFT;
            this.stage.scaleMode = StageScaleMode.NO_SCALE;
            
            addEventListener( Event.ADDED_TO_STAGE, onComplete );
        }
        
        public function onComplete( evt:Event ):void
        {
            /* note:
               here we simulate the FlashTracker component
               as if it was a Flash visual component
               by adding it to the display list
            */
            tracker = new FlashTracker();
            tracker.trackPageview( "/test" ); //test cache
            tracker.addEventListener( AnalyticsEvent.READY, onAnalyticsReady );
            
            tracker.account = "UA-111-222";
            tracker.mode    = "AS3";
            tracker.visualDebug = true;
            tracker.debug.verbose = true;
            tracker.debug.GIFRequests = true;
            addChild( tracker as DisplayObject );
            
        }
        
        public function onAnalyticsReady( event:AnalyticsEvent ):void
        {
            //trace( "onAnalyticsReady()" );
            var tracker:AnalyticsTracker = event.tracker;
            
            tracker.trackPageview( "/hello/world" );
            
        }
        
    }
}
