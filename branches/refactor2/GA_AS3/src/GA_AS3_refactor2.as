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
 
package
{
    
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    
    import com.google.analytics.GATracker;
    import com.google.analytics.core.as3_api;
    import com.google.analytics.v4.GoogleAnalyticsAPI;
    
    /* note:
       for testing code we use GATracker
       but ultimately users will use a component (SWC)
       as the main entry point to configure GA for AS3
    */
    [SWF(width="800", height="600", backgroundColor='0xffffff', frameRate='24', pageTitle='test', scriptRecursionLimit='1000', scriptTimeLimit='60')]
    [ExcludeClass]  
    public class GA_AS3_refactor2 extends Sprite
    {
        private var _gat:GATracker;
        public var pageTracker:GoogleAnalyticsAPI;
        
        public function GA_AS3_refactor2()
        {
            this.stage.align = StageAlign.TOP_LEFT;
            this.stage.scaleMode = StageScaleMode.NO_SCALE;
            
            addEventListener( Event.ADDED_TO_STAGE, onComplete );
        }
        
        public function onComplete( evt:Event ):void
        {
            use namespace as3_api;
            _gat = new GATracker( this );
            pageTracker = _gat.getTracker( "UA-1234-5" );
            //pageTracker.setSampleRate( -0.5 );
            //pageTracker.addOrganic("google","q");
            //pageTracker.setDomainName( ".zwetan.com" );
            pageTracker.setVar( "bonjour le monde" );
            pageTracker.trackPageview( "/test/hello/world" );
            //pageTracker.setLocalRemoteServerMode();
            //pageTracker.setLocalServerMode();
            //pageTracker.setRemoteServerMode();
        }
        
    }
}
