package com.google.ui
{
    public class Debug extends Label
    {
        private var _lines:Array;
        
        public var maxLines:uint = 5;
        
        public function Debug(color:uint=0, alignement:Align=null, stickToEdge:Boolean=false)
        {
            super("", "uiLabel", color, Align.bottom, true);
            
            _lines = [];
            
            forcedWidth = 500;
            selectable  = true;
        }
        
        
        public function write( message:String ):void
        {
            _lines.push( message );
            
            var lines:Array;
            if( _lines.length > maxLines+1 )
            {
                var start:uint = _lines.length-maxLines;
                var end:uint   = start + maxLines; 
                lines = _lines.slice( start, end );
            }
            else
            {
                lines = _lines;
            }
            
            text = lines.join("\n");
        }
        
    }
}