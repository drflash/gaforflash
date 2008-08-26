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

package com.google.analytics.data
{
    /**
     * Visitor / session tracking : always persists for 2 years.
     */
    public class UTMA
    {
    	/**
    	 * @private
    	 */
        private var _inURL:String = "__utma";
        
        /**
         * Field index for domain hash in visitor tracking cookie (__utma) value.
         */
        public static const DOMAINHASH:int   = 0;
        
        /**
         * Field index for session id in visitor tracking cookie (__utma) value.
         */
        public static const SESSIONID:int    = 1;
        
        /**
         * Field index for first visit timestamp in vistior tracking cookie (__utma) value.
         */
        public static const FIRSTTIME:int    = 2;
        
        /**
         * Field index for last visit timestamp in vistior tracking cookie (__utma) value.
         */
        public static const LASTTIME:int     = 3;
        
        /**
         * Field index for current visit timestamp in vistior tracking cookie (__utma) value.
         */
        public static const CURTIME:int      = 4;
        
        /**
         * Field index for session count in vistior tracking cookie (__utma) value.
         */
        public static const SESSIONCOUNT:int = 5;
        
        
        /**
         * The domain hash value.
         */
        public var domainHash:Number;
        
        /**
         * The session id value.
         */
        public var sessionId:Number;
        
        /**
         * The first time value.
         */
        public var firstTime:Number;
        
        /**
         * The last time value.
         */
        public var lastTime:Number;
        
        /**
         * The current time value.
         */
        public var currentTime:Number;
        
        /**
         * The session count value.
         */
        public var sessionCount:Number;
        
        
        
        /**
         * Creates a new UTMA instance.
         */
        public function UTMA( domainHash:Number = NaN, sessionId:Number = NaN, firstTime:Number = NaN,
                              lastTime:Number = NaN, currentTime:Number = NaN, sessionCount:Number = NaN )
        {
            this.domainHash   = domainHash;
            this.sessionId    = sessionId;
            this.firstTime    = firstTime;
            this.lastTime     = lastTime;
            this.currentTime  = currentTime;
            this.sessionCount = sessionCount;
        }
        
        public function toURLString():String
        {
            var data:Array = [];
                data.push( domainHash );   //0
                data.push( sessionId );    //1
                data.push( firstTime );    //2
                data.push( lastTime );     //3
                data.push( currentTime );  //4
                data.push( sessionCount ); //5
            return _inURL + "=" + data.join( "." );
        }
        
    }
}