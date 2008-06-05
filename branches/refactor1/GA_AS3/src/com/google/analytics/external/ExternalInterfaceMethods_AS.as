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

package com.google.analytics.external
{
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.external.ExternalInterface;
	
	public class ExternalInterfaceMethods_AS
	{
		
		

		/*  sample xml variable to call the external interface
		
			static var domainRequest :XML =     
					 <script>
						<![CDATA[            
							function(){                
								return document.charset;           
									}        ]]>   
				   </script>
				   
		how to call --- var result:Object = ExternalInterface.call(domainRequest);
		referance - http://www.actionscript.org/resources/articles/745/1/JavaScript-and-VBScript-Injection-in-ActionScript-3/Page1.html
		*/
	
	/*  sample xml variable to call the external interface */
		
		private	static var imageCreationRequest :XML =     
					 <script>
						<![CDATA[            
							function(soruceString){  
								function uVoid() {
										    return; 
										   }              
									image01= new Image();
									image01.src=soruceString ;
									image01.onload =  uVoid;  
									}        ]]>   
				   </script>
				   
		/*how to call --- var result:Object = ExternalInterface.call(domainRequest);
		referance - http://www.actionscript.org/resources/articles/745/1/JavaScript-and-VBScript-Injection-in-ActionScript-3/Page1.html
		*/
	

		private static function getGetterFunctionString(requiredDataString:String):String
		{
			var functionString:String = "function(){return "  + requiredDataString + ";}";
			
			return functionString;
		}
			
		private static function getSetterFunctionString(fieldString:String,detailsString:String):String
		{
			var functionString:String = "function(){ "+ fieldString + "=\""+ detailsString+"\";}";
			
			return functionString;
		}	
			
		private static function getEvalFunctionString(requiredDataString:String):String
		{
			var functionString:String = "function(){return eval( "  + requiredDataString + ");}";
			
			return functionString;
		}	

		public  function ExternalInterfaceMethods_AS()
		{
		
		}
		
		// HTML document infomration
		public static function getDetailsFromHtmlDOM(requestString:String):Object
		{
			// the user needs to figure out what is the type they are recieving and they can use it accordinglly
			var fucntionString:String = getGetterFunctionString(requestString);
			var result:Object;
			if(ExternalInterface.available)
			{
				try
				{
				 	result = ExternalInterface.call(fucntionString);
				}
				catch (e:Error)
				{
					trace(e.message);
				}
			}
			return result;
		}
		
		public static function callMethod(requestString:String):Object
		{
			var fucntionString:String = getEvalFunctionString(requestString);
			var result:Object;
			if(ExternalInterface.available)
			{
				try
				{
				 	result = ExternalInterface.call(fucntionString);
				}
				catch (e:Error)
				{
					trace(e.message);
				}
			}
			return result;
		}
		public static function setDetailsOnHtmlDOM(fieldString:String, detatilsString:String):void
		{
			// the user needs to figure out what is the type they are recieving and they can use it accordinglly
			var fucntionString:String = getSetterFunctionString(fieldString,detatilsString);
			if(ExternalInterface.available)
			{
				try
				{
					ExternalInterface.call(fucntionString);
				}
				catch (e:Error)
				{
					trace(e.message);
				}
				
			}
		}
		
		
		public static function createImageinHTML(sourceString:String):void
		{
		   /*  replaced the flash way
			if(ExternalInterface.available)
				ExternalInterface.call(imageCreationRequest,sourceString);
				*/
			 var imageRequest:URLRequest = new URLRequest(sourceString);  
			 var imageLoader:Loader = new Loader();
    		 imageLoader.load(imageRequest);

         
		}
		
		public static function getElementById(idString:String):Object
		{
			var funcString:String = getGetterFunctionString("getElementById("+idString+")");
			var requiredObj:Object;
			if(ExternalInterface.available)
			{				
				try
				{
					requiredObj=  ExternalInterface.call(funcString);
				}
				catch (e:Error)
				{
					trace(e.message);
				}
			}
			
			return requiredObj;
		}

	}
	
	/*
	import flash.external.ExternalInterface;
	var myJavaScript :XML =     
		<script>        
			<![CDATA[            
				function(myFoo){                
					function myFunc (str){                     
						return str.toUpperCase()                 
						};                 
						var anonResult = myFunc(myFoo);                 
						return anonResult;            
						}        ]]>   
	  </script>
	  
	  var myResult = ExternalInterface.call(myJavaScript , "foobar");*/
	
}