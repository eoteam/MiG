package com.mapx.view.controls
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;

	import flash.display.Graphics;
	import flash.display.Sprite;
	
	import mx.controls.TileList;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.Container;
	import mx.core.IUIComponent;
	import mx.core.ScrollPolicy;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	[Style(name="newSelectionColor",type="uint",format="Color",inherit="no")]
	public class MiGTileList extends TileList
	{
		use namespace mx_internal;
		public var dragFormat:String;
		public var customProxy:Boolean = false;
		public var useSelectionColor:Boolean = true;
		public var keyboardLookUp:Boolean = true;
		[Bindable] public var scalePercent:Number;
		private var firstUpdate:Boolean = true;
		public function MiGTileList()
		{
			super();
			//this.offscreenExtraRows = 1;
          	//setStyle( "paddingBottom", -1 );
            // parent container will handle scrolling
            //verticalScrollPolicy = ScrollPolicy.OFF;
            //( FlexEvent.UPDATE_COMPLETE, handleUpdateComplete );			
		}
 /*        private function handleUpdateComplete( event:FlexEvent ):void
        {
        	var combinedRendererHeight:Number = 0;        
          	  // iterate over list of renderers provided by our List subclass
            //var internalRowCount:int = Math.ceil(260*scalePercent*renderers.length/width);
            //internalRowCount = Math.ceil(scalePercent*internalRowCount/height);
            for each( var renderer:Object in renderers )
            {
            	if(renderer != null)
               		combinedRendererHeight += rowHeight*scalePercent;
            }      
            // list needs to be at least 10 pixels tall
            // and always needs to be 10 pixels taller than the combined height of the renderers
            //var r:int = this.explicitRowCount > 0 ? this.:rowCount;     
            this.height = combinedRendererHeight + 10; 
            if(firstUpdate)
            {
            	this.height += rowHeight*scalePercent*2;
            	firstUpdate = false;
            }
            // need to shrink list width when canvas has a scrollbar so the scrollbar doesn't overlap the list
            width = ( Container( parent ).maxVerticalScrollPosition > 0 ) ? parent.width - 16 : parent.width;
            trace('crapping out');
            //this.invalidateSize();
        }
       public function get renderers():Array
        {
            // prefix the internal property name with its namespace
            var rawArray:Array = mx_internal::rendererArray;
            var arr:Array = new Array();     
            // the rendererArray is a bit messy
            // its an Array of Arrays, except sometimes the sub arrays are empty
            // and sometimes it contains entries that aren't Arrays at all
            for each( var obj:Object in rawArray )
            {
                var rendererArray:Array = obj as Array;
                
                // make sure we have an Array and there is something in it
                if( rendererArray && rendererArray.length > 0 )
                {
                    // if there is something in it, the first item is our renderer
                    arr.push( obj[ 0 ] );
                }
            }
            return arr;
        }       	 */
 		override protected function drawSelectionIndicator(indicator:Sprite, x:Number, y:Number, width:Number,height:Number, color:uint,itemRenderer:IListItemRenderer):void
		{
			var alpha:Number;
			alpha = useSelectionColor?0.5:0;			
      		var g:Graphics = Sprite(indicator).graphics;
      		g.clear();
      		g.beginFill(color,alpha);
      		//var w:int = unscaledWidth - viewMetrics.left - viewMetrics.right;
      		g.drawRect(0,0,width,height);
      		g.endFill();
      		indicator.x = x;
      		indicator.y = y; 
      		indicator.alpha = alpha;
      		//Tweener.addTween(indicator,({alpha:.5, time:2, transition:"easeOutCubic"})); 
		}
		override protected function drawHighlightIndicator(indicator:Sprite, x:Number, y:Number, width:Number,height:Number, color:uint, itemRenderer:IListItemRenderer):void
		{
			var alpha:Number;
			alpha = useSelectionColor?0.8:0;
			var g:Graphics = Sprite(indicator).graphics;
			g.clear();
			g.beginFill(color,alpha);
			g.drawRect(0,0,width,height);
			g.endFill();
			indicator.x = x;
			indicator.y = y;
			indicator.alpha = 0;
			TweenMax.to(indicator,1,{alpha:.5,ease:Cubic.easeOut}); 
		}
		override protected function addDragData(ds:Object):void
		{
			if(dragFormat != null && dragFormat != "")
				ds.formats.push(dragFormat);
			super.addDragData(ds);
		}	
		override protected function get dragImage():IUIComponent
		{
			if(!customProxy)
				return super.dragImage;
			else
			{
				var custom:TileListCustomDragProxy = new TileListCustomDragProxy();
				custom.owner = this;
				return custom;
			}
		}			 
		override protected function findKey(eventCode:int):Boolean
    	{
    		if(keyboardLookUp)
    			return super.findKey(eventCode);
    		else
    			return false;
    	}	
 /*    override protected function dragScroll():void
    {
        var slop:Number = 0;
        var scrollInterval:Number;
        var oldPosition:Number;
        var d:Number;
        var scrollEvent:ScrollEvent;

        // sometimes, we'll get called even if interval has been cleared
        if (dragScrollingInterval == 0)
            return;

        const minScrollInterval:Number = 30;

        oldPosition = Container(parent).verticalScrollPosition;

        if (DragManager.isDragging)
        {
            slop = viewMetrics.top
                + (variableRowHeight ? getStyle("fontSize") / 4 : rowHeight);
        }

        clearInterval(dragScrollingInterval);

        if (mouseY < slop)
        {
            verticalScrollPosition = Math.max(0, oldPosition - 1);
            if (DragManager.isDragging)
            {
                scrollInterval = 100;
            }
            else
            {
                d = Math.min(0 - mouseY - 30, 0);
                // quadratic relation between distance and scroll speed
                scrollInterval = 0.593 * d * d + 1 + minScrollInterval;
            }

            dragScrollingInterval = setInterval(dragScroll, scrollInterval);

            if (oldPosition != verticalScrollPosition)
            {
                scrollEvent = new ScrollEvent(ScrollEvent.SCROLL);
                scrollEvent.detail = ScrollEventDetail.THUMB_POSITION;
                scrollEvent.direction = ScrollEventDirection.VERTICAL;
                scrollEvent.position = verticalScrollPosition;
                scrollEvent.delta = verticalScrollPosition - oldPosition;
                Container( parent ).dispatchEvent(scrollEvent);
            }
        }
        else if (mouseY > (unscaledHeight - slop))
        {
            verticalScrollPosition = Math.min(maxVerticalScrollPosition, Container(parent).verticalScrollPosition + 1);
            if (DragManager.isDragging)
            {
                scrollInterval = 100;
            }
            else
            {
                d = Math.min(mouseY - Container(parent).mx_internal::unscaledHeight - 30, 0);
                scrollInterval = 0.593 * d * d + 1 + minScrollInterval;
            }

            dragScrollingInterval = setInterval(dragScroll, scrollInterval);

            if (oldPosition != verticalScrollPosition)
            {
                scrollEvent = new ScrollEvent(ScrollEvent.SCROLL);
                scrollEvent.detail = ScrollEventDetail.THUMB_POSITION;
                scrollEvent.direction = ScrollEventDirection.VERTICAL;
                scrollEvent.position = verticalScrollPosition;
                scrollEvent.delta = verticalScrollPosition - oldPosition;
                Container( parent ).dispatchEvent(scrollEvent);
            }
        }
        else
        {
            dragScrollingInterval = setInterval(dragScroll, 15);
        }

        if (DragManager.isDragging && lastDragEvent && oldPosition != verticalScrollPosition)
        {
            dragOverHandler(lastDragEvent);
        }
    }    	 */
	}
}