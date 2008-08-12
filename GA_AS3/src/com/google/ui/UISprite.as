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

package com.google.ui
{
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.Event;    

    /**
     * The core UISprite class.
     */
    public class UISprite extends Sprite
    {
    	
    	/**
    	 * Indicates the display object align target.
    	 */
    	protected var alignTarget:DisplayObject;
    	
    	/**
    	 * Indicates if the resize process is listening. 
    	 */
        protected var listenResize:Boolean;
        
        /**
         * Indicates the alignement reference of this sprite.
         */
        public var alignement:Align;
        
        /**
         * Indicates the margin reference of this sprite.
         */
        public var margin:Margin;
        
        /**
         * Creates a new UISprite instance.
         */
        public function UISprite()
        {
            super();
            listenResize = false;
            
            alignement   = Align.none;
            alignTarget  = null;
            margin       = new Margin();
            
            addEventListener( Event.ADDED_TO_STAGE, _onAddedToStage );
            
        }
        
        /**
         * @private
         */
        private function _onAddedToStage( event:Event ):void
        {
            layout();
            resize();
        }
        
        /**
         * Layout the display.
         */
        protected function layout():void
        {
            //trace( "UISprite.layout" );
        }        
        
        /**
         * Invoked when the stage is resized.
         */
        protected function onResize( event:Event ):void
        {
            //trace( "UISprite.onResize" );
            resize();
        }
        
        /**
         * Align the specified display with the specified alignement value.
         */
        public function alignTo( alignement:Align, target:DisplayObject = null ):void
        {
            
            if( target == null )
            {
                target = this.stage;
            }
            
            var H:uint;
            var W:uint;
            
            if( target == this.stage )
            {
                if( this.stage == null )
                {
                    trace( "stage is null" );
                    return;
                }
                
                H = this.stage.stageHeight;
                W = this.stage.stageWidth;
            }
            else
            {
                H = target.height;
                W = target.width;
            }
            
            switch( alignement )
            {
                case Align.top:
                x = (W/2)-(width/2);
                y = target.y + margin.top;
                break;
                
                case Align.bottom:
                x = (W/2)-(width/2);
                y = (target.y+H)-height - margin.bottom;
                break;
                
                case Align.left:
                x = target.x + margin.left;
                y = (H/2)-(height/2);
                break;
                
                case Align.right:
                x = (target.x+W)-width - margin.right;
                y = (H/2)-(height/2);
                break;
                
                case Align.center:
                x = (W/2)-(width/2);
                y = (H/2)-(height/2);
                break;
                
                case Align.topLeft:
                x = target.x + margin.left;
                y = target.y + margin.top;
                break;
                
                case Align.topRight:
                x = (target.x+W)-width - margin.right;
                y = target.y + margin.top;
                break;
                
                case Align.bottomLeft:
                x = target.x + margin.left;
                y = (target.y+H)-height - margin.bottom;
                break;
                
                case Align.bottomRight:
                x = (target.x+W)-width - margin.right;
                y = (target.y+H)-height - margin.bottom;
                break;
            }
            
            if( !listenResize && (alignement != Align.none) )
            {
                target.addEventListener( Event.RESIZE, onResize );
                listenResize = true;
            }
            
            this.alignement  = alignement;
            this.alignTarget = target;
        }
        
        /**
         * Resize the display.
         */
        public function resize():void
        {
            if( alignement != Align.none )
            {
                alignTo( alignement, alignTarget );
            }
        }        
        
    }
}