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
    import flash.system.Capabilities;
    import flash.system.System;
    
    /**
    * User Agent
    * Constructs a user agent string for Flash.
    * 
    * info:
    * here we mimic a user-agent string for Flash
    * based on
    * http://www.mozilla.org/build/user-agent-strings.html
    * http://www.mozilla.org/build/revised-user-agent-strings.html
    * RFC 1945 - http://www.ietf.org/rfc/rfc1945.txt
    * RFC 2068 - http://www.ietf.org/rfc/rfc2068.txt
    * 
    * User-Agent        = "User-Agent" ":" 1*( product | comment )
    * product           = token ["/" product-version ]
    * product-version   = token
    * comment           = "(" *( ctext | comment ) ")"
    * ctext             = <any TEXT excluding "(" and ")">
    * token             = 1*<any CHAR except CTLs or tspecials>
    * tspecials         = "(" | ")" | "<" | ">" | "@" | "," | ";" | ":" | "\" | <"> | "/" | "[" | "]" | "?" | "=" | "{" | "}" | SP | HT 
    * 
    * 
    *
    * Constructs a user agent string for Flash.
    */
    
    public class UserAgent
    {
        /**
         * @private
         */
        private var _applicationProduct:String;
        
        /**
         * @private
         */
        private var _applicationVersion:String;
        
        /**
         * @private
         */
        private var _applicationComment:String;
        
        private var _localInfo:LocalInfo;
        
        /* for privacy concern */
        public static var minimal:Boolean = false;
        
        /**
         * Creates a new UserAgent instance.
         * @param product The product String representation.
         * @param version The version String representation.
         */
        public function UserAgent( localInfo:LocalInfo, product:String = "Flash", version:String = "" )
        {
            _localInfo = localInfo;
            applicationProduct = product;
            
            if( (product == "Flash") && (version == "") )
            {
                applicationVersion = _localInfo.flashVersion.toString(2);
            }
            else
            {
                applicationVersion = version;
            }
        }
        
        /**
         * Indicates the application product String representation.
         */
        public function get applicationProduct():String
        {
            return _applicationProduct;
        }
        
        public function set applicationProduct( value:String ):void
        {
            _applicationProduct = value;
        }
        
        /**
         * Indicates the application version String representation.
         */
        public function get applicationVersion():String
        {
            return _applicationVersion;
        }
        
        public function set applicationVersion( value:String ):void
        {
            _applicationVersion = value;
        }
        
        /**
         * Indicates the application product token String representation.
         */
        public function get applicationProductToken():String
        {
            var token:String = applicationProduct;
            
            if( applicationVersion != "" )
            {
                token += "/" + applicationVersion;
            }
            
            return token;
        }
        
        /* 
           ( Platform ;  PlayerType ;  OS ;  Localization information  ?[; DebugVersion ; PrereleaseVersion] )
        */
        public function get applicationComment():String
        {
            var comment:Array = [];
                comment.push( _localInfo.platform );
                comment.push( _localInfo.playerType );
                comment.push( _localInfo.operatingSystem );
                
                if( !UserAgent.minimal )
                {
                    comment.push( _localInfo.language );
                }
                
                if( Capabilities.isDebugger )
                {
                    comment.push( "DEBUG" );
                }
                
                /* TODO:
                   detect alpha/pre-release version ?
                */
            
            if( comment.length > 0 )
            {
                return "(" + comment.join( "; " ) + ")" ;
            }
            
            return "";
        }        
        
        
        /**
         * Indicates the Tamarin engine token or an empty string if vmVersion can not be found.
         * <p><b>Example :</b> <code>Tamarin/1.0d684</code></p>
         */
        public function get tamarinProductToken():String
        {
            if( UserAgent.minimal )
            {
                return "";
            }
            
            if( System.vmVersion )
            {
                return "Tamarin/" + trim( System.vmVersion, true ) ;
            }
            else
            {
                return "" ;
            }
        }
        
        /**
         * Indicates the vendor production token String representation.
         */
        public function get VendorProductToken():String
        {
            var vp:String = "";
            
            /* TODO:
               check for AIR, if found
               return AIR/1.0, AIR/1.1, etc.
            */
            
                vp += "FlashPlayer";
                vp += "/";
                vp += _localInfo.flashVersion.toString(3);
            
            return vp;
        }
        
        /**
         * Returns the String representation of the object.
         * @return the String representation of the object.
         */
        public function toString():String
        {
            var UA:String = "";
            
                UA += applicationProductToken;
            
            if( applicationComment != "" )
            {
                UA += " " + applicationComment;
            }
            
            if( tamarinProductToken != "" )
            {
                UA += " " + tamarinProductToken;
            }
            
            if( VendorProductToken != "" )
            {
                UA += " " + VendorProductToken;
            }
            
            return UA;
        }
        
    }
}