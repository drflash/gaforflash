
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
    import flash.errors.IllegalOperationError;
    import flash.text.TextField;
    
    import system.Strings;
    import system.terminals.Console;    

    /**
     * The TextFieldConsole use a TextField display that redirect messages in the debug application.
     * <p><b>Note:</b> You can not read from the output and so the TextFieldConsole is not interactive.</p>
     */
    public class TextFieldConsole implements Console 
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
         * Not supported, the console isn't interactive.
         * @throws flash.errors.IllegalOperationError The read() method is illegal in this console
         */        
        public function read():String
        {
            throw new IllegalOperationError( this + " read() method is illegal in this console." ) ;
        }

        /**
         * Not supported, the console isn't interactive.
         * @throws flash.errors.IllegalOperationError The readLine() method is illegal in this console
         */           
        public function readLine():String
        {
            throw new IllegalOperationError( this + " readLine() method is illegal in this console." ) ;
        }

        /**
         * Appends the message format.
         */        
        public function write( ...messages ):void
        {
            _buffer += _formatMessage( messages ) ;
        }

        /**
         * Appends the message format and add newline character.
         */        
        public function writeLine( ...messages ):void
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

        /**
         * @private
         */
        private var _buffer:String = "" ;

        /**
         * Formats the specific messages.
         * @param messages The Array representation of all message to format.
         * @private 
         */
        private function _formatMessage( messages:Array ):String
        {
            if( messages.length == 0 )
            {
                return "";
            }
            
            var msg:String = String( messages.shift( ) );
            
            if( messages.length == 0 )
            {
                return msg ;
            }
            
            messages.unshift( msg );
            return Strings.format.apply( Strings, messages );
        }           
    }
}
