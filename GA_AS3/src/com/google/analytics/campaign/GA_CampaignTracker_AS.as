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

package com.google.analytics.campaign
{
    import com.google.analytics.GA_utils_AS;
    
	public class GA_CampaignTracker_AS
	{
		  include "../globals/GA_utils_globals.as"
		  
		  // ---------------------------------------------------------------------------
		  // PRIVILIGED VARIABLES
		  // ---------------------------------------------------------------------------
		  /**
		   * Campaign Id.
		   *
		   * @private
		   * @type {String}
		   */
		  private  var id_:String ;
		
		
		  /**
		   * Campaign source.
		   *
		   * @private
		   * @type {String}
		   */
		  private  var source_:String ;
		  public function get source():String
		  {
		  	return source_;
		  }
		
		
		  /**
		   * Campaign click Id.
		   *
		   * @private
		   * @type {String}
		   */
		  private  var clickId_:String;
		
		
		  /**
		   * Campaign name.
		   *
		   * @private
		   * @type {String}
		   */
		  private  var name_ :String;
		
		
		  /**
		   * Campaign medium.
		   *
		   * @private
		   * @type {String}
		   */
		  public  var medium_:String;
		
		
		  /**
		   * Campaign term.
		   *
		   * @private
		   * @type {String}
		   */
		  public  var term_ :String;
		
		
		  /**
		   * Campaign content.
		   *
		   * @private
		   * @type {String}
		   */
		  private  var content_:String ;
		  
		/**
		 * @class Campaign tracker object.  Contains all the data associated with a
		 * campaign.
		 *
		 * @param {String} opt_id Optional.  Camapign Id.
		 * @param {String} opt_source Optional.  Campaign source.
		 * @param {String} opt_clickId Optional.  Campaign click id.
		 * @param {String} opt_name Optional.  Campaign name.
		 * @param {String} opt_medium Optional.  Campaign medium.
		 * @param {String} opt_term Optional.  Campaign term.
		 * @param {String} opt_content Optional.  Campaign content.
		 *
		 * @private
		 * @constructor
		 */
		public function GA_CampaignTracker_AS(opt_id:String = "",
                                    opt_source:String = "",
                                    opt_clickId:String = "",
                                    opt_name:String = "",
                                    opt_medium:String = "",
                                    opt_term:String = "",
                                    opt_content:String = "")
		{
			id_ = opt_id;
			source_ = opt_source;
			clickId_ = opt_clickId;
			name_ = opt_name;
			medium_ = opt_medium;
			term_ = opt_term;
			content_ = opt_content;
		}
		
		
		/**
		 * Converts this campaign tracker object to campaign tracker string used GATC
		 * and the collector front-end.
		 *
		 * @private
		 * @return {String} String representation of the campaign tracker.  Only return
		 *     the tracker string if and only if the tracker object is valid.  The
		 *     tracker object is considered to be valid if at least one of Id, soruce,
		 *     or click Id is present.
		 */
	
    

		public  function toTrackerString_():String
		{
		  //var selfRef = this;
		  var nsCache:GA_utils_AS = GA_utils_AS.getGAUTIS();
		  var trackerFields:Array = [];
		  var keyValues:Array = [
		      [GA_CAMP_UTMCID_,   id_],
		      [GA_CAMP_UTMCSR_,   source_],
		      [GA_CAMP_UTMGCLID_, clickId_],
		      [GA_CAMP_UTMCCN_,   name_],
		      [GA_CAMP_UTMCMD_,   medium_],
		      [GA_CAMP_UTMCTR_,   term_],
		      [GA_CAMP_UTMCCT_,   content_]
		  ];
		  var key:Number;
		  var value:String;
		  // if this campaign is valid
		  if (isValid_()) {
		  	
		    /**
		     * for each key/value pair, append key=value if and only if the value is
		     * not empty.
		     */
		    for (key = 0; key < keyValues.length; key++) {
		      if (!nsCache.isEmptyField_(keyValues[key][1])) 
		      {
		      	
		      	
		       /**
		         * We are no longer decoding/encoding the sequence of keywords but
		         * directly set the campaign information in the cookies. We would still
		         * need to convert the pluses in spaces as done in
		         * nsCache.decodeWrapper.
		         */
		        value = keyValues[key][1].split("+").join("%20");
		        value = value.split(" ").join("%20");
		        nsCache.arrayPush_(
	            trackerFields,
	            keyValues[key][0] + value);
		      }
		    }
		  }
		
		  return trackerFields.join(GA_campaign_AS.CAMPAIGN_TRACKING_DELIM);
		}
		
		
		/**
		 * Returns a flag indicating whether this tracker object is valid.  A tracker
		 * object is considered to be valid if and only if one of id, source or clickId
		 * is present
		 *
		 * @private
		 * @return {Boolean} Boolean flag indicating whether this tracker object is
		 *     valid.
		 */
		public function isValid_() :Boolean
		{
		  var isEmptyCache:Function = GA_utils_AS.getGAUTIS().isEmptyField_;
		
		  return !(isEmptyCache(id_) && isEmptyCache(source_) &&
		           isEmptyCache(clickId_));
		};

		
		
		/**
		 * Builds the tracker object from a tracker string.
		 *
		 * @private
		 * @param {String} trackerString Tracker string to parse tracker object from.
		 */
		public function fromTrackerString_(trackerString:String) :void
		{
		  //var selfRef = this;
		  var nsCache:GA_utils_AS = GA_utils_AS.getGAUTIS();
		
		  /**
		   * Inner helper function.  Used for better compression by the JSCompiler.  It
		   * reduces code duplication.
		   *
		   * This particular helper function takes a key, and parses the campaign
		   * tracker value from the tracker string.  
		   */
		 
		
		  // parse all the campaign fields
		  id_ = innerDecodeHelper(trackerString,GA_CAMP_UTMCID_);
		  source_ = innerDecodeHelper(trackerString,GA_CAMP_UTMCSR_);
		  clickId_ = innerDecodeHelper(trackerString,GA_CAMP_UTMGCLID_);
		  name_ = innerDecodeHelper(trackerString,GA_CAMP_UTMCCN_);
		  medium_ = innerDecodeHelper(trackerString,GA_CAMP_UTMCMD_);
		  term_ = innerDecodeHelper(trackerString,GA_CAMP_UTMCTR_);
		  content_ = innerDecodeHelper(trackerString,GA_CAMP_UTMCCT_);
		}
		
		private function innerDecodeHelper(trackerString:String,key:String):String
		{
		    return GA_utils_AS.getGAUTIS().decodeWrapper_(
		        GA_utils_AS.getGAUTIS().parseNameValuePairs_(
		            trackerString,
		            key,
		            GA_campaign_AS.CAMPAIGN_TRACKING_DELIM
		        )
		    );
		}


	}
}