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

package com.google.analytics.debug
{
    import com.google.analytics.config;
    import com.google.analytics.core.GIFRequest;
    
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.net.URLRequest;
    import flash.utils.getTimer;
    
    /**
     * The Layout class is a helper who manages
     * as a factory all visual display in the application.
     */
    public class Layout
    {
        private var _display:DisplayObject;
        private var _hasWarning:Boolean;
        private var _hasInfo:Boolean;
        private var _hasDebug:Boolean;
        private var _infoQueue:Array;
        private var _maxCharPerLine:int = 85;
        private var _warningQueue:Array;
        
        /**
         * The Debug reference of this Layout.
         */
        public var debug:Debug;
        
        /**
         * Creates a new Layout instance.
         */
        public function Layout( display:DisplayObject )
        {
            super();
            _display   = display;
            _hasWarning = false;
            _hasInfo    = false;
            _hasDebug   = false;
            _warningQueue = [];
            _infoQueue    = [];
        }
        
        private function _clearInfo( event:Event ):void
        {
            _hasInfo = false;
            
            if( _infoQueue.length > 0 )
            {
                createInfo( _infoQueue.shift() );
            }
        }
        
        private function _clearWarning( event:Event ):void
        {
            _hasWarning = false;
            if( _warningQueue.length > 0 )
            {
                createWarning( _warningQueue.shift() );
            }
        }        
        
        private function _filterMaxChars( message:String, maxCharPerLine:int = 0 ):String
        {
            var CRLF:String = "\n";
            var output:Array = [];
            var lines:Array = message.split(CRLF);
            var line:String;
            
            if( maxCharPerLine == 0 )
            {
                maxCharPerLine = _maxCharPerLine;
            }
            
            for( var i:int = 0; i<lines.length; i++ )
            {
                line = lines[i];
                while( line.length > maxCharPerLine )
                {
                    output.push( line.substr(0,maxCharPerLine) );
                    line = line.substring(maxCharPerLine);
                }
                output.push( line );
            }
            return output.join(CRLF);
        }
        
        /**
         * The protected custom trace method.
         */
        protected function trace( message:String ):void
        {
            var messages:Array = [];
            var pre0:String = getTimer() + " - ";
            var pre1:String = new Array(pre0.length).join(" ") + " ";
            
            if( message.indexOf("\n") > -1 )
            {
                var msgs:Array = message.split("\n");
                for( var j:int = 0; j<msgs.length; j++ )
                {
                    if( msgs[j] == "" )
                    {
                        continue;
                    }
                    
                    if( j == 0 )
                    {
                        messages.push( pre0 + msgs[j] );
                    }
                    else
                    {
                        messages.push( pre1 + msgs[j] );
                    }
                }
            }
            else
            {
                messages.push( pre0 + message );
            }
            
            var len:int = messages.length ;
            for( var i:int = 0; i<len ; i++ )
            {
                public::trace( messages[i] );
            }
        }
        
        /**
         * Adds to stage the specified visual display.
         */
        public function addToStage( visual:DisplayObject ):void
        {
            _display.stage.addChild( visual );
        }
        
        /**
         * Brings to front the specified visual display.
         */
        public function bringToFront( visual:DisplayObject ):void
        {
            _display.stage.setChildIndex( visual, _display.stage.numChildren - 1 );
        }
        
        /**
         * Creates an alert message in the debug display.
         */
        public function createAlert( message:String ):void
        {
            message = _filterMaxChars( message );
            var a:Alert = new Alert( message, [ new AlertAction("Close","close","close") ] );
            addToStage( a );
            bringToFront( a );
            if( _hasDebug )
            {
                debug.write( "<b>"+message+"</b>" );
            }
            if( config.debugTrace )
            {
                trace( "##" + message + " ##" );
            }
        }
        
        /**
         * Creates a debug message in the debug display.
         */
        public function createDebug():void
        {
            if( !debug )
            {
                debug = new Debug();
                debug.alignement = Align.bottom;
                debug.stickToEdge = true;
                addToStage( debug );
                _hasDebug = true;
            }
        }
        
        /**
         * Creates a failure alert message in the debug display.
         */
        public function createFailureAlert( message:String ):void
        {
            if( config.debugVerbose )
            {
                message = _filterMaxChars( message );
            }
            var fa:Alert = new FailureAlert( message, [ new AlertAction("Close","close","close") ] );
            addToStage( fa );
            bringToFront( fa );
            
            if( _hasDebug )
            {
                if( config.debugVerbose )
                {
                    message = message.split("\n").join("");
                    message = _filterMaxChars( message, 66 );
                }
                debug.write( "<b>"+message+"</b>" );
            }
            
            if( config.debugTrace )
            {
                trace( "## " + message + " ##" );
            }
        }
        
        /**
         * Creates a GIFRequest alert message in the debug display.
         */
        public function createGIFRequestAlert( message:String, request:URLRequest, ref:GIFRequest ):void
        {
            
            var f:Function = function():void
            {
                ref.sendRequest( request );
            };
            
            message = _filterMaxChars( message );
            var gra:GIFRequestAlert = new GIFRequestAlert( message, [ new AlertAction("OK","ok",f),
                                                                      new AlertAction("Cancel","cancel","close") ] );
            addToStage( gra );
            bringToFront( gra );
            
            if( _hasDebug )
            {
                //debug.write( "<b>"+message+"</b>" );
                debug.write( message );
            }
            
            if( config.debugTrace )
            {
                trace( "##" + message + " ##" );
            }
        }
        
        /**
         * Creates an info message in the debug display.
         */        
        public function createInfo( message:String ):void
        {
            if( _hasInfo )
            {
                _infoQueue.push( message );
                return;
            }
            
            message = _filterMaxChars( message );
            _hasInfo = true;
            var i:Info = new Info( message );
            addToStage( i );
            bringToFront( i );
            i.addEventListener( Event.REMOVED_FROM_STAGE, _clearInfo );
            
            if( _hasDebug )
            {
                debug.write( message );
            }
            
            if( config.debugTrace )
            {
                trace( message );
            }
        }
        
        /**
         * Creates a warning message in the debug display.
         */
        public function createWarning( message:String ):void
        {
            if( _hasWarning )
            {
                _warningQueue.push( message );
                return;
            }
            _hasWarning = true;
            var w:Warning = new Warning( message );
            addToStage( w );
            bringToFront( w );
            w.addEventListener( Event.REMOVED_FROM_STAGE, _clearWarning );
            if( _hasDebug )
            {
                debug.write( "<b>"+message+"</b>" );
            }
            if( config.debugTrace )
            {
                trace( "## " + message + " ##" );
            }
        }
        
        /**
         * Creates a success alert message in the debug display.
         */
        public function createSuccessAlert( message:String ):void
        {
            if( config.debugVerbose )
            {
                message = _filterMaxChars( message );
            }
            var sa:Alert = new SuccessAlert( message, [ new AlertAction("Close","close","close") ] );
            addToStage( sa );
            bringToFront( sa );
            
            if( _hasDebug )
            {
                if( config.debugVerbose )
                {
                    message = message.split("\n").join("");
                    message = _filterMaxChars( message, 66 );
                }
                debug.write( "<b>"+message+"</b>" );
            }
            
            if( config.debugTrace )
            {
                trace( "## " + message + " ##" );
            }
        }
        
    }
}

