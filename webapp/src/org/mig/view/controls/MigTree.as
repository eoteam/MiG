package org.mig.view.controls
{
	import flash.display.Sprite;
	
	import mx.collections.IList;


	public class MigTree extends SpringLoadedTree
	{
		/* public function MigTree()
		{
			super();
		} */
		
		
		[Bindable]
	    public var rowColoringFunction:Function;
	
	    protected override function drawRowBackground(s:Sprite, rowIndex:int, y:Number, height:Number, color:uint, dataIndex:int):void {
	      if (rowColoringFunction != null && IList(dataProvider).length > dataIndex) {
	        color = rowColoringFunction(IList(dataProvider).getItemAt(dataIndex), dataIndex, color);
	      }
	      //
	      graphics.clear();
	      var bg:Sprite = new Sprite();
	      bg.graphics.beginFill(0xCCCCCC,1);
	      bg.graphics.drawRect(0,0,50, 20);
	      //addChild(bg);
	      super.drawRowBackground(bg, rowIndex, y, height, color, dataIndex);
	      
	    }

		
	}
}