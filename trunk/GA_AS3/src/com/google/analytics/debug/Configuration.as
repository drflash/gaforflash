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
    
    public class Configuration
    {
        private var _verbose:Boolean = false;
        
        public var layout:Layout;
        
        public var active:Boolean = true;
        
        /**
         * To trace infos and warning to the output.
         */
        public var trace:Boolean   = true;
        
        /**
         * Allow to debug the GIF Request if true, will show a debug panel
         * and a confirmation message to send or not the request.
         */
        public var GIFRequest:Boolean = true;
        
        /**
         * Send a Gif Request with validation or not without validation (use sendToURL()) it's fire and forget
         * ok: send the request but does not returns any success or failure 
         * cancel: does not send the request with validation (use URLLoader.load())
         * ok: returns success when received by the the server
         * returns failure if not received by the server, or gif not found, or error etc.
         * cancel: does not send the request
         */
        public var validateGIFRequest:Boolean = true;
        
        /**
         * Indicates if show infos in the debug mode.
         */
        public var showInfos:Boolean = true;
        
        /**
         * Indicates if show warnings in the debug mode.
         */
        public var showWarnings:Boolean = true;
        
        /**
         * Indicates if show alerts in the debug mode.
         */
        //public var showAlerts:Boolean = true;
        
        public function Configuration(  )
        {
        }
        
        /**
         * To show more debug (used internally).
         */
        public function get verbose():Boolean
        {
            if( active )
            {
                return _verbose;
            }
            
            return false;
        }
        
        /**
        * @private
        */
        public function set verbose( value:Boolean ):void
        {
            _verbose = value;
        }
        
    }
}