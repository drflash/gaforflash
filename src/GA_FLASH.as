package
{
    import com.google.analytics.AnalyticsTracker;
    import com.google.analytics.components.FlashTracker;
    
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    
    /* Stub to test the AS3 API in pure ActionScript
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
            tracker = new FlashTracker();
            
            tracker.account = "UA-4241494-2";
            tracker.mode    = "AS3";
            tracker.visualDebug = true;
            addChild( tracker as DisplayObject );
            
            tracker.debug.verbose = true;
            tracker.trackPageview( "/hello/world" );
        }
        
    }
}
