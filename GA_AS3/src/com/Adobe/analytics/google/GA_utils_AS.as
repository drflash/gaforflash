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
	import com.Adobe.analytics.external.HTMLScreenDetails_AS;
	import com.Adobe.analytics.external.HTML_LocationDetails_AS;
	
	
	public class GA_utils_AS
	{
		
			include "globals/GA_utils_globals.as"; 
				
			private static  var GA_Config_:GA_config_AS;
			private  static var GA_Cookie_:GA_cookie_AS;
			private static var html_DocumentObj_:HTMLDocumentDetails_AS;	
			private static var html_ScreenObj_:HTMLScreenDetails_AS;	


		  /**
		   * Flag indicating whether site overlay has been initialized.
		   */
		  public var hasSiteOverlay_:Boolean = false;


		  /**
		   * Site overlay cookie domain name.
		   */
		  public var _gasoDomain :String = undefined;


		  /**
		   * Site overlay cookie path.
		   */
		 public var  _gasoCPath:String = undefined;
		
		
		private static var selfObject:GA_utils_AS;
		
		public static function getGAUTIS():GA_utils_AS
 		{
 			if(!selfObject)
 				selfObject = new GA_utils_AS();
 			
 			return selfObject;
 		} 
		 
		 
		public function GA_utils_AS()
		{
				GA_Config_ = new GA_config_AS();
 		}
 		public static function getCookieHandler(inDocument:HTMLDocumentDetails_AS,config:GA_config_AS):GA_cookie_AS
 		{
 			if(!GA_Cookie_)
 			{
 				GA_Cookie_ = new GA_cookie_AS(inDocument,config);
 			}
 			return GA_Cookie_;
 		}
 		
 		public static function getInitialisedCookieHandler():GA_cookie_AS
 		{
 			return GA_Cookie_;
 		}
 		
 		public static function get html_DocumentObj():HTMLDocumentDetails_AS
 		{
 			if(!html_DocumentObj_)
 			{
 				html_DocumentObj_ = new HTMLDocumentDetails_AS();
 			}
 			
 			return html_DocumentObj_;
 				
 		}
 		
 		public static function get html_ScreenObj():HTMLScreenDetails_AS
 		{
 			if(!html_ScreenObj_)
 			{
 				html_ScreenObj_ = new HTMLScreenDetails_AS();
 			}
 			
 			return html_ScreenObj_;
 				
 		}
 		
 		
 		public static function get GA_Config():GA_config_AS
 		{
 			if(!GA_Config_)
 			{
 				GA_Config_ = new GA_config_AS();
 			}
 			
 			return GA_Config_;
 				
 		}
 		
 		
 		
		 /**
		   * Generate hash for input string.  This is a global method, since it does not
		   * need to access any instance variables, and it is being used everywhere in the
		   * GATC module.
		   *
		   * @param {String} inString Input string to generate hash value on.
		   *
		   * @memberOf _gat
		   * @private
		   * @return {Number} Hash value of input string.  If input string is undefined,
		   *     or empty, return hash value of 1.
		 */
	 	 public function genHash_ (inString:String):int  
	 	 {
		    var hashVal:int = 1;                             // hash buffer
		    var lefMost7:int = 0;                            // left-most 7 bits
		    var charPos:int;                                 // character position in string
		    var curChar:int;                                 // current character in string
		
		    // if input is undef or empty, hash value is 1
		    if (!isEmptyField_(inString)) 
		    {
		    	
		      hashVal = 0;
		
		      // hash function
		      for (charPos = inString[LENGTH_] - 1; charPos >= 0; charPos--) 
		      {
			        curChar = inString.charCodeAt(charPos);
			
			        hashVal = ((hashVal << 6) & 0xfffffff) + curChar + (curChar << 14);
			
			        lefMost7 = hashVal & 0xfe00000;
			
			        hashVal = (lefMost7 != 0) ?
			                  (hashVal ^ (lefMost7 >> 21)) :
			                  hashVal;
	      	  }
	    	}
	
	    	return hashVal;
	  	}


	  /**
	   * Takes an input string consist of name-value pairs (either in query string
	   *     format; [?<key>=<value>&<key2>=<value2>&...] or cookie format:
	   *     [<key>=<value>;<key2>=<value2>;...]), and returns the value specified
	   *     by the key.
	   *
	   * @param {String} fullString String representation of the entire key-value
	   *     pairs.
	   * @param {String} key Key of the value to retrieve from fullString.
	   * @param {String} delim Delimiter used to seperate out pairs in the string.
	   *
	   * @memberOf _gat
	   * @private
	   * @return {String} Value for the specific key, from fullString.  Empty value
	   *     is denoted by the single character string "-".
	   */
	  public function parseNameValuePairs_ (fullString:String, key:String, delim:String):String 
	  {
	    var nsCache:Object = this;
	    var returnValue:String = "-";
	    var startPos:int, endPos:int;
	    var isEmptyCache:Function = nsCache.isEmptyField_;
	
	    /**
	     * If either full string, key value or delimiter is missing, there is no value
	     * to retrieve.
	     */
	     
	    if (!isEmptyCache(fullString) && !isEmptyCache(key) &&
	        !isEmptyCache(delim)) {
	      startPos = nsCache.indexOfProxy_(fullString, key);
	      
	      
	
	      if (startPos > -1) {
	        endPos = fullString.indexOf(delim, startPos);
	
	        if (endPos < 0) {
	          endPos = fullString[nsCache.LENGTH_];
	        }
	
	        returnValue = nsCache.substringProxy_(
	            fullString,
	            startPos + nsCache.indexOfProxy_(key, "=") + 1,
	            endPos
	        );
	      }
	  	}
	    return returnValue;
	  }


	  /**
	   * Takes an input string, and determine whether the string is a number.  The
	   * criteria for numberic string is:
	   * <ol>
	   *   <li>Only characters in strings consists of "01234556789".</li>
	   *   <li>Decimal (".") appears exactly 0, or 1 times.</li>
	   *   <li>
	   *     First character is "-" followed by numeric characters. (and 0-1 decimal
	   *     characters)
	   *   </li>
	   * </ol>
	   *
	   * @param {String} inString Input string.
	   *
	   * @memberOf _gat
	   * @private
	   * @return {Boolean} True if and only if inString is a numberic string,
	   *     according to the criteria stated above.
	   */
	  public function isNumber_ (inString:String):Boolean 
	  {
	    var isNumber:Boolean = false;
	
	    // counter for decimals in string
	    var decimalCount:int = 0;
	
	    // character position in string
	    var charPos:int;
	
	    // current character in string
	    var curChar:String;
	
	    // if input string is undef or empty, not numeric
	    if (!isEmptyField_(inString)) {
	      isNumber = true;
	
	      for (charPos = 0; charPos < inString[LENGTH_]; charPos++) {
	        curChar = inString.charAt(charPos);
	
	        decimalCount += ("." == curChar) ? 1 : 0;
	
	        /**
	         * A number is defined as a string with:
	         *   1. Zero or one decimals
	         *   2. Leads with negative sigh or not
	         *   3. All characters are numeric (except for possibly leading negatives
	         *      signs, and at most one decimal point).
	         *
	         * The first "isNumber &&" conditional is used to trigger a false value
	         * when isNumber is set to false for even one character in the string.
	         *
	         * @ignore
	         */
	        isNumber = isNumber &&
	                   (decimalCount <= 1) &&
	                   (((0 == charPos) && ("-" == curChar)) ||
	                    stringContains_(".0123456789", curChar));
	      }
	    }
	
	    // if we ever get here, the string passed all the checks.  It's a numeric
	    // string!
	    return isNumber;
	  }

	  /**
	   * Takes in an input string, and HTML encode it.  If ignoreNonQString is set
	   * to true, then the function assumes the input string is a URL, and encoder
	   * ignores the non query string part of the string.
	   *
	   * @param {String} inputString String to be encoded.
	   * @param {Boolean} opt_ignoreNonQString Flag indicating whether we should
	   *     ignore non query string part of the input string during encoding.  This
	   *     parameter is optional, and defaults to false.
	   *
	   * @memberOf _gat
	   * @private
	   * @return {String} Encoded string.
	   */
	  public function encodeWrapper_ (inputString:String, opt_ignoreNonQString:Boolean=false):String {
	    var encodeComponent:Function = encodeURIComponent as Function;
	    return (encodeComponent != null) ?
	
	            // for browsers that supports the newer encodeURIComponent()
	            (
	
	                (opt_ignoreNonQString) ?
	                    // ignore non query string portion of the string
	                    encodeURI(inputString) :
	
	                    // encode entire string
	                    encodeComponent(inputString)
	            ) :
	
	            // for browsers that don't support the newer encodeURIComponent()
	            escape(inputString);
	  }


	  /**
	   * Takes in an input string, and HTML decode it.  If ignoreNonQString is set
	   * to true, then the function assumes the input string is a URL, and decoder
	   * ignores the non query string part of the string.
	   *
	   * @param {String} inputString String to be decoded.
	   * @param {Boolean} opt_ignoreNonQString Flag indicating whether we should
	   *     ignore non query string part of the input string during decoding.  This
	   *     parameter is optional, and defaults to false.
	   *
	   * @memberOf _gat
	   * @private
	   * @return {String} Decoded string.
	   */

  	  public function decodeWrapper_ (inputString:String, opt_ignoreNonQString:Boolean=false):String
	  {
	     var decodeComponent:Function = decodeURIComponent as Function;
	     var outputString:String;
	
		/**
	     * Since decodeURIComponent, decodeComponent, and unescape does not decode
	     * "+" into spaces.  We need to be compatible with old URI encoding
	     * standards. [Issue id: 961766] 
	     */
	    inputString = inputString.split("+").join(" ");
	    
	    if (decodeComponent != null) 
	    {
	      try 
	      {
	        /**
	         * For browsers that supports the newer decodeURIComponent(), ignore
	         * non-query string portion of the string if opt_ignoreNonQString is set
	         * to true.  Else decode entire string. 
	         */
	        outputString = (opt_ignoreNonQString) ?
	                       decodeURI(inputString) :
	                       decodeComponent(inputString);
	      } catch (e:Error) 
	      {
	       outputString = unescape(inputString);
	      }
	    } 
	    else 
	    {
	      outputString = unescape(inputString);
	    }
	
	     return outputString;
	  }


	  /**
	   * This helper method returns the anchor part of an location object.  If there
	   * is no hash in the location, return empty string.
	   *
	   * @param {HTMLlocation} inLocation Location object used to determine anchor.
	   *
	   * @memberOf _gat
	   * @private
	   * @return {String} If there is hash in the location object, return the anchor.
	   *     Else return empty string.
	   */
	   public function getAnchor_ (inLocation:HTML_LocationDetails_AS):String {
	    return (inLocation && inLocation.hash) ?
	           substringProxy_(
	               inLocation.href,
	               indexOfProxy_(inLocation.href, "#"),inLocation.href.length
	           ) :
	           "";
	  }
  

	  /**
	   * Return flag indicating whether input value is considered to be empty.
	   *
	   * @param {String} value Value to determine whether it's empty or not.
	   *
	   * @memberOf _gat
	   * @private
	   * @return {Boolean} Returns true if value is undefined, equals to "-" or "".
	   */
	   public function isEmptyField_ (value:String):Boolean {
	    return ((undef_ == value) || ("-" == value) || ("" == value));
	  }


	  /**
	   * Returns true if and only if the input character is a whitespace character.
	   *
	   * @param {String} inChar Input character to determine whether this is a
	   *     whitespace character
	   *
	   * @memberOf _gat
	   * @private
	   * @return {Boolean} true if and only if the input character is a whitespace
	   *     character.
	   */
	   public function isWhiteSpace_ (inChar:String):Boolean{
	    return (inChar[LENGTH_] > 0) &&
	           stringContains_(" \n\r\t", inChar);
	  }


	  /**
	   * Returns true if and only if matchString is a substring of fullString.
	   *
	   * @param {String} fullString Full string to find matchString in.  This
	   *     parameter cannot be undefined.
	   * @param {String} matchString Substring to search for in fullString.
	   *
	   * @memberOf _gat
	   * @private
	   * @return {Boolean} True if and only if matchString is a substring of
	   *     fullString.
	   */
	  public function stringContains_ (fullString:String, matchString:String):Boolean {
	    return indexOfProxy_(fullString, matchString) > -1;
	  }


	  /**
	   * Replicates the Array.push() functionality.  But since Array.push() is not
	   * supported IE4 and IE5, I have to rewrite it.
	   *
	   * @param {Array} inArray Reference to array to push new element to.
	   * @param {Object} newElement New element to push (append) to inArray.
	   *
	   * @memberOf _gat
	   * @private
	   * @private
	   */
	   public function arrayPush_ (inArray:Array, newElement:Object):void {
	    inArray[inArray[LENGTH_]] = newElement;
	  }


	  /**
	   * This is a wrapper around the String.toLowerCase() method.  The purpose of
	   * this wrapper is to allow JSCompiler to rename the toLowerCase method calls.
	   *
	   * @param {String} inString String to convert to lower case.
	   *
	   * @memberOf _gat
	   * @private
	   * @return {String} String that is the lower-case equivalent of inString.
	   */
	   public function toLowerCaseProxy_ (inString:String):String {
	    return inString.toLowerCase();
	  }


	  /**
	   * This is a wrapper around the String.split() method.  The purpose of this
	   * wrapper is to allow JSCompiler to rename the split method calls.
	   *
	   * @param {String} inString The string to split on.
	   * @param {String} delim Delimiter to split the string with.
	   *
	   * @memberOf _gat
	   * @private
	   * @return {Array} An array of split fields.
	   */
	   public function splitProxy_ (inString:String, delim:String):Array {
	    return inString.split(delim);
	  }


	  /**
	   * This is a wrapper around the String.indexOf() method.  The purpose of this
	   * wrapper is to allow JSCompiler to rename the indexOf method calls.
	   *
	   * @param {String} inString The string to run indexOf on.
	   * @param {String} matchString The string to match indexOf on.
	   *
	   * @memberOf _gat
	   * @private
	   * @return {Number} Index of found matchString in inString.  If the match string
	   *     is not found, then -1 is returned.
	   */
	   public function indexOfProxy_ (inString:String, matchString:String):int {
	    return inString.indexOf(matchString);
	  }

	
	  /**
	   * This is a wrapper around the String.substring() method.  The purpose of this
	   * wrapper is to allow JSCompiler to rename the substring method calls.
	   *
	   * @param {String} inString The string to run substring on.
	   * @param {Number} startPos Starting offset to extract substring.
	   * @param {Number} opt_endPos (Optional) Ending offset to extract substring.
	   *
	   * @memberOf _gat
	   * @private
	   * @return {String} Substring specified by startPos and endPos.
	   */
	   public function substringProxy_ (inString:String, startPos:int, opt_endPos:int=-1):String {
	    opt_endPos = (-1 == opt_endPos) ?
	                 inString.length :
	                 opt_endPos;
	
	    return inString.substring(startPos, opt_endPos);
	  }


	  /**
	   * Generates hit id for revenue per page tracking for AdSense.  This method
	   * first examines the DOM for existing hid.  If there is already a hid in DOM,
	   * then this method will return the existing hid.  If there isn't any hid in
	   * DOM, then this method will generate a new hid, and both stores it in DOM, and
	   * returns it to the caller.
	   *
	   * @memberOf _gat
	   * @private
	   * @return {Number} hid used by AdSense for revenue per page tracking
	   */
	   public function genHid_ ():int {
	    var rtnHid:int = undef_;
	    /*
	    var windowCache = window; .... openpoint
	
	    // have hid in DOM
	    if (windowCache && windowCache.gaGlobal && windowCache.gaGlobal.hid) {
	      rtnHid = windowCache.gaGlobal.hid;
	
	    // doesn't have hid in DOM
	    } else {
	      rtnHid = Math.round(Math.random() * 0x7fffffff);
	
	      windowCache.gaGlobal = windowCache.gaGlobal ?
	                             windowCache.gaGlobal :
	                             new Object();
	
	      windowCache.gaGlobal.hid = rtnHid;
	    }
	*/
	    return rtnHid;
	  }


	  /**
	   * Generates a 32bit random number.
	   *
	   * @memberof _gat
	   * @private
	   * @return {Number} 32bit random number.
	   */
	   public function get32bitRand_ ():int 
	   {
	   	 return Math.round(Math.random() * 0x7fffffff);
	   }
	   
	     /**
		 * Factory method for returning a tracker object.
		 *
		 * @param {String} urchinAccount Urchin Account to record metrics in.
		 *
		 * @return {_gat.GA_Tracker_}  
		 */
		public function _getTracker(urchinAccount:String) :GA_EventTracker_AS
		{
		  var newTracker:GA_EventTracker_AS = new GA_EventTracker_AS(urchinAccount);
		
		  return newTracker;
		}
		

	}
	
}