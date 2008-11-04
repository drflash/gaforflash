package com.google.analytics
{
    import com.google.analytics.utils.Version;
    
    public class API
    {
        public function API()
        {
        }
        
        /**
        * version of Google Analytics AS3 API
        * 
        * note:
        * each components share the same code base and so the same version
        */
        public static var version:Version = new Version();
        include "version.properties"
        version.revision = "$Rev$ ".split( " " )[1];
        
    }
}