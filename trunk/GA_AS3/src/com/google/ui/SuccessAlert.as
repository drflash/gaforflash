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
    
    public class SuccessAlert extends Alert
    {
        public function SuccessAlert( text:String, actions:Array )
        {
            var alignement:Align = Align.bottomLeft;
            var stickToEdge:Boolean = true;
            var actionOnNextLine:Boolean = false;
            
            if( config.debugVerbose )
            {
                text = "<u><span class=\"uiAlertTitle\">Success</span>"+_spc(18)+"</u>\n\n"+text;
                alignement = Align.center;
                stickToEdge = false;
                actionOnNextLine = true;
            }
            
            super( text, actions, "uiSuccess", Style.successColor, alignement, stickToEdge, actionOnNextLine );
        }
        
        private function _spc( num:int ):String
        {
            var str:String = "";
            var spc:String = "          ";
            for( var i:int = 0; i<num+1; i++ )
            {
                str += spc;
            }
            
            return str;
        }
    }
}