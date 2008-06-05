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


	public class GA_config_AS
	{
		
		/**
		 *  @class Google Analytics Tracker Code (GATC)'s default settings component.
		 *     This class encompasses all out of the box configuration compoents
	 	 */	
		
		
		include "globals/GA_utils_globals.as"
		  
		public function GA_config_AS()
		{}
		
	 /**
	   * Helper function for constructing a new organic referrer instance.
	   *
	   * @param {String} engine Organic source engine
	   * @param {String} keyword Organic keyword name (query term for search)
	   *
	   */
	  public function newOrganicReferrer(engine:String, keyword:String):GA_OrganicReferrer_AS
	  {
	    return new GA_OrganicReferrer_AS(engine, keyword); 
	  }
	
	  /**
	   * Key name for campaign name. (in query string)
	   *
	   * @type {String}
	   */
	  public var UCCN_ :String= "utm_campaign";
	
	  /**
	   * Key name for campaign content. (in query string)
	   *
	   * @type {String}
	   */
	  public  var UCCT_:String = "utm_content";
	
	  /**
	   * Key name for campaign id. (in query string)
	   *
	   * @type {String}
	   */
	  public  var UCID_:String = "utm_id";
	
	  /**
	   * Key name for campaign medium. (in query string)
	   *
	   * @type {String}
	   */
	  public  var UCMD_:String = "utm_medium";
	
	  /**
	   * Key name for campaign no override flag. (in query string)
	   *
	   * @type {String}
	   */
	  public  var UCNO_:String = "utm_nooverride";
	
	  /**
	   * Key name for campaign source. (in query string)
	   *
	   * @type {String}
	   */
	  public  var UCSR_:String = "utm_source";
	
	  /**
	   * Key name for campaign term / keywords. (in query string)
	   *
	   * @type {String}
	   */
	  public  var UCTR_:String = "utm_term";
	
	  /**
	   * Key name for google ads click id. (in query string)
	   *
	   * @type {String}
	   */
	  public  var UGCLID_:String = "gclid";
	
	  /**
	   * Enable use of anchors for campaigns. (1=on | 0=off)
	   *
	   * @type {Number}
	   */
	  public  var allowAnchor_:Number = 0;
	
	  /**
	   * Enable linker functionality. (1=on|0=off)
	   *
	   * @type {Number}
	   */
	  public  var allowLinker_ :Number= 0;
	
	  /**
	   * Default cookie expiration time in seconds. (6 months)
	   *
	   * @type {String}
	   */
	  public  var conversionTimeout_:String = "15768000";
	
	  /**
	   * Default inactive session timeout in seconds.
	   *
	   * @type {String}
	   */
	  public  var sessionTimeout_:String = "1800";
	
	  /**
	   * Automatic / Organic keyword to ignore.
	   *
	   * @type {Array}
	   */
	  public  var organicIgnore_:Array = [];
	
	  /**
	   * Referral domains to ignore.
	   *
	   * @type {Array}
	   */
	  public  var referralIgnore_:Array = [];
	
	  /**
	   * Automatic / Organic source.
	   *
	   * @type {Array}
	   */
	  public  var organicSources_:Array = [
	      newOrganicReferrer("google",         "q"         ),
	      newOrganicReferrer("yahoo",          "p"         ),
	      newOrganicReferrer("msn",            "q"         ),
	      newOrganicReferrer("aol",            "query"     ),
	      newOrganicReferrer("aol",            "encquery"  ),
	      newOrganicReferrer("lycos",          "query"     ),
	      newOrganicReferrer("ask",            "q"         ),
	      newOrganicReferrer("altavista",      "q"         ),
	      newOrganicReferrer("netscape",       "query"     ),
	      newOrganicReferrer("cnn",            "query"     ),
	      newOrganicReferrer("looksmart",      "qt"        ),
	      newOrganicReferrer("about",          "terms"     ),
	      newOrganicReferrer("mamma",          "query"     ),
	      newOrganicReferrer("alltheweb",      "q"         ),
	      newOrganicReferrer("gigablast",      "q"         ),
	      newOrganicReferrer("voila",          "rdata"     ),
	      newOrganicReferrer("virgilio",       "qs"        ),
	      newOrganicReferrer("live",           "q"         ),
	      newOrganicReferrer("baidu",          "wd"        ),
	      newOrganicReferrer("alice",          "qs"        ),
	      newOrganicReferrer("yandex",         "text"      ),
	      newOrganicReferrer("najdi",          "q"         ),
	      newOrganicReferrer("aol",            "q"         ),
	      newOrganicReferrer("club-internet",  "q"         ),
	      newOrganicReferrer("mama",           "query"     ),
	      newOrganicReferrer("seznam",         "q"         ),
	      newOrganicReferrer("search",         "q"         ),
	      newOrganicReferrer("wp",             "szukaj"    ),
	      newOrganicReferrer("onet",           "qt"        ),
	      newOrganicReferrer("netsprint",      "q"         ),
	      newOrganicReferrer("google.interia", "q"         ),
	      newOrganicReferrer("szukacz",        "q"         ),
	      newOrganicReferrer("yam",            "k"         ),
	      newOrganicReferrer("pchome",         "q"         ),
	      newOrganicReferrer("kvasir",         "searchExpr"),
	      newOrganicReferrer("sesam",          "q"         ),
	      newOrganicReferrer("ozu",            "q"         ),
	      newOrganicReferrer("terra",          "query"     ),
	      newOrganicReferrer("nostrum",        "query"     ),
	      newOrganicReferrer("mynet",          "q"         ),
	      newOrganicReferrer("ekolay",         "q"         )
	  ];
	
	  /**
	   * Substring of host names to ignore when auto decorating href anchor elements
	   * for outbound link tracking.
	   *
	   * @type {Array}
	   */
	  public  var ignoredOutboundHosts_ :Array= [];
	
	  /**
	   * Default cookie path to set in document header.
	   *
	   * @type {String}
	   */
	  public  var cookiePath_:String = "/";
	
	  /**
	   * Sampling percentage of visitors to track. (1-100)
	   *
	   * @type {Number}
	   */
	  public  var sampleRate_:Number = 100;
	
	  /**
	   * Local service mode GIF url.
	   *
	   * @type {String}
	   */
	  public  var gifPathLocal_:String = "/__utm.gif";
	
	  /**
	   * Set document title detection option. (1 = on | 0 = off)
	   *
	   * @type {Number}
	   */
	  public  var detectTitle_ :Number= 1;
	
	  /**
	   * Flash version detection option. (1=on | 0=off)
	   *
	   * @type {Number}
	   */
	  public  var flashDetection_ :Number= 1;
	
	  /**
	   * Delimiter for e-commerce transaction fields.
	   *
	   * @type {String}
	   */
	  public  var transactionFieldDelim_:String = "|";
	
	  /**
	   * Detect client browser information flag. (1 = on | 0 = off)
	   *
	   * @type {Number}
	   */
	  public  var clientInfo_ :Number= 1;
	
	  /**
	   * Track campaign information flag. (1 = on | 0 = off)
	   *
	   * @type {Number}
	   */
	  public  var campaignTracking_:Number = 1;
	
	  /**
	   * Unique domain hash for cookies.
	   *
	   * @type {Number}
	   */
	  public  var allowDomainHash_ :Number= 1;
	
	  /**
	   * Domain name for cookies. (auto | none | domain)  If this variable is set to
	   * "auto", then we will try to resolve the domain name based on the
	   * HTMLDocument object.
	   *
	   * @type {String}
	   */
	  public  var domainName_:String = "auto";
	
	  /**
	   * Actual service model. (SERVICEMODE_LOCAL | SERVICEMODE_REMOTE |
	   * SERVICEMODE_BOTH)
	   *
	   * @type {Number}
	   */
	  public  var serviceMode_:Number = SERVICEMODE_REMOTE; 
	
	  /**
	   * Upper limit for number of href anchor tags to examine.  If this number is
	   * set to -1, then we will examine all the href anchor tags.  In other words,
	   * a -1 value indicates that there is no upper limit.
	   *
	   * @type {Number}
	   */
	  public  var maxOutboundLinkExamined_:Number = 1000;
	
	
	  /**
	   * The number of tokens available at the start of the session.
	   *
	   * @type {Number}
	   */
	  public  var tokenCliff_:Number = 10;
	
	
	  /**
	   * Capacity of the token bucket.
	   *
	   * @type {Number}
	   */
	  public  var bucketCapacity_:Number = 10;
	
	
	  /**
	   * The rate of token being released into the token bucket.  Unit for this
	   * parameter is number of token released per second.  This is set to 0.20
	   * right now, which translates to 1 token released every 5 seconds.
	   *
	   * @private
	   * @type {Number}
	   */
	  public  var tokenRate_:Number = 0.20;

	}
}