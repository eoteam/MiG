package org.mig.collections
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	import mx.events.PropertyChangeEvent;
	
	import org.mig.model.vo.ContentData;
	[Event(name="stateChange", type="flash.events.Event")] 
	public class DataCollection extends ArrayCollection
	{
		public static const NEW_COLLECTION:int = 0;
		public static const MODIFIED:int = 1;
		public static const COMMITED:int = 2;
		
		public var newItems:Array;
		public var deletedItems:Array;
		public var modifiedItems:Array;
		
		public var state:int;
		public function DataCollection(source:Array=null)
		{
			super(source);
			newItems = [];
			deletedItems = [];
			modifiedItems = [];
			state = 0;
			list.addEventListener( CollectionEvent.COLLECTION_CHANGE, onCollectionEvent);  
		}
		private function onCollectionEvent(event:CollectionEvent) :void {	
			var items:Array = event.items;
			var propChange:PropertyChangeEvent;
			var item:ContentData
			switch(event.kind) {
				case "remove":
					for each(item in items) 
						deletedItems.push(item);
					this.dispatchEvent(new Event("stageChange",true));
				break;
				case "add":
					if(state > 0) {
						for each(item in items) 
							newItems.push(item);
						this.state = 1;
						this.dispatchEvent(new Event("stageChange",true));
					}
				break;
				case "update":
					if(state > 0 ) {
						for each(propChange in items) {
							if(newItems.indexOf(propChange.source) == -1 && modifiedItems.indexOf(propChange.source) == -1) {
								modifiedItems.push(propChange.source);
								ContentData(propChange.source).modified = true;
							}
						}
						this.state = 1;
						this.dispatchEvent(new Event("stageChange",true));
					}
				break;
				
			}
		}     
		public function commit():void {
			state = 1;
			this.dispatchEvent(new Event("stageChange",true));
		}
	}
}