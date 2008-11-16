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
    import com.google.analytics.core.Buffer;    

    /**
    * The Urchin Tracking Module base cookie.
    * 
    * note:
    * all utm* cookies should be able to
    * - serialize/deserialize to SharedObject
    * - keep the field sort order in serrialization
    *   ex:
    *   if utma cookie serialize to
    *   __utma=<domainHash>.<sessionId>.<firstTime>.<lastTime>.<currentTime>.<sessionCount>
    *   then domainHash should have field index 0, sessionId field index 1, etc.
    * - each cookie should be able to notify a parent proxy
    *   when one of their field is updated
    */
    public class UTMCookie implements Cookie
    {
        
        protected var name:String;
        protected var inURL:String;
        protected var fields:Array;
        public var proxy:Buffer;
        
        public function UTMCookie( name:String, inURL:String, fields:Array )
        {
            this.name   = name;
            this.inURL  = inURL;
            this.fields = fields;
        }
        
        /**
         * Deserialize data from a simple object.
         */
        public function fromSharedObject( data:Object ):void
        {
            var field:String;
            var len:int = fields.length ;
            for( var i:int = 0; i<len ; i++ )
            {
                field = fields[i];
                
                if( data[ field ] )
                {
                    this[ field ] = data[ field ];
                }
            }
        }
                
        /**
         * Indicates if the cookie is empty.
         */
        public function isEmpty():Boolean
        {
            var empty:int = 0;
            var field:String;
            
            for( var i:int = 0; i<fields.length; i++ )
            {
                field = fields[i];
                
                if( (this[ field ] is Number) && isNaN( this[ field ] ) )
                {
                    empty++;
                }
                else if( (this[ field ] is String) && (this[ field ] == "") )
                {
                    empty++;
                }
            }
            
            if( empty == fields.length )
            {
                return true;
            }
            
            return false;
        } 
        
        /**
         * Reset the cookie.
         */
        public function reset():void
        {
            var field:String;
            
            for( var i:int = 0; i<fields.length; i++ )
            {
                field = fields[i];
                
                if( this[ field ] is Number )
                {
                    this[ field ] = NaN;
                }
                else if( this[ field ] is String )
                {
                    this[ field ] = "";
                }
            }
            
            update();
        }        
        
        /**
         * Format data to render in the URL.
         */
        public function toURLString():String
        {
            return inURL + "=" + valueOf();
        }
        
        /**
         * Serialize data to a simple object.
         */
        public function toSharedObject():Object
        {
            var data:Object = {};
            var field:String;
            var value:*;
            
            for( var i:int = 0; i<fields.length; i++ )
            {
                field = fields[i];
                value = this[ field ];
                
                if( value is String )
                {
                    data[ field ] = value;
                }
                else
                {
                    if( value == 0 )
                    {
                        data[ field ] = value;
                    }
                    else if( isNaN(value) )
                    {
                        continue;
                    }
                    else
                    {
                        data[ field ] = value;
                    }
                }
                
            }
            return data;
        }
                
        /**
         * Returns the String representation of the object.
         * @return the String representation of the object.
         */
        public function toString():String
        {
            var data:Array = [];
            var field:String;
            var value:*;
            
            var len:int = fields.length ; 
            for( var i:int = 0 ; i<len ; i++ )
            {
                field = fields[i];
                value = this[ field ];
                
                if( value is String )
                {
                    data.push( field + ": \"" + value +"\"" );
                }
                else
                {
                    if( value == 0 )
                    {
                        data.push( field + ": " + value );
                    }
                    else if( isNaN( value ) )
                    {
                        continue;
                    }
                    else
                    {
                        data.push( field + ": " + value );
                    }
                }
            }
            
            return  name.toUpperCase() + " {" + data.join( ", " ) + "}";
        }
        
        /**
         * Update the cookie.
         */
        protected function update():void
        {
            if( proxy )
            {
                proxy.update( name, toSharedObject() );
            }
        }        
        
        /**
         * Returns the primitive value of the object.
         * @return the primitive value of the object.
         */
        public function valueOf():String
        {
            var data:Array = [];
            var field:String;
            var value:*;
            
            for( var i:int = 0; i<fields.length; i++ )
            {
                field = fields[i];
                value = this[ field ];
                
                if( value is String )
                {
                    if( value == "" )
                    {
                        value = "-";
                        data.push( value );
                    }
                    else
                    {
                        data.push( value );
                    }
                }
                else if( value is Number )
                {
                    if( value == 0 )
                    {
                        data.push( value );
                    }
                    else if( isNaN( value ) )
                    {
                        value = "-";
                        data.push( value );
                    }
                    else
                    {
                        data.push( value );
                    }
                }
                
            }
            
            return ""+data.join( "." );
        }
        
    }
}