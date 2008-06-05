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
	import com.google.analytics.external.HTMLDocumentDetails_AS;
	import com.google.analytics.external.LocalObjectHandler;
	
	
	
	public class GA_cookie_AS
	{
	
		include "globals/GA_cookie_globals.as";
		
		/**
		 * @fileoverview Google Analytics Tracker Code (GATC)'s cookie module.  This
		 *     file encapsulates all the necessary components that defines the
		 *     behaviors of GATC cookies.
		 *
		 */
		
		
		
		
		// ---------------------------------------------------------------------------
	  // PRIVATE VARIABLES 
	  // ---------------------------------------------------------------------------
	  private var utmaFields_:Array;              // Visitor / session tracking fields
	  private var utmbFields_:Array;              // session timeout fields
	  private var utmcFields_:Array;              // session tracking
	  private var utmzFields_:Array;              // campaign tracking
	  private var utmxFields_:String;              // ALPO value
	  private var utmvFields_:Array;              // user defined value
	  private var gasoValue_:String;               // Site overlay
	
	  private var nsCache:GA_utils_AS = GA_utils_AS.getGAUTIS();           // namespace caching
	  private var isEmpty:Function =                 // caching isEmpty function 
	      nsCache.isEmptyField_;
	  private var LENGTH:String = nsCache.LENGTH_; // caching length property name
	  
	  /**
	   * This field is only being set in GA_Cookie.prototype.parseQString_.
	   * Otherwise this field is left undefined.  Which means, if this field is
	   * defined, then the fields are parsed in from the URL.  This distinction is
	   * important because we need to know whether or not the field values are
	   * corrupt.  If this value is not undefined, and hash doesn't match, then the
	   * values has been tempered with (either in the URL side, or the object has
	   * been manipulated since creation.
	   */
	  private var utmkFields_:String;              // hash
	  
	  /**
	   * Column index for key name in value matrix.
	   *
	   * @type {Number}
	   */
	  private var VALUE_MATRIX_KEY_:Number = 0;
	
	
	  /**
	   * Column index for getter references in value matrix.
	   *
	   * @type {Number}
	   */
	  private var VALUE_MATRIX_GETTER_:Number= 1;
	
	
	  /**
	   * Column index for setter references in value matrix.
	   *
	   * @type {Number}
	   */
	  private var VALUE_MATRIX_SETTER_:Number = 2;
	
	
	  /**
	   * Column index for writter references in value matrix.
	   *
	   * @type {Number}
	   */
	  private var VALUE_MATRIX_WRITTER_:Number = 3;
	
	  
	  /**
	   * Tracker configuration class.
	   *
	   * @type {_gat.GA_Config_}
	   */
	  private var config:GA_config_AS;
	
	
	  // ---------------------------------------------------------------------------
	  // PRIVILIGED VARIABLES 
	  // ---------------------------------------------------------------------------
	
	  // ~ Injected dependencies ---------------------------------------------------
	  /**
	   * Set the document cache (used for dependency injection).
	   *
	   * @type {HTMLDocument}
	   * @ignore
	   */
	  private var documentCache_ :HTMLDocumentDetails_AS;
	
	// var selfRef = this;

	/**
	 * @class Google Analytics Tracker Code (GATC)'s cookie module.  This
	 *     encompasses all the necessary data, and operations needed by the GATC
	 *     cookies.
	 *
	 * @param {HTMLDocument} documentCache HTML document object
	 * @param {_gat.GA_Config_} inConfig Tracker configuations.
	 *
	 * @private
	 * @constructor
	 */
		public function GA_cookie_AS(documentCache:HTMLDocumentDetails_AS, inConfig:GA_config_AS)
		{
			//selfRef = this;           // caching for better post-compilation file size
	  		config = inConfig;
			documentCache_ = documentCache;
		}
		
	  // ---------------------------------------------------------------------------
	  // PRIVATE METHODS
	  // ---------------------------------------------------------------------------
	  /**
	   * Helper function for returning fields in string representation. (delimited
	   * by ".")
	   *
	   * @private
	   * @param {Array} fields Array of field values to retrieve.
	   *
	   * @return {String} String representation of retrieved fields, if and only if
	   *     the given fields is an array.  Else return "-".
	   */
	  public function getFieldsAsString(fields:Array) :String
	  {
	    var fieldStringRep:String = /* (fields instanceof Array) ?  changed as follows */
	    					(fields as Array) ?
	                         fields.join(".") :
	                         "";
	    
	    return isEmpty(fieldStringRep) ? "-" : fieldStringRep;
	  }


	  /**
	   * This method takes a "." delimited string, and turns it into an array of
	   * fields.  Then depending on the numericFields flag, it might filter out
	   * non-numeric fields as "-".
	   *
	   * @private
	   * @param {String} fieldString "." delimieted string representation of fields
	   * @param {Boolean} opt_numericFields (Optional) Flag indicating whether we
	   *     should filter out non-numeric field values.  If this parameter is
	   *     omitted, the flag is assumed to be false.
	   *
	   * @return {Array} List of field values parsed from fieldString.  All fields
	   *     with non-numeric value will be ignored if numericFields flag is set to
	   *     true.
	   */
	  public function string2Fields_(fieldString:String, opt_numericFields:Boolean = false):Array 
	  {
	    var tmpField:Array = [];                         // array for list of field values
	    var fieldIdx:int;                              // field index
	    
	    // if there is a string for field, format into array
	    if (!isEmpty(fieldString)) {
	      tmpField = nsCache.splitProxy_(fieldString, ".");
	
	      if (opt_numericFields) {
	        for (fieldIdx = 0; fieldIdx < tmpField[LENGTH]; fieldIdx++) {
	          // exclude all non-numeric field values
	          if (!nsCache.isNumber_(tmpField[fieldIdx])) {
	            tmpField[fieldIdx] = "-";
	          }
	        }
	      }
	    }
	    
	    return tmpField;
	  }
	
	
	  /**
	   * Generate an expiration string for 2 years
	   *
	   * @private
	   * @return {String} Expiration string for 2 years
	   */
	  public function get2YearsExpirationString():String {
	    /**
	     * 63072000000 is the number of milliseconds in 2 year.
	     *
	     *           2 (year)
	     *         365 (days / year)
	     *          24 (hours / day)
	     *          60 (min / hour)
	     *          60 (sec / min)
	     * x      1000 (millisec / sec)
	     * -----------
	     * 63072000000 (millisec)
	     *
	     */
	    return getExpirationString_(63072000000);
	  }
	
	  public function get2YearsExpirationFlashDate():Date
	  {
	  	return getFlashExpirationDate_(63072000000);
	  }
	
	  /**
	   * Generate an expiration string that is x second into the future from today,
	   * where x is specified by input.
	   *
	   * @private
	   * @param {Number} expirationInMilli Milliseconds into the future where the
	   *     expiration string represents.
	   *
	   * @return {String} Expiration string that is [expirationInMilli] second into
	   *     the future from today.
	   */
	    public function getFlashExpirationDate_(expirationInMilli:Number):Date 
	    {
		    var todayDate:Date = new Date();
		    var expirationDate:Date = new Date(todayDate.getTime() + expirationInMilli);
		    return expirationDate;
		}
	
	  public function getExpirationString_(expirationInMilli:Number):String {
	    var todayDate:Date = new Date();
	    var expirationDate:Date = new Date(todayDate.getTime() + expirationInMilli);
	
	   // return "expires=" + expirationDate.toGMTString() + "; "; // changed as follows
	    return "expires=" + convertActionScriptDateToGMTDate(expirationDate) + "; ";
	  }
	
		private function getDayString(dayNumber:Number):String
		{
			switch(dayNumber)
			{
				
				case 0:
					return "Sun";
					break;
				case 1:
					return "Mon";
					break;	
				case 2:
					return "Tue";
					break;
				case 3:
					return "Wed";
					break;
				case 4:
					return "Thu";
					break;
				case 5:
					return "Fri";
					break;
				case 6:
					return "Sat";
					break;
				default:
					return "";
					break;
					
			}
		}
		private function getMonthString(monthNumber:Number):String
		{
			switch(monthNumber)
			{
				
				case 0:
					return "Jan";
					break;
				case 1:
					return "Feb";
					break;	
				case 2:
					return "Mar";
					break;
				case 3:
					return "Apr";
					break;
				case 4:
					return "May";
					break;
				case 5:
					return "Jun";
					break;
				case 6:
					return "Jul";
					break;
				case 7:
					return "Aug";
					break;
				case 8:
					return "Sep";
					break;
				case 9:
					return "Oct";
					break;
				case 10:
					return "Nov";
					break;
				case 11:
					return "Dec";
					break;
				default:
					return "";
					break;
					
			}
		}
		private function convertActionScriptDateToGMTDate(expirationDate:Date):String
		{
			// requied format is
			// Wed, 20 Jul 1983 19:45:00 UTC 

			 /*
			//to string returns 
			//Day Mon Date HH:MM:SS TZD YYYY
     		//For example:
*/
		    // (0)Wed (1)Apr (2)12 (3)15:30:17 (4)GMT-0700 (5)2006
		    var timeInfoArray:Array = expirationDate.toString().split(" ");
		    var oldTime:String = timeInfoArray[0] + ", "+
		    							timeInfoArray[2] + " "+
		    							timeInfoArray[1] + " "+
		    							timeInfoArray[5] + " "+
		    							timeInfoArray[3] + " UTC";
		    							
		   // we need to capture all the UTC info
		   var day:String = getDayString(expirationDate.dayUTC);
		   var month:String = getMonthString(expirationDate.monthUTC);
  		   var newTimeString:String = day + ", "+
    							expirationDate.dateUTC + " "+
    							month + " "+
    							expirationDate.fullYearUTC + " "+
    							expirationDate.hoursUTC+":" + expirationDate.minutesUTC+":"+ expirationDate.secondsUTC+" UTC";					
		    							
		    return newTimeString;
		    							

		}
	
	  /**
	   * Abstracted out cookie writing logic for GATC.  The only differences between
	   * GATC cookie writes are the actuall cookie value, and the expiration stamp.
	   *
	   * @private
	   * @param {String} mainValue Main cookie value, in the form of "[key]=[value]"
	   * @param {String} expString Expiration string.  In the form of
	   *     "expires=[exp string];"
	   */
	  public function writeCookie_(mainValue:String, expString:String): void {
	    // documentCache_[nsCache.COOKIE_] = --- changed as follows
	    documentCache_.cookie =
	        mainValue + "; " +
	        "path=" + config.cookiePath_ + "; " +                      // path
	        expString +                                                // expiration
	        getDomainNameString_();                            // domain
	   
	
	  }
	
	
	  /**
	   * Helper for parsing cookie values.
	   *
	   * @private
	   * @param {String} parseString String to parse cookie values from.
	   * @param {String} domainHash Domain hash for validating cookie values.
	   * @param {String} delim Field delimiter for parsing string.
	   */
	  public function parseHelper_(parseString:String, domainHash:String, delim:String):void {
	    var valueMatrix:Array = valueMatrix_;
	
	    // list index
	    var listIdx:Number;
	
	     // Parses fields
	    for (listIdx = 0; listIdx < valueMatrix.length; listIdx++) {
	      valueMatrix[listIdx][VALUE_MATRIX_SETTER_](
	          nsCache.parseNameValuePairs_(
	              parseString,
	              valueMatrix[listIdx][VALUE_MATRIX_KEY_] + domainHash,
	              delim
	          )
	      );
	    }
	  }
  

  // ---------------------------------------------------------------------------
	  // PRIVILIGED METHODS
	  // ---------------------------------------------------------------------------
	  /**
	   * Returns flag indicating whether the field values are genuine.  The field
	   * values are genuine if (1) the values are not parsed in from URL string
	   * (symptom of which is utmkFields instance variable is undefined), or (2) the
	   * values are parsed in from URL string (utmkFields is defined) and the
	   * utmkFields value matches the hash for all the other utm* field values.
	   * <br/><br/>
	   *
	   * Note: if __utmk value is missing from the URL, the instance variable would
	   * still be defined, but set to "-".
	   *
	   * @private
	   * @return {Boolean} Flag indicating whether the field values are genuine (not
	   *     tampered with).
	   */
	  public function isGenuine_ ():Boolean
	  {
	    /**
	     * utmkFields is undefined, which means this cookie is not parsed from query
	     * string.  Therefore, the values are implicitly trusted.
	     */
	    return (nsCache.undef_ == utmkFields_) ||
	
	           /**
	             * utmkFields is defined, which means this cookie is parsed from
	             * query string. Check hash to see whether the values were being
	             * tampered with.
	             *
	             * Note: if utmkFields == "-", then this would always fail.  Since
	             * this.genHash_() always returns a number typed value.
	             *
	             */
	           (utmkFields_ == String(genHash_()));
	  }
	
	  
	  /**
	   * Returns string representation of __utmx value (ALPO value).
	   *
	   * @private
	   * @return {String} string representation of __utmx value (ALPO value).
	   */
	   public function getUtmxValue_() :String{
	    return utmxFields_ ? utmxFields_ : "-";
	  }
	  
	  
	  /**
	   * Sets the new __utmx value.
	   *
	   * @private
	   * @param {String} newUtmxValue The new __utmx value to set.
	   */
	   public function setUtmxValue_(newUtmxValue:String):void {
	    utmxFields_ = newUtmxValue;
	  }
	
	
	  /**
	   * Sets the new __utmk value.
	   *
	   * @private
	   * @param {String} newUtmkValue The new __utmk value to set.
	   */
	   public function setUtmkValue_(newUtmkValue:String):void {
	    // format hash (if it's numeric, convert to a number typed variable. Else,
	    // set it to undefined)
	    utmkFields_ = nsCache.isNumber_(newUtmkValue) ?
	                  newUtmkValue:
	                  "-";
	  }
	  
	  
	  /**
	   * Returns string representation of __utmv value. (user-defined values)
	   *
	   * @private
	   * @return {String} string representation of __utmv value. (user-defined
	   *     values)
	   */
	   public function getUtmvValue_():String 
	   {
	     return getFieldsAsString(utmvFields_);
	   }
	  
	  
	  /**
	   * Sets the new __utmv value.
	   *
	   * @private
	   * @param {String} newUtmvValue The new __utmv value to set.
	   */
	   public function setUtmvValue_(newUtmvValue:String) :void
	   {
	     utmvFields_ = string2Fields_(newUtmvValue);
	   }
	  
	  
	  /**
	   * Returns string representation of __utmk value. (cookie value hash)
	   *
	   * @private
	   * @return {String} string representation of __utmk value. (cookie value hash)
	   */
	   public function getUtmkValue_() :String
	   {
	     return utmkFields_ ? utmkFields_ : "-";
	   }
	  
	  
	  /**
	   * Returns the cookie domain string.
	   *
	   * @private
	   * @return {String} Domain string for this particular cookie.
	   */
	   public function getDomainNameString_():String 
	   {
		    /**
		     * no need to check, since this is guarnateed to be there (or else constructor
		     * throws exception)
		     */
		    return isEmpty(config.domainName_) ?
		           "" :
		           "domain=" + config.domainName_ + ";";
	   }
	  
	  
	  /**
	   * Returns string representation of __utma value. (visitor / session tracker)
	   *
	   * @private
	   * @return {String} string representation of __utma value. (visitor / session
	   *     tracker)
	   */
	   public function getUtmaValue_() :String
	   {
	     return getFieldsAsString(utmaFields_);
	   }
	  
	  
	  /**
	   * Sets the new __utma value.
	   *
	   * @private
	   * @param {String} newUtmaValue The new __utma value to set.
	   */
	   public function setUtmaValue_(newUtmaValue:String):void 
	   {
	   	 utmaFields_ = string2Fields_(newUtmaValue, true);
	   }
	  
	  
	  /**
	   * Returns string representation of __utmb value (session timeout).
	   *
	   * @private
	   * @return {String} String representation of __utmb value. (session timeout)
	   */
	   public function getUtmbValue_() :String
	   {
	     return getFieldsAsString(utmbFields_);
	   }
	  
	  
	  /**
	   * Sets the new __utmb value.
	   *
	   * @private
	   * @param {String} newUtmbValue The new __utmb value to set.
	   */
	   public function setUtmbValue_(newUtmbValue:String) :void
	   {
	     utmbFields_ = string2Fields_(newUtmbValue, true);
	   }
	  
	  
	  /**
	   * Returns string representation of __utmc value. (transient session tracker)
	   *
	   * @private
	   * @return {String} string representation of __utmc value. (transient session
	   *     tracker)
	   */
	   public function getUtmcValue_() :String
	   {
	     return getFieldsAsString(utmcFields_);
	   }
	  
	  
	  /**
	   * Sets the new __utmc value.
	   *
	   * @private
	   * @param {String} newUtmcValue The new __utmc value to set.
	   */
	   public function setUtmcValue_(newUtmcValue:String):void 
	   {
	     utmcFields_ = string2Fields_(newUtmcValue, true);
	   }
	  
	  
	  /**
	   * Returns string representation of __utmz value (campaign tracker).
	   *
	   * @private
	   * @return {String} String representation of __utmz value. (campaign tracker)
	   */
	   public function getUtmzValue_():String {
	    return getFieldsAsString(utmzFields_);
	  }
	  
	  
	  /**
	   * Sets the new __utmz value.
	   *
	   * @private
	   * @param {String} newUtmzValue The new __utmz value to set.
	   */
	   public function setUtmzValue_(newUtmzValue:String):void 
	   {
	    utmzFields_ = string2Fields_(newUtmzValue);
	
	    for (var i:Number = 0; i < utmzFields_.length; i++) {
	      // non campaign tracker fields (ignore if they are non-numeric)
	      if ((i < COOKIE_INDEX_UTMZ_CAMPAIGNTRACKING) &&
	          !nsCache.isNumber_(utmzFields_[i])) {
	        utmzFields_[i] = "-";
	      }
	    }
	  }
	
	
	  /**
	   * Returns Google Analytics Site Overlay secure token.
	   *
	   * @private
	   * @return {String} Google Analytics Site Overlay secure token.
	   */
	   public function getGASOValue_():String {
	    return gasoValue_;
	  }
	
	
	  /**
	   * Sets the new Google Analytics Stie Overlay secure token.
	   *
	   * @private
	   * @param {String} newGASOValue The new GASO value to set.
	   */
	   public function setGASOValue_ (newGASOValue:String):void {
	    gasoValue_ = newGASOValue;
	  }
	  
	
	  /**
	   * This method clears all the fields of the cookie.
	   *
	   * @private
	   */
	   public function clearValues_():void {
	    utmaFields_ = [];
	    utmbFields_ = [];
	    utmcFields_ = [];
	    utmzFields_ = [];
	    utmxFields_ = nsCache.undef_;
	    utmvFields_ = [];
	    utmkFields_ = nsCache.undef_;
	  }
	
	
	  /**
	   * This method generates a digest of all the __utm* values.
	   *
	   * @private
	   * @return {Number} Digest of all the __utm* values.
	   */
	   public function genHash_():Number {
	    var valueString :String= "";
	    var idx:Number;
	
	    for (idx = 0; idx < valueMatrix_.length; idx++) {
	      valueString += valueMatrix_[idx][VALUE_MATRIX_GETTER_]();
	    }
	
	    return nsCache.genHash_(valueString);
	  }
	
	
	
	  /**
	   * This method takes a string representation of document cookies, and domain
	   * hash value, then it extracts the fields and places them into the
	   * appropriate instance variables.
	   *
	   * @private
	   * @param {String} domainHash Hash value of domain name, used for cookie value
	   *     authentication.
	   *
	   * @return {Boolean} Returns true if and only if parsing cookie value from
	   *     document cookies is successful.
	   */
	   public function parseCookieValues_(domainHash:String) :Boolean{
	    //var cookieString = selfRef.documentCache_[nsCache.COOKIE_]; // changed as follows  - documentCache_.cookeie
	    var cookieString:String = getCookieOrFlashStoredDetails(); // before it was documentCache_.cookie;

	    // success flag
	    var successFlag:Boolean = false;
	
	    // if cookie string is defined and not empty
	    if (cookieString) {
	      // parse cookie string
	      parseHelper_(cookieString, domainHash, ";");
	
	      // parses value hash (simple value, no fields)
	      setUtmkValue_(String(genHash_()));
	
	      // succesfully parsed cookie value
	      successFlag = true;
	
	    }
	
	    return successFlag;
	  }
	
	
	  /**
	   * This method takes in a query string, and places the extracted fields into
	   * the appropriate instance variables.
	   *
	   * @private
	   * @param {String} inQString Input query string for parsing fields from.
	   *
	   */
	   public function parseQString_(inQString:String):void {
	    parseHelper_(inQString, "", "&");
	
	    setUtmkValue_(
	        nsCache.parseNameValuePairs_(inQString, nsCache.COOKIE_UTMK_, "&")
	    );
	  }
	
	
	  /**
	   * Converts this cookie instance to linker parameters.
	   *
	   * @private
	   * @return {String} linker query parameters
	   */
	   public function toLinkerParams_():String {
	    var valueMatrix:Array = valueMatrix_;
	    var linkerParams :Array= [];
	    var listIdx:Number;
	
	    for (listIdx = 0; listIdx < valueMatrix.length; listIdx++) {
	      nsCache.arrayPush_(
	          linkerParams,
	          valueMatrix[listIdx][VALUE_MATRIX_KEY_] +
	              valueMatrix[listIdx][VALUE_MATRIX_GETTER_]()
	      );
	    }
	
	    // append __utmk (hash)
	    nsCache.arrayPush_(
	        linkerParams,
	        nsCache.COOKIE_UTMK_ + genHash_()
	    );
	    return linkerParams.join("&");
	  }
	
	
	  /**
	   * Takes a new path, and changes all the paths of GATC cookies to
	   * the new path.
	   *
	   * @private
	   * @param {String} domainHash Hash value of current domain.  Need for parsing
	   *     cookie values.
	   * @param {String} newPath New path to store GATC cookies under.
	   *
	   */
	   public function updatePath_(domainHash:String, newPath:String):void {
	    var valueMatrix:Array = valueMatrix_;
	
	    // original cookie path
	    var origCookiePath:String = config.cookiePath_;
	
	    // index for iterations
	    var idx:Number;
	
	    // read cookie values from document object
	    parseCookieValues_(domainHash);
	
	    // temporarily set cookie path, to write cookies with
	    config.cookiePath_ = newPath;
	
	    for (idx = 0; idx < valueMatrix.length; idx++) {
	      if (!isEmpty(valueMatrix[idx][VALUE_MATRIX_GETTER_]())) {
	        valueMatrix[idx][VALUE_MATRIX_WRITTER_]();
	      }
	    }
	
	    // restoring cookie path
	    config.cookiePath_ = origCookiePath;
	  }
	
	  
	  /**
	   * Writes the __utma cookie.  Note that __utma cookie always persists for 2
	   * years
	   *
	   * @private
	   */
	   public function writeUtmaValue_():void {
	   if(LocalObjectHandler.useLocalObject == false)
	   {
		    writeCookie_(
		        nsCache.COOKIE_UTMA_ + getUtmaValue_(),
		        get2YearsExpirationString()
		    );
	   }
	   else
	    LocalObjectHandler.writeUtmaDetails(getUtmaValue_(),get2YearsExpirationFlashDate(),config.cookiePath_);
	    
	  }
	
	
	  /**
	   * Writes the __utmb cookie.  Note that __utmb cookies persists for 30 min.
	   *
	   * @private
	   */
	   public function writeUtmbValue_():void {
	   	if(LocalObjectHandler.useLocalObject == false)
	   	{
		    writeCookie_(
		        nsCache.COOKIE_UTMB_ + getUtmbValue_(),
		        getExpirationString_(Number(config.sessionTimeout_) * 1000)
		    );
	    }
	    else
	    LocalObjectHandler.writeUtmbDetails(getUtmbValue_(),
	    	getFlashExpirationDate_(Number(config.sessionTimeout_) * 1000),config.cookiePath_);
	    
	  }
	
	
	  /**
	   * Writes the __utmc cookie.  Note that __utmc cookies expires when the
	   * browser exists.
	   *
	   * @private
	   */
	   public function writeUtmcValue_():void
	   {
	   	if(LocalObjectHandler.useLocalObject == false)
	   		 writeCookie_(nsCache.COOKIE_UTMC_ + getUtmcValue_(), "");
	   	else
	     	LocalObjectHandler.writeUtmcDetails(getUtmcValue_(),null,config.cookiePath_);

	  }
	
	
	  /**
	   * Writes the __utmz cookie.  Note that __utmz cookies persists for 6 months.
	   *
	   * @private
	   */
	   public function writeUtmzValue_():void {
	   	if(LocalObjectHandler.useLocalObject == false)
	   	{
		    writeCookie_(
		        nsCache.COOKIE_UTMZ_ + getUtmzValue_(),
		        getExpirationString_(Number(config.conversionTimeout_ )* 1000)
		    );
	    }
	    else
	    	 LocalObjectHandler.writeUtmzDetails(getUtmzValue_(),
	    	getFlashExpirationDate_(Number(config.conversionTimeout_) * 1000),config.cookiePath_);
	  };
	
	
	  /**
	   * Writes the __utmx cookie.  Note that __utmx cookies always persists for 2
	   * years
	   *
	   * @private
	   */
	   public function writeUtmxValue_():void {
	   	if(LocalObjectHandler.useLocalObject == false)
	   	{
		    writeCookie_(
		        nsCache.COOKIE_UTMX_ + getUtmxValue_(),
		        get2YearsExpirationString()
		    );
	    }
	    else
	    LocalObjectHandler.writeUtmxDetails(getUtmxValue_(),get2YearsExpirationFlashDate(),config.cookiePath_);
	  }
	
	
	  /**
	   * Writes the __utmv cookie.  Note that __utmv cookies always persists for 2
	   * years
	   *
	   * @private
	   */
	   public function writeUtmvValue_():void {
	   	if(LocalObjectHandler.useLocalObject == false)
	   	{
		    writeCookie_(
		        nsCache.COOKIE_UTMV_ + getUtmvValue_(),
		        get2YearsExpirationString()
		    );
	    }
	    else
	    	LocalObjectHandler.writeUtmvDetails(getUtmvValue_(),get2YearsExpirationFlashDate(),config.cookiePath_);
	  }
	
	
	  /**
	   * Writes the GASO cookie.  Note that GASO cookies expires when the browser
	   * exists.
	   *
	   * @private
	   */
	   public function writeGASOValue_():void {
	   	if(LocalObjectHandler.useLocalObject)
	    	writeCookie_(nsCache.COOKIE_GASO_ + getGASOValue_(), "");
	     else
	     	LocalObjectHandler.writeGASODetails(getGASOValue_(),null,config.cookiePath_);
	  }
	
	
	  // ---------------------------------------------------------------------------
	  // INITIALIZATION LOGIC
	  // --------------------------------------------------------------------------- 
	  /**
	   * Matrix (2D) of accessor functions and values used by JSCompiler for better
	   * code compression.
	   *
	   * Each row is a cookie value. (ie: __utma).  Each column is a type of
	   * accessor.  Column 1 is the key name, column 2 is the getter, column 3 is
	   * the setter, and column 4 is the writer (writes to HTMLDocument object).
	   *
	   * @private
	   * @type {Array}
	   */
	 private var valueMatrix_:Array = 
	 		[
	 
			      [
			          nsCache.COOKIE_UTMA_,
			          getUtmaValue_,
			          setUtmaValue_,
			          writeUtmaValue_
			      ],
			      [
			          nsCache.COOKIE_UTMB_,
			          getUtmbValue_,
			          setUtmbValue_,
			          writeUtmbValue_
			      ],
			      [
			          nsCache.COOKIE_UTMC_,
			          getUtmcValue_,
			          setUtmcValue_,
			          writeUtmcValue_
			      ],
			      [   // ALPO value
			          nsCache.COOKIE_UTMX_,
			          getUtmxValue_,
			          setUtmxValue_,
			          writeUtmxValue_
			      ],
			      [   // campaign tracker
			          nsCache.COOKIE_UTMZ_,
			          getUtmzValue_,
			          setUtmzValue_,
			          writeUtmzValue_
			      ],
			      [
			          nsCache.COOKIE_UTMV_,
			          getUtmvValue_,
			          setUtmvValue_,
			          writeUtmvValue_
			      ]
		  ]


		public function getCookieOrFlashStoredDetails():String
		{
			    var cookieString:String;
			    if(LocalObjectHandler.useLocalObject == false)
					cookieString = documentCache_.cookie;
				else
					cookieString = getCompleteCookieValueFromFlash();
			
			return cookieString;
		}

		public function getCompleteCookieValueFromFlash():String
		{
			var completeString:String = "";
			LocalObjectHandler.init(config.cookiePath_);
			var origObjectUsage:Boolean = LocalObjectHandler.useSameObject;
			LocalObjectHandler.useSameObject = true;
			
			var utmaValue:String = LocalObjectHandler.getUtmaValue(config.cookiePath_);
			var utmbValue:String = LocalObjectHandler.getUtmbValue(config.cookiePath_);
			var utmcValue:String = LocalObjectHandler.getUtmcValue(config.cookiePath_);
			var utmzValue:String = LocalObjectHandler.getUtmzValue(config.cookiePath_);
			var utmxValue:String = LocalObjectHandler.getUtmxValue(config.cookiePath_);
			var utmvValue:String = LocalObjectHandler.getUtmvValue(config.cookiePath_);
			var gasoValue:String = LocalObjectHandler.getGASOValue(config.cookiePath_);
			
			completeString += (utmaValue != "")? nsCache.COOKIE_UTMA_ + utmaValue + ";":"";
			completeString += (utmbValue != "")? nsCache.COOKIE_UTMB_ + utmbValue + ";":"";
			completeString += (utmcValue != "")? nsCache.COOKIE_UTMC_ + utmcValue + ";":"";
			completeString += (utmzValue != "")? nsCache.COOKIE_UTMZ_ + utmzValue + ";":"";
			completeString += (utmxValue != "")? nsCache.COOKIE_UTMX_ + utmxValue + ";":"";
			completeString += (utmvValue != "")? nsCache.COOKIE_UTMV_ + utmvValue + ";":"";
			completeString += (gasoValue != "")? nsCache.COOKIE_GASO_ + gasoValue + ";":"";
			LocalObjectHandler.useSameObject = origObjectUsage;
	        return completeString;
		}


	}
}