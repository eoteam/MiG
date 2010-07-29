package org.mig.model.vo.content
{
	import mx.collections.ArrayList;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.PropertyChangeEvent;
	import mx.events.PropertyChangeEventKind;
	
	import org.mig.collections.DataCollection;
	import org.mig.model.vo.ConfigurationObject;
	
	[Bindable]
	public class ContentTab extends ConfigurationObject
	{
		public var itemview:String;
		public var editview:String;
		
		public var dto:String;
		public var vars:String;
		public var orderby:String = "id";
		public var orderdirection:String = "ASC";
		public var templateids:String; 

		public var parameterids:String;
		
		public var parameters:DataCollection;
		public function ContentTab()
		{
			super();
			parameters = new DataCollection();
			//parameters.addEventListener(CollectionEvent.COLLECTION_CHANGE,handleParametersChange);
		}
		/*private function handleParametersChange(event:CollectionEvent):void {
			if(event.kind == CollectionEventKind.UPDATE) { 
				parametersChanged = true;
				for each(var item:PropertyChangeEvent in event.items) {
					item.source.changed = true;
				}
				this.dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,false,false,PropertyChangeEventKind.UPDATE,"parametersChanged",false,true,this));
			}
		}*/
	}
}