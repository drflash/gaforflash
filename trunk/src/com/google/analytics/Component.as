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
 
package com.google.analytics
{
    import com.google.analytics.core.Buffer;
    import com.google.analytics.core.GIFRequest;
    import com.google.analytics.core.ga_internal;
    import com.google.analytics.debug.DebugConfiguration;
    import com.google.analytics.debug.Layout;
    import com.google.analytics.external.AdSenseGlobals;
    import com.google.analytics.external.HTMLDOM;
    import com.google.analytics.external.JavascriptProxy;
    import com.google.analytics.utils.Environment;
    import com.google.analytics.v4.Bridge;
    import com.google.analytics.v4.Configuration;
    import com.google.analytics.v4.GoogleAnalyticsAPI;
    import com.google.analytics.v4.Tracker;
    
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.events.Event;
    
    
    public class Component extends MovieClip
    {
        private var _display:DisplayObject;
        
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
        private var _mode:String         = "AS3";
        private var _visualDebug:Boolean = false;
        
        public function Component()
        {
            addEventListener( Event.ADDED_TO_STAGE, _onAddedToStage );
        }
        
        private function _onAddedToStage( event:Event ):void
        {
            trace( "ADDED_TO_STAGE" );
            removeEventListener( Event.ADDED_TO_STAGE, _onAddedToStage );
            
            _display = this;
            
            _debug   = new DebugConfiguration();
            _config  = new Configuration( _debug );
            _jsproxy = new JavascriptProxy( _debug );
            
            if( _visualDebug )
            {
                _debug.layout = new Layout( _debug, _display );
                _debug.active = _visualDebug;
            }
        }
        
        private function _getTracker( account:String ):GoogleAnalyticsAPI
        {
            //_debug.info( "GATracker v" + version +"\naccount: " + account );
            
            _adSense   = new AdSenseGlobals( _debug );
            
            _dom        = new HTMLDOM( _debug );
            _dom.cacheProperties();
            
            _env        = new Environment( "", "", "", _debug, _dom );
            
            _buffer     = new Buffer( _config, _debug, false );
            
            _gifRequest = new GIFRequest( _config, _debug, _buffer, _env );
            
            use namespace ga_internal;
            _env.url = _display.stage.loaderInfo.url;
            return new Tracker( account, _config, _debug, _env, _buffer, _gifRequest, _adSense );
        }
        
        private function _getBridge( account:String ):GoogleAnalyticsAPI
        {
            return new Bridge( account, _debug, _jsproxy );
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
        
        public function getTracker( account:String ):GoogleAnalyticsAPI
        {
            switch( mode )
            {
                case "Bridge":
                return _getBridge( account );
                
                case "AS3":
                default:
                return _getTracker( account );
            }
            
        }
        
    }
}