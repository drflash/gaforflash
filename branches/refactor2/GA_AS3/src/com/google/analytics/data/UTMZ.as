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

package com.google.analytics.data
{
    /**
    * campaign tracking
    * 
    * note:
    * persists for 6 months.
    */
    public class UTMZ
    {
        private var _inURL:String = "__utmz";
        
        //Field index for domain hash in campaign tracking cookie (__utmz) value.
        public static const DOMAINHASH:int       = 0;
        
        //Field index for campaign creation timestamp in campaign tracking cookie (__utmz) value.
        public static const CAMPAIGNCREATION:int = 1;
        
        //Field index for campaign session count in campaign tracking cookie (__utmz) value.
        public static const CAMPAIGNSESSIONS:int = 2;
        
        //Field index for response count in campaign tracking cookie (__utmz) value.
        public static const RESPONSECOUNT:int    = 3;
        
        //Field index for campaign tracker in campaign tracking cookie (__utmz) value.
        public static const CAMPAIGNTRACKING:int = 4;
        
        
        
        public function UTMZ()
        {
        }

    }
}