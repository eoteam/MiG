package org.mig.view.controls
{
	import mx.controls.List;
	import  mx.controls.listClasses.IListItemRenderer;
	import flash.display.Sprite;
	public class MiGList extends List
	{
		public function MiGList()
		{
			super(); 
		}
		override protected function drawSelectionIndicator(indicator:Sprite, x:Number, y:Number, width:Number,height:Number, color:uint,itemRenderer:IListItemRenderer):void
		{		
			with(indicator.graphics) {
				clear();
				beginFill(color,1);
				drawRect(0,0,width,height);
				endFill();
			}
			indicator.x = x;
			indicator.y = y; 
			indicator.alpha = 1;
			//Tweener.addTween(indicator,({alpha:.5, time:2, transition:"easeOutCubic"})); 
		}
		override protected function drawHighlightIndicator(indicator:Sprite, x:Number, y:Number, width:Number,height:Number, color:uint, itemRenderer:IListItemRenderer):void
		{
			with(indicator.graphics) {
				clear();
				beginFill(color,1);
				drawRect(0,0,width,height);
				endFill();
			}
			indicator.x = x;
			indicator.y = y;
			indicator.alpha = 1;
		}		
	}
}