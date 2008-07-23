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
    import com.google.analytics.core.as3_api;
    import com.google.analytics.core.ga_internal;
    import com.google.analytics.core.js_bridge;
    import com.google.analytics.utils.LocalInfo;
    import com.google.analytics.v4.Bridge;
    import com.google.analytics.v4.GoogleAnalyticsAPI;
    import com.google.analytics.v4.Tracker;
    
    import flash.display.Sprite;
    
    /**
    * @fileoverview Google Analytic Tracker Code (GATC)'s main component.
    */
    
    public class GATracker extends Sprite
    {
        
        /**
        * note:
        * the GATracker need to be instancied and added to the Stage
        * or at least being placed in a display list.
        */
        public function GATracker()
        {
        }
        
        public static var version:String = "0.2.0." + "$Rev$ ".split( " " )[1];
        
        public static var localInfo:LocalInfo = new LocalInfo();
        
        /**
        * Factory method for returning a tracker object.
        * 
        * @param {String} account Urchin Account to record metrics in.
        * @return {GoogleAnalyticsAPI}
        */
        as3_api function getTracker( account:String ):GoogleAnalyticsAPI
        {
            /* note:
               To be able to obtain the URL of the main SWF containing the GA API
               we need to be able to access the stage property of a DisplayObject,
               here we open the internal namespace to be able to set that reference
               at instanciation-time.
               
               We keep the implementation internal to be able to change it if required later.
            */
            use namespace ga_internal;
            GATracker.localInfo.stage = this.stage;
            return new Tracker( account );
        }
        
        /**
        * @private
        */
        js_bridge function getTracker( account:String ):GoogleAnalyticsAPI
        {
            return new Bridge( account );
        }
        
    }
}