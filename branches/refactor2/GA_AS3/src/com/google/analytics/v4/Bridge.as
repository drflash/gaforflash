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

package com.google.analytics.v4
{
    import com.google.analytics.core.ServerOperationMode;
    
    /* TODO:
       re-implement actionscript3-event-tracking
       but join/optimize ExternalInterface calls
    */
    public class Bridge implements GoogleAnalyticsAPI
    {
        private var _account:String;
        
        public function Bridge(account:String)
        {
            _account = account;
        }
        
        public function getAccount():String
        {
            return null;
        }
        
        public function getVersion():String
        {
            return null;
        }
        
        public function initData():void
        {
        }
        
        public function setSampleRate(newRate:Number):void
        {
        }
        
        public function setSessionTimeout(newTimeout:int=1800):void
        {
        }
        
        public function setVar(newVal:String):void
        {
        }
        
        public function trackPageview(pageURL:String=""):void
        {
        }
        
        public function setAllowAnchor(enable:Boolean=false):void
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
        
        public function setCampaignTrack(enable:Boolean=true):void
        {
        }
        
        public function setCookieTimeout(newDefaultTimeout:int=15768000):void
        {
        }
        
        public function cookiePathCopy(newPath:String):void
        {
        }
        
        public function link(targetUrl:String, useHash:Boolean=false):void
        {
        }
        
        public function linkByPost(formObject:Object, useHash:Boolean=false):void
        {
        }
        
        public function setAllowHash(enable:Boolean=true):void
        {
        }
        
        public function setAllowLinker(enable:Boolean=false):void
        {
        }
        
        public function setCookiePath(newCookiePath:String="/"):void
        {
        }
        
        public function setDomainName(newDomainName:String="auto"):void
        {
        }
        
        public function addItem(item:String, sku:String, name:String, category:String, price:Number, quantity:int):void
        {
        }
        
        public function addTrans(orderId:String, affiliation:String, total:Number, tax:Number, shipping:Number, city:String, state:String, country:String):Object
        {
            return null;
        }
        
        public function trackTrans():void
        {
        }
        
        public function createEventTracker(objName:String):Object
        {
            return null;
        }
        
        public function trackEvent(eventType:String, label:String="", value:int=0):Boolean
        {
            return false;
        }
        
        public function addIgnoredOrganic(newIgnoredOrganicKeyword:String):void
        {
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
        
        public function getClientInfo():Boolean
        {
            return false;
        }
        
        public function getDetectFlash():Boolean
        {
            return false;
        }
        
        public function getDetectTitle():Boolean
        {
            return false;
        }
        
        public function setClientInfo(enable:Boolean=true):void
        {
        }
        
        public function setDetectFlash(enable:Boolean=true):void
        {
        }
        
        public function setDetectTitle(enable:Boolean=true):void
        {
        }
        
        public function getLocalGifPath():String
        {
            return null;
        }
        
        public function getServiceMode():ServerOperationMode
        {
            return null;
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
        
    }
}