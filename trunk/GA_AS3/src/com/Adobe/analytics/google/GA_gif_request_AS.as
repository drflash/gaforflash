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

package com.Adobe.analytics.google
{
	import com.Adobe.analytics.external.HTMLDocumentDetails_AS;
	
	public class GA_gif_request_AS
	{
		include "globals/GA_cookie_globals.as"
		include "globals/GA_utils_globals.as"
		import  flash.display.Bitmap;
		import com.Adobe.analytics.external.ExternalInterfaceMethods_AS;
		
		/**
		 * @fileoverview Google Analytics Tracker Code (GATC)'s GIF request module. This
		 *     file encapsulates all the necessary components that are required to
		 *     generate a GIF request to the Google Analytics Back End (GABE).
		 *
		 */
		
		
		/**
		 * This is the max number of tracking requests to the backend allowed per
		 * session.
		 *
		 * @type {Number}
		 * @private
		 */
		private var TRACKING_LIMIT_PER_SESSION:int = 500;
		
		
		/**
		 * @class Google Analytics Tracker Code (GATC)'s GIF request module.  This
		 *     encapsulates all the necessary components that are required to generate a
		 *     GIF request to the Google Analytics Back End (GABE).
		 *
		 * @param {_gat.GA_Config} inConfig Application configurations.
		 *
		 * @private
		 * @constructor
		 *
		 * @param {String} gifPathLocal URL of __utm.gif in Urchin software. 
		 */

	  // ---------------------------------------------------------------------------
	  // PRIVATE VARIABLES
	  // ---------------------------------------------------------------------------
	 // private var localImage_:Image;
	  //private var remoteImage_:Image;
	
	  //var selfRef:;           // caching for better post-compilation file size
	  private var nsCache:GA_utils_AS;           // namespace caching 
	
	  /**
	   * Application configurations
	   *
	   * @private
	   * @type {String}
	   */
	  private var config_ :GA_config_AS;
	
	
	  /**
	   * Object used to handle tracker cookies.  Initialized to undefined.
	   *
	   * @private
	   * @type {_gat.GA_Cookie_}
	   */
	 private  var cookieHandler_:GA_cookie_AS ;
			  
		public function GA_gif_request_AS(inConfig:GA_config_AS)
		{
					
			  //selfRef = this;           // caching for better post-compilation file size
			  nsCache = GA_utils_AS.getGAUTIS();           // namespace caching -- 
			  config_ = inConfig;			
		}
		
	  // ---------------------------------------------------------------------------
	  // PRIVATE METHODS
	  // ---------------------------------------------------------------------------
	  /**
	   * This is a dummy / place-holder function called by the onload function in
	   * the gif request.  We need this because historically when the onload
	   * function doesn't redirect to another function, some browsers won't wait for
	   * the gif image to load.
	   *
	   * @private
	   */	
	   public function uVoid():void {
	    return; 
	   }
 
	  /**
	   * This is a function ref.  Replaces creating this function on the fly.  This
	   * change fixes a memory leak issue discovered by a GA user (issue 816940)
	   *
	   * @private
	   */
	  public function  uOnload():void {
	    uVoid();
	  }


  /**
   * Updates the token in the bucket.  This method first calculates the token
   * delta since the last time the bucket count is updated.  If there are no
   * change (zero delta), then it does nothing.  However, if there is a delta,
   * then the delta is added to the bucket, and a new timestamp is updated for
   * the bucket as well.  To prevent spiking in traffic after a large number of
   * token has accumulated in the bucket (after a long period of time), we have
   * added a maximum capacity to the bucket.  In other words, we will not allow
   * the bucket to accumulate token passed a certain threshold.
   *
   * @private
   * @param {Array} utmb __utmb values represented as distinct fields.
   *
   * @return New __utmb values represented as distinct fields.
   */
  public function  updateToken(utmb:Array):Array {
    var timestamp:Number = (new Date()).getTime();
    var tokenDelta:Number;

    // calculate the token count increase since last update
    tokenDelta = (timestamp - utmb[COOKIE_INDEX_UTMB_LAST_TIME]) *
                 (config_.tokenRate_ / 1000)
                 
    // only update token when there is a change
    if (tokenDelta >= 1) {
      /**
       * Only fill bucket to capacity
       */
      utmb[COOKIE_INDEX_UTMB_TOKEN] = Math.min(
          Math.floor((utmb[COOKIE_INDEX_UTMB_TOKEN] * 1) + tokenDelta),
          config_.bucketCapacity_
      );

      utmb[COOKIE_INDEX_UTMB_LAST_TIME] = timestamp;
    }

    return utmb;
  }


  // ---------------------------------------------------------------------------
  // PRIVILIGED METHODS
  // ---------------------------------------------------------------------------
  /**
   * This method is responsible for sending a GIF request to GABE.  The GIF
   * requests contains all the metrics required by the GABE.
   *
   * @private
   * @param {String} searchString Search string containing analytics data.
   * @param {String} gaAccountId Google Analytics account Id to track data for.
   * @param {HTMLDocument} inDocument object used to extract cookies, and
   *     determining whether current page is secure or not.
   * @param {String} domainHash Domain name hash used to extract the correct
   *     cookie with.
   * @param {Boolean} opt_force Optional parameter.  If this parameter is set to
   *     true, then the gif request is send out regardless.  False by default.
   * @param {Boolean} opt_rateLimit Optional parameter.  If this parameter is
   *     set to true, then the gif request will be rate limited. False by
   *     default. 
   */
  public function sendGifRequest_(searchString:String,
                                     gaAccountId:String,
                                     inDocument:HTMLDocumentDetails_AS,
                                     domainHash:String,
                                     opt_force:Boolean = false,
                                     opt_rateLimit:Boolean = false):void
  {

    // for GIF request
   // var newImage:Image;

    // utmb value
    var utmb:Array;

    // service mode
    var serviceMode:Number = config_.serviceMode_;

    // location alias
    var docLoc:Object = inDocument.locationObj;
	
    // if cookie handler hasn't been initialized yet
    if (!cookieHandler_) {
      cookieHandler_ = GA_utils_AS.getCookieHandler(inDocument, config_); 
    }

    // get tracker cookies
    cookieHandler_.parseCookieValues_(domainHash);

    /**
     * Since _initData() should've been called by now, and session variables
     * should have been initialized.  __utmb should have a value at this point.
     */
    utmb = nsCache.splitProxy_(cookieHandler_.getUtmbValue_(), "."); 

    /**
     * Only send request if
     * 1. We havn't reached the limit yet.
     * 2. User forced gif hit
     */
    if ((utmb[COOKIE_INDEX_UTMB_TRACK_COUNT] < TRACKING_LIMIT_PER_SESSION) ||
        opt_force) {

      // update token bucket
      if (opt_rateLimit) {
        utmb = updateToken(utmb);
      }

      // if there are token left over in the bucket, send request
      if (opt_force || !opt_rateLimit || (utmb[COOKIE_INDEX_UTMB_TOKEN] >= 1)) {
        /**
         * Only consume a token for non-forced and rate limited tracking calls.
         */
        if (!opt_force && opt_rateLimit) {
          utmb[COOKIE_INDEX_UTMB_TOKEN] =
              (utmb[COOKIE_INDEX_UTMB_TOKEN] * 1) - 1;
        }

        // increment request count
        utmb[COOKIE_INDEX_UTMB_TRACK_COUNT] =
            (utmb[COOKIE_INDEX_UTMB_TRACK_COUNT] * 1) + 1;

        // prepend version number, cache buster and host name to search string
        searchString =
            "?utmwv=" + VERSION_NUMBER +
            "&utmn=" + nsCache.get32bitRand_() +
            (nsCache.isEmptyField_(docLoc.hostname) ?
                "" :
                "&utmhn=" + nsCache.encodeWrapper_(docLoc.hostname)) +
            searchString;

        /**
         * If service mode is send to local (or both), then we'll sent metrics
         * via a local GIF request.
         */
        if ((SERVICEMODE_LOCAL == serviceMode) ||
            (SERVICEMODE_BOTH == serviceMode)) {

          // create new image if needed
    
			var sourceStrig:String = config_.gifPathLocal_ + searchString;
			ExternalInterfaceMethods_AS.createImageinHTML(sourceStrig);
          /**
           * We need this because on some browser, without assingning an onload
           * function, the image will not load.
           */
           //ExternalInterfaceMethods_AS.createImageinHTML
          //localImage_.onload = uOnload; chagned as follows
          //localImage_.autoLoad = true;
        }

        /**
         * If service mode is set to remote (or both), then we'll sent metrics
         * via a remote GIF request.
         */
        if ((SERVICEMODE_REMOTE == serviceMode) ||
            (SERVICEMODE_BOTH == serviceMode)) {

          // create new image when needed
         // remoteImage_ = new Image(1, 1); 
		  

          /**
           * get remote address (depending on protocol), then append rest of
           * metrics / data
           */
         /* remoteImage_.source =  // src changed to source
              (
                  ("https:" == docLoc.protocol) ?
                  nsCache.GIF_PATH_REMOTE_SECURE_ :
                  nsCache.GIF_PATH_REMOTE_
              ) +
              searchString +
              "&utmac=" + gaAccountId +
              "&utmcc=" + getAllCookiesToSearchString_(
                  inDocument,
                  domainHash
              );
              
              */
              

			var sourceString1:String =  (
                  ("https:" == docLoc.protocol) ?
                  nsCache.GIF_PATH_REMOTE_SECURE_ :
                  nsCache.GIF_PATH_REMOTE_
              ) +
              searchString +
              "&utmac=" + gaAccountId +
              "&utmcc=" + getAllCookiesToSearchString_(
                  inDocument,
                  domainHash
              );
			ExternalInterfaceMethods_AS.createImageinHTML(sourceString1);
          /**
           * We need this because on some browser, without assinging an onload
           * function, the image will not load.
           */
          
          //remoteImage_.onload = uOnload; chagned as follows
          //remoteImage_.autoLoad = true;
        }
      }
    }
    cookieHandler_.setUtmbValue_(utmb.join("."));
    cookieHandler_.writeUtmbValue_();
  }



/**
   * Retreievs all the GATC cookies, and convert them into search string for the
   * GABE.
   *
   * @private
   * @param {HTMLDocument} inDocument Document object needed for extraction
   *     of GATC cookies.
   * @param {String} domainHash Domain hash to search cookies with.
   *
   * @return {String} All cookies formatted for GABE GIF request parameters.
   */
  private function getAllCookiesToSearchString_ (inDocument:HTMLDocumentDetails_AS, domainHash:String):String 
  {
    //  formatted (will not contain [<key>=-])
    var searchParams:Array = [];

    var keyList :Array= [
        nsCache.COOKIE_UTMA_,
        nsCache.COOKIE_UTMZ_,
        nsCache.COOKIE_UTMV_,
        nsCache.COOKIE_UTMX_
    ];

    // list index
    var idx:Number;

    // all cookies in string format.
 	var cookieString:String =cookieHandler_.getCookieOrFlashStoredDetails();
	// it was before   var cookieString:String = inDocument[nsCache.COOKIE_];

    // raw parameter;
    var rawParam:String;

    for (idx = 0; idx < keyList.length; idx++) {
      rawParam = nsCache.parseNameValuePairs_(
          cookieString,
          keyList[idx] + domainHash,
          ";"
      )

      if (!nsCache.isEmptyField_(rawParam)) {
        nsCache.arrayPush_(
            searchParams,
            keyList[idx] + rawParam + ";"
        );
      }
    }

    // delimit cookies by "+", then URL code the entire search string
    return nsCache.encodeWrapper_(searchParams.join("+"));
  }
  
  
  /**
   * Get last local gif request.  Used in unit testing.
   *
   * @private
   * @return {Image} Last local gif request send.
   */
   /*
  private function getLastLocalGifRequest_ ():Image
  {
    return localImage_;
  }
  */
  
  /**
   * Get last remote gif request.  Used in unit testing.
   *
   * @private
   * @return {Image} Last remote gif request send.
   */
   /*
   private function getLastRemoteGifRequest_ ():Image 
   {
    return remoteImage_;
   }
   */
   
  }
}