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
 *   Marc Alcaraz <ekameleon@gmail.com>.
 */

package com.google.analytics.external
{
    import com.google.analytics.debug;
    import flash.external.ExternalInterface;
    
    /**
     * Javascript proxy access class.
     */
    public class JavascriptProxy
    {

    	/**
    	 * The setProperty Javascript injection.
    	 */
        public static var setProperty_js:XML = 
            <script>
                <![CDATA[
                function( path , value )
                {
                    var paths;
                    var prop;
                    if( path.indexOf(".") > 0 )
                    {
                        paths = path.split(".");
                        prop  = paths.pop() ;
                    }
                    else
                    {
                        paths = [];
                        prop  = path;
                    }
                    var target = window ;
                    var len    = paths.length ;
                    for( var i = 0 ; i < len ; i++ )
                    {
                        target = target[ paths[i] ] ;
                    }
                    
                    target[ prop ] = value ;
                }
                ]]>
            </script>;
        
        
        /**
         * Creates a new JavascriptProxy instance.
         */
        public function JavascriptProxy()
        {
        }

		/**
		 * Sets the value of a DOM property
		 */            
        protected function setProperty( path:String, value:* ):void
        {
            jsExternal( setProperty_js, path, value );
        }
        
        /**
        * Returns the value of a DOM object
        */  
        public function getProperty( name:String ):*
        {
    		var getFcn:String = "function () { return "+ name +"; }";
        	
        	return jsExternal( getFcn );
        	
        }    
        
        /**
         * Indicates if the javascript proxy is available.
         */
        public function isAvailable():Boolean
        {
            return ExternalInterface.available;
        }
        
        /**
         * This function communicates between Flash and the JS browser DOM. It can except either a string or  
		 * XML for JS injection. 
         * 
         */        
        public function jsExternal(jsMethodName:String, ... args):*
		{	
			var jsResult:*;
			if(ExternalInterface.available)
			{
				try
				{

					if (debug.verbose) {
						var output:String = "";
						
						output = "Flash calling JS function: "+ jsMethodName;
						if (args.length > 0) {
							output += "\nParams: "+ args.join(",");
						} 
						debug.info(output);
					}

					args.unshift(jsMethodName);
					jsResult = ExternalInterface.call.apply(ExternalInterface, args);
					return jsResult;
				}
				catch(e:SecurityError)
				{
					debug.warning("ExternalInterface is not available.  Ensure that allowScriptAccess is set to 'always' in the Flash embed HTML.");
				}
				catch(e:Error)
				{
					debug.warning("ExternalInterface failed to make the call, reason: " + e.message);
				}
			}
			else
			{
				debug.warning("ExternalInterface is not available.");
			}
		}
            
    }
}