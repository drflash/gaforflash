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
	/**
	 * The Debug label class.
	 */
    public class Debug extends Label
    {
    	
    	/**
    	 * @private
    	 */
        private var _lines:Array;
        
        /**
         * The maximum number of lines in the debug label display.
         */
        public var maxLines:uint = 5;
        
        /**
         * Creates a new Debug instance.
         * @param color The color of the debug label.
         * @param alignement The Align value of the debug label.
         * @param stickToEdge The flag to defines the stickToEdge value.
         */
        public function Debug( color:uint=0, alignement:Align=null, stickToEdge:Boolean=false )
        {
            super("", "uiLabel", color, Align.bottom, true);
            
            _lines = [];
            
            forcedWidth = 500;
            selectable  = true;
        }
        
        /**
         * Writes a new message in the debug label.
         * @param message The message value to show in the debug label in the application.
         */
        public function write( message:String ):void
        {
            _lines.push( message );
            
            var lines:Array;
            if( _lines.length > maxLines+1 )
            {
                var start:uint = _lines.length-maxLines;
                var end:uint   = start + maxLines; 
                lines = _lines.slice( start, end );
            }
            else
            {
                lines = _lines;
            }
            
            text = lines.join("\n");
        }
        
    }
}