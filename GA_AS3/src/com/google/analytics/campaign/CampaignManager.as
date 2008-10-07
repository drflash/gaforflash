/*
 * Copyright 2008 Adobe Systems Inc., 2008 Google Inc.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * 
 * Contributor(s):
 *   Zwetan Kjukov <zwetan@gmail.com>.
 */

package com.google.analytics.campaign
{
    import com.google.analytics.core.Buffer;
    import com.google.analytics.core.OrganicReferrer;
    
    /**
    * 
    */
    public class CampaignManager
    {
        private var _buffer:Buffer;
        
        private var _domainHash:Number;
        private var _timeStamp:Number;
        
        //Delimiter for campaign tracker.
        public static const trackingDelimiter:String = "|";
        
        public function CampaignManager( buffer:Buffer, domainHash:Number, timeStamp:Number )
        {
            _buffer     = buffer;
            
            _domainHash = domainHash;
            _timeStamp  = timeStamp;
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
        public function getCampaignInformation():CampaignInfo
        {
            var campInfo:CampaignInfo;
            
            //TODO
            
            return campInfo;
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
        public function getOrganicCampaign():CampaignTracker
        {
            var camp:CampaignTracker = new CampaignTracker();
            
            var currentOrganicSource:OrganicReferrer;
            //config.organicSources
            var keyword:String;
            
            camp.source = currentOrganicSource.engine;
            camp.name   = "(organic)";
            camp.medium = "organic";
            camp.term   = keyword;
            
            return camp;
        }
        
  /**
   * This method returns the referral campaign information.
   *
   * @private
   * @return {_gat.GA_Campaign_.Tracker_} Returns nothing if there is no
   *     referrer. Otherwise, return referrer campaign tracker.
   */
        public function getReferrerCampaign():CampaignTracker
        {
            var hostname:String = "";
            var content:String  = "";
            var camp:CampaignTracker = new CampaignTracker();
            
            camp.source  = hostname;
            camp.name    = "(referral)";
            camp.medium  = "referral";
            camp.content = content;
            
            return camp;
            
        }
        
  /**
   * Returns the direct campaign tracker string.
   *
   * @private
   * @return {_gat.GA_Campaign_.Tracker_} Direct campaign tracker object.
   */
        public function getDirectCampaign():CampaignTracker
        {
            var camp:CampaignTracker = new CampaignTracker();
                camp.source = "(direct)";
                camp.name   = "(direct)";
                camp.medium = "(none)";
            
            return camp;
        }
        
    }
}