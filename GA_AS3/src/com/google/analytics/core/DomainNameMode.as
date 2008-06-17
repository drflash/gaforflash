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

package com.google.analytics.core
{
    /**
    * Domain name mode Enumeration.
    */
    public class DomainNameMode
    {
        /**
         * @private
         */
        private var _value:int;
        
        /**
         * @private
         */        
        private var _name:String;
        
        public function DomainNameMode( value:int = 0, name:String = "" )
        {
            _value = value;
            _name  = name;
        }
        
        /**
         * Returns the primitive value of the object.
         * @return the primitive value of the object.
         */
        public function valueOf():int
        {
            return _value;
        }
        
        /**
         * Returns the String representation of the object.
         * @return the String representation of the object.
         */
        public function toString():String
        {
            return _name;
        }
        
        /**
        * none is used in the following two situations:
        * - You want to disable tracking across hosts.
        * - You want to set up tracking across two separate domains.
        *   Cross- domain tracking requires configuration of the setAllowLinker() and link() methods.
        */
        public static const none:DomainNameMode    = new DomainNameMode( 0, "none" );
        
        /**
        * Attempts to automaticaly resolve the domain name.
        */
        public static const auto:DomainNameMode    = new DomainNameMode( 1, "auto" );
        
        /**
        * Custom is used to set explicitly to your domain name if your website spans multiple hostnames,
        * and you want to track visitor behavior across all hosts.
        * 
        * For example, if you have two hosts:
        * server1.example.com and server2.example.com,
        * you would set the domain name as follows:
        * pageTracker.setDomainName( new Domain( DomainName.custom, ".example.com" ) );
        */
        public static const custom:DomainNameMode  = new DomainNameMode( 2, "custom" );

    }
}