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

package com.google.analytics.ecomm
{
    import com.google.analytics.Utils;
    
	public class ECommItem
	{
		
		/**
		 * @class Item object for e-commerce module.  This encapsulates all the
		 *     necessary logic for manipulating an item.
		 *
		 * @param {String} transId Id of transaction this item belongs to.
		 * @param {String} sku SKU code for item.
		 * @param {String} name Product name.
		 * @param {String} category Product category.
		 * @param {String} price Product price.
		 * @param {String} quantity Purchase quantity.
		 *
		 * @private
		 * @constructor
		 */
		
		  // caching for better file size optimization
		
		  //***************************
		  /**
		   * Id of transaction this item belongs to.
		   *
		   * @private
		   * @type {String}
		   */
		   private var transid_:String ;
		   public function get transid():String
		   {
		   	return transid_;
		   }
		   public function set transid(transid:String):void
		   {
		   	 transid_ = transid;
		   }
		   
		   
		   
		//***************************
		  /**
		   * SKU code for this item.
		   *
		   * @private
		   * @type {String}
		   */
		   private var sku_:String;
		   public function get sku():String
		   {
		   	return sku_;
		   }
		   public function set sku(sku:String):void
		   {
		   	 sku_ = sku;
		   }
		
		
		  //***************************
		  /**
		   * Product name.
		   *
		   * @private
		   * @type {String}
		   */
		  private var name_:String;
		   public function get name():String
		   {
		   	return name_;
		   }
		   public function set name(name:String):void
		   {
		   	 name_ = name;
		   }
		  
		
		 //***************************
		  /**
		   * Product category.
		   *
		   * @private
		   * @type {String}
		   */
		  private var category_:String;
		   public function get category():String
		   {
		   	return category_;
		   }
		   public function set category(category:String):void
		   {
		   	 category_ = category;
		   }
		
		
		 //***************************
		  /**
		   * Product price. (ie: "2.99")                 
		   *
		   * @private
		   * @type {String}
		   */
		  private var price_:String ;
		   public function get price():String
		   {
		   	return price_;
		   }
		   public function set price(price:String):void
		   {
		   	 price_ = price;
		   }
		
		
		 //***************************
		  /**
		   * Purchase quantity.  (ie: "5")
		   *
		   * @private
		   * @type {String}
		   */
		  private var quantity_:String ;
		   public function get quantity():String
		   {
		   	return quantity_;
		   }
		   public function set quantity(quantity:String):void
		   {
		   	 quantity_ = quantity;
		   }


			public function ECommItem(transId:String,
		                                 sku:String,
		                                 name:String,
		                                 category:String,
		                                 price:String,
		                                 quantity:String)
			{
				 transid_ = transId;
				 sku_ = sku;
				 name_ = name;
				 category_ = category;
				 price_ = price;
				 quantity_ = quantity;
			}
		
		
		/**
		 * Converts this items object to gif parameters.
		 *
		 * @private
		 * @param {String} sessionId Session Id for this e-commerce transaction.
		 *
		 * @returns {String} GIF request parameters for this item.
		 */
		public function toGifParams_():String
		{
		  //var selfRef = this;
		  var encoderCache:Function = Utils.getGAUTIS().encodeWrapper_;
		  
		  return "&" + [
		      "utmt=item",
		      "utmtid=" + encoderCache(transid_),
		      "utmipc=" + encoderCache(sku_),
		      "utmipn=" + encoderCache(name_),
		      "utmiva=" + encoderCache(category_),
		      "utmipr=" + encoderCache(price_),
		      "utmiqt=" + encoderCache(quantity_)
		  ].join("&");
		};

	}
}