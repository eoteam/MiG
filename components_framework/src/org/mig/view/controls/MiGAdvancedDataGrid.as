package org.mig.view.controls
{
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	
	import mx.controls.AdvancedDataGrid;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.IUIComponent; 
 	import mx.core.mx_internal;	
	use namespace mx_internal;
 	[Event(name="childrenCreated", type="flash.events.Event")]
	public class MiGAdvancedDataGrid extends AdvancedDataGrid
	{
		public var clearingLines:Boolean = false; 
		public var clearVLineIndices:Array = [];
		public var dragFormat:String;
		private var prevIndex:int;
		private var prevSelectedItem:Object;
		public var customProxy:Boolean = false;	
		public var thumbURL:String;
		override protected function childrenCreated():void
		{
			super.childrenCreated();
			this.dispatchEvent(new Event("childrenCreated"));
		}
 		override protected function drawSelectionIndicator(indicator:Sprite, x:Number, y:Number, width:Number,height:Number, color:uint,itemRenderer:IListItemRenderer):void
		{
      		 var g:Graphics = Sprite(indicator).graphics;
      		g.clear();
      		g.beginFill(color,.25);
      		var w:int = unscaledWidth - viewMetrics.left - viewMetrics.right;
      		g.drawRect(0,0,w,height);
      		g.endFill();
      		indicator.x = x;
      		indicator.y = y; 
		}
		override protected function drawHighlightIndicator(indicator:Sprite, x:Number, y:Number, width:Number,height:Number, color:uint, itemRenderer:IListItemRenderer):void
		{
		  	var g:Graphics = Sprite(indicator).graphics;
		  	g.clear();
		  	g.beginFill(color,.5);
		  	var w:int = unscaledWidth - viewMetrics.left - viewMetrics.right;
		  	g.drawRect(0,0,w,height);
		  	g.endFill();
		  
		  	indicator.x = x;
		   	indicator.y = y;
		    indicator.alpha = 0;
			TweenMax.to(indicator,1,{alpha:.5,ease:Cubic.easeOut}); 
		} 
		override protected function drawVerticalLine(s:Sprite, colIndex:int, color:uint, x:Number):void
		{
			if(!clearingLines)
				super.drawVerticalLine(s,colIndex,color,x);
			else
			{
				if(clearVLineIndices.length == 0)
					return;//clear all
				else if(clearVLineIndices.indexOf(colIndex) != -1)
					return;//clear this line
				else
					super.drawVerticalLine(s,colIndex,color,x);
			}	
		} 
		override protected function addDragData(ds:Object):void
		{
			if(dragFormat != null && dragFormat != "")
				ds.formats.push(dragFormat);
			super.addDragData(ds);
			
		}
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(this.selectedCells.length > 0 && this.selectedItem != prevSelectedItem && selectedItem!=null)
			{
				prevSelectedItem = this.selectedItem;
				var rowIndex:int = this.selectedCells[0].rowIndex+1;
				if(prevIndex == rowIndex)
					rowIndex++;
				prevIndex = rowIndex;
				this.dispatchEvent(new DataEvent("itemFocus",false,false,rowIndex.toString()));	
			}
		}
/* 		override public function dragStartHandler(event:DragEvent):void
		{
			this.dropEnabled = false;
		}
		override public function dragEnterHandler(event:DragEvent):void
		{
			if(event.dragInitiator == this)
			{
				this.dropEnabled = true;
			}			
		} */
		override protected function get dragImage():IUIComponent
		{
			if(!customProxy)
				return super.dragImage;
			else
			{
				var custom:AdvancedDataGridCustomDragProxy = new AdvancedDataGridCustomDragProxy();
				custom.thumbURL = thumbURL;
				custom.owner = this;
				return custom;
			}
		}
		public function get cIterator():*
		{
			return mx_internal::collectionIterator;
		}
	}  
} 