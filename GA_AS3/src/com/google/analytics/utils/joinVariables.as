package com.google.analytics.utils
{
    import flash.net.URLVariables;
    
    public function joinVariables( ...variables ):URLVariables
    {
        var allvars:URLVariables = new URLVariables();
        var current:URLVariables;
        
        for( var i:int = 0; i<variables.length; i++ )
        {
            if( !(variables[i] is URLVariables) || !variables[i] )
            {
                continue;
            }
            
            current = variables[i];
            for( var prop:String in current )
            {
                allvars[prop] = current[prop];
            }
        }
        
        return allvars;
    }
}