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

// ActionScript file
/**
 * Enum for local service model.
 *
 * @type {Number}
 * @private
 */
public const SERVICEMODE_LOCAL:Number = 0;


/**
 * Enum for remote service model.
 *
 * @type {Number}
 * @private
 */
public const SERVICEMODE_REMOTE :Number= 1;


/**
 * Enum for both local and remote service model.
 *
 * @type {Number}
 * @private
 */
public const SERVICEMODE_BOTH :Number= 2;


/**
 * GA Tracker version number.
 *
 * @type {String}
 */
public const VERSION_NUMBER:String = "f4";


/**
 * X10 project id for Event tracker.
 *
 * @type {Number}
 */
public const EVENT_TRACKER_PROJECT_ID:Number = 5;


/**
 * Event tracker object name key index.
 *
 * @type {Number}
 */
public const EVENT_TRACKER_OBJECT_NAME_KEY_NUM:Number = 1;


/**
 * Event tracker event type key index.
 *
 * @type {Number}
 */
public const EVENT_TRACKER_TYPE_KEY_NUM:Number = 2;


/**
 * Event tracker description key index.
 *
 * @type {Number}
 */
public const EVENT_TRACKER_LABEL_KEY_NUM:Number = 3;


/**
 * Event tracker aggregate value key index.
 *
 * @type {Number}
 */
public const EVENT_TRACKER_VALUE_VALUE_NUM:Number= 1;




			  /**
		   * Length property for strings and arrays.  Used to shrink compiled javascript
		   * file size.  Using this approach instead of the "--alias_externals=true"
		   * option, which creates aliases for properties in the global namespace. This
		   * might result in namespace collisions.
		   *
		   * @type {String}
		   */
		 	public const LENGTH_:String = "length";


		  /**
		   * Cookie property from document objects.  Used to shrink compiled javascript
		   * file size.  Using this approach instead of the "--alias_externals=true"
		   * option, which creates aliases for properties in the global namespace. This
		   * might result in namespace collisions.
		   *
		   * @type {String}
		   */
		  public const COOKIE_:String =  "cookie";


		  /**
		   * Undefined literal.
		   *
		   */
		  public const undef_:* = undefined;

  
		  /**
		   * @class Containing information about an organic referrer.  Information
		   *     including source, and keyword.
		   *
		   * @param {String} engine Organic source engine
		   * @param {String} keyword Organic keyword name (query term for search)
		   *
		   * @constructor
		   * @private
		   */
  		


		  /**
		   * Key name for visitor / session tracker.  Format of this value is:
		   *     <domain_hash>.<session_id>.<fvisit>.<lvisit>.<curvisit>.<session_count>
		   *
		   * @type {String}
		   */
		  public const COOKIE_UTMA_:String  = "__utma=";


		  /**
		   * Key name for session timeout value.  Format of this value is:
		   *     <domain_hash>
		   *
		   * @type {String}
		   */
		  public const COOKIE_UTMB_:String  = "__utmb=";


		  /**
		   * Key name for transient session value.  Format of this value is:
		   *     <domain_hash>
		   *
		   * @type {String}
		   */
		  public const COOKIE_UTMC_:String  = "__utmc=";


		  /**
		   * Key name for cookie value digest in query string.
		   *
		   * @type {String}
		   */
		  public const COOKIE_UTMK_:String  = "__utmk=";


		  /**
		   * key name for User-defined value.
		   *
		   * @type {String}
		   */
		  public const COOKIE_UTMV_:String  = "__utmv=";


		  /**
		   * Key name for ALPO value in query string.
		   *
		   * @type {String}
		   */
		  public const COOKIE_UTMX_:String  = "__utmx=";


		  /**
		   * Key name for Google Analytic Site Overlay feature.
		   */
		  public const COOKIE_GASO_:String  = "GASO=";


		  /**
		   * Key name for campaign tracker.  Format of this value is:
		   *     <domain_hash>.<creation_time>.<session_count>.<responses>.<tracker> where
		   *     format for tracker have the following fields (seperated by "|"):
		   *         <table>
		   *           <tr><td>utmcsr - campaign source</td></tr>
		   *           <tr><td>utmccn - campaign name</td></tr>
		   *           <tr><td>utmcmd - campaign medium</td></tr>
		   *           <tr><td>utmctr - keywords</td></tr>
		   *           <tr><td>utmcct - ad conent description</td></tr>
		   *           <tr><td>utmcid - lookup table id</td></tr>
		   *           <tr><td>utmgclid - google ad click id</td></tr>
		   *         </table>
		   *
		   * @type {String}
		   */
		  public const COOKIE_UTMZ_:String  = "__utmz=";


		  /**
		   * Remote service mode unsecure GIF url.
		   *
		   * @type {String}
		   */
		  public const GIF_PATH_REMOTE_:String  = "http://www.google-analytics.com/__utm.gif";


		  /**
		   * Remote service mode, secure GIF url.
		   *
		   * @type {String}
		   */
		  public const GIF_PATH_REMOTE_SECURE_:String  = "https://ssl.google-analytics.com/__utm.gif";

  
		  /**
		   * Key name for campaign id. (in __utmz value)
		   *
		   * @type {String}
		   */
		 public const  GA_CAMP_UTMCID_:String  = "utmcid=";


		  /**
		   * Key name for campaign source. (in __utmz value)
		   *
		   * @type {String}
		   */
		  public const GA_CAMP_UTMCSR_:String  = "utmcsr=";


		  /**
		   * Key name for Ad click Id.  (in __utmz value)
		   */
		  public const GA_CAMP_UTMGCLID_:String  = "utmgclid=";


		  /**
		   * Key name for campaign name. (in __utmz value)
		   *
		   * @type {String}
		   */
		  public const GA_CAMP_UTMCCN_:String  = "utmccn=";


		  /**
		   * Key name for campaign medium. (in __utmz value)
		   *
		   * @type {String}
		   */
		  public const GA_CAMP_UTMCMD_:String  = "utmcmd=";


		  /**
		   * Key name for campaign keywords. (in __utmz value)
		   *
		   * @type {String}
		   */
		  public const GA_CAMP_UTMCTR_:String  = "utmctr=";


		  /**
		   * Key name for campaign content. (in __utmz value)
		   */
		  public const GA_CAMP_UTMCCT_:String  = "utmcct=";
