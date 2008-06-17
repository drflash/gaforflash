
package
{
    import com.google.analytics.GATracker;
    import com.google.analytics.core.as3_api;
    import com.google.analytics.v4.GoogleAnalyticsAPI;
    
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.text.TextField;
    import flash.text.TextFormat;
    
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
            debug( "protocol: " + GATracker.localInfo.protocol );
            debug( "isInHTML: " + GATracker.localInfo.isInHTML() );
            debug( "canBridgeToJS: " + GATracker.localInfo.canBridgeToJS() );
            debug( "account: " + pageTracker.getAccount() );
            debug( "-end-" );
            
        }
        
    }
}
