package com.google.analytics.components
{
    import com.google.analytics.API;
    import com.google.analytics.AnalyticsTracker;
    import com.google.analytics.core.Buffer;
    import com.google.analytics.core.EventTracker;
    import com.google.analytics.core.GIFRequest;
    import com.google.analytics.core.ServerOperationMode;
    import com.google.analytics.core.TrackerMode;
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
    import flash.display.Graphics;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.utils.getQualifiedClassName;
    import flash.utils.getDefinitionByName;
    
    /* force import for type in the includes */
    EventTracker;
    ServerOperationMode;
    
    /**
    * The Flash visual component.
    */
    [IconFile("analytics.png")]
    public class FlashTracker extends Sprite implements AnalyticsTracker
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
        
        //component
        protected var preview:MovieClip;
        protected var isLivePreview:Boolean;
        protected var livePreviewWidth:Number;
        protected var livePreviewHeight:Number;
        
        protected var _width:Number = 100;
        protected var _height:Number = 122; 
        protected var _componentInspectorSetting:Boolean;
        
        public var boundingBox_mc:DisplayObject;
        
        public static var version:Version = API.version;
        
        [IconFile("analytics.png")]
        public function FlashTracker()
        {
            super();
            
            isLivePreview = _checkLivePreview();
            _componentInspectorSetting = false;
            
            boundingBox_mc.visible = false;
            removeChild( boundingBox_mc );
            boundingBox_mc = null;
            
            if( isLivePreview )
            {
                _createLivePreview();
            }
            
            /* note:
               we have to use the ENTER_FRAME event
               to wait 1 frame so we can add to the display list
               and get the values declared in the component inspector.
            */
            addEventListener( Event.ENTER_FRAME, _factory );
        }
        
        
        private function _checkLivePreview():Boolean
        {
            if( parent != null && (getQualifiedClassName(parent) == "fl.livepreview::LivePreviewParent"))
            {
                return true;
            }
            
            return false;
        }
        
        private function _createLivePreview():void
        {
            preview = new MovieClip();
            
            var g:Graphics = preview.graphics;
                g.beginFill(0xffffff);
                g.moveTo(0, 0);
                g.lineTo(0, _width);
                g.lineTo(_width, _height);
                g.lineTo(_height, 0);
                g.lineTo(0, 0);
                g.endFill();
            
            /* note:
               because the Icon class is declared in the FLA
               and the FLA generate it automatically
               we need to use reflection to instanciate it
               so compc/asdoc does not generate errors
            */
            var iconClass:Class = getDefinitionByName( "com.google.analytics.components::Icon" ) as Class;
            preview.icon_mc = new iconClass();
            preview.icon_mc.name = "icon_mc";
            preview.addChild( preview.icon_mc );
            
            addChild( preview );
        }
        
        public function set componentInspectorSetting( value:Boolean ):void
        {
            _componentInspectorSetting = value;
        }
        
        public function setSize( w:Number, h:Number ):void
        {
            /* note:
               we don't resize the live preview
               we want to keep or default component size
               defined in the FLA
            */
        }
        
        /**
        * @private
        * Factory to build the different trackers
        */
        private function _factory( event:Event ):void
        {
            removeEventListener( Event.ENTER_FRAME, _factory );
            
            if( isLivePreview )
            {
                /* note:
                   we don't want to init the factory
                   when we are in live preview
                */
                return;
            }
            
            _display = this;
            
            if( !debug )
            {
                this.debug = new DebugConfiguration();
            }
            
            if( !config )
            {
                this.config = new Configuration( debug );
            }
            
            if( visualDebug )
            {
                debug.layout = new Layout( debug, _display );
                debug.active = visualDebug;
            }
            
            _jsproxy = new JavascriptProxy( debug );
            
            switch( mode )
            {
                case TrackerMode.BRIDGE :
                {
                    _tracker = _bridgeFactory();
                    break;
                }
                
                case TrackerMode.AS3 :
                default:
                {
                    _tracker = _trackerFactory();
                }
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
        
        /**
         * The Urchin Account.
         * You have to define this parameter to initialize the tracking.
         */
        [Inspectable]
        public function get account():String
        {
            return _account ;
        }
        
        /**
         * @private
         */
        public function set account(value:String):void
        {
            _account = value;
        }
        
        /**
        * The Tracker configuration.
        */
        public function get config():Configuration
        {
            return _config;
        }
        
        /**
         * @private
         */
        public function set config(value:Configuration):void
        {
            _config = value;
        }
        
        /**
        * The Tracker debug configuration.
        */
        public function get debug():DebugConfiguration
        {
            return _debug;
        }
        
        /**
         * @private
         */
        public function set debug(value:DebugConfiguration):void
        {
            _debug = value;
        }        
        
        /**
        * The Traker mode.
        * You can select two modes:
        * - AS3: use AS3 only, no dependency on HTML/JS
        * - Bridge: use AS3 bridged to HTML/JS which define ga.js
        */
        [Inspectable(defaultValue="AS3", enumeration="AS3,Bridge", type="String")]
        public function get mode():String
        {
            return _mode;
        }
        
        /**
         * @private
         */
        public function set mode( value:String ):void
        {
            _mode = value;
        }
        
        /**
         * Indicates if the tracker use a visual debug.
         * If set to true, at compile time you will
         * see a visual debug window with different
         * informations about the tracking requests and parameters.
         */
        [Inspectable(defaultValue="false", type="Boolean")]
        public function get visualDebug():Boolean
        {
            return _visualDebug;
        }
        
        /**
         * @private
         */
        public function set visualDebug( value:Boolean ):void
        {
            _visualDebug = value;
        }
        
        include "../common.txt"
        
    }
}