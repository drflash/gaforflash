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

package com.google.analytics.utils
{
    /**
    * This function takes a raw string, and removes all leading and trailing
    * whitespaces (space, new line, CR, tab).
    * 
    * If the inner option is true, trim also whitespaces within the string
    */
    public function trim( raw:String, everything:Boolean = false ):String
    {
        if( raw == "" )
        {
            return "";
        }
        
        var whitespaces:Array = [" ","\n","\r","\t"];
        var str:String = raw;
        
        if( everything )
        {
            var i:int;
            for( i=0; i<whitespaces.length && (str.indexOf( whitespaces[i] ) > -1); i++)
            {
                str = str.split( whitespaces[i] ).join( "" );
            }
        }
        else
        {
            var iLeft:int;
            var iRight:int;
            
            for( iLeft = 0; (iLeft < str.length) && (whitespaces.indexOf( str.charAt( iLeft ) ) > -1) ; iLeft++ )
                {
                }
            str = str.substr( iLeft );
            
            for( iRight = str.length - 1; (iRight >= 0) && (whitespaces.indexOf( str.charAt( iRight ) ) > -1) ; iRight-- )
                {            
                }
            str = str.substring( 0, iRight + 1 );
        }
        
        return str;
    }
}
