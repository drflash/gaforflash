see: [Google Analytics JS API](http://code.google.com/apis/analytics/docs/gaJSApi.html)

note:<br>
a <b>-</b> sign indicate something not implemented<br>
a <b>+</b> sign indicate something added to the AS3 API but that does not exists in the JS API<br>
a <b>~</b> sign indicate something that work differently in the AS3 API compared to the JS API<br>
a <b>#</b> sign indicate something deprecated in the JS API and removed (or not implemented) in the AS3 API<br>
<br>
<br>
<b>com.google.analytics.v4.GoogleAnalyticsAPI</b>

<ul><li><b>Basic Configuration</b><br>Methods that you use for customizing all aspects of Google Analytics reporting.<br>see: <a href='http://code.google.com/apis/analytics/docs/gaJSApiBasicConfiguration.html'>JS API</a>
<pre><code>getAccount():String;<br>
getVersion():String;<br>
#initData():void;<br>
+resetSession():void;<br>
setSampleRate( newRate:Number ):void;<br>
setSessionTimeout( newTimeout:int ):void;<br>
setVar( newVal:String ):void;<br>
trackPageview( pageURL:String = "" ):void<br>
</code></pre></li></ul>

<ul><li><b>Campaign Tracking</b><br>Methods that you use for setting up and customizing campaign tracking in Google Analytics reporting.<br>see: <a href='http://code.google.com/apis/analytics/docs/gaJSApiCampaignTracking.html'>JS API</a>
<pre><code>setAllowAnchor( enable:Boolean ):void;<br>
setCampContentKey( newCampContentKey:String ):void;<br>
setCampMediumKey( newCampMedKey:String ):void;<br>
setCampNameKey( newCampNameKey:String ):void;<br>
setCampNOKey( newCampNOKey:String ):void;<br>
setCampSourceKey( newCampSrcKey:String ):void;<br>
setCampTermKey( newCampTermKey:String ):void;<br>
setCampaignTrack( enable:Boolean ):void;<br>
setCookieTimeout( newDefaultTimeout:int ):void;<br>
</code></pre></li></ul>

<ul><li><b>Domains and Directories</b><br>Methods that you use for customizing how Google Analytics reporting works across domains,<br>across different hosts, or within sub-directories of a website.<br>see: <a href='http://code.google.com/apis/analytics/docs/gaJSApiDomainDirectory.html'>JS API</a>
<pre><code>-cookiePathCopy( newPath:String ):void;<br>
~getLinkerUrl( url:String = "", useHash:Boolean = false ):String;<br>
~link( targetUrl:String, useHash:Boolean = false ):void;<br>
-linkByPost( formObject:Object, useHash:Boolean = false ):void;<br>
setAllowHash( enable:Boolean ):void;<br>
setAllowLinker( enable:Boolean ):void;<br>
setCookiePath( newCookiePath:String ):void;<br>
setDomainName( newDomainName:String ):void;<br>
</code></pre></li></ul>

<ul><li><b>Ecommerce</b><br>Methods that you use for customizing ecommerce in Google Analytics reporting.<br>see: <a href='http://code.google.com/apis/analytics/docs/gaJSApiEcommerce.html'>JS API</a>
<pre><code>addItem( item:String, sku:String, name:String, category:String, price:Number, quantity:int ):void;<br>
addTrans( orderId:String, affiliation:String, total:Number, tax:Number, shipping:Number, city:String, state:String, country:String ):void;<br>
trackTrans():void;<br>
</code></pre></li></ul>

<ul><li><b>Event Tracking</b><br>Methods that you use for setting up Event Tracking in Google Analytics reporting.<br>see: <a href='http://code.google.com/apis/analytics/docs/gaJSApiEventTracking.html'>JS API</a>
<pre><code>+createEventTracker( objName:String ):EventTracker;<br>
#trackEvent( action:String, label:String = null, value:Number = NaN ):Boolean;<br>
trackEvent( category:String, action:String, label:String = null, value:Number = NaN ):Boolean;<br>
</code></pre></li></ul>

<ul><li><b>Search Engines and Referrers</b><br>Methods that you use for customizing search engines and referral traffic in Google Analytics reporting.<br>see: <a href='http://code.google.com/apis/analytics/docs/gaJSApiSearchEngines.html'>JS API</a>
<pre><code>addIgnoredOrganic( newIgnoredOrganicKeyword:String ):void;<br>
addIgnoredRef( newIgnoredReferrer:String ):void;<br>
addOrganic( newOrganicEngine:String, newOrganicKeyword:String ):void;<br>
clearIgnoredOrganic():void;<br>
clearIgnoredRef():void;<br>
clearOrganic():void;<br>
</code></pre></li></ul>

<ul><li><b>Web Client</b><br>Methods that you use to customize web client information tracking in Google Analytics reporting.<br>see: <a href='http://code.google.com/apis/analytics/docs/gaJSApiWebClient.html'>JS API</a>
<pre><code>getClientInfo():Boolean;<br>
getDetectFlash():Boolean;<br>
getDetectTitle():Boolean;<br>
setClientInfo( enable:Boolean ):void;<br>
setDetectFlash( enable:Boolean ):void;<br>
setDetectTitle( enable:Boolean ):void;<br>
</code></pre></li></ul>

<ul><li><b>Urchin Server</b><br>Methods that you use for configuring your server setup when you are using<br>both Google Analytics and the Urchin software to track your website.<br>see: <a href='http://code.google.com/apis/analytics/docs/gaJSApiUrchin.html'>JS API</a>
<pre><code>getLocalGifPath():String;<br>
getServiceMode():ServerOperationMode;<br>
setLocalGifPath( newLocalGifPath:String ):void;<br>
setLocalRemoteServerMode():void;<br>
setLocalServerMode():void;<br>
setRemoteServerMode():void;<br>
</code></pre>