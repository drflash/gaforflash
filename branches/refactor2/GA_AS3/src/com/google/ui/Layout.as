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

package com.google.ui
{
    import com.google.analytics.config;
    
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.utils.getTimer;
    
    /**
     * The Layout class is a helper who manages all information's displays in the application.
     */
    public class Layout
    {
    	
    	/**
    	 * @private
    	 */
        private var _display:DisplayObject;

        /**
         * @private
         */        
        private var _hasWarning:Boolean;
        
        /**
         * @private
         */
        private var _hasInfo:Boolean;
        
        /**
         * @private
         */
        private var _hasDebug:Boolean;
        
        /**
         * @private
         */
        private var _warningQueue:Array;
        
        private var _maxCharPerLine:int = 85;
        
        /**
         * @private
         */
        private var _infoQueue:Array;
        
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
        
        private function _filterMaxChars( message:String ):String
        {
            var CRLF:String = "\n";
            var output:Array = [];
            var lines:Array = message.split(CRLF);
            var line:String;
            for( var i:int = 0; i<lines.length; i++ )
            {
                line = lines[i];
                while( line.length > _maxCharPerLine )
                {
                    output.push( line.substr(0,_maxCharPerLine) );
                    line = line.substring(_maxCharPerLine);
                }
                output.push( line );
            }
            
            return output.join(CRLF);
        }
        
        /**
         * @private
         */
        private function _clearWarning( event:Event ):void
        {
            _hasWarning = false;
            
            if( _warningQueue.length > 0 )
            {
                createWarning( _warningQueue.shift() );
            }
            
        }

        /**
         * @private
         */
        private function _clearInfo( event:Event ):void
        {
            _hasInfo = false;
            
            if( _infoQueue.length > 0 )
            {
                createInfo( _infoQueue.shift() );
            }
            
        }
        
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
            
            for( var i:int = 0; i<messages.length; i++ )
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
        

        
    }
}

