package org.mig.view.controls
{
	import flash.display.Sprite;
	
	import mx.collections.IList;
	import mx.controls.Tree;
	import mx.controls.listClasses.IListItemRenderer;


	public class MigTree extends Tree {

		override protected function drawHighlightIndicator(indicator:Sprite, x:Number, y:Number, width:Number, height:Number, color:uint, itemRenderer:IListItemRenderer):void {
			super.drawHighlightIndicator(indicator,x,y,width,height,color,itemRenderer);
			indicator.graphics.clear();
		}
		override protected function drawSelectionIndicator(indicator:Sprite, x:Number, y:Number, width:Number, height:Number, color:uint, itemRenderer:IListItemRenderer):void {
			super.drawSelectionIndicator(indicator,x,y,width,height,color,itemRenderer);
			indicator.graphics.clear();
		}	
/*		override public function validateDisplayList():void {
			this.runDataEffectNextUpdate = true;
			super.validateDisplayList();
		}*/
	}
}