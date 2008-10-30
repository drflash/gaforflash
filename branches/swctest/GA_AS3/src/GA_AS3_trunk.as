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
    import com.google.analytics.GATracker;
    import com.google.analytics.core.as3_api;
    import com.google.analytics.debug;
    import com.google.analytics.v4.GoogleAnalyticsAPI;
    
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;

    /* note:
       for testing code we use GATracker
       but ultimately users will use a component (SWC)
       as the main entry point to configure GA for AS3
    */
    [SWF(width="800", height="600", backgroundColor='0xffffff', frameRate='24', pageTitle='test', scriptRecursionLimit='1000', scriptTimeLimit='60')]
    [ExcludeClass]
    public class GA_AS3_trunk extends Sprite
    {
        private var _gat:GATracker;
        public var pageTracker:GoogleAnalyticsAPI;
        
        public function GA_AS3_trunk()
        {
            this.stage.align = StageAlign.TOP_LEFT;
            this.stage.scaleMode = StageScaleMode.NO_SCALE;
            
            addEventListener( Event.ADDED_TO_STAGE, onComplete );
        }
        
        public function onComplete( evt:Event ):void
        {
            //debug.minimizedOnStart = true;
            use namespace as3_api;
            _gat = new GATracker( this, true );
            //pageTracker = _gat.getTracker( "UA-1234-5" );
            
            //UA-4241494-2 for gaas3.zwetan.com
            //please your own UA to test
            pageTracker = _gat.getTracker( "UA-4241494-2" );
            //pageTracker.setSampleRate( -0.5 );
            //pageTracker.addOrganic("google","q");
            //pageTracker.setDomainName( ".zwetan.com" );
            
            //ideally you would want to change the setVar for each different tests
            pageTracker.setVar( "Rocktober 020 online" );
            pageTracker.trackPageview( "/test/hello/world/from/AS3/API/020" );
            
            //pageTracker.setLocalRemoteServerMode();
            //pageTracker.setLocalServerMode();
            //pageTracker.setRemoteServerMode();
        }
        
    }
}
