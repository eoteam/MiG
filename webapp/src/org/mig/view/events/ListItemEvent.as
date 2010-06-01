package org.mig.view.events
{
	import flash.events.Event;
	
	import spark.components.List;
	
	public class ListItemEvent extends Event
	{
		public static const ITEM_CLICK:String = "itemClick";
		public static const ITEM_DOUBLECLICK:String = "itemDoubleClick";
		
		public var list:List;
		public var itemIndex:int;
		public function ListItemEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}