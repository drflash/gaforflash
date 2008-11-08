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

package
{
    import buRRRn.ASTUce.Runner;
    import buRRRn.ASTUce.config;
    
    import system.config;
    import system.console;
    import system.ui.TextFieldConsole;
    
    import com.google.analytics.AllTests;
    
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.text.TextField;
    import flash.text.TextFormat;    

    [SWF(width="800", height="600", backgroundColor='0x333333', frameRate='24', pageTitle='GA unit tests', scriptRecursionLimit='1000', scriptTimeLimit='60')]
    [ExcludeClass]
    public class GA_TestRunner extends Sprite
        {
        
        /**
         * Creates a new GA_TestRunner instance. 
         */
        public function GA_TestRunner()
            {
            
            // init
            
            stage.align     = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            
            textfield                   = new TextField();
            textfield.defaultTextFormat = new TextFormat( "Courier New" , 14 , 0xFFFFFF );
            textfield.multiline         = true;
            textfield.selectable        = true;
            textfield.wordWrap          = true;
                
            addChild( textfield ) ;
                
            stage.addEventListener( Event.RESIZE , resize );
            resize();
            
            console = new TextFieldConsole( textfield );
            
            system.config.serializer.prettyPrinting  = true;
            
            buRRRn.ASTUce.config.showConstructorList = false;
            
            // testing
            
            Runner.main( com.google.analytics.AllTests.suite() );
            
            
            }
            
        /**
         * The debug textfield of this application.
         */
        public var textfield:TextField ;
        
        /**
         * Invoked to resize the application content.
         */
        public function resize( e:Event = null ):void
            {
            textfield.width  = stage.stageWidth ;
            textfield.height = stage.stageHeight ;
            }
            
        }
    }


