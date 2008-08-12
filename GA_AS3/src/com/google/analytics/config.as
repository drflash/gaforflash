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

package com.google.analytics
{
    import com.google.analytics.v4.Configuration;
    
    /**
    * config is a singleton
    * 
    * we have mostly public read/write properties
    * and getters/setters.
    * 
    * we want to always have the same access point
    * but be able to switch from one configuration to another
    * (GA v4, v5, etc.).
    * 
    * to configure options in the components it should
    * be easier to have this global object.
    */
    public const config:Configuration = new Configuration();
}

