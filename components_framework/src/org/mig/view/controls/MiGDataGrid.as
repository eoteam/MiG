package org.mig.view.controls
{
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	import mx.controls.DataGrid;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.DragSource;
 	

	public class MiGDataGrid extends DataGrid
	{ 
		public var dragFormat:String;
	 	[Bindable] public var rollOverAlpha:Number = 0.25;
	 	private var _selectionAlpha:Number = 0.5;
		public var clearingLines:Boolean = false; 
		public var clearVLineIndices:Array = [];	 		
	 	public function get selectionAlpha():Number
	 	{
	 		return _selectionAlpha;
	 	}	
	 	public function set selectionAlpha(value:Number):void
	 	{
	 		_selectionAlpha = value;
	 		for each(var item:Object in this.selectedItems)
	 			this.drawItem(this.itemToItemRenderer(item),true,true,false,true);
	 	}
		override protected function drawSelectionIndicator(indicator:Sprite, x:Number, y:Number, width:Number,height:Number, color:uint,itemRenderer:IListItemRenderer):void
		{
		  	var g:Graphics = Sprite(indicator).graphics;
		  	g.clear();
		  	g.beginFill(color,selectionAlpha);
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
		  	g.beginFill(color,rollOverAlpha);
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
				DragSource(ds).addData(this.selectedItems,dragFormat);
			super.addDragData(ds);
		}
 	}  
} 