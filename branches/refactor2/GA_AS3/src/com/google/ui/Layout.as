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
    import flash.display.DisplayObject;
    import flash.events.Event;
    
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
            
            _hasInfo = true;
            var i:Info = new Info( message );
            addToStage( i );
            bringToFront( i );
            i.addEventListener( Event.REMOVED_FROM_STAGE, _clearInfo );
            
            if( _hasDebug )
            {
                debug.write( message );
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
                debug.write( "## "+message+" ##" );
            }
        }
        

        
    }
}

