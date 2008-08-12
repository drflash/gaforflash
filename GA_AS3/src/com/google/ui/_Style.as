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

package com.google.ui
{
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.text.StyleSheet;
    
    public class _Style
    {
        private var _defaultSheet:String;
        private var _sheet:StyleSheet;
        private var _loader:URLLoader;
        
        public var roundedCorner:uint;
        public var backgroundColor:uint;
        
        public var warningColor:uint;
        public var infoColor:uint;
        
        
        public function _Style()
        {
            _sheet  = new StyleSheet();
            _loader = new URLLoader();
            
            _init();
        }
        
        private function _init():void
        {
            _defaultSheet  = "";
            _defaultSheet += "a{text-decoration: underline;}\n";
            _defaultSheet += ".uiLabel{color: #000000;font-family: Arial;font-size: 12;margin-left: 2;margin-right: 2;}\n";
            _defaultSheet += ".uiWarning{color: #ffffff;font-family: Arial;font-size: 14;font-weight: bold;margin-left: 6;margin-right: 6;}\n";
            _defaultSheet += ".uiInfo{color: #000000;font-family: Arial;font-size: 14;font-weight: bold;margin-left: 6;margin-right: 6;}\n";
            _defaultSheet += "\n";
            
            roundedCorner   = 6;
            backgroundColor = 0xcccccc;
            
            warningColor    = 0xcc0000;
            infoColor       = 0xffff99;
            
            _parseSheet( _defaultSheet );
        }
        
        private function _parseSheet( data:String ):void
        {
            _sheet.parseCSS( data );
        }
        
        
        public function get sheet():StyleSheet
        {
            return _sheet;
        }
        
    }
}