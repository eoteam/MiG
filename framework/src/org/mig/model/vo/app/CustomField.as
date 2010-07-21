package org.mig.model.vo.app
{
	import mx.collections.ArrayList;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.PropertyChangeEvent;
	import mx.events.PropertyChangeEventKind;
	
	import org.mig.model.vo.ContentData;

	[Bindable]
	public class CustomField extends ContentData
	{	
		public var templateid:int;
		public var customfieldid:int;
		public var displayorder:int;
		
		public var typeid:int;
		public var groupid:int;
		public var name:String;
		public var displayname:String;
		public var optionsArray:ArrayList;
		public var defaultvalue:String;
		public var description:String;
		
		public var globalDelete:Boolean = false;
		public var ready:Boolean = false;
		public var globalChange:Boolean = false;
		
		private var _options:String;
		
		public function CustomField() {
			super();
			stateProps = stateProps.concat(["optionsArray","globalChange","ready","globalDelete"]);
			defaultvalue = description = '';
			optionsArray = new ArrayList();
			optionsArray.addEventListener(CollectionEvent.COLLECTION_CHANGE,handleChange);
		}
		private function handleChange(event:CollectionEvent):void {
			for each(var option:CustomFieldOption in optionsArray.source) {
				option.index = optionsArray.getItemIndex(option)+1;
			}
			var result:String = '';
			for each(var item:CustomFieldOption in optionsArray.source) {
				result += (optionsArray.getItemIndex(item)+1).toString()+'='+item.value + ',';
			}
			result = result.substring(0,result.length-1);
			var changed:Boolean = true;
			if(event.kind == CollectionEventKind.UPDATE) {
				if(PropertyChangeEvent(event.items[0]).property == "selected" || PropertyChangeEvent(event.items[0]).property == "index")
					changed = false;
			}	
			if(ready && changed) 
				this.dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,false,false,PropertyChangeEventKind.UPDATE,"options",_options,result,this));
			_options = result;
		}
		public function set options(ops:String):void
		{
			_options = ops;
			var tmp:Array = ops.split(',');
			optionsArray.removeAll();
			for each(var op:String in tmp) {
				var tokens:Array = op.split('=');
				var option:CustomFieldOption = new CustomFieldOption();
				option.customfield = this;
				option.index = Number(tokens[0]);
				option.value = tokens[1];
				optionsArray.addItem(option);
			}
		}
		public function get options():String {
			return _options;
		}
		
		/*public function clone():CustomField {
			var field:CustomField = new CustomField();
			field.customfieldid = customfieldid;
			field.fieldid = fieldid;
			field.typeid = typeid;
			field.name = name;
			field.displayname = displayname;
			field.displayorder = displayorder;
			field.defaultvalue = defaultvalue;
			field.description = description;
			field.options = options;
			return field;
		}*/
	}
}