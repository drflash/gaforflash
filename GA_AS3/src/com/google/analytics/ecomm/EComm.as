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
    
	public class EComm
	{
		
  
  		private var transactions_:Array; 
  		public function get transactions():Array
  		{
  			return transactions_;
  		}



		public function EComm()
		{
			/**
		   * List of transation objects associated with this e-commerce instance.  Each
		   * instance of the e-commerce object could have 0 to many transactions.  And
		   * each transaction object could have 0 to many items.
		   *
		   * @private
		   * @type {Array}
		   */
		   transactions_ = [];
		}
		
		
		
		/**
		 * Creates a transaction object with the given values. As with _addItem(), only
		 * tracking for transactions is handled by this method. No additional ecommerce
		 * functionality is provided. Therefore, if the transaction is a duplicate of
		 * an existing transaction for that session, the old transaction values are
		 * over-written with the new transaction values.
		 *
		 * @example
		 * pageTracker._addTrans(
		 *     "1234",             // order ID - required
		 *     "My Partner Store", // affiliation or store name
		 *     "84.99",            // total - required
		 *     "7.66",             // tax
		 *     "15.99",            // shipping
		 *     "Boston",           // city
		 *     "MA",               // state or province
		 *     "USA"               // country
		 * );
		 *
		 * @private
		 * @param {String} orderId Internal unique order id number for this transaction.
		 * @param {String} affiliation Optional partner or store affiliation. (undefined
		 *     if absent)
		 * @param {String} total Total dollar amount of the transaction.
		 * @param {String} tax Tax amount of the transaction.
		 * @param {String} shipping Shipping charge for the transaction.
		 * @param {String} city City to associate with transaction.
		 * @param {String} state State to associate with transaction.
		 * @param {String} country Country to associate with transaction.
		 *
		 * @return {_gat.GA_EComm_.Transactions_} The tranaction object that was
		 *     modified.
		 */
		public function addTransaction_ (orderId:String,
                                          affiliation:String,
                                          total:String,
                                          tax:String,
                                          shipping:String,
                                          city:String,
                                          state:String,
                                          country:String):ECommTransaction
		   {
			  //var selfRef = this;
			  var nsCache:Utils = Utils.getGAUTIS();
			  var matchedTransaction :ECommTransaction= getTransaction_(orderId);
			
			  // add new transaction
			  if (nsCache.undef_ == matchedTransaction) 
			  {
				    matchedTransaction = new  ECommTransaction(
				        orderId,
				        affiliation,
				        total,
				        tax,
				        shipping,
				        city,
				        state,
				        country
				    );
	
	    		nsCache.arrayPush_(transactions_, matchedTransaction);
	
	  		// duplicate / previously existing transaction
	  		} 
	  		else 
	  		{
			    matchedTransaction.affiliation = affiliation;
			    matchedTransaction.total = total;
			    matchedTransaction.tax = tax;
			    matchedTransaction.shipping = shipping;
			    matchedTransaction.city = city;
			    matchedTransaction.state = state;
			    matchedTransaction.country = country;
			}

  			return matchedTransaction;
		}


		/**
		 * Takes an order Id, and returns the corresponding transaction object.  If the
		 * transaction is not found, return undefined.
		 *
		 * @private
		 * @param {String} orderId Internal unique order id number for this transaction.
		 *
		 * @return {_gat.GA_EComm_.Transactions_} Transaction object with the specified
		 *     order Id.
		 */
		 public function getTransaction_ (orderId:String) :ECommTransaction
		 {
		 	
			  var returnTransaction:ECommTransaction;
			  var transactions:Array = transactions_;
			  var idx:Number;
			
			  for (idx = 0; idx < transactions.length; idx++) 
			  { 
			    returnTransaction = (orderId == transactions[idx].id_) ?
			                        transactions[idx] :
			                        returnTransaction;
			  }
			
			  return returnTransaction; 
		}





	}
}