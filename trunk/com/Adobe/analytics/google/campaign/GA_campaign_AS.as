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

package com.Adobe.analytics.google.campaign
{
	import com.Adobe.analytics.external.HTMLDocumentDetails_AS;
	import com.Adobe.analytics.external.HTML_LocationDetails_AS;
	import com.Adobe.analytics.google.GA_OrganicReferrer_AS;
	import com.Adobe.analytics.google.GA_config_AS;
	import com.Adobe.analytics.google.GA_cookie_AS;
	import com.Adobe.analytics.google.GA_utils_AS;
	 
	public class GA_campaign_AS
	{
		 
		
		/**
		 * Delimiter for campaign tracker. (Constant equals to "|")
		 *
		 * @type {String}
		 * @private
		 */
		public static const CAMPAIGN_TRACKING_DELIM:String = "|";
		
		
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
		  private var documentCache_:HTMLDocumentDetails_AS ;
		
		  // ~ Instance variables ------------------------------------------------------
		  /**
		   * Hash value of the current domain name.
		   *
		   * @private
		   * @type {Number}
		   */
		  private var domainHash_:String ; // refer the cosntructor it says domainHash is string
		
		  /**
		   * Formatted referrer.
		   *
		   * @private
		   * @type {String}
		   */
		  private var referrer_:String ;
		
		
		  /**
		   * Current time in seconds.
		   *
		   * @private
		   * @type {Number}
		   */
		  private var timeStamp_:Number;
		
		
		  /**
		   * Tracker configuration class.
		   *
		   * @private
		   * @type {_gat.GA_Config_}
		   */
		  private var config_:GA_config_AS;
  
  
		  // ---------------------------------------------------------------------------
		  // PRIVATE VARIABLES
		  // ---------------------------------------------------------------------------
		  /**
		   * Key name for new campaign flag. (in gif hit)
		   *
		   * @private
		   * @type {String}
		   */
		  private var UTMCN_ :String= "utmcn=";
		
		  /**
		   * Key name for repeated campaign click flag. (in gif hit)
		   *
		   * @private
		   * @type {String}
		   */
		  private var UTMCR_:String = "utmcr=";
		  
		
		  private var nsCache:GA_utils_AS = GA_utils_AS.getGAUTIS();
		  private var isEmptyField:Function = nsCache.isEmptyField_;
		  private var undef = nsCache.undef_;
		  private var stringContains:Function =  nsCache.stringContains_;
		  private var parseNameValuePairs:Function = nsCache.parseNameValuePairs_;
		  private var toLowerCase:Function = nsCache.toLowerCaseProxy_;
		  private var splitProxy:Function = nsCache.splitProxy_;
		  private var LENGTH:String = nsCache.LENGTH_;


		var cookieWrapper_:GA_cookie_AS = 	GA_utils_AS.getInitialisedCookieHandler();
  
		  /**
			 * @class Google Analytics Tracker Code (GATC)  This class encompasses all the
			 * neccessary logic in logging web-site metrics onto the GA back-end system.
			 *
			 * @constructor
			 * @private
			 *
			 * @param {String} domainHash Hash value of the current domain name
			 * @param {HTMLDocument} documentCache Document cache.
			 * @param {String} referrer Formatted referrer for page.
			 * @param {Number} timeStamp Current time in seconds.
			 * @param {_gat.GA_Config_} inConfig Tracker configuations.
			 *
		 */
		public function GA_campaign_AS(domainHash:String,
                             documentCache:HTMLDocumentDetails_AS,
                             referrer:String,
                             timeStamp:Number,
                             inConfig:GA_config_AS)
		{
			documentCache_ = documentCache;
			domainHash_ = domainHash;
			referrer_ = referrer;
			timeStamp_ = timeStamp;
			config_ = inConfig;
		}
		
		
	  // ---------------------------------------------------------------------------
	  // PRIVATE METHODS
	  // ---------------------------------------------------------------------------
	  /**
	   * This method will return true if and only document referrer is invalid.
	   * Document referrer is considered to be invalid when it's empty (undefined,
	   * empty string, "-", or "0"), or it's not a valid URL (doesn't have protocol)
	   *
	   * @private
	   * @param {String} docRef Document referrer to be evaluated for validity.
	   *
	   * @return {Boolean} True if and only if document referrer is invalid.
	   */
	  public function invalidReferrer(docRef:String):Boolean
	  {
	    return isEmptyField(docRef) ||
	           ("0" == docRef) ||
	           !stringContains(docRef, "://");
	  }
  

		  // ---------------------------------------------------------------------------
		  // PRIVILIGED METHODS
		  // ---------------------------------------------------------------------------
		  /**
		   * Retrieves campaign tracker from search string.
		   *
		   * @private
		   * @param {String} searchString Search string to retrieve campaign tracker from.
		   *
		   * @return {String} Return campaign tracker retrieved from search string.
		   */
		  public function getTrackerFromSearchString_ (searchString:String):GA_CampaignTracker_AS
		  { 
			    var organicCampaign:GA_CampaignTracker_AS = getOrganicCampaignInfo_();
			    var configCache:GA_config_AS = config_;
			
			    return new  GA_CampaignTracker_AS(
			        parseNameValuePairs(                                         // id
			            searchString,
			            configCache.UCID_ + "=",
			            "&"
			        ),
			        parseNameValuePairs(                                         // source
			            searchString,
			            configCache.UCSR_ + "=",
			            "&"
			        ),
			        parseNameValuePairs(                                         // click id
			            searchString,
			            configCache.UGCLID_ + "=",
			            "&"
			        ),
			        getCampaignValue_(                                   // name
			            searchString,
			            configCache.UCCN_,
			            "(not set)"
			        ),
			        getCampaignValue_(                                   // medium
			            searchString,
			            configCache.UCMD_,
			            "(not set)"
			        ),
			        getCampaignValue_(                                   // term
			            searchString,
			            configCache.UCTR_,
			            organicCampaign && !isEmptyField(organicCampaign.term_) ?
			                nsCache.decodeWrapper_(organicCampaign.term_) :
			                undef
			        ),
			        getCampaignValue_(                                   // content
			            searchString,
			            configCache.UCCT_,
			            undef
			        )
			    );
	  	}
	  	
	  	
	  	
	/**
	   * This method returns the organic campaign information.
	   *
	   * @private
	   * @return {_gat.GA_Campaign_.Tracker_} Returns undefined if referrer is not a
	   *     matching organic campaign source. Otherwise, returns the campaign
	   *     tracker object.
	   *
	   */
	 public function getOrganicCampaignInfo_():GA_CampaignTracker_AS {
	    var hostName:String;                                // referrer host name
	    var keyword:String;                                 // matching keyword
	    var docRef:String =referrer_;              		 // referrer
	    var idx:Number;                                     // source index
	    var curOrganicSource:GA_OrganicReferrer_AS;                        // current organic source
	    var organicSources:Array =                         // organic sources
	        config_.organicSources_;
	
	    // if there is no referrer, or referrer is not a valid URL, return nothing
	    if (invalidReferrer(docRef)) {
	      return null;
	    }
	
	    // get host name from referrer
	    hostName = toLowerCase(splitProxy(docRef, "://")[1]);
	    if (stringContains(hostName, "/")) {
	      hostName = splitProxy(hostName, "/")[0];
	    }
	
	    // go through each valid organic sources
	    for (idx = 0; idx < organicSources.length; idx++) 
	    {
	      curOrganicSource = organicSources[idx];
	
	      // organic source match
	      if (stringContains(hostName, toLowerCase(curOrganicSource.engine_))) 
	      {
        	// if matching keyword name is found
        	docRef = splitProxy(docRef, "?").join("&");

	        if (stringContains(docRef, "&" + curOrganicSource.keyword_ + "=")) 
	        {
	
	          // extract keyword value from query string
	          keyword = splitProxy(
	              docRef,
	              "&" + curOrganicSource.keyword_ + "="
	          )[1];
	
	          if (stringContains(keyword, "&")) 
	          {
	            keyword = splitProxy(keyword, "&")[0];
	          }
	
	          // return campaign tracker
	          return new  GA_CampaignTracker_AS
	          (
	              undef,                                               // id
	              curOrganicSource.engine_,                            // source
	              undef,                                               // click id
	              "(organic)",                                         // name
	              "organic",                                           // medium
	              keyword,                                             // term
	              undef                                                // content
	          );
	        }
	      }
	    }
	    return null;
	  }
	  
	  /**
		   * This helper method is used to retrieve specific campaign field values when
		   * given a search string.
		   *
		   * @private
		   * @param {String} fullString The full search string to retrieve campaign field
		   *     values from.
		   * @param {String} urlKeyName Name of campaing field value in the search string.
		   * @param {String} fallbackValue Value to assign to campaign field if the
		   *     particular value cannot be retrieved from search string.
		   *
		   * @return {String} Return key-value pair for campaign field. (<key>=<value>)
		   *     Where key of the output string is the specific trackerKeyName, and the
		   *     value is either retrieved from the given search string, or it's the given
		   *     fallbackValue if retrival fails.  If both value retrieval from search
		   *     string fails, and fallbackValue is left undefined, then return undefined.
	   */
		  public function getCampaignValue_(fullString:String, urlKeyName:String, fallbackValue:String):String
		  {
		    // get raw value from search string
		    var rawValue:String = parseNameValuePairs(
		        fullString,
		        urlKeyName + "=",
		        "&"
		    );
		
		    var returnValue:String =
		        // if there is a raw value, format it
		        !isEmptyField(rawValue) ?
		            nsCache.decodeWrapper_(rawValue) :
		
		        // if there is no raw value, use provided fall back value
		        !isEmptyField(fallbackValue) ?
		            fallbackValue : "-";
		
		    return returnValue;
		  }
		  
		  
		  /**
		   * This method returns true if and only if campaignTracker is a valid organic
		   * campaign tracker (utmcmd=organic), and the keyword (utmctr) is contained in
		   * the ignore watch list (ORGANIC_IGNORE).
		   *
		   * @private
		   * @param {_gat.GA_Campaign_.Tracker_} campaignTracker Campaign tracker
		   *     reference.
		   *
		   * @return {Boolean} Return true if and only if the campaign tracker is a valid
		   *     organic campaign tracker, and the keyword is contained in the ignored
		   *     watch list.
		   */
		 public function isIgnoredKeyword_ (campaignTracker:GA_CampaignTracker_AS):Boolean
		 {
		    var organicIgnore:Array = config_.organicIgnore_;
		    var toBeIgnored:Boolean = false;
		    var keyword:String;
		    var idx:Number;
		
		    // organic campiagn, try to match ignored keywords
		    if (campaignTracker && ("organic" == campaignTracker.medium_)) 
		    {
			      // convert to lower case for case insensitive matching
			      keyword = toLowerCase(nsCache.decodeWrapper_(campaignTracker.term_));
			
			      // iterate through each ignored keywords (until a match is found)
			      for (idx = 0; idx < organicIgnore.length; idx++) 
			      {
			        toBeIgnored =
			            toBeIgnored || (toLowerCase(organicIgnore[idx]) == keyword);
			      }
		    }
		
		    return toBeIgnored;
		  }
		  
		  /**
		   * This method returns the referral campaign information.
		   *
		   * @private
		   * @return {_gat.GA_Campaign_.Tracker_} Returns nothing if there is no
		   *     referrer. Otherwise, return referrer campaign tracker.
		   */
		  public function getReferrerCampaignInfo_():GA_CampaignTracker_AS
		  {
			    var hostName:String = "";                           // referrer host name
			    var content:String = "";                            // campaign content description
			    var campaignTracker:GA_CampaignTracker_AS;                         // campaign tracker
			    var docRef:String = referrer_;                 // referrer
			
			    // if there is no referrer, or referrer is not a valid URL,  return nothing
			    if (invalidReferrer(docRef)) {
			      return null;
			    }
			
			    // get host name from referrer
			    hostName = toLowerCase(splitProxy(docRef, "://")[1]);
			    if (stringContains(hostName, "/")) 
			    {
			      content = nsCache.substringProxy_(
			          hostName,
			          nsCache.indexOfProxy_(hostName, "/")
			      );
			
			      if (stringContains(content, "?")) 
			      {
			        content = splitProxy(content, "?")[0];
			      }
			
			      hostName = splitProxy(hostName, "/")[0];
			    }
			
			    if (0 == nsCache.indexOfProxy_(hostName, "www.")) 
			    {
			        hostName = nsCache.substringProxy_(hostName, 4);
			    }
			
			    return new GA_CampaignTracker_AS(
			        undef,                                                     // id
			        hostName,                                                  // source
			        undef,                                                     // click id
			        "(referral)",                                              // name
			        "referral",                                                // medium
			        undef,                                                     // term
			        content                                                    // content
			    );
		  }
		  
		  /**
		   * Takes a location object, and returns the search string.  If there is an
		   * anchor in the URL, and allow anchor is set to true, then the anchor will be
		   * prepended to the resultant search string.
		   *
		   * @private
		   * @param {HTMLLocation} inLocation location object to extract anchor and search
		   *     string from.
		   *
		   * @return {String} Search string extracted from location object.  If there is
		   *     an anchor in the URL, and allow anchor flag is set to true, then the
		   *     anchor will be prepended to the search string.
		   */
		  public function formatCampaignSearchString_(inLocation:HTML_LocationDetails_AS):String
		  {
		    var searchString:String = "";
		
		    /**
		     * If allow to use anchor in campaign tracker, pre-pend anchor to search
		     * string.
		     */
		    if (config_.allowAnchor_) {
		      searchString = nsCache.getAnchor_(inLocation);
		
		      searchString = ("" != searchString) ? searchString + "&" : searchString;
		    }
		
		    searchString += inLocation.search; // check here for the campain information
			//searchString += "?utm_source=source+gatc021&utm_term=term+gatc021&utm_campaign=campaign+gatc021&utm_medium=medium+gatc021&utm_content=content+gatc021";
		    return searchString;
		  }
		  
		  /**
		   * Returns the direct campaign tracker string.
		   *
		   * @private
		   * @return {_gat.GA_Campaign_.Tracker_} Direct campaign tracker object.
		   */
		  public function getDirectCampaign_():GA_CampaignTracker_AS 
		  {
		    return new  GA_CampaignTracker_AS(
		        undef,                                                     // id
		        "(direct)",                                                // source
		        undef,                                                     // click id
		        "(direct)",                                                // name
		        "(none)",                                                  // medium
		        undef,                                                     // term
		        undef                                                      // content
		    )
		  }
		  
		  
		  
		  
		  /**
		   * This method returns true if and only if campaignTracker is a valid
		   * referreal campaign tracker (utmcmd=referral), and the domain (utmcsr) is
		   * contained in the ignore watch list (REFERRAL_IGNORE).
		   *
		   * @private
		   * @param {String} campaignTracker String representation of the campaign
		   *     tracker.
		   *
		   * @return {Boolean} Return true if and only if the campaign tracker is a
		   *     valid referral campaign tracker, and the domain is contained in the
		   *     ignored watch list.
		   */
		 public function isIgnoredReferral_ (campaignTracker:GA_CampaignTracker_AS):Boolean 
		 {
		    var toBeIgnored:Boolean = false;
		    var domainName:String;
		    var idx:Number;
		    var refIgnore:Array = config_.referralIgnore_;
		
		    // referral campiagn, try to match ignored domains
		    if (campaignTracker && ("referral" == campaignTracker.medium_)) {
		      domainName = toLowerCase(nsCache.encodeWrapper_(campaignTracker.source));
		
		      // iterate through each ignored keywords (until a match is found)
		      for (idx = 0; idx < refIgnore.length; idx++) {
		        /**
		         * if one of the ignored referral domain is matched, then toBeIgnored will
		         * be set to true
		         */
		        toBeIgnored = toBeIgnored ||
		                      stringContains(domainName, toLowerCase(refIgnore[idx]));
		      }
		    }
		
		    return toBeIgnored;
		  }




		/**
		   * Predicate function for determining whether the campaign tracker is a valid
		   * campaign tracker.
		   *
		   * @private
		   * @param {_gat.GA_Campaign_.Tracker_} Campaign tracker object to validate.
		   *
		   * @return {Boolean} Return true if and only if the campaign tracker object is
		   *     valid.
		   */
		  public function validTracker_(campaignTracker:GA_CampaignTracker_AS):Boolean
		  {
		    return (undef != campaignTracker) && campaignTracker.isValid_();
		  }


		  /**
		   * Retrieves campaign information.  If linker functionality is allowed, and
		   * the cookie parsed from search string is valid (hash matches), then load the
		   * __utmz value form search string, and write the value to cookie, then return
		   * "".  Otherwise, attempt to retrieve __utmz value from cookie.  Then
		   * retrieve campaign information from search string.  If that fails, try
		   * organic campaigns next.  If that fails, try referral campaigns next.  If
		   * that fails, try direct campaigns next.  If it still fails, return nothing.
		   * Finally, determine whether the campaign is duplicated.  If the campaign is
		   * not duplicated, then write campaign information to cookie, and indicate
		   * there is a new campaign for gif hit.  Else, just indicate this is a
		   * repeated click for campaign.
		   *
		   * @private
		   * @param {_gat.GA_Cookie_} inCookie GA_Cookie instance containing cookie
		   *     values parsed in from URL (linker).  This value should never be
		   *     undefined.
		   * @param {Boolean} noSession Indicating whether a session has been
		   *     initialized. If __utmb and/or __utmc cookies are not set, then session
		   *     has either timed-out or havn't been initialized yet.
		   *
		   * @return {String} Gif hit key-value pair indicating wether this is a repeated
		   *     click, or a brand new campaign for the visitor.
		   */
		  public function getCampaignInformation_(inCookie:GA_cookie_AS, noSession:Boolean):String 
		  {
			    var searchString:String = "";
			    var utmzValue:String = "-";                       // __utmz value
			    var campaignTracker:GA_CampaignTracker_AS;                       // tracker object
			    var campNoOverride:String;                        // don't override campaign?
			    var responseCount:Number = 0;                     // campaign response count
			    var duplicateCampaign:Boolean;                     // is camapaign duplicated?
			    var cookieString:String;                          // string representation of cookies
			    var domainHash:String = domainHash_;      // caching domain hash value
		
			    // check to see whether required parameter is present
			    if (!inCookie) 
			    {
			      return "";
			    }
		
				/*
			    cookieString = documentCache_[nsCache.COOKIE_] ?
			        documentCache_[nsCache.COOKIE_] :
			        "";  changed as below
			      */
			     
			    cookieString =  cookieWrapper_.getCookieOrFlashStoredDetails(); 
			    /* before it was 
			    cookieString = documentCache_.cookie ?
			        documentCache_.cookie :
			        ""; 
			        */
		
			    // format search string
			    searchString = formatCampaignSearchString_(
			        documentCache_.locationObj
			 
			    );
		
		
		
		    /**
		     * Allow linker functionality, and cookie is parsed from URL, and the cookie
		     * hash matches.
		     */
		    if (config_.allowLinker_ && inCookie.isGenuine_()) 
		    {
		       utmzValue = inCookie.getUtmzValue_();
		
		      /**
		       * Check if there is a z cookie value, and whether it have a semi-colon.
		       * (since it's taking from URL, it could be anything.  Making sure so cookie
		       * could be set correctly.)
		       *
		       * 1. Update cookie z with new value.
		       * 2. Return no campaign tracking information.
		       *
		       */
		      if (!isEmptyField(utmzValue) && !stringContains(utmzValue, ";")) {
		        inCookie.writeUtmzValue_();
		        return "";
		      }
		    }
		     /**
     * Note: if ever reaches this point, one of the following criteria would've
     * been violated:
     *
     *     1. Allows linker functionality.
     *     2. Cookie value is forwarded, and value integrity is intact.
     *     3. Valid z cookie value is taken from URL.
     */
    // retrieving campaign tracker
    utmzValue = parseNameValuePairs(
        cookieString,
        nsCache.COOKIE_UTMZ_ + domainHash,
        ";"
    );

    // retriever tracker from search string
    campaignTracker = getTrackerFromSearchString_(searchString);
    if (validTracker_(campaignTracker)) {
      // check for no override flag in search string
      campNoOverride = parseNameValuePairs(
          searchString,
          config_.UCNO_ + "=",
          "&"
      );

      // if no override is true, and there is a utmz value, then do nothing now
      if (("1" == campNoOverride) && !isEmptyField(utmzValue)) {
       return ""; 
      }
    }

    /**
     * Get organic campaign if there is no campaign tracker from search string.
     */
    if (!validTracker_(campaignTracker)) {
      campaignTracker = getOrganicCampaignInfo_();

      /**
       * If there is utmz cookie value, and organic keyword is being ignored, do
       * nothing.
       */
      if (!isEmptyField(utmzValue) &&
          isIgnoredKeyword_(campaignTracker)) {
        return "";
      }
    }

    /**
     * Get referral campaign if there is no campaign tracker from search string
     * and organic campaign, and either utmb or utmc is missing (no session).
     */
    if (!validTracker_(campaignTracker) && noSession) {
      campaignTracker = getReferrerCampaignInfo_();

      /**
       * If there is utmz cookie value, and referral domain is being ignored, do
       * nothing.
       */
      if (!isEmptyField(utmzValue) &&
         isIgnoredReferral_(campaignTracker)) {
        return "";
      }
    }

    /**
     * Get direct campaign if there is no campaign tracker from search string,
     * organic campaign, or referral campaign.
     */
    if (!validTracker_(campaignTracker)) {
      /**
       * Only get direct campaign when there is no utmz cookie value, and there is
       * no session. (utmb or utmc is missing value)
       */
      if (isEmptyField(utmzValue) && noSession) {
        campaignTracker= getDirectCampaign_();
      }
    }

    /**
     * Give up (do nothing) if still cannot get campaign tracker.
     */
    if (!validTracker_(campaignTracker)) {
      return "";
    }

    /**
     * utmz cookie have value, check whether campaign is duplicated.
     */
    if (!isEmptyField(utmzValue)) {
      var fields:Array = splitProxy(utmzValue, ".");
      var oldTracker:GA_CampaignTracker_AS = new GA_CampaignTracker_AS("","","","","","","");
      oldTracker.fromTrackerString_(fields.slice(4).join("."));

      duplicateCampaign =
          (toLowerCase(oldTracker.toTrackerString_()) ==
           toLowerCase(campaignTracker.toTrackerString_()));

      responseCount = fields[3] * 1;
    }

    /**
     * Record as new campaign if and only if campaign is not duplicated, or there
     * is no session information.
     */
    if (!duplicateCampaign || noSession) {
      var utmaValue:String = parseNameValuePairs(
          cookieString,
          nsCache.COOKIE_UTMA_ + domainHash,
          ";"
      );

      var sessionCountPos:int = utmaValue.lastIndexOf(".");

      // there should be at least 9 characters before the session count field
      var sessionCount:int =
          (sessionCountPos > 9) ?
          	Number(nsCache.substringProxy_(utmaValue, sessionCountPos + 1)) * 1 :
          0;

      responseCount++;

      // if there is no session number, increment
      sessionCount = (0 == sessionCount) ? 1 : sessionCount;

      // construct + write cookie
      inCookie.setUtmzValue_(
          [
              domainHash,
              timeStamp_,
              sessionCount,
              responseCount,
              campaignTracker.toTrackerString_()
          ].join(".")
      );
      inCookie.writeUtmzValue_();

      // indicate new campaign
      return "&" + UTMCN_ + "1";

    } else {
      // indicate repeated campaign
      return "&" + UTMCR_ + "1";

    }
  }

		  
		  
	}
}



  

  


  



