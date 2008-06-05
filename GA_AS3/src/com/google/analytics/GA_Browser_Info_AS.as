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
	import com.Adobe.analytics.external.HTML_GeneralDetails_AS;
	
	import flash.system.Capabilities;


	
	public class GA_Browser_Info_AS
	{
		
		 /**
		 * @class Google Analytics Tracker Code (GATC)'s browser information component.
		 *     This class encompasses all the neccessary logic for tracking browser
		 *     information.
		 *
		 *
		 * @constructor
		 */
		 
		  // ---------------------------------------------------------------------------
		  // PRIVATE VARIABLES
		  // ---------------------------------------------------------------------------
		  private var emptyField:String = "-";
		  private var nsCache:GA_utils_AS;
		
		  /**
		   * Flash version detection option. (1=on | 0=off)
		   *
		   * @type {Number}
		   */
		  private var flashDetection:Number;
		
		  
		  // ---------------------------------------------------------------------------
		  // PRIVILIGED VARIABLES
		  // ---------------------------------------------------------------------------
		
		  // ~ Injected dependencies ---------------------------------------------------
		  /**
		   * Sets the screen cache. (used for dependency injection)
		   *
		   * @type {Screen}
		   */
		  private var screenCache_:HTMLScreenDetails_AS; 

		
		  /**
		   * Set the document cache. (used for dependency injection)
		   *
		   * @type {HTMLDocument}
		   * @ignore
		   */
			private var documentCache_:HTMLDocumentDetails_AS= GA_utils_AS.html_DocumentObj;
		
		
		  // ~ Instance variables ------------------------------------------------------
		  /**
		   * Screen resolution.
		   *
		   * @private
		   * @type {String}
		   */
		  private var screenResolution_:String = emptyField;
		
		
		  /**
		   * Screen color depth.
		   *
		   * @private
		   * @type {String}
		   */
		  private var screenColorDepth_ :String = emptyField;
		
		
		  /**
		   * Character set.
		   *
		   * @private
		   * @type {String}
		   */
		  private var characterSet_:String = emptyField;
		
		
		  /**
		   * Browser language.
		   *
		   * @private
		   * @type {String}
		   */
		  private var language_ :String= emptyField;
		
		
		  /**
		   * Is Java enabled in browser?
		   *
		   * @private
		   * @type {Number}
		   */
		  private var javaEnabled_:Number = 1;
		
		
		  /**
		   * Flash plug-in version.
		   *
		   * @private
		   * @type {String}
		   */
		  private var flashVersion_:String = emptyField;


		  public function GA_Browser_Info_AS(detectFlash:int)
		  {
			 nsCache = GA_utils_AS.getGAUTIS();
 			 flashDetection = detectFlash;
		  }
		
		
		  // ---------------------------------------------------------------------------
		  // PRIVATE METHODS
		  // ---------------------------------------------------------------------------
		  /**
		   * Detects the installed flash plugin version.
		   *
		   * @return {String} Installed flash plug-in version.  
		   */
		 public function getFlashVersion():String {
		  		
		   return Capabilities.version;
	
		  }


		  // ---------------------------------------------------------------------------
		  // PRIVILIGED METHODS
		  // ---------------------------------------------------------------------------
		  /**
		   * Extracts browser data, and stores them into individual data fields.
		   *
		   * @private
		   */
		  public function getBrowserInfo_():void
		  {
			if(!screenCache_)
			{
				screenCache_= GA_utils_AS.html_ScreenObj;
			}
		    // have a screen reference
		     var screenInfoFromFlash:String = String(Capabilities.screenResolutionX) + "x" + String(Capabilities.screenResolutionY);
		 
		    if (screenCache_.screenFound) 
		    {
		      screenResolution_ = screenCache_.width + "x" +
		                                 screenCache_.height;
		     screenColorDepth_ = screenCache_.colorDepth + "-bit";
		
		    // don't have screen reference
		    }


		          language_ = HTML_GeneralDetails_AS.getBrowserLanguage();
		          javaEnabled_ = HTML_GeneralDetails_AS.isJavaEnabled();
		    
	
	    // flash detection is on
	    flashVersion_ = (flashDetection) ? String(getFlashVersion()) : emptyField;
	
	
	    characterSet_ = nsCache.encodeWrapper_(
	        // have characterSet property
	        (documentCache_.characterSet) ? documentCache_.characterSet :
	
		        // have charset property
		        (documentCache_.charset) ? documentCache_.charset : emptyField
	    );
	    
	   
	  }
	
	
	  /**
	   * Returns the GIF hit query string with browser information.
	   *
	   * @private
	   * @return {String} Part of the request string that encapsulates browser
	   *     information.
	   */
	  public function toQueryString_ () :String
	  {
	    return "&" +
	        [
	            "utmcs=" + nsCache.encodeWrapper_(characterSet_),
	            "utmsr=" + screenResolution_,
	            "utmsc=" + screenColorDepth_,
	            "utmul=" + language_,
	            "utmje=" + javaEnabled_,
	            "utmfl=" + nsCache.encodeWrapper_(flashVersion_)
	        ].join("&");
	  }

	}
}