
        /* note:
           general include to not repeat the GoogleAnalyticsAPI
           redirection on a _tracker property
        */
        
        public function getAccount():String
        {
            return _tracker.getAccount();
        }
        
        public function getVersion():String
        {
            return _tracker.getVersion();
        }
        
        public function initData():void
        {
            _tracker.initData();
        }
        
        public function setSampleRate(newRate:Number):void
        {
            _tracker.setSampleRate(newRate);
        }
        
        public function setSessionTimeout(newTimeout:int):void
        {
            _tracker.setSessionTimeout(newTimeout);
        }
        
        public function setVar(newVal:String):void
        {
            _tracker.setVar(newVal);
        }
        
        public function trackPageview(pageURL:String=""):void
        {
            _tracker.trackPageview(pageURL);
        }
        
        public function setAllowAnchor(enable:Boolean):void
        {
            _tracker.setAllowAnchor(enable);
        }
        
        public function setCampContentKey(newCampContentKey:String):void
        {
            _tracker.setCampContentKey(newCampContentKey);
        }
        
        public function setCampMediumKey(newCampMedKey:String):void
        {
            _tracker.setCampMediumKey(newCampMedKey);
        }
        
        public function setCampNameKey(newCampNameKey:String):void
        {
            _tracker.setCampNameKey(newCampNameKey);
        }
        
        public function setCampNOKey(newCampNOKey:String):void
        {
            _tracker.setCampNOKey(newCampNOKey);
        }
        
        public function setCampSourceKey(newCampSrcKey:String):void
        {
            _tracker.setCampSourceKey(newCampSrcKey);
        }
        
        public function setCampTermKey(newCampTermKey:String):void
        {
            _tracker.setCampTermKey(newCampTermKey);
        }
        
        public function setCampaignTrack(enable:Boolean):void
        {
            _tracker.setCampaignTrack(enable);
        }
        
        public function setCookieTimeout(newDefaultTimeout:int):void
        {
            _tracker.setCookieTimeout(newDefaultTimeout);
        }
        
        public function cookiePathCopy(newPath:String):void
        {
            _tracker.cookiePathCopy(newPath);
        }
        
        public function link(targetUrl:String, useHash:Boolean=false):void
        {
            _tracker.link(targetUrl, useHash);
        }
        
        public function linkByPost(formObject:Object, useHash:Boolean=false):void
        {
            _tracker.linkByPost(formObject, useHash);
        }
        
        public function setAllowHash(enable:Boolean):void
        {
            _tracker.setAllowHash(enable);
        }
        
        public function setAllowLinker(enable:Boolean):void
        {
            _tracker.setAllowLinker(enable);
        }
        
        public function setCookiePath(newCookiePath:String):void
        {
            _tracker.setCookiePath(newCookiePath);
        }
        
        public function setDomainName(newDomainName:String):void
        {
            _tracker.setDomainName(newDomainName);
        }
        
        public function addItem(item:String, sku:String, name:String, category:String, price:Number, quantity:int):void
        {
            _tracker.addItem(item, sku, name, category, price, quantity);
        }
        
        public function addTrans(orderId:String, affiliation:String, total:Number, tax:Number, shipping:Number, city:String, state:String, country:String):Object
        {
            return _tracker.addTrans(orderId, affiliation, total, tax, shipping, city, state, country);
        }
        
        public function trackTrans():void
        {
            _tracker.trackTrans();
        }
        
        public function createEventTracker(objName:String):EventTracker
        {
            return _tracker.createEventTracker(objName);
        }
        
        public function trackEvent(category:String, action:String, label:String=null, value:Number=NaN):Boolean
        {
            return _tracker.trackEvent(category, action, label, value);
        }
        
        public function addIgnoredOrganic(newIgnoredOrganicKeyword:String):void
        {
            _tracker.addIgnoredOrganic(newIgnoredOrganicKeyword);
        }
        
        public function addIgnoredRef(newIgnoredReferrer:String):void
        {
            _tracker.addIgnoredRef(newIgnoredReferrer);
        }
        
        public function addOrganic(newOrganicEngine:String, newOrganicKeyword:String):void
        {
            _tracker.addOrganic(newOrganicEngine, newOrganicKeyword);
        }
        
        public function clearIgnoredOrganic():void
        {
            _tracker.clearIgnoredOrganic();
        }
        
        public function clearIgnoredRef():void
        {
            _tracker.clearIgnoredRef();
        }
        
        public function clearOrganic():void
        {
            _tracker.clearOrganic();
        }
        
        public function getClientInfo():Boolean
        {
            return _tracker.getClientInfo();
        }
        
        public function getDetectFlash():Boolean
        {
            return _tracker.getDetectFlash();
        }
        
        public function getDetectTitle():Boolean
        {
            return _tracker.getDetectTitle();
        }
        
        public function setClientInfo(enable:Boolean):void
        {
            _tracker.setClientInfo(enable);
        }
        
        public function setDetectFlash(enable:Boolean):void
        {
            _tracker.setDetectFlash(enable);
        }
        
        public function setDetectTitle(enable:Boolean):void
        {
            _tracker.setDetectTitle(enable);
        }
        
        public function getLocalGifPath():String
        {
            return _tracker.getLocalGifPath();
        }
        
        public function getServiceMode():ServerOperationMode
        {
            return _tracker.getServiceMode();
        }
        
        public function setLocalGifPath(newLocalGifPath:String):void
        {
            _tracker.setLocalGifPath(newLocalGifPath);
        }
        
        public function setLocalRemoteServerMode():void
        {
            _tracker.setLocalRemoteServerMode();
        }
        
        public function setLocalServerMode():void
        {
            _tracker.setLocalServerMode();
        }
        
        public function setRemoteServerMode():void
        {
            _tracker.setRemoteServerMode();
        }
        
