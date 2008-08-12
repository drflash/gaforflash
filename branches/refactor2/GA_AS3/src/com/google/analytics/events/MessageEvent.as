
package com.google.analytics.events
{
    import flash.events.Event;

    public class MessageEvent extends Event
    {
        
        public static const INFO:String    = "info";
        public static const WARNING:String = "warning";
        
        public var message:String;
        
        public function MessageEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, message:String = "")
        {
            super(type, bubbles, cancelable);
            
            this.message = message;
        }
        
        override public function clone():Event
        {
            return new MessageEvent(type, bubbles, cancelable, message);
        }
        
    }
}