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
    */
    public class UserAgent
    {
        private var _applicationProduct:String;
        private var _applicationVersion:String;
        private var _applicationComment:String;
        
        private var _flashVersion:Object = LocalInfo.flashVersion;
        
        public function UserAgent( product:String = "Flash", version:String = "" )
        {
            if( (product == "Flash") && (version == "") )
            {
                applicationProduct = product;
                applicationVersion = _flashVersion.major +"." + _flashVersion.minor;
            }
        }
        
        public function get applicationProduct():String
        {
            return _applicationProduct;
        }
        
        public function set applicationProduct( value:String ):void
        {
            _applicationProduct = value;
        }
        
        public function get applicationVersion():String
        {
            return _applicationVersion;
        }
        
        public function set applicationVersion( value:String ):void
        {
            _applicationVersion = value;
        }
        
        public function get applicationProductToken():String
        {
            return applicationProduct+"/"+applicationVersion;
        }
        
        /* 
           ( Platform ;  PlayerType ;  OS ;  Localization information  ?[; DebugVersion ; PrereleaseVersion] )
        */
        public function get applicationComment():String
        {
            var comment:Array = [];
                comment.push( LocalInfo.platform );
                comment.push( LocalInfo.playerType );
                comment.push( LocalInfo.operatingSystem );
                comment.push( LocalInfo.language );
                
                if( Capabilities.isDebugger )
                {
                    comment.push( "DEBUG" );
                }
                
                /* TODO:
                   detect alpha/pre-release version ?
                */
            
            if( comment.length > 0 )
            {
                return "(" + comment.join( "; " ) + ")";
            }
            
            return "";
        }
        
        /* Returns the Tamarin engine token.
           or an empty string if vmVersion can not be found.
           
           ex:
           Tamarin/1.0d684
        */
        public function get tamarinProductToken():String
        {
            if( System.vmVersion )
            {
                return "Tamarin/" + trim( System.vmVersion, true );
            }
            else
            {
                return "";
            }
        }
        
        public function get VendorProductToken():String
        {
            var vp:String = "";
            
            /* TODO:
               check for AIR, if found
               return AIR/1.0, AIR/1.1, etc.
            */
            
                vp += "FlashPlayer";
                vp += "/";
                vp += [_flashVersion.major,_flashVersion.minor,_flashVersion.build].join( "." );
            
            return vp;
        }
        
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