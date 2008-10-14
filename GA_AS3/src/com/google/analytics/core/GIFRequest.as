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

package com.google.analytics.core
{
    import com.google.analytics.config;
    import com.google.analytics.utils.Environment;
    import com.google.analytics.utils.Protocols;
    import com.google.analytics.utils.generate32bitRandom;
    import com.google.analytics.debug.Layout;
    
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.net.URLVariables;
    import flash.net.sendToURL;
    
    /**
     * Google Analytics Tracker Code (GATC)'s GIF request module.
     * This file encapsulates all the necessary components that are required to
     * generate a GIF request to the Google Analytics Back End (GABE).
     */
    public class GIFRequest
    {
        private var _buffer:Buffer;
        private var _info:Environment;
        private var _layout:Layout;
        
        private var _utmac:String;
        private var _lastRequest:URLRequest;
        
        /**
         * Creates a new GIFRequest instance.
         */
        public function GIFRequest( buffer:Buffer, info:Environment,
                                    layout:Layout = null )
        {
            _buffer = buffer;
            _info   = info;
            
            _layout = layout;
        }
        
        /**
        * Account String. Appears on all requests.
        * 
        * ex:
        * utmac=UA-2202604-2
        */
        public function get utmac():String
        {
            return _utmac;
        }
        
        /**
        * Tracking code version
        * 
        * ex:
        * utmwv=1
        */
        public function get utmwv():String
        {
            return config.version;
        }
        
        /**
        * Unique ID generated for each GIF request to prevent caching of the GIF image.
        * 
        * ex:
        * utmn=1142651215
        */
        public function get utmn():String
        {
            return generate32bitRandom() as String;
        }
        
        /**
        * Host Name, which is a URL-encoded string.
        * 
        * ex:
        * utmhn=x343.gmodules.com
        */
        public function get utmhn():String
        {
            return _info.domainName;
        }
        
        /**
        * Sample rate
        */
        public function get utmsp():String
        {
            return (config.sampleRate * 100) as String;
        }
        
        /**
        * Cookie values. This request parameter sends all the cookies requested from the page.
        * 
        * ex:
        * utmcc=__utma%3D117243.1695285.22%3B%2B__utmz%3D117945243.1202416366.21.10.utmcsr%3Db%7Cutmccn%3D(referral)%7Cutmcmd%3Dreferral%7Cutmcct%3D%252Fissue%3B%2B
        * 
        * note:
        * you first get each cookie
        * __utma=117243.1695285.22;
        * __utmz=117945243.1202416366.21.10.utmcsr=b|utmccn=(referral)|utmcmd=referral|utmcct=%2Fissue;
        * the rhs can already be URLencoded , see for ex %2Fissue is for /issue
        * you join all the cookie and separate them with +
        * __utma=117243.1695285.22;+__utmz=117945243.1202416366.21.10.utmcsr=b|etc
        * the you URLencode all
        * __utma%3D117243.1695285.22%3B%2B__utmz%3D117945243.1202416366.21.10.utmcsr%3Db%7Cetc
        */
        public function get utmcc():String
        {
            var cookies:Array = [];
            
            if( _buffer.hasUTMA() )
            {
                cookies.push( _buffer.utma.toURLString() + ";" );
            }
            
            if( _buffer.hasUTMZ() )
            {
                cookies.push( _buffer.utmz.toURLString() + ";" );
            }
            
            if( _buffer.hasUTMV() )
            {
                cookies.push( _buffer.utmv.toURLString() + ";" );
            }
            
            //delimit cookies by "+"
            return cookies.join( "+" );
        }
        
        /**
        * Updates the token in the bucket.
        * This method first calculates the token delta since
        * the last time the bucket count is updated.
        * 
        * If there are no change (zero delta), then it does nothing.
        * However, if there is a delta, then the delta is added to the bucket,
        * and a new timestamp is updated for the bucket as well.
        * 
        * To prevent spiking in traffic after a large number of token
        * has accumulated in the bucket (after a long period of time),
        * we have added a maximum capacity to the bucket.
        * In other words, we will not allow the bucket to accumulate
        * token passed a certain threshold.
        */
        public function updateToken():void
        {
            var timestamp:Number = new Date().getTime();
            var tokenDelta:Number;
            
            // calculate the token count increase since last update
            tokenDelta = (timestamp - _buffer.utmb.lastTime) * (config.tokenRate / 1000);
            trace( "tokenDelta: " + tokenDelta );
            
            // only update token when there is a change
            if( tokenDelta >= 1 )
            {
                //Only fill bucket to capacity
                _buffer.utmb.token    = Math.min( Math.floor( _buffer.utmb.token + tokenDelta ) , config.bucketCapacity );
                _buffer.utmb.lastTime = timestamp;
                trace( _buffer.utmb.toString() );
            }
        }
        
        private function _debugSend( request:URLRequest ):void
        {
            var data:String = "url = " + request.url + "\n";
            for( var param:String in request.data )
            {
                if( param == "utmcc" )
                {
                    var utmcc:String = decodeURIComponent(request.data[param]);
                    var fields:Array = utmcc.split(";+");
                    var tmp:String = param + " = ";
                    
                    data += tmp + "\n";
                    tmp = "";
                    
                    for( var i:int = 0; i<fields.length; i++ )
                    {
                        data += tmp + fields[i] + "\n";
                    }
                    
                    //data += param + " = " + decodeURIComponent(request.data[param]) + "\n";
                }
                else
                {
                    data += param + " = " + request.data[param] + "\n";
                }
            }
            
            if( _layout )
            {
                //_layout.createAlert( data );
                _layout.createGIFRequestAlert( data, request, this );
            }
            
        }
        
        private function _shortenURL( url:String ):String
        {
            if( url.length > 60 )
            {
                var paths:Array = url.split( "/" );
                while( url.length > 60 )
                {
                    paths.shift();
                    url = "../" + paths.join("/");
                }
            }
            
            return url;
        }
        
        public function onSecurityError( event:SecurityErrorEvent ):void
        {
            if( _layout && config.debugGIFRequest )
            {
                _layout.createFailureAlert( event.text );
            }
        }
        
        public function onIOError( event:IOErrorEvent ):void
        {
            if( _layout && config.debugGIFRequest )
            {
                //_layout.createFailureAlert( event.text );
                var url:String = _lastRequest.url;
                
                if( config.debugVerbose )
                {
                    url += "?"+_lastRequest.data.toString();
                }
                else
                {
                    url = _shortenURL( url );
                }
                
                _layout.createFailureAlert( "\"" + url + "\" does not exists or is unreachable" );
            }
        }
        
        public function onComplete( event:Event ):void
        {
            if( _layout && config.debugGIFRequest )
            {
                var url:String = _lastRequest.url;
                
                if( config.debugVerbose )
                {
                    url += "?"+_lastRequest.data.toString();
                }
                else
                {
                    url = _shortenURL( url );
                }
                
                _layout.createSuccessAlert( "Gif Request sent to \"" + url + "\"" );
            }
        }
        
        public function sendWithValidation( request:URLRequest ):void
        {
            var req:URLLoader = new URLLoader();
            
            req.addEventListener( IOErrorEvent.IO_ERROR, onIOError, false, 0, true );
            req.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError, false, 0, true );
            req.addEventListener( Event.COMPLETE, onComplete, false, 0, true );
            
            _lastRequest = request;
            
            try
            {
                req.load( request );
            }
            catch( e:Error )
            {
                if( _layout )
                {
                    _layout.createFailureAlert( "\"URLLoader.load()\" could not instanciate Gif Request" );
                }
            }
        }
        
        public function sendWithoutValidation( request:URLRequest ):void
        {
            try
            {
                sendToURL( request );
            }
            catch( e:Error )
            {
                if( _layout )
                {
                    _layout.createFailureAlert( "\"sendToURL()\" could not instanciate Gif Request" );
                }
            }
        }
        
        public function sendRequest( request:URLRequest ):void
        {
            if( config.validateGIFRequest )
            {
                sendWithValidation( request );
            }
            else
            {
                sendWithoutValidation( request );
            }
        }
        
        /**
        * 
        * 
        */
        public function send( account:String, variables:URLVariables = null,
                              force:Boolean = false, rateLimit:Boolean = false ):void
        {
             _utmac = account;
             
             if( !variables )
             {
                 variables = new URLVariables();
             }
             
             trace( _buffer.utmb.trackCount +" < "+ config.trackingLimitPerSession );
             /* Only send request if
                1. We havn't reached the limit yet.
                2. User forced gif hit
             */
            if( (_buffer.utmb.trackCount < config.trackingLimitPerSession) || force )
            {
                //update token bucket
                if( rateLimit )
                {
                    updateToken();
                }
                
                //if there are token left over in the bucket, send request
                if( force || !rateLimit || (_buffer.utmb.token >= 1) )
                {
                    //Only consume a token for non-forced and rate limited tracking calls.
                    if( !force && rateLimit )
                    {
                        _buffer.utmb.token -= 1;
                    }
                    
                    //increment request count
                    _buffer.utmb.trackCount += 1;
                    
                    
                    variables.utmwv = utmwv;
                    variables.utmn  = generate32bitRandom();
                    
                    if( _info.domainName != "" )
                    {
                        variables.utmhn = _info.domainName;
                    }
                    
                    if( config.sampleRate < 1 )
                    {
                        variables.utmsp = config.sampleRate * 100;
                    }
                    
                     /* If service mode is send to local (or both),
                        then we'll sent metrics via a local GIF request.
                     */
                     if( (config.serverMode = ServerOperationMode.local) ||
                         (config.serverMode = ServerOperationMode.both) )
                         {
                             var localPath:String = _info.locationSWFPath;
                             
                             if( localPath.lastIndexOf( "/" ) > 0 )
                             {
                                 localPath = localPath.substring(0,localPath.lastIndexOf( "/" ));
                             }
                             
                             var localImage:URLRequest = new URLRequest();
                                 localImage.url  = localPath + config.localGIFpath;
                                 localImage.data = variables;
                             
                             if( config.debugGIFRequest )
                             {
                                 _debugSend( localImage );
                             }
                             else
                             {
                                 sendRequest( localImage );
                             }
                         }
                     
                     /* If service mode is set to remote (or both),
                        then we'll sent metrics via a remote GIF request.
                     */
                     if( (config.serverMode = ServerOperationMode.remote) ||
                         (config.serverMode = ServerOperationMode.both) )
                         {
                             var remoteImage:URLRequest = new URLRequest();
                             
                             /* get remote address (depending on protocol),
                                then append rest of metrics / data
                             */
                             if( _info.protocol == Protocols.HTTPS )
                             {
                                 remoteImage.url = config.secureRemoteGIFpath;
                             }
                             else if( _info.protocol == Protocols.HTTP )
                             {
                                 remoteImage.url = config.remoteGIFpath;
                             }
                             else
                             {
                                 trace( "## we are in a local file:// !! ##" );
                                 remoteImage.url = config.remoteGIFpath;
                             }
                             
                             variables.utmac = utmac;
                             variables.utmcc = encodeURIComponent( utmcc );
                             
                             remoteImage.data = variables;
                             
                             if( config.debugGIFRequest )
                             {
                                 _debugSend( remoteImage );
                             }
                             else
                             {
                                 sendRequest( remoteImage );
                             }
                             
                         }
                    
                }
                
            }
        }
        
        
    }
}