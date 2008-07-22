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
    import com.google.analytics.utils.UserAgent;
    import com.google.analytics.v4.GoogleAnalyticsAPI;
    
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.text.TextField;
    import flash.text.TextFormat;
    
    /* note:
       for testing code we use GATracker
       but ultimately users will use a component (SWC)
       as the main entry point to configure GA for AS3
    */
    [SWF(width="800", height="600", backgroundColor='0xffffff', frameRate='24', pageTitle='test', scriptRecursionLimit='1000', scriptTimeLimit='60')]
    public class GA_AS3_refactor2 extends Sprite
    {
        private var _gat:GATracker;
        public var pageTracker:GoogleAnalyticsAPI;
        public var output:TextField;
        
        public function GA_AS3_refactor2()
        {
            use namespace as3_api;
            
            _gat = new GATracker();
            addChild( _gat );
            pageTracker = _gat.getTracker( "UA-1234-5" );
            //trace( "account: " + pageTracker.getAccount() );
            //pageTracker.showURL();
            
            addEventListener( Event.ADDED_TO_STAGE, onComplete );
        }
        
        public function createDebug():void
        {
            output = new TextField();
            output.autoSize = "left";
            output.wordWrap = true;
            output.border   = true;
            output.borderColor = 0x000000;
            output.defaultTextFormat = new TextFormat("Arial",10,0x000000,false);
            output.width  = 800;
            output.height = 600;
            
            addChild( output );
            stage.addEventListener( Event.RESIZE, onStageResize );
            
        }
        
        public function onStageResize( evt:Event ):void
        {
            output.width  = stage.width;
            output.height = stage.height;
        }
        
        public function debug( message:String ):void
        {
            output.appendText( message + "\r\n");
        }
        
        public function onComplete( evt:Event ):void
        {
            createDebug();
            onStageResize( null );
            debug( "-start-" );
            debug( "GAT v" + GATracker.version );
            debug( "protocol: " + GATracker.localInfo.protocol );
            debug( "isInHTML: " + GATracker.localInfo.isInHTML() );
            debug( "canBridgeToJS: " + GATracker.localInfo.canBridgeToJS() );
            debug( "account: " + pageTracker.getAccount() );
            debug( "user-agent: " + new UserAgent() );
            debug( "-end-" );
            
        }
        
    }
}
