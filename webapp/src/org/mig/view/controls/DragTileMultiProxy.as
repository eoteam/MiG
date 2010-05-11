package org.mig.view.controls
{
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	
	import mx.core.UIComponent;
	
    public class DragTileMultiProxy extends UIComponent
    {
    	public var spacing:int = 10;
    	public var maxDragWidth:Number = 800;
		public function DragTileMultiProxy():void
        {
            super();
        } 
        public function addItems(items:Array):void
        {            
            var itemX:int = 0; //y position to place items at
            var itemY:int = 0; //y position to place items at
            for  (var i:int=0;i<items.length;i++)
            {
                
                var container:UIBitmap = new UIBitmap(items[i],PixelSnapping.NEVER);
                addChild(DisplayObject(container));    
				container.x = itemX;
				container.y = itemY;
				
				itemX += container.width+spacing;
				
				if(itemX > maxDragWidth)
				{
					itemX = 0;
					itemY += container.height+spacing;
				}
            }
        }
    }
}// ActionScript file
