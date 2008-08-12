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
    * user defined value
    * 
    * note:
    * always persists for 2 years.
    */
    public class UTMV
    {
        private var _inURL:String = "__utmv";
        
        //Field index for domain hash in user defined cookie (__utmv) value.
        public static const DOMAINHASH:int = 0;
        
        //Field index for user defined fields in user defined cookie (__utmv) value.
        public static const VALUE:int      = 1;
        
        public function UTMV()
        {
        }

    }
}