package org.mig.view.controls
{
	import flash.events.KeyboardEvent;
	
	import mx.core.DragSource;
	import mx.core.IFlexDisplayObject;
	
	import spark.components.List;
	
	public class MiGList extends List
	{
		public var keyboardLookUp:Boolean = false;
		public var customProxy:Boolean = true; 
		public var dragFormat:String;
		
		public function MiGList()
		{
			super();
		}
		override protected function  keyDownHandler(event:KeyboardEvent):void {
			if(keyboardLookUp)
				super.keyDownHandler(event);
		}
		override public function addDragData(dragSource:DragSource):void {
			if(dragFormat != "" && dragFormat != null)
				dragSource.addData(this.selectedItems, dragFormat);
			super.addDragData(dragSource); 
		} 
	}
}