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

package com.google.analytics.core
{
    import com.google.analytics.config;
    import com.google.analytics.external.AdSenseGlobals;
    import com.google.analytics.utils.LocalInfo;
    
    import flash.net.URLVariables;
    
    public class DocumentInfo
    {
        private var _info:LocalInfo;
        private var _adSense:AdSenseGlobals;
        
        private var _pageURL:String;
        private var _utmr:String;
        
        public function DocumentInfo( info:LocalInfo, formatedReferrer:String,
                                      pageURL:String = null, adSense:AdSenseGlobals = null )
        {
            _info = info;
            
            _utmr = formatedReferrer;
            
            _pageURL = pageURL;
            
            if( !adSense )
            {
                adSense = new AdSenseGlobals();
            }
            _adSense = adSense;
        }
        
  /**
   * Generates hit id for revenue per page tracking for AdSense.  This method
   * first examines the DOM for existing hid.  If there is already a hid in DOM,
   * then this method will return the existing hid.  If there isn't any hid in
   * DOM, then this method will generate a new hid, and both stores it in DOM, and
   * returns it to the caller.
   *
   * @memberOf _gat
   * @private
   * @return {Number} hid used by AdSense for revenue per page tracking
   */
        private function _generateHitId():Number
        {
            var hid:Number;
            
            //have hid in DOM
            if( _adSense.hid && (_adSense.hid != "") )
            {
                hid = Number( _adSense.hid );
            }
            //doesn't have hid in DOM
            else
            {
                hid = Math.round( Math.random() * 0x7fffffff );
                _adSense.hid = String( hid );
            }
            
            return hid;
        }
        
  /**
   * This method will collect and return the page URL information based on
   * the page URL specified by the user if present, and the document's
   * actual path otherwise.
   *
   * @private
   * @param {String} opt_pageURL (Optional) User-specified Page URL to assign
   *     metrics to at the back-end.
   *
   * @return {String} Final page URL to assign metrics to at the back-end.
   */
        private function _renderPageURL( pageURL:String = "" ):String
        {
            var pathname:String = _info.locationPath;
            var search:String   = _info.locationSearch;
            
            if( !pageURL || (pageURL == "") )
            {
                pageURL = pathname + unescape( search );
            }
            
            return pageURL;
        }
        
        /**
        * Page title, which is a URL-encoded string.
        * 
        * ex:
        * utmdt=analytics%20page%20test
        */
        public function get utmdt():String
        {
            return _info.documentTitle;
        }
        
        /**
        * hit id for revenue per page tracking for AdSense.
        * 
        * ex:
        * utmhid=2059107202
        */
        public function get utmhid():String
        {
            return String( _generateHitId() );
        }
        
        /**
        * Referral, complete URL.
        * 
        * ex:
        * utmr=http://www.example.com/aboutUs/index.php?var=selected
        */
        public function get utmr():String
        {
            return _utmr;
        }
        
        /**
        * Page request of the current page. 
        * 
        * ex:
        * utmp=/testDirectory/myPage.html
        */
        public function get utmp():String
        {
            return _renderPageURL( _pageURL );
        }
        
        public function toURLVariables():URLVariables
        {
            var variables:URLVariables = new URLVariables();
                
                if( config.detectTitle && ( utmdt != "") )
                {
                    variables.utmdt = utmdt;
                }
                
                variables.utmhid = utmhid;
                variables.utmr   = utmr;
                variables.utmp   = utmp;
            
            return variables;
        }
        
        public function toURLString():String
        {
            var v:URLVariables = toURLVariables();
            return v.toString();
        }
    }
}