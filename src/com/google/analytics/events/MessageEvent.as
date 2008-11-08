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

package com.google.analytics.events
{
    import flash.events.Event;    

    /**
     * The event invoked in a warning or info message is dispatched in the GA tracker.
     */
    public class MessageEvent extends Event
    {
        
        /**
         * Defines the value of the type property of an info message event object.
         * @eventType info
         */
        public static const INFO:String    = "info";
        
        /**
         * Defines the value of the type property of a warning message event object.
         * @eventType warning
         */
        public static const WARNING:String = "warning";
        
        /**
         * The message value of this event.
         */
        public var message:String;
        
        /**
         * Creates a new MessageEvent instance.
         * @param type the string type of the instance. 
         * @param bubbles indicates if the event is a bubbling event.
         * @param cancelable indicates if the event is a cancelable event.
         * @param message the message value of the event.
         */
        public function MessageEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, message:String = "")
        {
            super(type, bubbles, cancelable);
            this.message = message;
        }
        
        /**
         * Returns the shallow copy of this event.
         * @return the shallow copy of this event.
         */
        public override function clone():Event
        {
            return new MessageEvent(type, bubbles, cancelable, message);
        }
        
    }
}