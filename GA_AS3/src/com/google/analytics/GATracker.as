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

package com.google.analytics
{
	import com.google.analytics.external.HTMLDocumentDetails;
	import com.google.analytics.external.HTMLLocationDetails;
	import com.google.analytics.campaign.Campaign;
	import com.google.analytics.ecomm.EComm;
	import com.google.analytics.ecomm.ECommTransaction;
	
	public class GATracker
	{
		include "globals/cookie_globals.as"
		include "globals/utils_globals.as"
		
		// ---------------------------------------------------------------------------
		  // PRIVATE VARIABLES
		  // ---------------------------------------------------------------------------
		 
		  private var nsCache:Utils = Utils.getGAUTIS();
		  private var undef:Object = nsCache.undef_;
		  private var isEmpty:Function= nsCache.isEmptyField_;
		  private var indexOfProxy:Function = nsCache.indexOfProxy_;
		  private var substringProxy :Function= nsCache.substringProxy_;
		  private var parseNameValuePairs:Function = nsCache.parseNameValuePairs_;
		  private var stringContains:Function = nsCache.stringContains_;
		  private var splitProxy:Function = nsCache.splitProxy_;
		  private var LOCATION:String= "location";
		  private var LENGTH:String = nsCache.LENGTH_;
		
		  /**
		   * Object that makes gif requests.
		   *
		   * @type {_gat.GA_GIF_Request_}
		   */
		  private var gifRequester:GIFRequest = null;
		
		  /**
		   * Configuation for analytics tracker.
		   *
		   * @type {_gat.GA_Config_}
		   */
 		   private var config:Config = Utils.GA_Config;
		
		  /**
		   * Flag indicating whether data has been initialized.
		   *
		   * @type {Boolean}
		   */
		  private var hasInitData :Boolean= false;
		
		
		  // ---------------------------------------------------------------------------
		  // PRIVILIGED VARIABLES
		  // ---------------------------------------------------------------------------
		
		  // ~ Injected dependencies ---------------------------------------------------
		  /**
		   * Set the document cache. (used for dependency injection)
		   *
		   * @type {HTMLDocument}
		   * @ignore
		   */
		  private var documentCache_:HTMLDocumentDetails = Utils.html_DocumentObj;
		
		  /**
		   * Sets the window cache. (used for dependency injection)
		   *
		   * @type {Window}
		   * @ignore
		   */
		  //private var windowCache_ = window; ... openpoint
		  private var windowCache_:Object;
		
		
		  // ~ Instance variables ------------------------------------------------------
		  /**
		   * Current time in seconds.
		   *
		   * @type {Number}
		   * @ignore
		   */
		  private var timeStamp_:Number= Math.round((new Date()).getTime() / 1000);
		
		
		  /**
		   * Stores urchin account in variable.
		   *
		   * @type {String}
		   * @ignore
		   */
		  private var uAccount_:String ;
		  
		
		  /**
		   * Formatted referrer.
		   *
		   * @type {String}
		   * @ignore
		   */
		  private var formattedRef_ :String= "";
		
		
		  /**
		   * E-commerce module.
		   *
		   * @type {GA_EComm}
		   * @ignore
		   */
		  private var ecomm_ :EComm= null;
		
		
		  /**
		   * Unique session id.
		   *
		   * @type {Number}
		   * @ignore
		   */
		  private var sessionId_:Number = nsCache.get32bitRand_();
		
		
		  /**
		   * Google analytics site overlay token.
		   *
		   * @type {String}
		   * @ignore
		   */
		  private var gasoValue_ :String= "";
		
		
		  /**
		   * Indicating whether a session has been initialized.  If __utmb and/or __utmc
		   * cookies are not set, then session has either timed-out or havn't been
		   * initialized yet.
		   *   
		   * @type {Boolean}
		   * @ignore
		   */
		  private var noSession_:Boolean = false;
		
		
		  /**
		   * GIF request parameter for tracking browser info.
		   *
		   * @type {_gat.GA_Browser_Info_}
		   * @ignore
		   */
		  private var browserInfo_:BrowserInfo = null;
		
		
		  /**
		   * GIF request parameter for tracking campaign info.
		   *
		   * @type {String}
		   * @ignore
		   */
		  private var campaignInfo_ :String= "";
		
		
		  /**
		   * Object for holding extensible data and generating encoded strings.
		   *
		   * @type {GA_X10}
		   * @ignore
		   */
		  private var x10Module_ :X10= null;
		
		
		  /**
		   * Object for holding event tracker X10 module.
		   *
		   * @type {GA_X10}
		   * @ignore
		   */
		  private var eventTracker_:X10;  // changed =_undef (removed)
		
		
		  /**
		   * Hash value of the current domain name.
		   *
		   * @type {Number}
		   * @ignore
		   */
		  private var domainHash_:String = "";
		
		
		  /**
		   * Wrapper object for document cookie values.
		   *
		   * @type {GA_Cookie}
		   * @ignore
		   */
		  private var cookieWrapper_:Cookie = null;
		
		/**
		 * @fileoverview Google Analytic Tracker Code (GATC)'s main component.  This
		 *     encapsulates all the logics for the GATC module.
		 *
		 */
		
		/**
		 * @class Google Analytics Tracker Code (GATC)  This class encompasses all the
		 *     neccessary logic in logging web-site metrics onto the GA back-end system.
		 * 
		 * @param {String} urchinAccount Urchin Account to record metrics in.
		 *
		 * @constructor
		 */
		public function GATracker(urchinAccount:String)
		{
			uAccount_ = urchinAccount;
			
		}


	  // ---------------------------------------------------------------------------
	  // PRIVATE METHODS
	  // ---------------------------------------------------------------------------
	  /**
	   * Resolves domain name from document object if domain name is set to "auto".
	   */
	  private function updateDomainName():void 
	  {
	    // domain name is set to "auto", resolve from document object
	    if ("auto" == config.domainName_) 
	    {
	      var domainNameCache:String = documentCache_.domain;
	      
	      // strip out leading "www." if appropriate
	      if ("www." == substringProxy(domainNameCache,0, 4)) 
	      {
	        domainNameCache = substringProxy(domainNameCache, 4);
	      }
	
	      // store domain name
	      config.domainName_ = domainNameCache;
	    }
	
	    // making domain name case insensitive
	    config.domainName_ = nsCache.toLowerCaseProxy_(config.domainName_);
	    
	  }
  

//	  /**
//	   * Return true if and only if the cookie domain is NOT a google search page.
//	   *
//	   * @return {Boolean} Return true if and only if the cookie domain is not a
//	   *     google search page.
//	   */
//	   public function isNotGoogleSearch():Boolean
//	   {
//		    /**
//		     * This flag will be 0 if domainName starts with either "www.google.",
//		     * ".google", or "google.".
//		     *
//		     * (0 == subDomainFlag)
//		     *     is equivalent to
//		     * ( (0 == domainName.indexOf("www.google.")) ||
//		     *   (0 == domainName.indexOf(".google.")) ||
//		     *   (0 == domainName.indexOf("google.")) )
//		     *
//		     */
//		    var domainNameCache:String= config.domainName_;
//		
//		    var subDomainFlag:Boolean = Boolean(indexOfProxy(domainNameCache, "www.google.")*
//		                        		indexOfProxy(domainNameCache, ".google.")  *
//		                        		indexOfProxy(domainNameCache, "google."));
//		
//		    /**
//		     * Note: google.org is not a google search page.
//		     */
//		    return subDomainFlag ||
//		           ("/" != config.cookiePath_) ||
//		           (indexOfProxy(domainNameCache, "google.org") > -1);
//	  }
	  
	   /**
	   * This methods takes a valueString that contains a __utma value, and extracts
	   * it.  Then it updates the session count.  And moves the current timestamp
	   * field of __utma into the last timestamp field.  Finally, it stamps the
	   * current time into the current timestamp field of __utma.  The updated
	   * __utma value is then passed back.
	   *
	   * @param {String} valueString String that contains a __utma value.
	   * @param {String} delim Field delimiter for valueString.
	   * @param {String} timeStamp Timestamp for now.
	   *
	   * @return {String} Updated __utma value with session count updated, current
	   *     timestamp moved to last timestamp, and current timestamp updated to
	   *     now.  However, if valueString doesn't contain __utma value, then return
	   *     "-".
	   */
	  public function getNewUtmaValue(valueString:String, delim:String, timeStamp:String):String
	  {
	    // if any of the parameters are missing, there is no __utma value to update
	    if (isEmpty(valueString) || isEmpty(delim) || isEmpty(timeStamp)) 
	    {
	      return "-";
	    }
	
	    // extract __utma value
	    var utmaValue:String = parseNameValuePairs(
	        valueString,
	        nsCache.COOKIE_UTMA_ + domainHash_,
	        delim
	    );
	    var utmaFields:Array;
	
	    // if __utma value is not empty, update
	    if (!isEmpty(utmaValue)) 
	    {
	      // split into fields
	      utmaFields = splitProxy(utmaValue, ".");
	
	      // update session count
	      utmaFields[COOKIE_INDEX_UTMA_SESSIONCOUNT] =
	        (utmaFields[COOKIE_INDEX_UTMA_SESSIONCOUNT]) ?
	          (utmaFields[COOKIE_INDEX_UTMA_SESSIONCOUNT] * 1) + 1:
	          1;
	
	      // last session time, is current session time (update)
	      utmaFields[COOKIE_INDEX_UTMA_LASTTIME] =
	          utmaFields[COOKIE_INDEX_UTMA_CURTIME];
	
	      // current session time is now
	      utmaFields[COOKIE_INDEX_UTMA_CURTIME] = timeStamp;
	
	      utmaValue = utmaFields.join(".");
	    }
	
	    return utmaValue;
	  }


	  /**
	   * Returns predicate indicating whether we should track this page.  Only track
	   * page if it's not residing on local machine (file protocol)
	   *
	   * @return {Boolean} True if and only if the page is not sitting no local
	   *     machine, and it's not sitting on a google domain.
	   */
	  public function doTracking():Boolean 
	  {
	  	 //return true; //openpoint local testing
	     return ("file:" != documentCache_.location_protocol);  // &&isNotGoogleSearch();
	  }
	  
	  /**
	   * This method takes a raw string, and removes all leading and trailing
	   * whitespaces (space, new line, CR, tab).
	   *
	   * @param {String} rawString Unformatted string to be trimmed.
	   *
	   * @return {String} Resulting string with no leading and trailing whitespaces.
	   */
	  public function trim(rawString:String):String 
	  {
	    if (!rawString || ("" == rawString)) 
	    {
	      return "";
	    }
	
	    while (nsCache.isWhiteSpace_(rawString.charAt(0))) 
	    {
	      rawString = substringProxy(rawString, 1);
	    }
	
	    while (nsCache.isWhiteSpace_(
	        rawString.charAt(rawString[LENGTH] - 1))) 
	    {
	      rawString = substringProxy(rawString, 0, rawString[LENGTH] - 1);
	    }
	
	    return rawString;
	  }

	  /**
	   * If the cookie value is valid, then write the value to document cookies.
	   * Cookie values are retrieved usign the getterRef, and written using the
	   * setterRef, and writterRef.
	   *
	   * @param {Function} getterRef Function reference used to retrieve cookie value.
	   * @param {Function} setterRef Function reference used to set cookie value.
	   * @param {Function} writterRef Function reference used to write cookie value.
	   */
	  public function writeCookieIfValid(getterRef:Function, 
	  	setterRef:Function, writterRef:Function) :void
	  {
	    if (!isEmpty(getterRef())) 
	    {
	      // decoded, because this value comes off the linker
	      setterRef(nsCache.decodeWrapper_(getterRef()));
	
	      if (!stringContains(getterRef(), ";")) 
	      {
	        writterRef();
	      }
	    }
	  }




	 /**
	   * Predicate function indicating whether the given host belongs to an outbound
	   * link.  The anchor is an outbound link on when all of the following is true:
	   *
	   * <ol>
	   *   <li>Link count limit has not been reached</li>
	   *   <li>Anchor tag has a different host name than the document</li>
	   *   <li>Anchor tag host is not being ignored</li>
	   * </ol>
	   *
	   * @public
	   * @param {String} tagHost Host name for href tag.
	   *
	   * @return {Boolean} true if and only if the given host belongs to an outbound
	   *     link
	   */
	  public function isOutboundLink(tagHost:String):Boolean 
	  {
	    var idx:Number;
	   /* var isOutbound = ("" != tagHost) &&
	                     (documentCache_[LOCATION].host != tagHost); */ // changed as follows  - 
	
		var isOutbound:Boolean = ("" != tagHost) &&
	                     (documentCache_.location_host != tagHost); 
	                     
	    if (isOutbound) 
	    {
	      for (idx = 0; idx < config.ignoredOutboundHosts_.length; idx++) 
	      {
	        
	        isOutbound = isOutbound && (
	            indexOfProxy(
	                nsCache.toLowerCaseProxy_(tagHost),
	                nsCache.toLowerCaseProxy_(config.ignoredOutboundHosts_[idx])
	            )
	        );
	      }
	    }
	
	    return isOutbound;
	  }


	  // ---------------------------------------------------------------------------
	  // PRIVILIGED METHODS
	  // ---------------------------------------------------------------------------
	  /**
	   * If the domain name is initialized to "auto", then automatically trying to
	   * resolve cookie domain name from document object.  The resolved domain name
	   * will be stored in the domain name instance variable, which could be
	   * accessed by the set/getDomainName methods.  If domain hashing is turn on,
	   * then the hash of the domain name is also returned.  Else, hash value is
	   * always 1.
	   *
	   * @public
	   * @return {Number} If the domain name is empty (undefined, empty string, or
	   *     "none"), then return 1 as the hash of domain name.  If hashing is
	   *     turned off , then return 1 as the hash value as well.  If there is a
	   *     domain name, and domain hashing is turned on, then return the hash of
	   *     the domain name.
	   */
	  public function getDomainHash_ ():Number 
	  {
	    /**
	     * Normalize to "" if domain name is missing.  Then return 1 as the domain
	     * hash.
	     */
	    if (!config.domainName_ || ("" == config.domainName_) ||
	        ("none" == config.domainName_)) {
	      config.domainName_ = "";
	      return 1;
	    }
	
	    // resolve domain name if appropraite, and store
	    updateDomainName();
	
	    // allow domain hashing, return hash of domain
	    if (config.allowDomainHash_) 
	    {
	      return nsCache.genHash_(config.domainName_);
	
	    // does not allow domain hashing, return 1 as domain hash
	    } 
	    else 
	    {
	      return 1;
	    }
	  }


	  /**
	   * Formats document referrer.
	   *
	   * @param {String} docRef Document referrer.  Take from document.referrer.
	   * @param {String} cookieDomainName Cookie domain name.  Take from
	   *     documen.domain.
	   *
	   * @public
	   * @return {String} formatted referrer.  If referrer is in the sub-domain of
	   *     document, then formatted referrer is set to "0".  If referrer is enclosed
	   *     in square brackets, then there is no referrer.
	   */
	  public function formatReferrer_(docRef:String, cookieDomainName:String) :String
	  {
	
	    // if there is no referrer
	    if (isEmpty(docRef)) 
	    {
	      docRef = "-";
	
	    // if there is a referrer
	    } 
	    else 
	    {
	      cookieDomainName += (config.cookiePath_ && ("/" != config.cookiePath_)) ?
	                          config.cookiePath_ :
	                          "";
	
	      var domainNamePos:int = indexOfProxy(docRef, cookieDomainName);
	
	
	      docRef =
	          // no self-referral
	          ((domainNamePos >= 0) && (domainNamePos <= 8)) ?
	          "0" :
	
	          // no referrer if referrer is enclosed in square-brackets
	          (("[" == docRef.charAt(0)) &&
	              ("]" == docRef.charAt(docRef[LENGTH] - 1))) ?
	              "-" : docRef;
	    }
	
	    return docRef;
	  }
	



	  /**
	   * This method will gather metric data needed and construct it into a search
	   * string to be sent via a GIF request.  It is used by any tracking methods
	   * that needs browser, campaign, and document information to be sent.
	   *
	   * @public
	   *
	   * @param opt_pageURL Optional parameter.  This is the virtual page URL for 
	   *     the page view.
	   *
	   * @return {String} The rendered search string with various information included.
	   */
	  public function renderMetricsSearchString_(opt_pageURL:String = ""):String
	  {
	    var searchString:String = "";
	    var documentCache:HTMLDocumentDetails = documentCache_;        // caches document object
	
	    // get client browser information
	    searchString += browserInfo_ ?
	                    browserInfo_.toQueryString_() :
	                    "";
	
	    // get campaign tracking
	    searchString += config.campaignTracking_ ? campaignInfo_ : "";
	
	    // record title, if title detection is on
	    searchString +=
	        (config.detectTitle_ && !isEmpty(documentCache.title)) ?
	            "&utmdt=" + nsCache.encodeWrapper_(documentCache.title) :
	            "";
	
	    // referrer
	    searchString += "&utmhid=" + nsCache.genHid_() +
	                    "&utmr=" + formattedRef_ +
	                    "&utmp=" + renderPageURL_(opt_pageURL);
	
	    return searchString;
	  }

	  /**
	   * This method will collect and return the page URL information based on
	   * the page URL specified by the user if present, and the document's
	   * actual path otherwise.
	   *
	   * @public
	   * @param {String} opt_pageURL (Optional) User-specified Page URL to assign
	   *     metrics to at the back-end.
	   *
	   * @return {String} Final page URL to assign metrics to at the back-end.
	   */
	  public function renderPageURL_(opt_pageURL:String = "" ):String 
	  {
	   // var docLoc = documentCache_[LOCATION];     // location --changed as folllows
	     var docLoc:HTMLLocationDetails = documentCache_.locationObj;     // location 
	
	    // use page url if specified, else extract it from location object
	    opt_pageURL = ((undef != opt_pageURL) && ("" != opt_pageURL)) ?
	                  nsCache.encodeWrapper_(opt_pageURL, true) :
	                  nsCache.encodeWrapper_(
	                      docLoc.pathname + unescape(docLoc.search),
	                      true
	                  );
	    return opt_pageURL;
	  }

	  /**
	   * This method will gather all the data needed, and sent these data to GABE
	   * (Google Analytics Back-end) via GIF requests.
	   *
	   * @public
	   * @param {String} opt_pageURL (Optional) Page URL to assign metrics to at the
	   *     back-end.
	   */
	  public function trackMetrics_ (opt_pageURL:String = "") :void 
	  {
	    if (takeSample_()) 
	    {
	      var searchString:String = "";                             // gif request parameters
	
	      // X10
	      if ((x10Module_ != undef) &&
	          (x10Module_.renderUrlString_().length > 0)) 
	      {
	        searchString += "&utme=" + nsCache.encodeWrapper_(
	           x10Module_.renderUrlString_()
	        );
	      }
	
	      // Browser, campaign, and document information.
	      searchString += renderMetricsSearchString_(opt_pageURL);
	
	      // sent data to GABE via GIF hit
	      gifRequester.sendGifRequest_(
	          searchString,
	          uAccount_,
	          documentCache_,
	          domainHash_
	          	      );
	    }
	  }
	  
  
  
	  /**
	   * Construcks linker parameters, used for forwarding cookie values to another
	   * domain.
	   *
	   * @private
	   * @return {String} Query string parameter used for forwarding cookie values.
	   */
	 private function constructLinkerParams_ () :String
	 {
	    // parse cookie values
	    var cookieParser:Cookie = new  Cookie(documentCache_, config);
	
	    // parsed cookie value
	    return cookieParser.parseCookieValues_(domainHash_) ?
	           cookieParser.toLinkerParams_() :
	           "";
	  }


	  /**
	   * This method takes a target URL, and appropriately inserts the linkerParams.
	   * If useHash is set to true, then linkerParams is being appended to the
	   * target URL as anchor tag.  Otherwise, it is being inserted into the
	   * targetURL as part of its query string.
	   *
	   * @param {String} targetUrl URL of target site to sent cookie values to.
	   * @param {String} useHash Set to true for passing tracking code variables by
	   *     using the # anchortag separator. (currently this behavior is for
	   *     internal Google properties only.)
	   *
	   * @private
	   * @return {String} formatted URL with linkerParams appropriately inserted
	   *     into targetUrl.
	   */
	  private function _getLinkerUrl (targetUrl:String, useHash:String):String 
	  {
	    var urlFields:Array = splitProxy(targetUrl, "#");
	    var formattedUrl:String = targetUrl;
	    var linkerParams:String = constructLinkerParams_(); 
	
	    // have linker parameters
	    if (linkerParams) 
	    {
	      /**
	       * Using hash to seperate out linker parameter, and there is no hash in
	       * URL, proceed.
	       */
	      if (useHash && (1 >= urlFields.length)) 
	      {
	        formattedUrl += "#" + linkerParams;
	
	      } 
	      else if (!useHash || (1 >= urlFields[LENGTH]))
	      {
	        // there is no hash in URL
	        if (1 >= urlFields.length) 
	        {
	          /**
	           * If there are no query string, then use "?".  if there is already a
	           * query string, then use "&".
	           */
	          formattedUrl +=
	              (stringContains(targetUrl, "?") ? "&" : "?") + linkerParams;
	
	        // there is hash in URL
	        } 
	        else 
	        {
	          /**
	           * If there are no query string, then use "?".  if there is already a
	           * query string, then use "&".
	           */
	          formattedUrl = urlFields[0] +
	                         (stringContains(targetUrl, "?") ? "&" : "?") +
	                         linkerParams + "#" + urlFields[1];
	        }
	      }
	    }
	
	    return formattedUrl;
	  }


//	  /**
//	   * Event listener for site overlay.  It determines whether or not site overlay
//	   * should be turned on or off.  If site overlay is turned on, then the site
//	   * overlay javascript will be sourced, and statistics will be overlaid on top
//	   * of the live site.  This method will turn on site overlay when site overlay
//	   * token is passed to the page via anchor in the URL, or stored as document
//	   * cookie.
//	   *
//	   * @private
//	   */
//	  private function siteOverlayHandler_ ():void 
//	  {
//	  	/*.... openpoint -- this is needed to add the additional javascript code
//	   // var scriptElement:Object; 
//	
//	    // sanity check
//	    if (gasoValue_ && (gasoValue_.length >= 10)) 
//	    {
//		      // persis site overlay token in cookie
//		     cookieWrapper_.setGASOValue_(gasoValue_);
//		     cookieWrapper_.writeGASOValue_();
//		
//		      // storing gaso cookie domain and cookie path
//		      nsCache._gasoDomain = config.domainName_;
//		      nsCache._gasoCPath = config.cookiePath_; 
//		
//		      /**
//		       * source site overlay script.  This javascript does the heavy lifting for
//		       * site overlay.  This method merely decides whether site overlay should
//		       * be turned on or not.
//		       */
//		       /*  
//		       -- this is not needed for action script
//		      scriptElement = documentCache_.createElement("script");
//		
//		      scriptElement.type = "text/javascript";
//		      scriptElement.id = "_gasojs";
//		      scriptElement.src =
//		          "https://www.google.com/analytics/reporting/overlay_js?gaso=" +
//		          gasoValue_ + "&" + nsCache.get32bitRand_();
//		
//		      documentCache_.getElementsByTagName("head")[0]
//		         .appendChild(scriptElement);
//		         
//	    }*/
//	  }

	
	/**
	   * Handles / formats GATC cookie values.  If linker functionalities are
	   * enabled, then GATC cookies parsed from linker request takes precedences
	   * over stored cookies.  Also updates the __utma, __utmb, and __utmc values
	   * appropriately.
	   *
	   * @private
	   */
	   private function handleCookie_():void
	   {
		   	
			
		    // caching for better size compression by compiler
		    var timeStamp:String = String(timeStamp_);
		    var cookieWrapper:Cookie = cookieWrapper_;
		    
		     // cookie in string form
		    //var cookieString = documentCache_[nsCache.COOKIE_]; // changed as follows
		    var cookieString:String = cookieWrapper_.getCookieOrFlashStoredDetails();
				//cookieString = documentCache_.cookie;
			
			
		    var domainHash:String = domainHash_ + "";
		    var windowCache:Object = windowCache_; // openpoint .... window ??
		    var gaGlobalCache:Object = windowCache ? windowCache.gaGlobal : undef;
	
		    // achor string from URL
		    var anchorString:String;
	
		    // position of cookie values in cookie string
		    var hasUtma:Boolean = stringContains(
		        cookieString,
		        nsCache.COOKIE_UTMA_ + domainHash
		    );
		    var hasUtmb:Boolean = stringContains(
		        cookieString,
		        nsCache.COOKIE_UTMB_ + domainHash
		    );
		    var hasUtmc:Boolean = stringContains(
		        cookieString,
		        nsCache.COOKIE_UTMC_ + domainHash
		    );
		    var utma:String;
		    var utmb:Array = [];
		    var searchString:String = "";                              // search string
	
		    // visitor id
		    var vid:String;
	
		    // make sure cookie string is not undef
		    cookieString = isEmpty(cookieString) ? "" : cookieString;
	
		    /**
		     * Linker functionalities are enabled.
		     */
		    if (config.allowLinker_) 
		    {
		
		      //anchorString = nsCache.getAnchor_(documentCache_[LOCATION]); // changed as follows
		 	  anchorString = nsCache.getAnchor_(documentCache_.locationObj);
		 	   
		      // pre-pend anchor to search string if needed
		      if (config.allowAnchor_ && !isEmpty(anchorString)) 
		      {
		        searchString = anchorString + "&";
		      }
		
	      	//searchString += documentCache_[LOCATION].search; // changed as follows
			searchString += documentCache_.location_search; 
			
		      // search string have __utma value
		      if (!isEmpty(searchString) && stringContains(searchString,
		          nsCache.COOKIE_UTMA_)) 
		      {
	
		        // parse querystring for cookie values
		        cookieWrapper.parseQString_(searchString);
	
		        // if cookie values is corrupt, discards all values
		        if (!cookieWrapper.isGenuine_()) 
		        {
		           cookieWrapper.clearValues_();
		        }
		        utma = cookieWrapper.getUtmaValue_();
		      }
	
		      // if __utmx has content, write to cookie
		      writeCookieIfValid(
		          cookieWrapper.getUtmxValue_,
		          cookieWrapper.setUtmxValue_,
		          cookieWrapper.writeUtmxValue_
		      );
	
		      // if __utmv has content, write to cookie
		      writeCookieIfValid(
		          cookieWrapper.getUtmvValue_,
		          cookieWrapper.setUtmvValue_,
		          cookieWrapper.writeUtmvValue_
		      );
	   	 	}
	
		    /**
		     * Has linked cookie value.
		     */
		    if (!isEmpty(utma)) 
		    {
	
		      /**
		       * Linked value only have __utma.  Either __utmb, or __utmc is missing.
		       */
		      if (isEmpty(cookieWrapper.getUtmbValue_()) ||
		          isEmpty(cookieWrapper.getUtmcValue_())) 
	          {

			        /**
			         * We take passed in __utma value, and we update it.
			         */
			        utma = getNewUtmaValue(searchString, "&", String(timeStamp));
	
			        // Indicate that there is no session information.
			        noSession_ = true;
	
			      /**
			       * There are session informations.  We are gonig to extract the domainHash,
			       * just in case it doesn't agree, and we override the passed in domainHash.
			       */
		      } 
		      else 
		      {
			        utmb = splitProxy(cookieWrapper.getUtmbValue_(), "."); 
			        domainHash = utmb[COOKIE_INDEX_UTMB_DOMAINHASH];
		      }
	
		    /**
		     * Does not have linked cookie value.
		     */
		    } 
		    else 
		    {
	      		/**
		       * We already have __utma value stored in document cookie.
		       */
			    if (hasUtma) 
			    {
			        /**
			         * Either __utmb, __utmc, or both are missing from document cookie.  We
			         * take the existing __utma value, and update with new session
			         * information.  And then we indicate that there is no session information
			         * available.
			         */
			        if (!hasUtmb || !hasUtmc) 
			        {
			          utma = getNewUtmaValue(cookieString, ";", timeStamp);
			          noSession_ = true;
			        } 
			        else 
			        {
			          utma = parseNameValuePairs(
			              cookieString,
			              nsCache.COOKIE_UTMA_,
			              ";"
			          );
			          utmb = splitProxy(
			              parseNameValuePairs(
			                  cookieString,
			                  nsCache.COOKIE_UTMB_,
			                  ";"
			              ),
			              "."
			          ); 
	        		}
	
				      /**
				       * We don't have __utma value already stored in document cookie.  We are not
				       * gonig to construct a new __utma value.  Also indicate that tehre is no
				       * session information stored in cookie.
				       */
	      		} 
	      		else 
	      		{
			        utma = [
			            domainHash,
			            sessionId_,
			            timeStamp,
			            timeStamp,
			            timeStamp,
			            1
			        ].join(".");
	        		noSession_ = true;
	      		}
	    }
	
	    /**
	     * Format __utma value into fields
	     */
	    var utmaArray:Array = splitProxy(utma, ".");
	
	    /**
	     * Over-write with DOM values if present
	     */
	    if (windowCache && gaGlobalCache) 
	    {
		      /**
		       * Over-write current session time with sid from DOM
		       */
		      utmaArray[COOKIE_INDEX_UTMA_CURTIME] = gaGlobalCache.sid ?
		                                        gaGlobalCache.sid :
		                                        utma[COOKIE_INDEX_UTMA_CURTIME];
	
		      /**
		       * Over-write visitor id, and first session timestamp with visitor id from
		       * DOM
		       */
		      if (gaGlobalCache.vid) 
		      {
		        vid = splitProxy(gaGlobalCache.vid, ".");
		
		        utmaArray[COOKIE_INDEX_UTMA_SESSIONID] = vid[0];
		        utmaArray[COOKIE_INDEX_UTMA_FIRSTTIME] = vid[1];
	      	  }
	    }
	    cookieWrapper.setUtmaValue_(utmaArray.join("."));
	
	
		    /**
		     * Sets the common __utmb, __utmc values.
		     *
		     * Note: we are resetting the count for every new session.
		     */
		    utmb[COOKIE_INDEX_UTMB_DOMAINHASH] = domainHash;
		    utmb[COOKIE_INDEX_UTMB_TRACK_COUNT] = utmb[COOKIE_INDEX_UTMB_TRACK_COUNT] ?
		                                          utmb[COOKIE_INDEX_UTMB_TRACK_COUNT] :
		                                          0;
		    utmb[COOKIE_INDEX_UTMB_TOKEN] =
		        (undefined != utmb[COOKIE_INDEX_UTMB_TOKEN]) ?
		        utmb[COOKIE_INDEX_UTMB_TOKEN] :
		        config.tokenCliff_;
		    utmb[COOKIE_INDEX_UTMB_LAST_TIME] = utmb[COOKIE_INDEX_UTMB_LAST_TIME] ?
		                                        utmb[COOKIE_INDEX_UTMB_LAST_TIME] :
		                                        (new Date()).getTime();
		
		    cookieWrapper.setUtmbValue_(utmb.join("."));
		    cookieWrapper.setUtmcValue_(domainHash);
		
		    /**
		     * The assumption is, by this point, if the cookie value is corrupt from
		     * URL, then it would've been dealt with previously.
		     */
		    if (!isEmpty(cookieWrapper.getUtmkValue_())) 
		    {
		      cookieWrapper.setUtmkValue_(String(cookieWrapper.genHash_()));
		    }
	
	
		    /**
		     * Store cookies
		     */
		    cookieWrapper.writeUtmaValue_();
		    cookieWrapper.writeUtmbValue_();
		    cookieWrapper.writeUtmcValue_();
	  }

	   /**
	   * Helper function for initialize gif requester object, and picking up the
	   * lastest config.
	   *
	   * @ignore
	   */
		  private function initGifRequester_() :void
		  {
		    gifRequester = new GIFRequest(config);
		  }

	  /**
	   * Initializes the GATC (Google Analytics Tracker Code) object.
	   *
	   * @example
	   * var pageTracker = _gat._getTracker("UA-12345-1");
	   * pageTracker._initData();
	   * pageTracker._trackPageview();  
	   *
	   */
	   
	   //&&&&&&&&&&&&&&&&&&&&&&&&&&&
	  public function _initData() :void
	  {
	     var campInfo:Campaign;
	
	     if (!hasInitData) 
	     {
	       // create new gif request object
	       initGifRequester_();
	
	       // get domain hash
	       domainHash_ = String(getDomainHash_());
	
	       // init. cookie wrapper
	       cookieWrapper_ =   Utils.getCookieHandler(documentCache_,config);
	     }
		    
	      // no need if page is a google property
	      if (doTracking()) 
	      {
	        // initializes cookies each time for page tracking, event tracking, X10,
	 		 // transactions, custom variables
	        handleCookie_();
	      }
	
		 if (!hasInitData) 
	     {
	    	// no need if page is a google property
	    	if(doTracking())
	    	{
		        // format referrer
		        formattedRef_ = formatReferrer_(
		            documentCache_.referrer,
		            documentCache_.domain
		        );
	
		        // caching browser info
		        if (config.clientInfo_) 
		        {
		          browserInfo_ = new  BrowserInfo(
		              config.flashDetection_
		          );
		          browserInfo_.getBrowserInfo_();
		        }
	
		        // cache campaign info
		        if (config.campaignTracking_) 
		        {
			          campInfo = new Campaign(
			              domainHash_,
			              documentCache_,
			              formattedRef_,
			              timeStamp_,
			              config
			          );
		
			          campaignInfo_ = campInfo.getCampaignInformation_(
			              cookieWrapper_,
			              noSession_
			          );
	        	}
	      }
	      // Initialize X10 module.
	      x10Module_ = new X10();
	
	      // Initialize event tracker module
	      eventTracker_ = new X10();
	      hasInitData = true;
	    }
	
//	    // Initialize site overlay
//	    if (!nsCache.hasSiteOverlay_) 
//	    {
//	      initSiteOverlay_();
//	    }
   
	  }
	
	  /**
	   * Returns the session ID from __utma.
	   *
	   * @return {String} Session ID
	   */
	  private function _visitCode() :String
	  {
	    _initData();
	    
	    // get __utma value
	    /*
	    var utmaValue = parseNameValuePairs(
	        documentCache_[nsCache.COOKIE_],
	        nsCache.COOKIE_UTMA_ + domainHash_,
	        ";"
	    );*/  //changed as follows
	    var utmaValue:String = parseNameValuePairs(
	        cookieWrapper_.getCookieOrFlashStoredDetails(), //before it was documentCache_.cookie,
	        nsCache.COOKIE_UTMA_ + domainHash_,
	        ";"
	    );
    
	    var utmaFields:Array = splitProxy(utmaValue, ".");
	
	    /**
	     * Have at least four fields. (domain hash, unique, first time stamp, last
	     * time stamp)
	     */
	    return (utmaFields.length < 4) ?
	           "" :
	           utmaFields[COOKIE_INDEX_UTMA_SESSIONID];
	  }

	
	  /**
	   * Changes the paths of all GATC cookies to the newly-specified path. Use this
	   * feature to track user behavior from one directory structure to another on
	   * the same domain. In order for this to work, the GATC tracking data must be
	   * initialized (<code>_initData()</code> must be called).
	   *
	   * @example
	   * var pageTracker = _gat._getTracker("UA-12345-1");
	   * pageTracker._initData();
	   * pageTracker._trackPageview();
	   * pageTracker._cookiePathCopy("/newSubDirectory/");
	   *
	   * @param {String} newPath New path to store GATC cookies under.
	   */
	  public function _cookiePathCopy(newPath:String):void 
	  {
	    _initData();
	    if (cookieWrapper_) 
	    {
	      cookieWrapper_.updatePath_(domainHash_, newPath);
	    }
	  }



//	  /**
//	   * Attaches site overlay handler as an onload event listener for the document.
//	   *
//	   * @private
//	   */
//	   	private function initSiteOverlay_():void 
//	   	{
//		   // var anchor = documentCache_[LOCATION].hash; // changed as follows
//		    var anchor:String = documentCache_.location_hash; 
//		    var gasoValue:Array;
//	
//		    gasoValue =
//		        (anchor && ("" != anchor) && (0 == indexOfProxy(anchor, "#gaso="))) ?
//	
//	        /**
//	         * If there is an anchor, and the anchor have overlay token, then
//	         * extract overlay token from anchor string
//	         */
//	        [parseNameValuePairs(anchor, "gaso=", "&")] :
//	
//	        /**
//	         * If there is no anchor, or no overlay token in anchor, extract
//	         * overlay token from cookie.
//	         */
//	       /* parseNameValuePairs(
//	            documentCache_[nsCache.COOKIE_],
//	            nsCache.COOKIE_GASO_,
//	            ";"
//	     ); */// changed as follows
//	    [ parseNameValuePairs(
//	            cookieWrapper_.getCookieOrFlashStoredDetails(),// before it was documentCache_.cookie,
//	            nsCache.COOKIE_GASO_,
//	            ";"
//	     )];
//
//	    /**
//	     * Still don't have an overlay token, do nothing more.
//	     *
//	     * Historically, the code also checks whether gasoValue is undefined, or
//	     * empty.  However, the above if-else block always retrieves gasoValue through
//	     * parseNameValuePairs, and parseNameValuePairs always passes back "-" if
//	     * value is not found (never "" or undefined), therefore, the
//	     * gasoValue.length < 10 condition is sufficient in determining whether gaso
//	     * value is present.
//	     */
//	    if (gasoValue.length >= 10) 
//	    {
//	      gasoValue_ = gasoValue[0]; // openpoint ---- check this
//
//      	// mozilla specific (adding a new event listener)
//     	 if (windowCache_.addEventListener) 
//     	 {
//	       	 // adding site overlay handler as a load event listener (non-blocking)
//	        windowCache_.addEventListener(
//	            "load",
//	            siteOverlayHandler_,
//	            false
//	        );
//
//	      // IE specific (attaching event listener)
//	      } 
//	      else 
//	      {
//	        // attaching site overlay handler as a onLoad event listener
//	        windowCache_.attachEvent('onload', siteOverlayHandler_);
//	      }
//	    }
//	
//	    nsCache.hasSiteOverlay_ = true;
//	  }

	  /**
	   * This method returns true to indicate GATC will take this sample.  Or false
	   * to indicate GATC will skip this sample.  Sampling decision is a function of
	   * sample rate (a percentage) and the session ID.
	   *
	   * @param {String} sessionId Used to decide whether we should sample this
	   *     session.
	   *
	   * @private
	   * @return {Boolean} True to indicate we should record this hit.  False to
	   *     indicate we should skip this hit.
	   */
	  private function takeSample_() :Boolean
	  {
	    return (Number(_visitCode()) % 10000) < (config.sampleRate_ * 100);
	  }

//	  /**
//	   * Iterate through all the href anchor tags within the DOM, and automatically
//	   * decorate all the outbound links with outbound tracking calls.  The new
//	   * event handler will also preserve the original behavior of the event
//	   * handler.
//	   *
//	   * @private
//	   */
//   
//	  private function tagOutboundLinks_() :void
//	  {
//	    var curLink:Number;
//	    var curElement:Object;
//	    var links:Array = documentCache_.links;
//	
//	    /**
//	     * Iterate through each HREF anchor tag.
//	     */
//	    for (curLink = 0;
//	         (curLink < links.length) &&
//	             (curLink < config.maxOutboundLinkExamined_);
//	         curLink++) 
//	   {
//	      
//	      curElement = links[curLink];
//	
//	      /**
//	       * If this is an outbound link, and we are going to tag it.
//	       */
//	      if (isOutboundLink(curElement.host))  // openpoint ... link details -- host .... clicking on the ,links has the event handler ..
//	      {
//	        /**
//	         * Caveat: if the href tag element already have a gatcOnclick property,
//	         *   then this href anchor will not be decorated with outbound tracking
//	         *   call. 
//	         */
//	        if (!curElement.gatcOnclick) 
//	        {
//	          // Store old onclick handler.
//	          curElement.gatcOnclick = curElement.onclick;
//	
//	          // create new onclick handler, wrapped around old event handler
//	          curElement.onclick = function(e) 
//	          {
//	
//	            // tracker code
//	            _trackOutboundUrl(this.href);
//	
//	            // if there is an old handler, perserve its behaior
//	            if (this.gatcOnclick) 
//	            {
//	              return this.gatcOnclick(e)
//	            }
//	          }
//	
//	        }
//	      }
//	    }
//	  }




	 /**
	   * Main logic for GATC (Google Analytic Tracker Code).  If linker
	   * functionalities are enabled, it attempts to extract cookie values from the
	   * URL. Otherwise, it tries to extract cookie values from
	   * <code>document.cookie</code>. It also updates or creates cookies as
	   * necessary, then writes them back to the document object.  Gathers all the
	   * appropriate metrics to send to the UCFE (Urchin Collector Front-end).
	   *
	   * @example
	   * var pageTracker = _gat._getTracker("UA-12345-1");
	   * pageTracker._initData();
	   * pageTracker._trackPageview("/home/landingPage");
	   *
	   * @param {String} opt_pageURL Optional parameter to indicate what page
	   *     URL to track metrics under. When using this option, use a beginning
	   *     slash (/) to indicate the page URL.
	   */
	  public function _trackPageview(opt_pageURL:String = "") :void
	  {
	    /**
	     * Do nothing if we decided to not track this page.
	     */
	    if (doTracking()) {
	      _initData();
	      
//	      /**
//	       * If auto track outbound links is enabled, then auto decorate all
//	       * outbound href anchor tags.
//	       */
//	      if (config.ignoredOutboundHosts_ &&
//	          (config.ignoredOutboundHosts_.length > 0)) 
//	      {
//	        tagOutboundLinks_();
//	      }
	
	      // track metrics (sent data to GABE)
	      trackMetrics_(opt_pageURL);
	
	      noSession_ = false;
	    }
	  }


	  /**
	   * Sends both the transaction and item data to the Google Analytics server.
	   * This method should be called after <code>_trackPageview()</code>, and used
	   * in conjunction with the <code>_addItem()</code> and <code>addTrans()</code>
	   * methods.  It should be called after items and transaction elements have
	   * been set up.
	   *
	   * @example
	   * var pageTracker = _gat._getTracker("UA-12345-1");
	   * pageTracker._initData();
	   * pageTracker._trackPageview();
	   * pageTracker._addTrans(
	   *     "1234",           // order ID - required
	   *     "Womens Apparel", // affiliation or store name
	   *     "11.99",          // total - required
	   *     "1.29",           // tax
	   *     "15.00",          // shipping
	   *     "San Jose",       // city
	   *     "California",     // state or province
	   *     "USA"             // country
	   *  );
	   * pageTracker._addItem(
	   *     "1234",           // order ID - required
	   *     "DD44",           // SKU/code
	   *     "T-Shirt",        // product name
	   *     "Olive Medium",   // category or variation
	   *     "11.99",          // unit price - required
	   *     "1"               // quantity - required
	   * );
	   * pageTracker._trackTrans();
	   */
	  public function _trackTrans():void 
	  {
	    var domainHash:String = domainHash_;
	    var searchStrings:Array = [];
	    var tIdx:Number;
	    var curTrans:ECommTransaction;
	    var iIdx:Number;
	    var searchIdx:Number;
	
	    _initData();
	
	    // if there is no e-commerce instance, do nothing
	    if (ecomm_ && takeSample_()) 
	    {
	      // walk transaction / item tree
	      for (tIdx = 0; tIdx < ecomm_.transactions.length; tIdx++) {
	        
	        curTrans = ecomm_.transactions[tIdx];
	
	        nsCache.arrayPush_(
	            searchStrings,
	            curTrans.toGifParams_()
	        );
	
	        for (iIdx = 0; iIdx < curTrans.items.length; iIdx++) {
	          nsCache.arrayPush_(
	              searchStrings,
	              curTrans.items[iIdx].toGifParams_()
	          );
	        }
	      }
	
	      // sent data to GABE via GIF hits
	      for (searchIdx = 0; searchIdx < searchStrings.length; searchIdx++) {
	        
	        gifRequester.sendGifRequest_(
	            searchStrings[searchIdx],
	            uAccount_,
	            documentCache_,
	            domainHash,
	            true
	        );
	      }
	    }
	  }



	 /**
	   * This method reparses the e-commerce.  If there were an e-commerce instance,
	   * it will be wiped out, and replaced with data in the HTML DOM.
	 */
	  	public function _setTrans() :void
	  	{
		    var docCache:HTMLDocumentDetails = documentCache_;
		    var newECommInstance :Boolean= true;
		    var lineNumber:Number;
		    var transFields:Array;
		    var transFieldIdx:Number;
		    var lines:Array;
		    var parentTrans:ECommTransaction;
		
		    var element:Object = (docCache.getElementById != null) ?
		        // get element by "getElementById"
		        docCache.getElementById("utmtrans") :
		
		        // get element by document property
		        (docCache.utmform && docCache.utmform.utmtrans) ?
		            docCache.utmform.utmtrans :
		            undef;
		    
		    _initData();
	
	    if (element && element.value) {
	      // clear out old e-commerce values
	      ecomm_ = new EComm();
	
	      lines = splitProxy(element.value, "UTM:");
	
	      // assign default transaction field delimiter if it's not set
	      config.transactionFieldDelim_ = !config.transactionFieldDelim_ ||
	                                     ("" == config.transactionFieldDelim_) ?
	                                     "|" : config.transactionFieldDelim_;
	
	      // for each line item
	      for (lineNumber = 0; lineNumber < lines.length; lineNumber++) 
	      {
		        lines[lineNumber] = trim(lines[lineNumber]);
		
		        transFields = splitProxy(
		            lines[lineNumber],
		            config.transactionFieldDelim_
		        );
	
		        for (transFieldIdx = 0; transFieldIdx < transFields.length;
		            transFieldIdx++) 
		        {
		          
		          transFields[transFieldIdx] = trim(transFields[transFieldIdx]);
		        }
	
	        if ("T" == transFields[0]) 
	        {
	          // add transaction
	          _addTrans(
	              transFields[1],                                     // order id,
	              transFields[2],                                     // store
	              transFields[3],                                     // total
	              transFields[4],                                     // tax
	              transFields[5],                                     // shipping
	              transFields[6],                                     // city
	              transFields[7],                                     // state
	              transFields[8]                                      // country
	          );
	        } else if ("I" == transFields[0]) {
	          // add item to transaction
	          _addItem(
	              transFields[1],                                 // order id
	              transFields[2],                                 // SKU
	              transFields[3],                                 // product name
	              transFields[4],                                 // variation
	              transFields[5],                                 // unit price
	              transFields[6]                                  // quantity
	          );
	        }
	      }
	    }
	  }


	  /**
	   * Creates a transaction object with the given values. As with
	   * <code>_addItem()</code>, this method handles only transaction tracking and
	   * provides no additional ecommerce functionality. Therefore, if the
	   * transaction is a duplicate of an existing transaction for that session, the
	   * old transaction values are over-written with the new transaction values.
	   *
	   * @example
	   * pageTracker._addTrans(
	   *     "1234",             // order ID - required
	   *     "My Partner Store", // affiliation or store name
	   *     "84.99",            // total - required
	   *     "7.66",             // tax
	   *     "15.99",            // shipping
	   *     "Boston",           // city
	   *     "MA",               // state or province
	   *     "USA"               // country
	   * );
	   *
	   * @param {String} orderId Internal unique order id number for this
	   *     transaction.
	   * @param {String} affiliation Optional partner or store affiliation.
	   *     (undefined if absent)
	   * @param {String} total Total dollar amount of the transaction.
	   * @param {String} tax Tax amount of the transaction.
	   * @param {String} shipping Shipping charge for the transaction.
	   * @param {String} city City to associate with transaction.
	   * @param {String} state State to associate with transaction.
	   * @param {String} country Country to associate with transaction.
	   *
	   * @return {_gat.GA_EComm_.Transactions_} The tranaction object that was
	   *     modified.
	   */
	  public function _addTrans(orderId:String,
	                               store:String,
	                               total:String,
	                               tax:String,
	                               shippingFee:String,
	                               billingCity:String,
	                               billingState:String,
	                               billingCountry:String) :ECommTransaction
		 {
		    // initialize e-comm instance if it hasn't been initialized yet.
		    ecomm_ = ecomm_ ? ecomm_ : new EComm();
		
		    // adding transaction
		    return ecomm_.addTransaction_(
		        orderId,
		        store,
		        total,
		        tax,
		        shippingFee,
		        billingCity,
		        billingState,
		        billingCountry
		    );
	
	  	}



	 /**
	   * Adds a transaction item to the parent transaction object. Use this method
	   * to track items purchased by visitors to your ecommerce site.  This method
	   * tracks items by SKU and performs no additional ecommerce calculations (such
	   * as quantity calculations). Therefore, if the item being added is a
	   * duplicate (by SKU) of an existing item for that session, then the old
	   * information is replaced with the new. Additionally, it does not enforce the
	   * creation of a parent transation object, but it is advised that you set this
	   * up explicitly in your transaction tracking code. If no parent transaction
	   * object exists for the item, the item is attached to an empty transaction
	   * object instead.
	   *
	   * @example
	   * pageTracker._addItem(
	   *     "343212",    // order ID
	   *     "DD4444",    // sku
	   *     "Lava Lamp", // product name
	   *     "Decor",     // category or product variation
	   *     "34.99",     // price
	   *     "1"          // quantity
	   * );
	   *
	   * @param {String} Item's order ID (required).
	   * @param {String} sku Item's SKU code (required).
	   * @param {String} name Product name.
	   * @param {String} category Product category.
	   * @param {String} price Product price (required).
	   * @param {String} quantity Purchase quantity (required).
	   */
	  public function _addItem (orderId:String,
	                           sku:String,
	                           productName:String,
	                           variation:String,
	                           unitPrice:String,
	                           quantity:String) :void
		 {

		    var parentTrans:ECommTransaction;
		    
		    // initialize e-comm instance if it hasn't been initialized yet.
		    ecomm_ = ecomm_ ? ecomm_ : new EComm();
		
		    // get item's parent transaction
		    parentTrans = ecomm_.getTransaction_(orderId);
		
		    /**
		     * If there is no parent transaction (out of order, or orphan item, add
		     * placeholder parent transaction)
		     */
		    if (!parentTrans) 
		    {
		      parentTrans = _addTrans(orderId, "", "", "", "", "", "", "");
		    }
		
		    // add item to trnasaction
		    parentTrans.addItem_(sku, productName, variation, unitPrice, quantity);
	 	 }


		  /**
		   * Sets a user-defined value. The value you supply appears as an option in the
		   * Segment pull-down for the Traffic Sources reports.  You can use this value
		   * to provide additional segmentation on users to your website. For example,
		   * you could have a login page or a form that triggers a value based on a
		   * visitor's input, such as a preference the visitor chooses, or a privacy
		   * option. This variable is then updated in the cookie for that visitor.
		   *
		   * @param {String} newVal New user defined value to set.
		   */
		  public function _setVar(newVal:String):void 
		  {
		    // empty user value or google's page, do nothing
		    if (newVal && ("" != newVal))	// && isNotGoogleSearch()) 
		    {
		      // cookie that we are going to use for writing new cookie value
		      var newCookie:Cookie = new Cookie(documentCache_, config);
		
		      // domain hash
		      var domainHash:String = domainHash_;
		
		      // set the new value
		      newCookie.setUtmvValue_(
		          domainHash + "." + nsCache.encodeWrapper_(newVal)
		      );
		
		      // write value to cookie
		      newCookie.writeUtmvValue_();
		
		      // sent gif request if taking this sample
		      if (takeSample_()) 
		      {
		        gifRequester.sendGifRequest_(
		          "&utmt=var",
		          uAccount_,
		          documentCache_,
		          domainHash_
		        );
		      }
		    }
		  }


		  /**
		   * This method works in conjunction with the <code>_setDomainName()</code> and
		   * <code>_setAllowLinker()</code> methods to enable cross-domain user
		   * tracking.  The <code>_link()</code> method passes the cookies from this
		   * site to another via URL parameters (HTTP GET). It also changes the
		   * document.location and redirects the user to the new URL.
		   *
		   * <pre>&lt;a href="http://www.newsite.com" onclick="pageTracker._link('http://www.newsite.com');return false;"&gt;Go to our sister site&lt;/a&gt;</pre>
		   * <br />
		   * You must also enable linking on the target site
		   * (<code>pageTracker._setAllowLinker(true);</code>) in order for link to work
		   * properly.
		   *
		   * @param {String} targetUrl URL of target site to send cookie values to.
		   * @param {String} useHash Set to true for passing tracking code variables by
		   *     using the # anchortag separator rather than the default ? query string
		   *     separator. (Currently this behavior is for internal Google properties
		   *     only.)
		   */
		  public function _link(targetUrl:String, useHash:String):void 
		  {
		    // do nothing if linker is disabled, or target url is undef or blank
		    if (config.allowLinker_ && targetUrl) 
		    {
		      _initData();
		          
		      // redirect
		      /*
		      	documentCache_[LOCATION].href = _getLinkerUrl(
		          targetUrl,
		          useHash
		      );*/ // cahnged as follows
		      
		      documentCache_.location_href = _getLinkerUrl(
		          targetUrl,
		          useHash
		      );
		    }
		  }


		  /**
		   * This method works in conjunction with the <code>_setDomainName()</code> and
		   * <code>_setAllowLinker()</code> methods to enable cross-domain user
		   * tracking.  The <code>_linkByPost()</code> method passes the cookies from
		   * the referring form to another site in a string appended to the action value
		   * of the form (HTTP POST). This method is typically used when tracking user
		   * behavior from one site to a 3rd-party shopping cart site, but can also be
		   * used to send cookie data to other domains in pop-ups or in iFrames.
		   *
		   * <pre>&lt;form action="http://www.shoppingcartsite.com/myService/formProcessor.php"
		   *      name="f" method="post" onsubmit="pageTracker._linkByPost(this)"&gt;
		   * . . .
		   * &lt;/form&gt;</pre>
		   * <br />
		   * In addition, <code>_setAllowLinker()</code> must be set to true on the
		   * destination web page in order for linking to work.
		   *
		   * @param {HTMLFormElement} formObject Form object encapsulating the POST
		   *     request.
		   * @param {String} useHash Set to true for passing tracking code variables by
		   *     using the # anchortag separator rather than the default ? query string
		   *     separator.
		   */
		  public function _linkByPost(formObject:Object, useHash:String) :void
		  {
		    /**
		     * Do nothing if linker is disabled, or form object doesn't exist, or
		     * doesn't have an action.
		     */
		    if (config.allowLinker_ && formObject && formObject.action) 
		    {
		      _initData();
		          
		      // modify
		      formObject.action = _getLinkerUrl(
		          formObject.action,
		          useHash
		      );
		    }
		  }

		  /**
		   * Public interface for setting an X10 string key.
		   *
		   * @param {Number} projectId The project ID for which to set a value.
		   * @param {Number} num The numeric index for which to set a value.
		   * @param {String} value The value to be set into the specified indices.
		   */
		  public function _setXKey(projectId:Number, num:Number, value:String):void
		  {
		    x10Module_._setKey(projectId, num, value);
		  }

		  /**
		   * Public interface for setting an X10 integer value.
		   *
		   * @param {Number} projectId The project ID for which to set a value.
		   * @param {Number} num The numeric index for which to set a value.
		   * @param {Number} value The value to be set into the specified indices.
		   */
		  public function _setXValue(projectId:Number, num:Number, value:Number):void 
		  {
		    x10Module_._setValue(projectId, num, value);
		  }

		  /**
		   * Public Interface for getting an X10 string key.
		   *
		   * @param {Number} projectId The project ID for which to get a value.
		   * @param {Number} num The numeric index for which to get a value.
		   *
		   * @return {String} The requested key, null if not found.
		   */
		  public function _getXKey(projectId:Number, num:Number):Object
		  {
		    return x10Module_._getKey(projectId, num);
		  }

		  /**
		   * Public interface for getting an X10 integer value.
		   *
		   * @param {Number} projectId The project ID for which to get a value.
		   * @param {Number} num The numeric index for which to get a value.
		   *
		   * @return {String} The requested value in string form, null if not found.
		   */
		  public function _getXValue(projectId:Number, num:Number) :Object
		  {
		    return x10Module_._getValue(projectId, num);
		  }

		  /**
		   * Public interface for clearing all X10 string keys for a given project ID.
		   *
		   * @param {Number} projectId The project ID for which to clear all keys.
		   */
		  public function _clearXKey (projectId:Number):void
		  {
		    x10Module_._clearKey(projectId);
		  }

		  /**
		   * Public interface for clearing all X10 integer values for a given project ID.
		   *
		   * @param {Number} projectId The project ID for which to clear all values.
		   */
		  public function _clearXValue(projectId:Number) :void
		  {
		    x10Module_._clearValue(projectId);
		  }

		  /**
		   * Public interface for spawning new X10 objects. These are used to keep
		   * track of event-based data (as opposed to the persistent data kept on
		   * the self.X10Module_ object) that need to be stored separately.
		   *
		   * @return {_gat.GA_X10_} new X10 object.
		   */
		  public function _createXObj():X10
		  {
		    _initData();
		    return new X10();
		  }

		 /**
		   * Public interface for sending an event. This will render all event-based
		   * data along with Analytics data previously collected on pageview and send
		   * the event to collectors.
		   *
		   * @param {_gat.GA_X10_} opt_xObj Event-based X10 data that we may want to
		   *     augment to the persistent X10 data stored on the tracker object
		   *     instance.
		   */
		  public function _sendXEvent(opt_xObj:X10) :void
		  {
		    var searchString:String = "";
		
		    _initData();
		
		    if (takeSample_()) {
		      searchString +=
		          // Hit type.
		          "&utmt=event" +
		
		          // X10 data.
		          "&utme=" + nsCache.encodeWrapper_(
		               x10Module_.renderMergedUrlString_(
		                   opt_xObj
		               )
		           ) +
		
		          // Browser, campaign, and document information.
		          renderMetricsSearchString_();
		
		      // sent gif request
		      gifRequester.sendGifRequest_(
		        searchString,
		        uAccount_,
		        documentCache_,
		        domainHash_,
		        false,
		        true
		      );
		    }
		  }

		  /**
		   * Creates an event tracking object with the specified name. Call this method
		   * when you want to create a new web page object to track in the Event
		   * Tracking section of the reporting. See the Event Tracking Guide for more
		   * information.
		   *
		   * @example
		   * var videoTracker = pageTracker._createEventTracker("Videos");
		   *
		   * @param {String} objName The name of the tracked object.
		   *
		   * @return {_gat.GA_EventTracker_} A new event tracker instance.
		   */
		   /* ........ openpoint... looks like this is with old syntax
		  public function _createEventTracker (objName:String):GA_EventTracker_AS 
		  {
		    _initData();
		    return new GA_EventTracker_AS(objName, selfRef);
		  }...*/


	  /**
	   * Tracks the event.
	   *
	   * @param {String} objName The name of the tracked object.
	   * @param {String} eventType The type name for the event.
	   * @param {String} opt_label An optional descriptor for the event.
	   * @param {String} opt_value An optional value to be aggregated with
	   *     the event.
	   *
	   * @return {Boolean} whether the event was successfully sent.
	   */
		  public function _trackEvent(objName:String, 
									  eventType:String, 
									  opt_label:String = "", 
									  opt_value:String = "") :Boolean
		  {
		    var success :Boolean= true;
		    var eventTracker:X10 = eventTracker_;
		
		    // If event tracking call is valid
		    if ((undef != objName) && (undef != eventType) && ("" != objName) &&
		        ("" != eventType)) {
		
		      // clear event tracker data
		      eventTracker._clearKey(EVENT_TRACKER_PROJECT_ID);
		      eventTracker._clearValue(EVENT_TRACKER_PROJECT_ID);
		 
		      // object
		      success =
		          eventTracker._setKey(
		              EVENT_TRACKER_PROJECT_ID,
		              EVENT_TRACKER_OBJECT_NAME_KEY_NUM,
		              objName
		          ) ? success : false;
		
		      // event type
		      success =
		          eventTracker._setKey(
		              EVENT_TRACKER_PROJECT_ID,
		              EVENT_TRACKER_TYPE_KEY_NUM,
		              eventType
		          ) ? success : false;
		
		      // event description / label
		      success = ((undef == opt_label) ||
		          eventTracker._setKey(
		              EVENT_TRACKER_PROJECT_ID,
		              EVENT_TRACKER_LABEL_KEY_NUM,
		              opt_label
		          )) ? success : false;
		
		      // aggregate value
		      success = ((undef == opt_value) ||
		          eventTracker._setValue(
		              EVENT_TRACKER_PROJECT_ID,
		              EVENT_TRACKER_VALUE_VALUE_NUM,
		              Number(opt_value)
		          )) ? success : false;
		
		      // event tracker is set successfully
		      if (success) 
		      {
		        _sendXEvent(eventTracker);
		      }
		
		    } 
		    else 
		    {
		      // event tracking call is not valid, failed!
		      success = false;
		    }
		
		    return success;
		  }

	
		  /**
		   * Tracks the outbound click.  Indicates the visitor has clicked on an
		   * outbound link.
		   *
		   * @param {String} outboundUrl URL for the outbound link.
		   */
		  public function _trackOutboundUrl(outboundUrl:String):void 
		  {
		    _initData();
		
		    if (takeSample_())
		     {
		      // create new X10 object
		      var outboundTracker:X10 = new X10();
		
		      /**
		       * Set project id to 6 (Outbound tracking project id)
		       * 1st key in the project is for outbound tracking URL
		       */
		      outboundTracker._setKey(6, 1, outboundUrl);
		
		      // send gif request
		      gifRequester.sendGifRequest_(
		          // search string
		          "&utmt=event" +
		          "&utme=" + nsCache.encodeWrapper_(
		              outboundTracker.renderUrlString_()
		          ) + renderMetricsSearchString_(),
		
		          uAccount_,
		          documentCache_,
		          domainHash_,
		          false,
		          true
		      );
		    }
		  }

		  /**
		   * Sets the domain name for cookies. There are three modes to this method:
		   * <code>("auto" | "none" | [[]domain])</code>. By default, the method is set
		   * to auto, which attempts to resolve the domain name based on the location
		   * object in the DOM.  <br/><br/>
		   *
		   * Set this method explicitly to your domain name if your website spans
		   * multiple hostnames, and you want to track visitor behavior across all
		   * hosts. For example, if you have two hosts: <code>server1.example.com</code>
		   * and <code>server2.example.com</code>, you would set the domain name as
		   * follows:<br/><br/>
		   *
		   * <pre>pageTracker._setDomainName(".example.com");</pre><br/><br/>
		   *
		   * Be sure to use a leading "." in front of your domain name, as illustrated
		   * here. The leading period ensures that the cookie will be accessible across
		   * all hosts.  Otherwise, the cookie is accessible only in
		   * example.com.<br/><br/>
		   *
		   * Set this method to none in the following two situations:
		   * <li>You want to disable tracking across hosts.</li>
		   * <li>You want to set up tracking across two separate domains. Cross-
		   * domain tracking requires configuration of the
		   * <code>_setAllowLinker()</code> and <code>_link</code></li> methods.
		   *
		   * @example
		   * pageTracker._setDomainName("none");
		   *
		   * @param {String} newDomainName New default domain name to set.
		   */
	 	   public function _setDomainName(newDomainName:String):void 
	 	   {
	    		config.domainName_ = newDomainName;
	  	   }
	
		  /**
		   * Returns the domain name for cookies.
		   *
		   * @private
		   * @return {String} domain name
		   */
		  private function getDomainName_() :String
		  {
		    return config.domainName_;
		  }

		  /**
		   * Adds a search engine to be included as a potential search engine traffic
		   * source. By default, Google Analytics recognizes a number of common search
		   * engines, but you can add additional search engine sources to the list.
		   *
		   * @param {String} newOrganicEngine Engine for new organic source.
		   * @param {String} newOrganicKeyword Keyword name for new organic source.
		   */
		  public function _addOrganic(newOrganicEngine:String, newOrganicKeyword:String):void 
		  {
		  	
		    nsCache.arrayPush_(
		        config.organicSources_,
		        new OrganicReferrer(newOrganicEngine, newOrganicKeyword)
		    );
		    
		  }
	
		  /**
		   * Clears all search engines as organic sources.  Use this method when you
		   * want to define a customized search engine ordering precedence.
		   */
		   public function _clearOrganic() :void
		   {
		    	config.organicSources_ = [];
		   }

		  /**
		   * Return organic sources.
		   *
		   * @private
		   * @return {Array} organic sources
		   */
		   private function getOrganic_() :Array
		   {
		    	return config.organicSources_;
		   }

		  /**
		   * Sets the string as ignored term(s) for Keywords reports. Use this to
		   * configure Google Analytics to treat certain search terms as direct traffic,
		   * such as when users enter your domain name as a search term. When you set
		   * keywords using this method, the search terms are still included in your
		   * overall page view counts, but not included as elements in the Keywords
		   * reports.
		   *
		   * @example
		   * pageTracker._addIgnoredOrganic("www.mydomainname.com");
		   *
		   * @param {String} newIgnoredOrganicKeyword Keyword search terms to treat as
		   *     direct traffic.
		   */
		   public function _addIgnoredOrganic(newIgnoredOrganicKeyword:String):void 
		   {
		    	nsCache.arrayPush_(config.organicIgnore_, newIgnoredOrganicKeyword);
		   }

		  /**
		   * Clears all strings previously set for exclusion from the Keyword reports.
		   */
		   public function _clearIgnoredOrganic() :void
		   {
		   	 config.organicIgnore_ = [];
		   }

		  /**
		   * Returns all strings that have been set for exclusion from the Keyword
		   * reports.
		   *
		   * @private
		   * @return {Array} Keywords to ignore.
		   */
		   private function getIgnoredOrganic_():Array 
		   {
		    	return config.organicIgnore_;
		   }

		  /**
		   * Excludes a source as a referring site. Use this option when you want to set
		   * certain referring links as direct traffic, rather than as referring sites.
		   * For example, your company might own another domain that you want to track
		   * as direct traffic so that it does not show up on the "Referring Sites"
		   * reports. Requests from excluded referrals are still counted in your overall
		   * page view count.
		   *
		   * @example
		   * pageTracker._addIgnoredRef("www.sister-site.com");
		   *
		   * @param {String} newIgnoredReferrer Referring site to exclude.
		   */
		   public function _addIgnoredRef(newIgnoredReferrer:String) :void
		   {
		    	nsCache.arrayPush_(config.referralIgnore_, newIgnoredReferrer);
		   }
		
		  /**
		   * Clears all items previously set for exclusion from the Referring Sites
		   * report.
		   */
		   public function _clearIgnoredRef() :void
		   {
		    	config.referralIgnore_ = [];
		   }

		  /**
		   * Returns all strings that have been set for exclusion from the Referring
		   * Sites report.
		   *
		   * @private
		   * @return {Array} Referring sites to exclude.
		   */
		   private function getIgnoredRef_() :Array
		   {
		   	 return config.referralIgnore_;
		   }

		  /**
		   * Sets the allow domain hash flag. By default, this value is set to true. The
		   * domain hashing functionality in Google Analytics creates a hash value from
		   * your domain, and uses this number to check cookie integrity for visitors.
		   * If you have multiple sub-domains, such as <code>example1.example.com</code>
		   * and <code>example2.example.com</code>, and you want to track user behavior
		   * across both of these sub-domains, you would turn off domain hashing so that
		   * the cookie integrity check will not reject a user cookie coming from one
		   * domain to another. Additionally, you can turn this feature off to optimize
		   * per-page tracking performance.
		   *
		   * @param {Boolean} enable If this parameter is set to true, then domain
		   *     hashing is enabled.  Else, domain hashing is disabled. True by default.
		   */
		   public function _setAllowHash(enable:Boolean) :void
		   {
		    	config.allowDomainHash_ = enable ? 1 : 0;
		   }

		  /**
		   * Sets the campaign tracking flag. By default, campaign tracking is enabled
		   * for standard Google Analytics set up.  If you wish to disable campaign
		   * tracking and the associated cookies that are set for campaign tracking,
		   * you can use this method.
		   *
		   * @param {Boolean} enable True by default, which enables campaign
		   *     tracking.  If set to false, campaign tracking is disabled.
		   */
		   public function _setCampaignTrack(enable:Boolean) :void
		   {
		   	 config.campaignTracking_ = enable ? 1 : 0;
		   }

		  /**
		   * Sets the browser tracking module. By default, Google Analytics tracks
		   * browser information from your visitors and provides more data about your
		   * visitor's browser settings that you get with a simple HTTP request. If you
		   * desire, you can turn this tracking off by setting the parameter to false.
		   * If you do this, any browser data will not be tracked and cannot be
		   * recovered at a later date, so use this feature carefully.
		   *
		   * @param {Boolean} enable Defaults to true, and browser tracking is enabled.
		   *     If set to false, browser tracking is disabled.
		   */
		   public function _setClientInfo(enable:Boolean):void 
		   {
		    	config.clientInfo_ = enable ? 1 : 0;
		   }

		  /**
		   * Gets the flag that indicates whether the browser tracking module is
		   * enabled. See <code>_setClientInfo()</code> for more information.
		   *
		   * @param {Number} 1 if enabled, 0 if disabled.
		   */
		   public function _getClientInfo():Number
		   {
		   	 return config.clientInfo_;
		   }

		  /**
		   * Sets the new cookie path for your site. By default, Google Analytics sets
		   * the cookie path to the root level (/).  In most situations, this is the
		   * appropriate option and works correctly with the tracking code you install
		   * on your website, blog, or corporate web directory. However, in a few cases
		   * where user access is restricted to only a sub-directory of a domain, this
		   * method can resolve tracking issues by setting a sub-directory as the
		   * default path for all tracking.
		   *
		   * Typically, you would use this if your data is not being tracked and you
		   * subscribed to a blog service and only have access to your defined
		   * sub-directory, or if you are on a Corporate or University network and only
		   * have access to your home directory. In these cases, using a terminal slash
		   * is the recommended practice for defining the sub-directory.
		   *
		   * @example
		   * pageTracker._setCookiePath("/~username/");
		   * pageTracker._setCookiePath("/myBlogDirectory/");
		   *
		   * @param {String} newCookiePath New cookie path to set.
		   */
		   public function _setCookiePath(newCookiePath:String) :void
		   {
		    	config.cookiePath_ = newCookiePath;
		   }

		  /**
		   * Set the transaction field delimiter.
		   *
		   * @param {String} newTransactionDelim New default domain name to set.
		   */
		   public function _setTransactionDelim(newTransactionDelim:String) :void
		   {
		    	config.transactionFieldDelim_ = newTransactionDelim;
		   }

		  /**
		   * Sets the campaign tracking cookie expiration time in seconds. By default,
		   * campaign tracking is set for 6 months. In this way, you can determine over
		   * a 6-month period whether visitors to your site convert based on a specific
		   * campaign. However, your business might have a longer or shorter campaign
		   * time-frame, so you can use this method to adjust the campaign tracking for
		   * that purpose.
		   *
		   * @example
		   * pageTracker._setCookieTimeout("3152600"); //number of seconds in 1 year
		   *
		   * @param {String} newDefaultTimeout New default cookie expiration time to
		   *     set. Pass in as a string and it is converted to an integer.
		   */
		   public function _setCookieTimeout(newDefaultTimeout:String):void 
		   {
		    	config.conversionTimeout_ = newDefaultTimeout;
		   }

		  /**
		   * Sets the Flash detection flag. By default, Google Analytics tracks Flash
		   * player information from your visitors and provides detailed data about your
		   * visitor's Flash player settings.
		   *
		   * If you desire, you can turn this tracking off by setting the parameter to
		   * false.  If you do this, any Flash player data will not be tracked and
		   * cannot be recovered at a later date, so use this feature carefully.
		   *
		   * @param {Boolean} enable Default is true and Flash
		   *     detection is enabled.  False disables Flash detection.
		   */
		   public function _setDetectFlash(enable:Boolean):void 
		   {
		    	config.flashDetection_ = enable ? 1 : 0;
		   }

		  /**
		   * Gets the Flash detection flag. See <code>_setDetectFlash()</code> for more
		   * information.
		   *
		   * @param {Number} 1 if enabled, 0 if disabled.
		   */
		   public function _getDetectFlash():Number 
		   {
		    	return config.flashDetection_;
		   }

		  /**
		   * Sets the title detection flag. By default, page title detection for your
		   * visitors is on. This information appears in the Contents section under
		   * "Content by Title."
		   *
		   * If you desire, you can turn this tracking off by setting the parameter to
		   * false. You could do this if your website has no defined page titles and the
		   * Content by Title report has all content grouped into the "(not set)" list.
		   * You could also turn this off if all your pages have particularly long
		   * titles. If you do this, any page titles that are defined in your website
		   * will not be displayed in the "Content by Title" reports. This information
		   * cannot be recovered at a later date once it is disabled.
		   *
		   *
		   * @param {Boolean} enable Defaults to true, and title detection is enabled.
		   *     If set to false, title detection is disabled.
		   */
		   public function _setDetectTitle(enable:Boolean) :void
		   {
		   		config.detectTitle_ = enable ? 1 : 0;
		   }

		  /**
		   * Gets the title detection flag.
		   *
		   * @param {Number} 1 if enabled, 0 if disabled.
		   */
		   public function _getDetectTitle() :Number
		   {
		  	 return config.detectTitle_;
		   }

		  /**
		   * Sets the local path for the Urchin GIF file. Use this method if you are
		   * running the Urchin tracking software on your local servers. The path you
		   * specific here is used by the <code>_setLocalServerMode()</code> and
		   * <code>_setLocalRemoteServerMode()</code> methods to determine the path to
		   * the local server itself.
		   *
		   * @param {String} newLocalGifPath Path to GIF file on the local server.
		   */
		   public function _setLocalGifPath(newLocalGifPath:String) :void
		   {
		    	config.gifPathLocal_ = newLocalGifPath;
		   }

		  /**
		   * Gets the local path for the Urchin GIF file. See
		   * <code>_setLocalGifPath()</code> for more information.
		   *
		   * @return {String} Path to GIF file on the local server.
		   */
		   public function _getLocalGifPath():String 
		   {
		    	return config.gifPathLocal_;
		   }

		  /**
		   * Invoke this method to send your tracking data to a local server only.  You
		   * would use this method if you are running the Urchin tracking software on
		   * your local servers and want all tracking data to be sent to your servers.
		   * In this scenario, the path to the local server is set by
		   * <code>_setLocalGifPath()</code>.
		   */
		   public function _setLocalServerMode():void 
		   {
		    	config.serviceMode_ = SERVICEMODE_LOCAL;
		   }

		  /**
		   * Default installations of Google Analytics send tracking data to the Google
		   * Analytics server.  You would use this method if you have installed the
		   * Urchin software for your website and want to send particular tracking data
		   * only to the Google Analytics server. 
		   */
		   public function _setRemoteServerMode() :void
		   {
		    	config.serviceMode_ = SERVICEMODE_REMOTE;
		   }

		  /**
		   * Invoke this method to send your tracking data both to a local server and to
		   * the Google Analytics backend servers.  You would use this method if you are
		   * running the Urchin tracking software on your local servers and want to
		   * track data locally as well as via Google Analytics servers. In this
		   * scenario, the path to the local server is set by
		   * <code>_setLocalGifPath()</code>.
		   */
		   public function _setLocalRemoteServerMode():void
		   {
		    	config.serviceMode_ = SERVICEMODE_BOTH;
		   }

		  /**
		   * Returns server operation mode.
		   *
		   * @public
		   * @return {Nunmber} Server operation mode. (0=local | 1=remote | 2=both)
		   */
		   public function getLocalRemoteServerMode_() :Number
		   {
		    	return config.serviceMode_;
		   }

		  /**
		   * Returns the server operation mode.  Possible return values are 0 for local
		   * mode (sending data to local server set by <code>_setLocalGifPath()</code>),
		   * 1 for remote mode (send data to Google Analytics backend server), or 2 for
		   * both local and remote mode.
		   *
		   * @return {Number} Server operation mode.
		   */
		   public function _getServiceMode() :Number
		   {
		    	return config.serviceMode_;
		   }

		  /**
		   * Sets the new sample rate. If your website is particularly large and subject
		   * to heavy traffic spikes, then setting the sample rate ensures
		   * un-interrupted report tracking. Sampling in Google Analytics occurs
		   * consistently across unique visitors, so there is integrity in trending and
		   * reporting even when sampling is enabled, because unique visitors remain
		   * included or excluded from the sample, as set from the initiation of
		   * sampling.
		   *
		   * @example
		   * pageTracker._setSampleRate("80"); //sets sampling rate to 80 percent
		   *
		   * @param {String} newRate New sample rate to set. Provide a numeric string as
		   *     a whole percentage.
		   */
		   public function _setSampleRate(newRate:String) :void
		   {
		    	config.sampleRate_ = Number(newRate);
		   }

	 	 /**
		   * Sets the new session timeout in seconds. By default, session timeout is set
		   * to 30 minutes (1800 seconds). Session timeout is used to compute visits,
		   * since a visit ends after 30 minutes of browser inactivity or upon browser
		   * exit. If you want to change the definition of a "session" for your
		   * particular needs, you can pass in the number of seconds to define a new
		   * value.  This will impact the Visits reports in every section where the
		   * number of visits are calculated, and where visits are used in computing
		   * other values.  For example, the number of visits will increase if you
		   * shorten the session timeout, and will decrease if you increase the session
		   * timeout.
		   *
		   * @param {String} newTimeout New session timeout to set in seconds.
		   */
		   public function _setSessionTimeout(newTimeout:String):void
		   {
		   	 config.sessionTimeout_ = newTimeout;
		   }

		  /**
		   * Sets the linker functionality flag as part of enabling cross-domain user
		   * tracking.  By default, this method is set to false and linking is disabled.
		   * See also <code>_link()</code>, <code>_linkByPost()</code>, and
		   * <code>_setDomainName()</code> methods to enable cross-domain tracking.
		   *
		   * @example
		   * pageTracker._setAllowLinker(true);
		   *
		   * @param {Boolean} enable If this parameter is set to true, then linker is
		   *     enabled.  Else, linker is disabled.
		   */
		   public function _setAllowLinker(enable:Boolean) :void
		   {
		    	config.allowLinker_ = enable ? 1 : 0;
		   }

		  /**
		   * Allows the # sign to be used as a query string delimiter in campaign
		   * tracking.  This option is disabled by default. Typically, campaign tracking
		   * URLs are comprised of the question mark (?) separator and the ampersand (&)
		   * as delimiters for the key/value pairs that make up the query. By enabling
		   * this option, your campaign tracking URLs can use a pound (#) sign instead
		   * of the ampersand (&).
		   *
		   * @example
		   * http://mysite.net/index.html?source=In+House#method=email#offer_type=Fall+email+offers
		   * pageTracker._setAllowAnchor(true);
		   *
		   * @param {Boolean} enable If this parameter is set to true, then campaign
		   *     will use anchors.  Else, campaign will use search strings.
		   */
		   public function _setAllowAnchor(enable:Boolean) :void
		   {
		    	config.allowAnchor_ = enable ? 1 : 0;
		   }

		  /**
		   * Sets the campaign name key. The campaign name key is used to retrieve the
		   * name of your advertising campaign from your campaign URLs. You would use
		   * this function on any page that you want to track click-campaigns
		   * on.<br /> <br />
		   *
		   * For example, suppose you send an email to registered users about a special
		   * offer, and the link to that offer looks like: <br /><br />
		   *
		   * <pre>http://mysite.net/index.html?source=In+House&method=email&offer_type=Fall+email+offers</pre><br /><br />
		   *
		   * In this url, the key "offer_type" delineates the name supplied in the URL
		   * for that campaign.  (This is the name that appears in the list of Campaigns
		   * in the Traffic Sources report.) To use that key as your customized campaign
		   * name key, you would set:<br /><br />
		   *
		   * @example
		   * pageTracker._setCampNameKey("offer_type");
		   *
		   * @param {String} newCampNameKey Campaign name key.
		   */
		   public function _setCampNameKey(newCampNameKey:String):void 
		   {
		    	config.UCCN_ = newCampNameKey;
		   }

		  /**
		   * Sets the campaign ad content key.  The campaign content key is used to
		   * retrieve the ad content (description) of your advertising campaign from
		   * your campaign URLs. Use this function on the landing page defined in your
		   * campaign.<br /><br />
		   *
		   * For example, suppose you have an ad on another website with this URL to
		   * your site: <br /><br />
		   *
		   * <pre>http://mysite.net/index.html?source=giganoshopper.com&method=referral&offer_type=Christmas+specials&description=Garden+gloves</pre><br /><br />
		   *
		   * In this url, the key "description" delineates the content supplied in the
		   * URL for that campaign.  (These terms and phrases appear under the Ad
		   * Content column in the Campaign detail page in the Traffic Sources report.)
		   * To use that key as your customized campaign content key, you would
		   * set:<br /><br />
		   *
		   * @example
		   * pageTracker._setCampContentKey("description");
		   *
		   * @param {String} newCampContentKey New campaign content key to set.
		   */
		   public function _setCampContentKey(newCampContentKey:String):void 
		   {
		    	config.UCCT_ = newCampContentKey;
		   }

		  /**
		   * Sets the campaign ID key used to retrieve the ID of your advertising
		   * campaign from campaign URLs.  While the campaign ID does not appear as a
		   * segment option or a heading in the Campaigns reports, a lookup table can be
		   * used to map the campaign ID to its respective campaign in order to
		   * delineate similarly tagged campaigns from each other. Additionally, if you
		   * do not provide a source for your campaign URL, then you must provide a
		   * campaign ID; otherwise no campaign cookie will be set for this campaign.
		   * The following example shows a URL with a customized ID key:<br/><br/>
		   *
		   * <pre>http://mysite.net/index.html?source=giganoshopper.com&method=referral&offer_type=Christmas+specials&description=Garden+gloves&ID=78789</pre><br/><br/>
		   *
		   * In this url, the key "ID" delineates the id string for that campaign (and
		   * ensures that this data will be recorded as a unique campaign).  To use that
		   * key as your customized campaign content key, you would set:<br /><br />
		   *
		   * @example
		   * pageTracker._setCampIdKey("ID");
		   *
		   * @param {String} newCampIdKey New campaign Id key to set.
		   */
		   public function _setCampIdKey(newCampIdKey:String):void 
		   {
		    	config.UCID_ = newCampIdKey;
		   }

		  /**
		   * Sets the campaign medium key, which is used to retrieve the medium from
		   * your campaign URLs. The medium appears as a segment option in the Campaigns
		   * report. <br/><br/>
		   *
		   * For example, suppose you have an ad on another website with this URL to
		   * your site: <br /><br />
		   *
		   * <pre>http://mysite.net/index.html?source=giganoshopper.com&method=ad&offer_type=Christmas+specials&description=Garden+gloves</pre><br /><br />
		   *
		   * In this url, the key "method" delineates the medium in the URL for that
		   * campaign. To use that key as your customized campaign content key, you
		   * would set:<br /><br />
		   *
		   * @example
		   * pageTracker._setCampMediumKey("method");
		   *
		   * @param {String} newCampMedKey Campaign medium key to set.
		   */
		   public function _setCampMediumKey(newCampMedKey:String):void
		   {
		    	config.UCMD_ = newCampMedKey;
		   }

		  /**
		   * Sets the campaign no-override key, which is used to retrieve the campaign
		   * no-override value from the URL. By default, this value is set to false. For
		   * campaign tracking and conversion measurement, this means that, by default,
		   * the most recent impression is the campaign that will be credited in your
		   * conversion tracking.  If you prefer to associate the first-most impressions
		   * to a conversion, you would set this method to true. The no-override value
		   * prevents the campaign data from being over-written by similarly defined
		   * campaign URLs that the visitor might also click on. <br/><br/>
		   *
		   * If you have an ad on another website with this URL to your site:
		   * <br /><br />
		   *
		   * <pre>http://mysite.net/index.html?source=giganoshopper.com&method=referral&offer_type=Christmas+specials&description=Garden+gloves&noo=1234</pre><br /><br />
		   *
		   * In this url, the key "noo" delineates the no-override value in the URL for
		   * that campaign. To use that key as your customized campaign no-override key,
		   * you would set:<br /><br />
		   *
		   * @example
		   * pageTracker._setCampNOKey("noo");
		   *
		   * @param {String} newCampNOKey Campaign no-override key to set.
		   */
		   public function _setCampNOKey(newCampNOKey:String) :void
		   {
		    	config.UCNO_ = newCampNOKey;
		   }

		  /**
		   * Sets the campaign source key, which is used to retrieve the campaign source
		   * from the URL. "Source" appears as a segment option in the Campaigns report.
		   * <br/><br/>
		   *
		   * For example, suppose you have an ad on another website with this URL to
		   * your site: <br /><br />
		   *
		   * <pre>http://mysite.net/index.html?source=giganoshopper.com&method=referral&offer_type=Christmas+specials&description=Garden+gloves</pre><br /><br />
		   *
		   * In this url, the key "source" delineates the source in the URL for that
		   * campaign. To use that key as your customized campaign source key, you would
		   * set:<br /><br />
		   *
		   * @example
		   * pageTracker._setCampSourceKey("source");
		   *
		   * @param {String} newCampSrcKey Campaign source key to set.
		   */
		   public function _setCampSourceKey(newCampSrcKey:String):void 
		   {
		    	config.UCSR_ = newCampSrcKey;
		   }

		  /**
		   * Sets the campaign term key, which is used to retrieve the campaign keywords
		   * from the URL. <br/><br/>
		   *
		   * For example, suppose you have a paid ad on a search engine tagged as
		   * follow: <br /><br />
		   *
		   * <pre>http://mysite.net/index.html?source=weSearch4You.com&method=paidSearchAd&offer_type=Christmas+specials&description=Garden+gloves&term=garden+tools</pre><br /><br />
		   *
		   * In this url, the key "term" delineates the keyword terms in the URL for
		   * that campaign. To use that key as your customized campaign term key, you
		   * would set:<br /><br />
		   *
		   * @example
		   * pageTracker._setCampTermKey("term");
		   *
		   * @param {String} newCampTermKey Term key to set.
		   */
		   public function _setCampTermKey(newCampTermKey:String):void
		   {
		    	config.UCTR_ = newCampTermKey;
		   }

		  /**
		   * Sets the campaign click ID key, which is used for parsing campaign click id
		   * from the URL. <br/><br/>
		   *
		   * For example, suppose you have an ad on another search engine site:
		   * <br /><br />
		   *
		   * <pre>http://mysite.net/index.html?source=searchForU.com&method=referrer&offer_type=Christmas+specials&description=Garden+gloves&term=garden+tools&clickID=2345</pre><br /><br />
		   *
		   * In this url, the key "clickID" delineates the click ID in the URL for that
		   * campaign. To use that key as your customized campaign click ID key, you
		   * would set:<br /><br />
		   *
		   * @example
		   * pageTracker._setCampCIdKey("clickID");
		   *
		   * @param {String} newCampCIdKey Campaign click id key to set.
		   */
		   public function _setCampCIdKey(newCampCIdKey:String) :void
		   {
		    	config.UGCLID_ = newCampCIdKey;
		   }

		  /**
		   * Returns the Google Analytics tracking ID for this tracker object. If you
		   * are tracking pages on your website in multiple accounts, you can use this
		   * method to determine the account that is associated with a particular
		   * tracker object.
		   *
		   * @return {String} Account ID this tracker object is instantiated with.
		   */
		   public function _getAccount():String 
		   {
		    	return uAccount_;
		   }

		  /**
		   * Return GA Tracker version number.
		   *
		   * @return {String} GA Tracker version number. 
		   */
		   public function _getVersion():String 
		   {
		    	return VERSION_NUMBER;
		   }

		  /**
		   * Enable automatic outbound link tracking feature with the given list of
		   * domains to ignored.
		   *
		   * @param {Array} ignoredDomains List of substrings of domain to ignore by the
		   *     auto outbound tracking feature.  For example, if ".google." is one of
		   *     the element in the array, then all links that links to
		   *     "www.google.com", "www.google.org", and "finance.google.com" will be
		   *     ignored.  If ignoredDomains is an empty array, then the automatic
		   *     outbound link tracking feature is disabled.
		   */
		   public function _setAutoTrackOutbound(ignoredDomains:Array):void 
		   {
		    	config.ignoredOutboundHosts_ = ignoredDomains;
		   }

		  /**
		   * Sets the upper limit for number of href anchor tags to examine in the auto
		   * outbound tracking feature.  The value of -1 indicates that there is no
		   * upper limit.
		   *
		   * @param {Number} newLimit New upper limit to set.
		   */
		   public function _setHrefExamineLimit(newLimit:Number) :void
		   {
		    config.maxOutboundLinkExamined_ = newLimit;
		   }
		   
		   // special setters for the non DOM users
		   public function setReferrerString(referrer:String):void
		   {
		   		documentCache_.setReferrer(referrer);
		   }
		   public function setLocationHash(hash:String):void
		   {
		   		documentCache_.locationObj.setHash(hash);
		   }
		   
		   public function setLocationHref(href:String):void
		   {
		   		documentCache_.locationObj.setHref(href);
		   }
		   
		   public function setLocationProtocol(protocol:String):void
		   {
		   		documentCache_.locationObj.setProtocol(protocol);
		   }
		   
		   public function setLocationHostname(hostname:String):void
		   {
		   		documentCache_.locationObj.setHostName(hostname);
		   }
		   
		   public function setLocationPathname(pathname:String):void
		   {
		   		documentCache_.locationObj.setPathName(pathname);
		   }
	}
}