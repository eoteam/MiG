
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

package org.mig.view.controls {
    
    import org.mig.model.vo.media.MediaContainerNode;
    import com.thanksmister.controls.ImageCache;
    
    import flash.display.DisplayObject;
    import flash.events.Event;
    
    import mx.controls.AdvancedDataGrid;
    import mx.core.UIComponent;
    import mx.core.UITextField;

	
    public class AdvancedDataGridCustomDragProxy extends UIComponent {
        
        [Embed(source='../../../../../../webapp/src/migAssets/library.swf#folderIcon')]
        	private var folderIcon:Class;
       
		public var thumbURL:String;
        public function AdvancedDataGridCustomDragProxy():void
        {
            super();
        }
        
        override protected function createChildren():void
        {
            super.createChildren();
            
            //retrieve the selected indicies and then sort them
            //in order to display them in the proper order
           
            
            var dg:mx.controls.AdvancedDataGrid = mx.controls.AdvancedDataGrid(owner);
            
            var itemX:int = 0; //y position to place items at
            var itemY:int = 0; //y position to place items at
            for  (var i :int=dg.selectedItems.length-1; i>=0;i--)
            {
                var item:Object = dg.selectedItems[i];
                var container: UIComponent = new UIComponent();
                addChild(DisplayObject(container));    
                                
                var label:UITextField = new UITextField();
                label.text = item.label;
                label.styleName = "bodyCopy";
               	label.y= 152;
               	label.width = 150;
                container.addChild(label);
                
               
                var image:ImageCache = new ImageCache();
                image.addEventListener(Event.COMPLETE,handleComplete);
                if(item is MediaContainerNode)
				{
					if(item.data.mimetype.toString() == "images")
             		   	image.source = thumbURL+item.path+item.name;
					else if(item.data.mimetype.toString() == "videos" && item.data.thumb.toString() == "1")
					{
						var n:String = item.data.name.toString();	
						var arr:Array = n.split(".");
						n = '';
						for(var j:int=0;j<arr.length-1;j++)
							n += arr[j];
						image.source = thumbURL+item.data.path.toString()+n+'.jpg';						
					}
					else
						image.source =  "migAssets/images/docIcon.png";		
				}
				else
                {
                	image.source = folderIcon;
                	image.width = 150;
                	image.height = 150;
                }

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