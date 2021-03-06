package org.mig.collections
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.PropertyChangeEvent;
	
	import org.mig.model.vo.ContentData;
	
	/**
	 * @flowerModelElementId _ecXDgM2REd--irTzzklAjg
	 */
	public class DataCollection extends ArrayCollection
	{
		public static const NEW_COLLECTION:int = 0;
		public static const MODIFIED:int = 1;
		public static const COMMITED:int = 2;
		
		public var newItems:ArrayList;
		public var deletedItems:ArrayList;
		public var modifiedItems:ArrayList;
		
		public var state:int;
		
		public function DataCollection(source:Array=null)
		{
			super(source);
			newItems = new ArrayList();
			deletedItems = new ArrayList();
			modifiedItems = new ArrayList();
			state = 0;
			//list.addEventListener( CollectionEvent.COLLECTION_CHANGE, onCollectionEvent);  
		}
    
		override public function dispatchEvent(event:Event):Boolean {
			
			if(event is CollectionEvent) {
				var items:Array = CollectionEvent(event).items;
				var propChange:PropertyChangeEvent;
				var item:ContentData; 
				switch(CollectionEvent(event).kind) {

					case CollectionEventKind.REMOVE:
						for each(item in items)  {
						 	//add everything to deleted. wait for an add event to see if it was a move
							if(!item.isNew)
								deletedItems.addItem(item);
							else
								newItems.removeItem(item);
						}
							//this.dispatchEvent(new Event("stageChange",true));
					break;
					case CollectionEventKind.ADD:
						if(state > 0) {
							for each(item in items)  {
								if(deletedItems.getItemIndex(item) != -1) //just moved
									deletedItems.removeItem(item);
								else if(item.isNew) { //otherwise its truly new item
									newItems.addItem(item);
								}
							}
							this.state = 1;
							//this.dispatchEvent(new Event("stageChange",true));
						}
						else {
							for each(item in items) 
								item.isNew = false;
						}
					break;
					case CollectionEventKind.UPDATE:
						if(state > 0 ) {
							var noChange:Boolean = true;
							for each(propChange in items) {
								if(ContentData(propChange.source).stateProps.indexOf(propChange.property) == -1) {
									if(modifiedItems.getItemIndex(propChange.source) == -1 && newItems.getItemIndex(propChange.source) == -1) {
										modifiedItems.addItem(propChange.source)
									}
									ContentData(propChange.source).modified = true;
									ContentData(propChange.source).updateData[propChange.property] = propChange.newValue;
									noChange = false;
								}
								
							}
							this.state = 1;
							if(noChange)
								return false;
						}
					break;
				}
			}
			return super.dispatchEvent(event);
		}	
/*		public function commit():void {
			//state = 1;
			this.dispatchEvent(new Event("stageChange",true));
		}*/
		public function setItemNotModified(item:ContentData):void {
			if(this.modifiedItems.getItemIndex(item) != -1) {
				modifiedItems.removeItem(item);
			}		
		}
		public function setItemNotNew(item:ContentData):void {
			if(this.newItems.getItemIndex(item) != -1) {
				newItems.removeItem(item);
				item.isNew = false;
			}				
		}
		public function isItemNew(item:ContentData):Boolean {
			return newItems.getItemIndex(item) == -1?false:true;
		}
		public function isItemModified(item:ContentData):Boolean {
			return modifiedItems.getItemIndex(item) == -1?false:true;
		}		
	}
}