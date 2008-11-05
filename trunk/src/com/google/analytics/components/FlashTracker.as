package com.google.analytics.components
{
    import com.google.analytics.API;
    import com.google.analytics.AnalyticsTracker;
    import com.google.analytics.core.Buffer;
    import com.google.analytics.core.EventTracker; EventTracker;
    import com.google.analytics.core.GIFRequest;
    import com.google.analytics.core.ServerOperationMode; ServerOperationMode;
    import com.google.analytics.core.ga_internal;
    import com.google.analytics.debug.DebugConfiguration;
    import com.google.analytics.debug.Layout;
    import com.google.analytics.external.AdSenseGlobals;
    import com.google.analytics.external.HTMLDOM;
    import com.google.analytics.external.JavascriptProxy;
    import com.google.analytics.utils.Environment;
    import com.google.analytics.utils.Version;
    import com.google.analytics.v4.Bridge;
    import com.google.analytics.v4.Configuration;
    import com.google.analytics.v4.GoogleAnalyticsAPI;
    import com.google.analytics.v4.Tracker;
    
    import flash.display.DisplayObject;
    import flash.events.Event;
    
    import fl.core.UIComponent;
    
    public class FlashTracker extends UIComponent implements AnalyticsTracker
    {
        private var _display:DisplayObject;
        private var _tracker:GoogleAnalyticsAPI;
        
        //factory
        private var _config:Configuration;
        private var _debug:DebugConfiguration;
        private var _env:Environment;
        private var _buffer:Buffer;
        private var _gifRequest:GIFRequest;
        private var _jsproxy:JavascriptProxy;
        private var _dom:HTMLDOM;
        private var _adSense:AdSenseGlobals;
        
        //component properties
        private var _account:String      = "";
        private var _mode:String         = "AS3";
        private var _visualDebug:Boolean = false;
        
        public function FlashTracker()
        {
            super();
            
            addEventListener( Event.ADDED_TO_STAGE, _factory );
        }
        
        public static var version:Version = API.version;
        
        /**
        * @private
        * Factory to build the different trackers
        */
        private function _factory( event:Event ):void
        {
            removeEventListener( Event.ADDED_TO_STAGE, _factory );
            
            _display = this;
            
            if( !debug )
            {
                this.debug = new DebugConfiguration();
            }
            
            if( !config )
            {
                this.config = new Configuration( debug );
            }
            
            _jsproxy = new JavascriptProxy( debug );
            
            if( visualDebug )
            {
                debug.layout = new Layout( debug, _display );
                debug.active = visualDebug;
            }
            
            switch( mode )
            {
                case "Bridge":
                _tracker = _bridgeFactory();
                break;
                
                case "AS3":
                default:
                _tracker = _trackerFactory();
            }
            
        }
        
        /**
        * @private
        * Factory method for returning a Tracker object.
        * 
        * @return {GoogleAnalyticsAPI}
        */
        private function _trackerFactory():GoogleAnalyticsAPI
        {
            debug.info( "GATracker (AS3) v" + version +"\naccount: " + account );
            
            _adSense   = new AdSenseGlobals( debug );
            
            _dom        = new HTMLDOM( debug );
            _dom.cacheProperties();
            
            _env        = new Environment( "", "", "", debug, _dom );
            
            _buffer     = new Buffer( config, debug, false );
            
            _gifRequest = new GIFRequest( config, debug, _buffer, _env );
            
            use namespace ga_internal;
            _env.url = _display.stage.loaderInfo.url;
            
            return new Tracker( account, config, debug, _env, _buffer, _gifRequest, _adSense );
        }
        
        /**
        * @private
        * Factory method for returning a Bridge object.
        * 
        * @return {GoogleAnalyticsAPI}
        */
        private function _bridgeFactory():GoogleAnalyticsAPI
        {
            debug.info( "GATracker (Bridge) v" + version +"\naccount: " + account );
            
            return new Bridge( account, _debug, _jsproxy );
        }
        
        [Inspectable]
        public function get account():String
        {
            return _account
        }
        
        public function set account(value:String):void
        {
            _account = value;
        }
        
        [Inspectable(defaultValue="AS3", enumeration="AS3,Bridge", type="String")]
        public function get mode():String
        {
            return _mode;
        }
        
        public function set mode( value:String ):void
        {
            _mode = value;
        }
        
        [Inspectable(defaultValue="false", type="Boolean")]
        public function get visualDebug():Boolean
        {
            return _visualDebug;
        }
        
        public function set visualDebug( value:Boolean ):void
        {
            _visualDebug = value;
        }
        
        public function get config():Configuration
        {
            return _config;
        }
        
        public function set config(value:Configuration):void
        {
            _config = value;
        }
        
        public function get debug():DebugConfiguration
        {
            return _debug;
        }
        
        public function set debug(value:DebugConfiguration):void
        {
            _debug = value;
        }
        
        include "../common.txt"
        
    }
}