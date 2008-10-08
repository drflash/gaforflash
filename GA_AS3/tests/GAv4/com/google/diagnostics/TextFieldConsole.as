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
 *   Marc Alcaraz <ekameleon@gmail.com>
 *   Zwetan Kjukov <zwetan@gmail.com>.
 */
 
package com.google.diagnostics 
{
    import flash.text.TextField;
    
    import system.diagnostics.TraceConsole;    

    /**
     * The TextFieldConsole use a TextField display that redirect messages in the debug application.
     * <p><b>Note:</b> You can not read from the output and so the TextFieldConsole is not interactive.</p>
     */
    public class TextFieldConsole extends TraceConsole 
    {
        
        /**
         * Creates a new TextFieldConsole instance.
         * @param textfield The TextField reference to redirect the messages.
         */
        public function TextFieldConsole( textfield:TextField , verbose:Boolean=true )
        {
        	this.textfield = textfield ;
        	this.verbose   = verbose ;
        }
        
        /**
         * The TextField reference of this console.
         */
        public var textfield:TextField ;
        
        /**
         * Indicates the verbose mode.
         */
        public var verbose:Boolean ;
        
        /**
         * Appends the message format and add newline character.
         */        
        public override function writeLine( ...messages ):void
        {
            var msg:String = _formatMessage( messages ) ;
            
            msg = _buffer + msg  ;
            
            if ( verbose )
            {
                trace( msg ) ; 
            }
            
            var txt:String = textfield.text ;
            txt += msg + "\r" ;
            
            textfield.text = txt ;
            
            _buffer = "" ;
        }
        
    }
}
