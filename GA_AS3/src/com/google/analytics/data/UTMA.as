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
    * Visitor / session tracking
    * 
    * note:
    * always persists for 2 years.
    */
    public class UTMA
    {
        private var _inURL:String = "__utma";
        
        //Field index for domain hash in visitor tracking cookie (__utma) value.
        public static const DOMAINHASH:int   = 0;
        
        //Field index for session id in visitor tracking cookie (__utma) value.
        public static const SESSIONID:int    = 1;
        
        //Field index for first visit timestamp in vistior tracking cookie (__utma) value.
        public static const FIRSTTIME:int    = 2;
        
        //Field index for last visit timestamp in vistior tracking cookie (__utma) value.
        public static const LASTTIME:int     = 3;
        
        //Field index for current visit timestamp in vistior tracking cookie (__utma) value.
        public static const CURTIME:int      = 4;
        
        //Field index for session count in vistior tracking cookie (__utma) value.
        public static const SESSIONCOUNT:int = 5;
        
        
        public var domainHash:uint;
        public var sessionId:uint;
        public var firstTime:uint;
        public var lastTime:uint;
        public var currentTime:uint;
        public var sessionCount:uint;
        
        public function UTMA()
        {
        }
        
        
    }
}