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
	public class GA_OrganicReferrer_AS
	{
		public var engine_:String;
		public var keyword_:String;
		public function GA_OrganicReferrer_AS(engine:String, keyword:String)
		{
			 /**
		     * Organic source engine.
		     *
		     * @type {String}
		     * @ignore
		     */
		     this.engine_ = engine;  
		
		
		    /**
		     * Organic keyword.
		     *
		     * @type {String}
		     * @ignore
		     */
		   	this.keyword_ = keyword; 
		}

	}
}
