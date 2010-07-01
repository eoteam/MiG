package org.mig.view.controls
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	import mx.collections.IList;
	import mx.controls.Tree;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.DragSource;


	public class MigTree extends SpringLoadedTree {
	
		public var dragFormat:String;
		override protected function drawSelectionIndicator(indicator:Sprite, x:Number, y:Number, width:Number, height:Number, color:uint, itemRenderer:IListItemRenderer):void {
			//super.drawSelectionIndicator(indicator,x,y,width,height,color,itemRenderer);

			var g:Graphics = indicator.graphics;
			g.clear();
			g.beginFill(color,0.5);
			g.drawRect(0, 0, width, height);
			g.endFill();
			
			indicator.x = x;
			indicator.y = y;
		}	
		override protected function drawHighlightIndicator(indicator:Sprite, x:Number, y:Number, width:Number, height:Number, color:uint, itemRenderer:IListItemRenderer):void {
			//super.drawHighlightIndicator(
			var g:Graphics = indicator.graphics;
			g.clear();
			g.beginFill(color,0.5);
			g.drawRect(0, 0, width, height);
			g.endFill();
			
			indicator.x = x;
			indicator.y = y;
		}
		override protected function addDragData(ds:Object):void {
			DragSource(ds).addData(this.selectedItems, dragFormat);
			super.addDragData(ds);
		}
	}
}