package org.mig.model.vo.app
{
	import org.mig.model.vo.ContentData;

	[Bindable]
	public class CustomField extends ContentData
	{	
		
		public var templateid:int;
		public var customfieldid:int;
		public var fieldid:int;
		public var displayorder:int;
		
		
		public var isNew:Boolean = true;
		
		public var typeid:int;
		public var name:String;
		public var displayname:String;
		public var optionsArray:Array = [];
		public var defaultvalue:String = "";
		public var description:String = "";
		
	
		
		public function set options(ops:String):void
		{
			var tmp:Array = ops.split(',');
			for each(var op:String in tmp) {
				var tokens:Array = op.split('=');
				optionsArray.push({index:tokens[0],value:tokens[1]});
			}
		}
		public function get options():String {
			var result:String = '';
			for each(var item:Object in optionsArray) {
				result += (optionsArray.indexOf(item)+1).toString()+'='+item.value + ',';
			}
			result = result.substring(0,result.length-1);
			return result;
		}

	}
}