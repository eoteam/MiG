
package com.mapx.view.skins {
    //import com.mapx.manager.DragManagerImpl2;
    
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.ProgressEvent;
    
    import mx.core.Singleton;
    import mx.events.FlexEvent;
    import mx.preloaders.IPreloaderDisplay;
    import mx.preloaders.Preloader;
    public class SitePreloader extends Sprite implements
		IPreloaderDisplay {

        private var _progress:Shape;
        private var _preloader:Preloader;
        private var _backgroundAlpha:Number;
        private var _backgroundColor:uint;
        private var _backgroundImage:Object;
        private var _backgroundSize:String;
        private var _stageHeight:Number;
        private var _stageWidth:Number;
        
        private var _totalWidth:Number = 250;
        private var _totalHeight:Number = 2;

        public function set preloader(value:Sprite):void {
            _preloader = value as Preloader;
            value.addEventListener(ProgressEvent.PROGRESS, progressEventHandler);
            value.addEventListener(FlexEvent.INITIALIZE,handleInitialize);
            value.addEventListener(FlexEvent.INIT_COMPLETE,initCompleteEventHandler);
        }

        public function set backgroundAlpha(value:Number):void {
            _backgroundAlpha = value;
        }

        public function get backgroundAlpha(  ):Number {
            return _backgroundAlpha;
        }

        public function set backgroundColor(value:uint):void {
            _backgroundColor = value;
        }

        public function get backgroundColor(  ):uint {
            return _backgroundColor;
        }

        public function set backgroundImage(value:Object):void {
            _backgroundImage = value;
        }

        public function get backgroundImage(  ):Object {
            return _backgroundImage;
        }

        public function set backgroundSize(value:String):void {
            _backgroundSize = value;
        }

        public function get backgroundSize(  ):String {
            return _backgroundSize;
        }

        public function set stageWidth(value:Number):void {
            _progress.x = value / 2;
            _stageWidth = value;
        }

        public function get stageWidth(  ):Number {
            return _stageWidth;
        }

        public function set stageHeight(value:Number):void {
            _progress.y = value / 2;
            _stageHeight = value;
        }

        public function get stageHeight(  ):Number {
            return _stageHeight;
        }

        public function SitePreloader(  ) {
            _progress = new Shape(  );
            addChild(_progress);
           
           
        	//_loaderText.embedFonts = true;
            //_loaderText.setStyle("color", 0xFFFFFF);
            
            //_loaderText.htmlText = "<FONT FACE='Helvetica, Arial, Sans-Serif'><b>TALD</b></FONT>";
            
        }

        private function progressEventHandler(event:ProgressEvent):void {

        	var bgColor:uint = 0x000000;
        	var bgStrokeColor:uint = 0x666666;
        	var fillColor:uint = 0xAAAAAA;
            _progress.graphics.clear();
            //_progress.graphics.lineStyle(1, bgColor, 1);
            _progress.graphics.beginFill(bgColor);
            _progress.graphics.lineStyle(1,bgStrokeColor,1);
            _progress.graphics.drawRect(0,0,_totalWidth,_totalHeight);
            _progress.graphics.endFill();
            _progress.graphics.lineStyle(0,0,0);
            var progressWidth:Number = (event.bytesLoaded / event.bytesTotal) * _totalWidth;
            _progress.graphics.beginFill(fillColor);
            _progress.graphics.drawRect(0,0,progressWidth,_totalHeight);
            _progress.graphics.endFill();
            
            
        }
        public function initialize():void {
            _progress.x = (stage.stageWidth/2)+100;
            _progress.y = stage.stageHeight/2;
            _progress.rotation = -135;         
        }
        private function initCompleteEventHandler(event:FlexEvent):void {
            dispatchEvent(new Event(Event.COMPLETE));
        }
        private function handleInitialize(event:FlexEvent):void
        {
/*         	            Singleton.registerClass("mx.managers::IDragManager",
                                    Class( DragManagerImpl2 ) );    */
        }

    }
}
