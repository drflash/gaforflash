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
    import com.google.analytics.debug;
    import com.google.analytics.utils.Environment;
    import com.google.analytics.utils.generate32bitRandom;
    import com.google.analytics.utils.Protocols;
    import com.google.analytics.utils.Variables;
    
    import flash.display.Loader;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLRequest;
    import flash.net.sendToURL;
    import flash.system.LoaderContext;
    
    /**
     * Google Analytics Tracker Code (GATC)'s GIF request module.
     * This file encapsulates all the necessary components that are required to
     * generate a GIF request to the Google Analytics Back End (GABE).
     */
    public class GIFRequest
    {
        private var _buffer:Buffer;
        private var _info:Environment;
        
        private var _utmac:String;
        private var _lastRequest:URLRequest;
        
        /**
         * Creates a new GIFRequest instance.
         */
        public function GIFRequest( buffer:Buffer, info:Environment )
        {
            _buffer = buffer;
            _info   = info;
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
            
            if( debug.verbose )
            {
                debug.info( "tokenDelta: " + tokenDelta );
            }
            
            // only update token when there is a change
            if( tokenDelta >= 1 )
            {
                //Only fill bucket to capacity
                _buffer.utmb.token    = Math.min( Math.floor( _buffer.utmb.token + tokenDelta ) , config.bucketCapacity );
                _buffer.utmb.lastTime = timestamp;
                
                if( debug.verbose )
                {
                    debug.info( _buffer.utmb.toString() );
                }
                
            }
        }
        
        private function _debugSend( request:URLRequest ):void
        {
            var data:String = "url = " + request.url;
            debug.alertGifRequest( data, request, this );
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
            if( debug.GIFRequests )
            {
                debug.failure( event.text );
            }
        }
        
        public function onIOError( event:IOErrorEvent ):void
        {
            var url:String = _lastRequest.url;
            
            if( debug.GIFRequests )
            {
                if( !debug.verbose )
                {
                    if( url.indexOf( "?" ) > -1 )
                    {
                        url = url.split( "?" )[0];
                    }
                    url = _shortenURL( url );
                }
                
                debug.failure( "\"" + url + "\" does not exists or is unreachable" );
            }
            else
            {
                debug.warning( "gif request failed" );
            }
            
            _removeListeners( event.target );
        }
        
        public function onComplete( event:Event ):void
        {
            var url:String = _lastRequest.url;
            
            if( debug.GIFRequests )
            {
                if( !debug.verbose )
                {
                    if( url.indexOf( "?" ) > -1 )
                    {
                        url = url.split( "?" )[0];
                    }
                    url = _shortenURL( url );
                }
                
                debug.success( "Gif Request sent to \"" + url + "\"" );
            }
            else
            {
                debug.info( "gif request sent" );
            }
            
            _removeListeners( event.target );
        }
        
        private function _removeListeners( target:Object ):void
        {
            target.removeEventListener( IOErrorEvent.IO_ERROR, onIOError );
            target.removeEventListener( Event.COMPLETE, onComplete );
        }
        
        public function sendWithValidation( request:URLRequest ):void
        {
            trace( "sendWithValidation()" );
            
            var loader:Loader = new Loader();
            var context:LoaderContext = new LoaderContext( false );
            
            loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
            loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onComplete );
            
            _lastRequest = request;
            
            try
            {
                loader.load( request, context );
                //debug.layout.addToStage( loader );
            }
            catch( e:Error )
            {
                debug.failure( "\"Loader.load()\" could not instanciate Gif Request" );
            }
        }
        
        public function sendWithoutValidation( request:URLRequest ):void
        {
            trace( "sendWithoutValidation()" );
            try
            {
                sendToURL( request );
            }
            catch( e:Error )
            {
                debug.failure( "\"sendToURL()\" could not instanciate Gif Request" );
            }
        }
        
        public function sendRequest( request:URLRequest ):void
        {
            if( debug.validateGIFRequest )
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
        public function send( account:String, variables:Variables = null,
                              force:Boolean = false, rateLimit:Boolean = false ):void
        {
             _utmac = account;
             
             if( !variables )
             {
                 variables = new Variables();
             }
             
             variables.URIencode = false;
//             variables.pre  = [ "utmwv", "utmn", "utmhn" ];
             variables.pre  = [ "utmwv", "utmn", "utmhn", "utmcs",
                                "utmsr", "utmsc", "utmul", "utmje",
                                "utmfl", "utmdt", "utmhid", "utmr", "utmp" ];
             variables.post = [ "utmcc" ];
             
             if( debug.verbose )
             {
                 debug.info( "tracking: " + _buffer.utmb.trackCount+"/"+config.trackingLimitPerSession );
             }
             
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
                    
                    if( debug.verbose )
                    {
                        debug.info( _buffer.utmb.toString() );
                    }
                    
                    
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
                                 
                                 //localImage.data = variables;
                                 localImage.url +=  "?"+variables.toString();
                             
                             if( debug.GIFRequests )
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
                             variables.utmcc = encodeURIComponent(utmcc);
                             
                             //remoteImage.data = variables;
                             remoteImage.url +=  "?"+variables.toString();
                             
                             if( debug.GIFRequests )
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