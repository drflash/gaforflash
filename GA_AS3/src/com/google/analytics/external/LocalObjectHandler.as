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

package com.Adobe.analytics.external
{
	import flash.net.SharedObject;
	public class LocalObjectHandler
	{
		public static const LOCAL_OBJ_NAME:String = "GA_Variables";
		public static const APPLICATION_EXPIRY:String = "Application_Exp";
		public static var utmcWritten:Boolean = false; // utmc life is application life.
			// hence the utmc's written from the current application scope only will be read.
	
	
		public static var gasoWritten:Boolean = false; // gaso life is application life.
			// hence the gaso's written from the current application scope only will be read.
			
		private static var googleVariable_:SharedObject;
		private static var useLocalObject_:Boolean = true;
		private static var useSameObject_:Boolean = false;
		
		public function LocalObjectHandler()
		{
			
		}
		
		public static function get useLocalObject():Boolean
		{
			return useLocalObject_ ;
		}
		
		public static function set useLocalObject(status:Boolean):void
		{
			useLocalObject_ = status;
		}
		
	
		public static function get useSameObject():Boolean
		{
			return useSameObject_;
		}
		public static function set useSameObject(flag:Boolean):void
		{
			useSameObject_ = flag;
		}
		
		public static function init(localObjectPath:String):SharedObject
		{
			//if(!googleVariable_) // we need to always load fresh as 
			// is possible that another instance of the application also can write the cookies.
			// we need to get the latest.
			
			// check whether we need to init the object
			
			var initObject:Boolean = false;
			
			if(!useSameObject_)
				initObject = true;
			else if(!googleVariable_)
				initObject = true;
			
			
			if( initObject)
			{
				var path:String;
				if(localObjectPath != "/")
					path = "/"+localObjectPath;
				else	
					path = "/";
			
				try
				{
					googleVariable_ = SharedObject.getLocal(LOCAL_OBJ_NAME,path);
				}		
				catch (er:Error)
				{
					trace(er.message+" The path you mentioned  is not part of the complete swf path. Hence resetting to default");
					path = "/";
					googleVariable_ = SharedObject.getLocal(LOCAL_OBJ_NAME, path);
					
				}
			}
			
			return googleVariable_;
		}
		
		public static function getUtmaValue(localObjectPath:String):String
		{
			init(localObjectPath);
			if(googleVariable_.data.utmaExpiry > new Date())
				return googleVariable_.data.utmaValue;
			else
			{
				if(googleVariable_.data.utmaExpiry)
				{
					googleVariable_.data.utmaValue = "";
					googleVariable_.data.utmaExpiry = "";
				}
				return "";
			}
		
			
		}
		public static function getUtmbValue(localObjectPath:String):String
		{
			
			init(localObjectPath);
			if(googleVariable_.data.utmbExpiry > new Date())
				return googleVariable_.data.utmbValue;
			else
			{
				if(googleVariable_.data.utmbExpiry)
				{
					googleVariable_.data.utmbValue = "";
					googleVariable_.data.utmbExpiry = "";
				}
				return "";
			}
			
		}
		public static function getUtmcValue(localObjectPath:String):String
		{
			if(utmcWritten == true)
			{
				init(localObjectPath);
				return googleVariable_.data.utmcValue;
			}
			else
			{
				googleVariable_.data.utmbValue = "";
				return "";
			}
		}
		
		public static function getUtmzValue(localObjectPath:String):String
		{
			init(localObjectPath);
			if(googleVariable_.data.utmzExpiry > new Date())
				return googleVariable_.data.utmzValue;
			else
			{	
				if(googleVariable_.data.utmzExpiry)
				{
					googleVariable_.data.utmzValue = "";
					googleVariable_.data.utmzExpiry = "";
				}
				
				return "";
			}
			
		}
		
		public static function getUtmxValue(localObjectPath:String):String
		{
			init(localObjectPath);
			if(googleVariable_.data.utmxExpiry > new Date())
				return googleVariable_.data.utmxValue;
			else
			{
				if(googleVariable_.data.utmxExpiry)
				{
					googleVariable_.data.utmxValue = "";
					googleVariable_.data.utmxExpiry = "";
				}
				return "";
			}
			
		}
		
		
		public static function getUtmvValue(localObjectPath:String):String
		{
			init(localObjectPath);
			if(googleVariable_.data.utmvExpiry > new Date())
				return googleVariable_.data.utmvValue;
			else
			{
				if(googleVariable_.data.utmvExpiry)
				{
					googleVariable_.data.utmvValue = "";
					googleVariable_.data.utmvExpiry = "";
				}
				return "";
			}
			
		}
		
		
		public static function getGASOValue(localObjectPath:String):String
		{
			if(gasoWritten == true)
			{
				init(localObjectPath);
				return googleVariable_.data.gasoValue;
			}
			else
			{
				googleVariable_.data.gasoValue = "";
				return "";
			}
			
		}
		
		
		public static function writeUtmaDetails(value:String,expiryInfo:Date,localObjectPath:String):void
		{
			init(localObjectPath);
			googleVariable_.data.utmaValue = value;
			googleVariable_.data.utmaExpiry = expiryInfo;
			googleVariable_.flush();
		}
		
		public  static function writeUtmbDetails(value:String,expiryInfo:Date,localObjectPath:String):void
		{
			
			init(localObjectPath);
			googleVariable_.data.utmbValue = value;
			googleVariable_.data.utmbExpiry = expiryInfo;
			googleVariable_.flush();
		}
		
		public static function writeUtmcDetails(value:String,expiryInfo:Date,localObjectPath:String):void
		{
			init(localObjectPath);
			googleVariable_.data.utmcValue = value;
			if(expiryInfo == null)
				googleVariable_.data.utmcExpiry = APPLICATION_EXPIRY;
			else
				googleVariable_.data.utmcExpiry = expiryInfo;
			utmcWritten = true;// this is needed to ensure that we read only the values written 
			// byt the current instance of the application.
			googleVariable_.flush();
		}
		
		public static function writeUtmzDetails(value:String,expiryInfo:Date,localObjectPath:String):void
		{
			init(localObjectPath);
			googleVariable_.data.utmzValue = value;
			googleVariable_.data.utmzExpiry = expiryInfo;
			googleVariable_.flush();
		}
		
		public static function writeUtmxDetails(value:String,expiryInfo:Date,localObjectPath:String):void
		{
			
			init(localObjectPath);
			googleVariable_.data.utmxValue = value;
			googleVariable_.data.utmxExpiry = expiryInfo;
			googleVariable_.flush();
		}
		
		
		public static function writeUtmvDetails(value:String,expiryInfo:Date,localObjectPath:String):void
		{
			init(localObjectPath);
			googleVariable_.data.utmvValue = value;
			googleVariable_.data.utmvExpiry = expiryInfo;
			googleVariable_.flush();
		}

		public static function writeGASODetails(value:String,expiryInfo:Date,localObjectPath:String):void
		{
			init(localObjectPath);
			googleVariable_.data.gasoValue = value;
			if(expiryInfo == null)
				googleVariable_.data.gasoExpiry = APPLICATION_EXPIRY;
			else
				googleVariable_.data.gasoExpiry = expiryInfo;
			gasoWritten  = true;// this is needed to ensure that we read only the values written 
			// byt the current instance of the application.
			googleVariable_.flush();
		}
	}
}