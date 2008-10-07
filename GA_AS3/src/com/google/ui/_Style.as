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
    import flash.net.URLLoader;
    import flash.text.StyleSheet;    
    
    /**
     * The _Style class.
     */
    public class _Style
    {
    	
    	/**
    	 * @private
    	 */
        private var _defaultSheet:String;

        /**
         * @private
         */
        private var _sheet:StyleSheet;

        /**
         * @private
         */
        private var _loader:URLLoader;
        
        /**
         * The background color.
         */
        public var backgroundColor:uint;

        /**
         * The info color value.
         */
        public var infoColor:uint;
        
        /**
         * The rounded corner value.
         */
        public var roundedCorner:uint;
        
        /**
         * The warning color value.
         */
        public var warningColor:uint;
        
        /**
         * The alert color value.
         */
        public var alertColor:uint;
        
        public var successColor:uint;
        public var failureColor:uint;
        
        
        /**
         * Creates a new _Style class.
         */
        public function _Style()
        {
            _sheet  = new StyleSheet();
            _loader = new URLLoader();
            
            _init();
        }
        
        /**
         * @private
         */
        private function _init():void
        {
            _defaultSheet  = "";
            _defaultSheet += "a{text-decoration: underline;}\n";
            _defaultSheet += ".uiLabel{color: #000000;font-family: Arial;font-size: 12;margin-left: 2;margin-right: 2;}\n";
            _defaultSheet += ".uiWarning{color: #ffffff;font-family: Arial;font-size: 14;font-weight: bold;margin-left: 6;margin-right: 6;}\n";
            _defaultSheet += ".uiAlert{color: #ffffff;font-family: Arial;font-size: 14;font-weight: bold;margin-left: 6;margin-right: 6;}\n";
            _defaultSheet += ".uiInfo{color: #000000;font-family: Arial;font-size: 14;font-weight: bold;margin-left: 6;margin-right: 6;}\n";
            _defaultSheet += ".uiSuccess{color: #ffffff;font-family: Arial;font-size: 12;font-weight: bold;margin-left: 6;margin-right: 6;}\n";
            _defaultSheet += ".uiFailure{color: #ffffff;font-family: Arial;font-size: 12;font-weight: bold;margin-left: 6;margin-right: 6;}\n";
            _defaultSheet += ".uiAlertAction{color: #ffffff;text-align: center;font-family: Arial;font-size: 12;font-weight: bold;margin-left: 6;margin-right: 6;}\n";
            _defaultSheet += ".uiAlertTitle{color: #ffffff;font-family: Arial;font-size: 16;font-weight: bold;margin-left: 6;margin-right: 6;}\n";
            _defaultSheet += "\n";
            
            roundedCorner   = 6;
            backgroundColor = 0xcccccc;
            
            infoColor       = 0xffff99;
            alertColor      = 0xffcc00;
            warningColor    = 0xcc0000;
            successColor    = 0x00ff00;
            failureColor    = 0xff0000;
            
            _parseSheet( _defaultSheet );
        }
        
        /**
         * @private
         */
        private function _parseSheet( data:String ):void
        {
            _sheet.parseCSS( data );
        }
        
        /**
         * @private
         */
        public function get sheet():StyleSheet
        {
            return _sheet;
        }
        
    }
}