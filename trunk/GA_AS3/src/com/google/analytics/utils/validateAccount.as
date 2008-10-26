package com.google.analytics.utils
{
    /**
    * Checks if the paramater is a GA account ID.
    */
    public function validateAccount( account:String ):Boolean
    {
        var rel:RegExp = /^UA-[0-9]*-[0-9]*$/;
        
        return rel.test(account);
    }
}
