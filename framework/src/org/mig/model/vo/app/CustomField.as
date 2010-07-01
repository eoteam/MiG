package org.mig.model.vo.app
{
	import org.mig.model.vo.ValueObject;

	[Bindable]
	public class CustomField extends ValueObject
	{	
		public var typeid:int;
		public var groupid:int;
		public var name:String;
		public var displayname:String;
		public var optionsArray:Array = [];
		public var defaultvalue:String = "";
		public var description:String = "";
		
		public var createdby:int;
		public var createdate:Number;
		public var modifiedby:int;
		public var modifieddate:Number;		
		
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
				result += item.value + ',';
			}
			return result;
		}

	}
}