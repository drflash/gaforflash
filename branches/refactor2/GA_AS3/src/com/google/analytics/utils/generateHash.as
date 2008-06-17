/*
 * Copyright 2008 Adobe Systems Inc., 2008 Google Inc.Licensed under the Apache License, 
 * Version 2.0 (the "License");you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at    
 * http://www.apache.org/licenses/LICENSE-2.0Unless required by applicable law or agreed to in writing, 
 * software distributed under the License is distributed on an 
 * "AS IS" BASIS,WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, 
 * either express or implied.See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.google.analytics.utils
{
    /**
    * Generate hash for input string.
    * This is a global method, since it does not need
    * to access any instance variables, and it is being
    * used everywhere in the GATC module.
    * 
    * @param {String} input Input string to generate hash value on.
    * @return {Number} Hash value of input string.
    *                  If input string is undefined, or empty, return hash value of 1.
    */
    public function generateHash(input:String):int
    {
        var hash:int      = 1; // hash buffer
        var leftMost7:int = 0; // left-most 7 bits
        var pos:int;           // character position in string
        var current:int;       // current character in string
        
        // if input is undef or empty, hash value is 1
        if(input != null && input != "")
        {
            hash = 0;
            
            // hash function
            for(pos = input.length - 1; pos >= 0; pos--)
            {
                current   = input.charCodeAt(pos);
                hash      = ((hash << 6) & 0xfffffff) + current + (current << 14);
                leftMost7 = hash & 0xfe00000;
                //hash      = (leftMost7 != 0) ? (hash ^ (leftMost7 >> 21)) : hash;
                if(leftMost7 != 0)
                {
                    hash ^= leftMost7 >> 21;
                }
            }
        }
        
        return hash;
    }
}