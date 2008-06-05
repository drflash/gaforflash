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

// -----------------------------------------------------------------------------
	// CONSTANTS (substituted by compiler later) 
	// -----------------------------------------------------------------------------
	/**
	 * Field index for domain hash in vistior tracking cookie (__utma) value.
	 * (Constant equals to 0)
	 *
	 * @type {Number}
	 * @private
	 */
	public const COOKIE_INDEX_UTMA_DOMAINHASH:Number = 0;
	
	
	/**
	 * Field index for session id in vistior tracking cookie (__utma) value.
	 * (Constant equals to 1)
	 *
	 * @type {Number}
	 * @private
	 */
	public const COOKIE_INDEX_UTMA_SESSIONID:Number = 1;
	
	
	/**
	 * Field index for first visit timestamp in vistior tracking cookie (__utma)
	 * value.  (Constant equals to 2)
	 *
	 * @type {Number}
	 * @private
	 */
	public const COOKIE_INDEX_UTMA_FIRSTTIME:Number = 2;
	
	
	/**
	 * Field index for last visit timestamp in vistior tracking cookie (__utma)
	 * value.  (Constant equals to 3)
	 *
	 * @type {Number}
	 * @private
	 */
	public const COOKIE_INDEX_UTMA_LASTTIME:Number = 3;
	
	
	/**
	 * Field index for current visit timestamp in vistior tracking cookie (__utma)
	 * value.  (Constant equals to
	 * 4)
	 *
	 * @type {Number}
	 * @private
	 */
	public const COOKIE_INDEX_UTMA_CURTIME:Number = 4;
	
	
	/**
	 * Field index for session count in vistior tracking cookie (__utma) value.
	 * (Constant equals to 5)
	 *
	 * @type {Number}
	 * @private
	 */
	public const COOKIE_INDEX_UTMA_SESSIONCOUNT:Number = 5;
	
	
	/**
	 * Field index for domain hash in session timeout cookie (__utmb) value.
	 * (Constant equals to 0)
	 *
	 * @type {Number}
	 * @private
	 */
	public const COOKIE_INDEX_UTMB_DOMAINHASH:Number = 0;
	
	
	/**
	 * Field index for tracking count in session timeout cookie (__utmb) value.
	 * (Constant equals to 1)
	 *
	 * @type {Number}
	 * @private
	 */
	public const COOKIE_INDEX_UTMB_TRACK_COUNT:Number = 1;
	
	
	/**
	 * Number of token in bucket.
	 *
	 * @type {Number}
	 * @private
	 */
	public const COOKIE_INDEX_UTMB_TOKEN:Number = 2;
	
	
	/**
	 * Time stamp for last time the token bucket was updated.
	 *
	 * @type {Number}
	 * @private
	 */
	public const COOKIE_INDEX_UTMB_LAST_TIME:Number = 3;
	
	
	/**
	 * Field index for domain hash in session cookie (__utmc) value.  (Constant
	 * equals to 0)
	 *
	 * @type {Number}
	 * @private
	 */
	public const COOKIE_INDEX_UTMC_DOMAINHASH :Number= 0;
	
	
	/**
	 * Field index for domain hash in campaign tracking cookie (__utmz) value.
	 * (Constant equals to 0)
	 *
	 * @type {Number}
	 * @private
	 */
	public const COOKIE_INDEX_UTMZ_DOMAINHASH :Number= 0;
	
	
	/**
	 * Field index for campaign creation timestamp in campaign tracking cookie
	 * (__utmz) value.  (Constant equals to 1)
	 *
	 * @type {Number}
	 * @private
	 */
	public const COOKIE_INDEX_UTMZ_CAMPAIGNCREATION:Number = 1;
	
	
	/**
	 * Field index for campaign session count in campaign tracking cookie (__utmz)
	 * value.  (Constant equals to 2)
	 *
	 * @type {Number}
	 * @private
	 */
	public const COOKIE_INDEX_UTMZ_CAMPAIGNCSESSIONS:Number = 2;
	
	
	/**
	 * Field index for response count in campaign tracking cookie (__utmz) value.
	 * (Constant equals to 3)
	 *
	 * @type {Number}
	 * @private
	 */
	public const COOKIE_INDEX_UTMZ_RESPONSECOUNT:Number = 3;
	
	
	/**
	 * Field index for campaign tracker in campaign tracking cookie (__utmz) value.
	 * (Constant equals to 4)
	 *
	 * @type {Number}
	 * @private
	 */
	public const COOKIE_INDEX_UTMZ_CAMPAIGNTRACKING:Number = 4;
	
	
	/**
	 * Field index for domain hash in user deined cookie (__utmv) value.  (Constant
	 * equals to 0)
	 *
	 * @type {Number}
	 * @private
	 */
	public const COOKIE_INDEX_UTMV_DOMAINHASH:Number = 0;
	
	
	/**
	 * Field index for user defined fields in user deined cookie (__utmv) value.
	 * (Constant equals to 1)
	 *
	 * @type {Number}
	 * @private
	 */
	public const COOKIE_INDEX_UTMV_VALUE:Number = 1;
