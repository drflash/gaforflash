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
	import flash.system.Capabilities;

	public class HTMLScreenDetails_AS
	{
		
		public static const SCREEN_OBJECT_REQUEST_STRING:String = "screen";
		public static const SCREEN_WIDTH_REQUEST_STRING:String = "screen.width";
		public static const SCREEN_HEIGHT_REQUEST_STRING:String = "screen.height";
		public static const SCREEN_COLORDEPTH_REQUEST_STRING:String = "screen.colorDepth";
		
		// only the used variables are obtained
		private var width_:Number;
		private var height_:Number;
		private var colorDepth_:Number;
		private var screenFound_:Boolean = false;
		
		public function get width():Number
		{
			return width_;
			
		}
		public function get height():Number
		{
			return height_;
			
		}
		public function get colorDepth():Number
		{
			return colorDepth_;
		}
		public function get screenFound():Boolean
		{
			return screenFound_;
		}
		
		
		
		public function HTMLScreenDetails_AS()
		{
			//var tempObj:Object = ExternalInterfaceMethods_AS.getDetailsFromHtmlDOM(SCREEN_OBJECT_REQUEST_STRING);
			//if(tempObj != null)
			{
				screenFound_  = true;
				width_ = Capabilities.screenResolutionX;
				height_ = Capabilities.screenResolutionY;
				
				//width_ = Number(ExternalInterfaceMethods_AS.getDetailsFromHtmlDOM(SCREEN_WIDTH_REQUEST_STRING));
				//height_ = Number(ExternalInterfaceMethods_AS.getDetailsFromHtmlDOM(SCREEN_HEIGHT_REQUEST_STRING));
				colorDepth_ = Number(ExternalInterfaceMethods_AS.getDetailsFromHtmlDOM(SCREEN_COLORDEPTH_REQUEST_STRING));
			}
		}

	}
}