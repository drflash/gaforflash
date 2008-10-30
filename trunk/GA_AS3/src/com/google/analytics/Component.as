package com.google.analytics
{
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.utils.getQualifiedClassName;
    
    public class Component extends MovieClip
    {
        
        private var preview_mc:MovieClip;
        private var isLivePreview:Boolean;
        private var livePreviewWidth:Number;
        private var livePreviewHeight:Number;
        
        private var _origWidth:Number;
        private var _origHeight:Number;
        
        public var boundingBox_mc:MovieClip;
        public var icon_mc:MovieClip;
        
        [Inspectable]
        public var test0:Boolean = false;
        
        [Inspectable]
        public var test1:Boolean = false;
        
        [Inspectable]
        public var test2:Boolean = false;
        
        //private var _lib:AnalyticsLibrary;
        
        public function Component()
        {
            isLivePreview = (parent != null && getQualifiedClassName(parent) == "fl.livepreview::LivePreviewParent");
            
            _origWidth = super.width;
            _origHeight = super.height;
            
            // remove boundingBox_mc
            boundingBox_mc.visible = false;
            removeChild( boundingBox_mc );
            boundingBox_mc = null;
            
            // setup live preview look
            if (isLivePreview)
            {
                createLivePreviewMovieClip();
                setSize(_origWidth, _origHeight);
            }
            
            addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
        }
        
        public function get registrationX():Number
        {
            return super.x;
        }
        
        public function set registrationX(x:Number):void
        {
            super.x = x;
        }
        
        public function get registrationY():Number
        {
            return super.y;
        }
        
        public function set registrationY(y:Number):void
        {
            super.y = y;
        }
        
        public function get registrationWidth():Number
        {
            return super.width;
        }
        
        public function set registrationWidth(w:Number):void
        {
            width = w;
        }
        
        public function get registrationHeight():Number
        {
            return super.height
        }
        
        public function set registrationHeight(h:Number):void
        {
            height = h;
        }
        
        private function createLivePreviewMovieClip():void
        {
            preview_mc = new MovieClip();
            preview_mc.name = "preview_mc";
            
            preview_mc.box_mc = new MovieClip();
            preview_mc.box_mc.name = "box_mc";
            preview_mc.box_mc.graphics.beginFill(0x000000);
            preview_mc.box_mc.graphics.moveTo(0, 0);
            preview_mc.box_mc.graphics.lineTo(0, 100);
            preview_mc.box_mc.graphics.lineTo(100, 100);
            preview_mc.box_mc.graphics.lineTo(100, 0);
            preview_mc.box_mc.graphics.lineTo(0, 0);
            preview_mc.box_mc.graphics.endFill();
            preview_mc.addChild(preview_mc.box_mc);
            
            preview_mc.icon_mc = new Icon();
            preview_mc.icon_mc.name = "icon_mc";
            preview_mc.addChild(preview_mc.icon_mc);
            
            addChild(preview_mc);
        }
        
        public function setSize( width:Number, height:Number ):void
        {
            
            if (isLivePreview)
            {
                livePreviewWidth = width;
                livePreviewHeight = height;
                
                preview_mc.box_mc.width = width;
                preview_mc.box_mc.height = height;
                
                if( preview_mc.box_mc.width < preview_mc.icon_mc.width ||
                    preview_mc.box_mc.height < preview_mc.icon_mc.height )
                {
                    preview_mc.icon_mc.visible = false;
                }
                else
                {
                    preview_mc.icon_mc.visible = true;
                    preview_mc.icon_mc.x = (preview_mc.box_mc.width - preview_mc.icon_mc.width) / 2;
                    preview_mc.icon_mc.y = (preview_mc.box_mc.height - preview_mc.icon_mc.height) / 2;
                }
                
                
                return;
            }
            
        }
        
        private function test():void
        {
            
        }
        
        private function onAddedToStage( event:Event ):void
        {
            trace( "ADDED TO STAGE" );
            removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
        }
        
    }
}