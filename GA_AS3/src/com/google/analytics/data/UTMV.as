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
     * User defined value : always persists for 2 years.
     */
    public class UTMV
    {
    	
    	/**
    	 * @private
    	 */
        private var _inURL:String = "__utmv";
        
//        /**
//         * Field index for domain hash in user defined cookie (__utmv) value.
//         */
//        public static const DOMAINHASH:int = 0;
        
//        /**
//         * Field index for user defined fields in user defined cookie (__utmv) value.
//         */
//        public static const VALUE:int      = 1;
       
        /**
         * The domain hash in user defined cookie (__utmv) value.
         * <p><b>Note :</b> First element in the toURLString representation) (0).</p>
         */
        public var domainHash:Number ;
        
        /**
         * The user defined fields in user defined cookie (__utmv) value.
         * <p><b>Note :</b> Second element in the toURLString representation) (1).</p>
         */    
        public var value:String;
        
        /**
         * Creates a new UTMV instance.
         * @param domainHash The field index for domain hash in user defined cookie (__utmv) value.
         * @param value
         */
        public function UTMV( domainHash:Number = 0, value:String = "" )
        {
            this.domainHash = domainHash;
            this.value      = value;
        }
        
        /**
         * Returns the URL String representation of the object.
         * @return the URL String representation of the object.
         */
        public function toURLString():String
        {
            var data:Array = [];
                data.push( domainHash ); //0
                data.push( encodeURIComponent(value) ); //1
            
            return _inURL + "=" + data.join( "." ) ;
        }
        
    }
}