
/**
 * Derrick Grigg
 * dgrigg@rogers.com
 * http://www.dgrigg.com
 * created on Nov 3, 2006
 * 
 * Custom drag proxy that displays an image and a label
 * 
 * For use with the com.dgrigg.controls.DataGrid
 */

package com.mapx.view.controls{
    
    import com.map.model.MediaContainerNode;
    import com.thanksmister.controls.ImageCache;
    
    import flash.display.DisplayObject;
    import flash.events.Event;
	import com.map.controller.ControllerLocator;
    import mx.controls.AdvancedDataGrid;
    import mx.controls.TileList;
    import mx.core.UIComponent;
    import mx.core.UITextField;
    
    public class TileListCustomDragProxy extends UIComponent
    {      	
        public function TileListCustomDragProxy():void
        {
            super();
        }
        
        override protected function createChildren():void
        {
            super.createChildren();    
            
            var dg:mx.controls.TileList = mx.controls.TileList(owner);
            
            var itemX:int = 0; //y position to place items at
            var itemY:int = 0; //y position to place items at
            for  (var i :int=dg.selectedItems.length-1; i>=0;i--)
            {
                var item:Object = dg.selectedItems[i];
                var container: UIComponent = new UIComponent();
                addChild(DisplayObject(container));    
                                
               
                var image:ImageCache = new ImageCache();
                image.addEventListener(Event.COMPLETE,handleComplete);
      
                image.source = ControllerLocator.mediaManagerController.thumbURL+item.data.path+item.data.name;

				container.addChild(image);
				container.x = itemX;
				container.y = itemY;
				
				itemX += 160;
				
				if(itemX > 800)
				{
					itemX = 0;
					itemY += 170;
				}
				trace(itemX,itemY);
            }
            this.x = owner.mouseX- 50;
            this.y = owner.mouseY -50;
        }
        private function handleComplete(event:Event):void
        {
        	var image:ImageCache = event.currentTarget as ImageCache;
/*        		 var ratio:Number ;
        	if(image.source is String)
        		ratio = image.content.width / image.content.height;
        	else if(image.source is Bitmap)
        		ratio = image.source.width / image.source.height;  */
            image.width = 150;
            image.height = 150;
        }
/*         private function handleComplete(event:Event):void
        {
            //scale the image to the desired size
            var info:LoaderInfo = LoaderInfo(event.target);
            var image:Object = info.content;
            var ratio:Number = image.width/image.height
            image.height = 100;
            image.width = image.height * ratio;
        } */
    }
}