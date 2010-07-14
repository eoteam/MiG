package org.mig.model.vo.app
{
	import mx.collections.ArrayList;
	
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
		public var optionsArray:ArrayList = new ArrayList();
		public var defaultvalue:String = "";
		public var description:String = "";
		
		public var hardDelete:Boolean = false;
		
		public function set options(ops:String):void
		{
			var tmp:Array = ops.split(',');
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
			var result:String = '';
			for each(var item:CustomFieldOption in optionsArray.source) {
				result += (optionsArray.getItemIndex(item)+1).toString()+'='+item.value + ',';
			}
			result = result.substring(0,result.length-1);
			return result;
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