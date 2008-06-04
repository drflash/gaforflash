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

package com.Adobe.analytics.google.ecomm
{
	import com.Adobe.analytics.google.GA_utils_AS;
	public class GA_EComm_Transactions
	{
		
		 
  
		/**
		 * @class Transaction object for e-commerce module.  This encapsulates all the
		 *     necessary logic for manipulating a transaction.
		 *
		 * @private
		 * @param {String} orderId Internal unique order id number for this transaction.
		 * @param {String} affiliation Optional partner or store affiliation (undefined
		 *     if absent)
		 * @param {String} total Total dollar amount of the transaction.
		 * @param {String} tax Tax amount of the transaction.
		 * @param {String} shipping Shipping charge for the transaction.
		 * @param {String} city City to associate with transaction.
		 * @param {String} state State to associate with transaction.
		 * @param {String} country Country to associate with transaction.
		 *
		 * @constructor
		 */
			  
		  
		  //**********************
		  /**
		   * Internal unique order id number for this transaction.
		   *
		   * @private
		   * @type {String}
		   */
		   private var id_ :String;
		   public function get id():String
		   {
		   	return id_;
		   }
		   public function set id(id:String):void
		   {
		   	 id_ = id;
		   }
		  
		  
		  
		  
		  //**********************
		  /**
		   * Optional partner or store affiliation. (undefined if absent)
		   *
		   * @private
		   * @type {String}
		   */
		  private var affiliation_:String ;
		   public function get affiliation():String
		   {
		   	return affiliation_;
		   }
		   public function set affiliation(affiliation:String):void
		   {
		   	 affiliation_ = affiliation;
		   }
  
   		  
		  
		  //**********************
		 /**
		   * Total dollar amount of the transaction.
		   *
		   * @private
		   * @type {String}
		   */
		  private var total_:String;
		   public function get total():String
		   {
		   	return total_;
		   }
		   public function set total(total:String):void
		   {
		   	 total_ = total;
		   }
		  
			  
		  
		  //**********************
		/**
		   * Tax amount of the transaction. (ie: "0.49")
		   *
		   * @private
		   * @type {String}
		   */
		  private var tax_ :String;
		   public function get tax():String
		   {
		   	return tax_;
		   }
		   public function set tax(tax:String):void
		   {
		   	 tax_ = tax;
		   }
		  
			  
		  
		  //**********************
		/**
		   * Shipping charge for the transaction. (ie: "1.69")
		   *
		   * @private
		   * @type {String}
		   */
		  private var shipping_:String;
		   public function get shipping():String
		   {
		   	return shipping_;
		   }
		   public function set shipping(shipping:String):void
		   {
		   	 shipping_ = shipping;
		   }
		  
			  
		  
		  //**********************
		/**
		   * City to associate with transaction.
		   *
		   * @private
		   * @type {String}
		   */
		  private var city_ :String;
		   public function get city():String
		   {
		   	return city_;
		   }
		   public function set city(city:String):void
		   {
		   	 city_ = city;
		   }
 	 		  
 	 		  
		  
		  //**********************
 		 /**
		   * State to associate with transaction.
		   *
		   * @private
		   * @type {String}
		   */
  		   private var state_:String;
		   public function get state():String
		   {
		   	return state_;
		   }
		   public function set state(state:String):void
		   {
		   	 state_ = state;
		   }
  				  
		  
		  //**********************   
		/**
		   * Country to associate with transaction.
		   *
		   * @private
		   * @type {String}
		   */
  		   private var country_:String; 
		   public function get country():String
		   {
		   	return country_;
		   }
		   public function set country(country:String):void
		   {
		   	 country_ = country;
		   }
  		  	
  		  		  
		  
		  //********************** 
  		/**
		   * Items associated with this transaction.  There could be 0 to many items per
		   * transaction.
		   *
		   * @private
		   * @type {Array}
		   */
  		   private var items_:Array = [];
		   public function get items():Array
		   {
		   	return items_;
		   }
		   public function set items(items:Array):void
		   {
		   	 items_ = items;
		   }
		   
		   
  		   
		public function GA_EComm_Transactions(orderId:String,
                                        affiliation:String,
                                        total:String,
                                        tax:String,
                                        shipping:String,
                                        city:String,
                                        state:String,
                                        country:String)
		{
			id_ = orderId;
			affiliation_ = affiliation;
			total_ = total;
			tax_ = tax;
			shipping_ = shipping;
			city_ = city;
			state_ = state;
			country_ = country;
		}

		/**
		 * Adds a transaction item to the parent transaction object. Requires the
		 * trackTrans() method. Use this method to track items purchased by visitors to
		 * your ecommerce site. If the item being added is a duplicate (by SKU) of an
		 * existing item, then the old information is replaced with the new. If no
		 * parent transaction object has been created, an empty transaction object is
		 * created for the item to be added to.
		 *
		 * @example
		 * pageTracker._addItem(
		 *   "343212", //order ID
		 *   "DD4444", //sku
		 *   "Lava Lamp", // product name
		 *   "Decor", // category or product variation
		 *   "34.99", // price
		 *   "1"  //quantity
		 * );
		 *
		 * @private
		 * @param {String} sku Item's SKU code.
		 * @param {String} name Product name.
		 * @param {String} category Product category.
		 * @param {String} price Product price (required).
		 * @param {String} quantity Purchase quantity (required).
		 */
		public function addItem_ (sku:String,
                                name:String,
                                category:String,
                                price:String,
                                quantity:String) :void
       {
		  //var selfRef = this;
		  var dupItems:GA_EComm_Items_AS = getItem_(sku);
		  var id:String = id_;
		  var nsCache:GA_utils_AS = GA_utils_AS.getGAUTIS();
		
		  // add new transaction
		  if (nsCache.undef_ == dupItems) {
		    nsCache.arrayPush_(
		        items_,
		        new GA_EComm_Items_AS(id, sku, name, category, price, quantity)
		    );
		
		  // duplicate / previously existing transaction
		  } 
		  else 
		  {
		    dupItems.transid = id;
		    dupItems.sku = sku;
		    dupItems.name = name;
		    dupItems.category = category;
		    dupItems.price = price;
		    dupItems.quantity = quantity;
		  }
	 }


	/**
	 * Takes a sku, and returns the corresponding item object.  If the item is not
	 * found, return undefined.
	 *
	 * @private
	 * @param {String} sku SKU code for item.
	 *
	 * @return {_gat.GA_EComm_.Items_} Item object with the specified sku. 
	 */
	public function getItem_(sku:String):GA_EComm_Items_AS {
	  var returnItem:GA_EComm_Items_AS;
	  
	  var items:Array = items_;
	  var idx:Number;
	
	  for (idx = 0; idx < items.length; idx++) 
	  {
	    returnItem = (sku == items[idx].sku_) ? items[idx] : returnItem;
	  }
	
	  return returnItem;
	};


	/**
	 * Converts this transactions object to gif parameters.
	 *
	 * @private
	 * @returns {String} GIF request parameters for this transaction.
	 */
	public function toGifParams_():String 
	{
	  //var selfRef = this;
	  var encoderCache:Function = GA_utils_AS.getGAUTIS().encodeWrapper_; 
  
	  return "&" + [
	      "utmt=tran",
	      "utmtid=" + encoderCache(id_),
	      "utmtst=" + encoderCache(affiliation_),
	      "utmtto=" + encoderCache(total_),
	      "utmttx=" + encoderCache(tax_),
	      "utmtsp=" + encoderCache(shipping_),
	      "utmtci=" + encoderCache(city_),
	      "utmtrg=" + encoderCache(state_),
	      "utmtco=" + encoderCache(country_)
	  ].join("&");
	}


	}
}