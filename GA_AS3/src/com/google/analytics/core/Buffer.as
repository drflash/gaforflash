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

package com.google.analytics.core
{
    import com.google.analytics.data.GASO;
    import com.google.analytics.data.UTMA;
    import com.google.analytics.data.UTMB;
    import com.google.analytics.data.UTMC;
    import com.google.analytics.data.UTMK;
    import com.google.analytics.data.UTMV;
    import com.google.analytics.data.UTMX;
    import com.google.analytics.data.UTMZ;    

    /**
     * Google Analytics Tracker Code (GATC)'s memory module.
     */
    public class Buffer
    {
        
        /**
         * The UTMA reference of the buffer.
         * @see com.google.analytics.data.UTMA
         */
        public var utma:UTMA;

        /**
         * The UTMB reference of the buffer.
         * @see com.google.analytics.data.UTMB
         */
        public var utmb:UTMB;

        /**
         * The UTMC reference of the buffer.
         * @see com.google.analytics.data.UTMC
         */
        public var utmc:UTMC;

        /**
         * The UTMK reference of the buffer.
         * @see com.google.analytics.data.UTMK
         */
        public var utmk:UTMK;

        /**
         * The UTMV reference of the buffer.
         * @see com.google.analytics.data.UTMV
         */
        public var utmv:UTMV;

        /**
         * The UTMX reference of the buffer.
         * @see com.google.analytics.data.UTMX
         */
        public var utmx:UTMX;

        /**
         * The UTMZ reference of the buffer.
         * @see com.google.analytics.data.UTMZ
         */
        public var utmz:UTMZ;
        
        /**
         * The GASO reference of the buffer.
         * @see com.google.analytics.data.GASO
         */
        public var gaso:GASO;
        
        /**
         * Creates a new Buffer instance.
         */
        public function Buffer()
        {
            this.utmv = new UTMV();
        }

    }
}
