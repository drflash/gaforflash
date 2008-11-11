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
 *   Marc ALCARAZ <ekameleon@gmail.com>.
 *   Zwetan Kjukov <zwetan@gmail.com>.
 */
 
package com.google.analytics.core 
{
    import com.google.analytics.v4.GoogleAnalyticsAPI;                                                                        

    /**
     * This queue is used in the GA trackers during the initialize process to keep in memory the users tracking.
     * This cache is flushing when the tracker is initialize. 
     */
    public class TrackerCache implements GoogleAnalyticsAPI
    {

        private var _ar:Array ;
    	
    	/**
    	 * Creates a new Cache instance
    	 */
    	public function TrackerCache()
    	{
    		_ar = [] ;
    	}
    	
    	/**
    	 * Indicates if the object throws errors.
    	 */
    	public static var CACHE_THROW_ERROR:Boolean ;
        
    	/**
    	 * Removes all commands in memory.
    	 */
    	public function clear():void
    	{
    	   _ar = [] ;	
    	}
    	
    	/**
         * Enqueue a new tracker command in the tracker cache.
         * @param name The name of the method to invoke.
         * @param ...args The optional arguments passed-in the method. 
         */
        public function enqueue( name:String , ...args:Array=null ):Boolean 
        {
            if (name == null) 
            {
            	return false ;
            }
            _ar.push( { name:name , arguments:arguments } ) ;
            return true ;
        }
        
        /**
         * Flush the memory of the tracker cache.
         */
        public function flush():void
        {
        	        	
        }
        
        /**
         * Returns the number of commands in the tracker cache.
         */
        public function size():uint
        {
            return _ar.length ;	
        }
        
        //////////////////////////// GoogleAnalyticsAPI implementation
                
        public function createEventTracker(objName:String):EventTracker
        {
            return null ;
        }

        public function addIgnoredOrganic(newIgnoredOrganicKeyword:String):void
        {
        }        

        public function addItem(item:String, sku:String, name:String, category:String, price:Number, quantity:int):void
        {
        }
        
        public function addTrans(orderId:String, affiliation:String, total:Number, tax:Number, shipping:Number, city:String, state:String, country:String):Object
        {
        	return null ;
        }
        
        public function addIgnoredRef(newIgnoredReferrer:String):void
        {
        }
        
        public function addOrganic(newOrganicEngine:String, newOrganicKeyword:String):void
        {
        }
        
        public function clearIgnoredOrganic():void
        {
        }
        
        public function clearIgnoredRef():void
        {
        }
        
        public function clearOrganic():void
        {
        }
        
        public function cookiePathCopy(newPath:String):void
        {
        }        
        
        public function getClientInfo():Boolean
        {
        	return false ;
        }
        
        public function getDetectFlash():Boolean
        {
        	return false ;
        }
        
        public function getDetectTitle():Boolean
        {
        	return false ;
        }
                
        public function getAccount():String
        {
        	return "" ;
        }
        
        public function getLocalGifPath():String
        {
        	return "" ;
        }
        
        public function getServiceMode():ServerOperationMode
        {
        	return null ;
        }
        
        public function getVersion():String
        {
        	return "" ;
        }         
        
        public function initData():void
        {
        	
        }
        
        public function link(targetUrl:String, useHash:Boolean = false):void
        {
        	
        }
        
        public function linkByPost(formObject:Object, useHash:Boolean = false):void
        {
        	
        }        
        
        public function setAllowHash(enable:Boolean):void
        {
        	
        }
        
        public function setAllowLinker(enable:Boolean):void
        {
        	
        }
        
        public function setCookiePath(newCookiePath:String):void
        {
        }
        
        public function setDomainName(newDomainName:String):void
        {
        }

        public function setClientInfo(enable:Boolean):void
        {
        }
        
        public function setDetectFlash(enable:Boolean):void
        {
        }
        
        public function setDetectTitle(enable:Boolean):void
        {
        }

        public function setLocalGifPath(newLocalGifPath:String):void
        {
        	
        }
        
        public function setLocalRemoteServerMode():void
        {
        	
        }
        
        public function setLocalServerMode():void
        {
        	
        }
        
        public function setRemoteServerMode():void
        {
        	
        }
        
        public function setSampleRate(newRate:Number):void
        {
        	
        }
        
        public function setSessionTimeout(newTimeout:int):void
        {
        	
        }
        
        public function setVar(newVal:String):void
        {
        	
        }
                
        public function setAllowAnchor(enable:Boolean):void
        {
        	
        }
        
        public function setCampContentKey(newCampContentKey:String):void
        {
        	
        }
        
        public function setCampMediumKey(newCampMedKey:String):void
        {
        	
        }
        
        public function setCampNameKey(newCampNameKey:String):void
        {
        	
        }
        
        public function setCampNOKey(newCampNOKey:String):void
        {
        	
        }
        
        public function setCampSourceKey(newCampSrcKey:String):void
        {
        	
        }
        
        public function setCampTermKey(newCampTermKey:String):void
        {
        	
        }
        
        public function setCampaignTrack(enable:Boolean):void
        {
        	
        }
        
        public function setCookieTimeout(newDefaultTimeout:int):void
        {
        	
        }
        
        public function trackPageview(pageURL:String = ""):void
        {
        
        }        
        
        // return true always
        public function trackEvent(category:String, action:String, label:String = null, value:Number = NaN):Boolean
        {
            return true ;
        }           
        
        public function trackTrans():void
        {
        
        }        

    }

}
