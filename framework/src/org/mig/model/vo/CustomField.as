package org.mig.model.vo
{

	[Bindable]
	public class CustomField extends ValueObject
	{	
		public var typeid:int;
		public var groupid:int;
		
		public var name:String;
		public var displayname:String;
		public var optionsArray:Array;
		public var defaultvalue:String = "";
		public function set options(ops:String):void
		{
			optionsArray = [];
			var tmp:Array = ops.split(',');
			for each(var op:String in tmp) {
				var tokens:Array = op.split('=');
				optionsArray.push({index:tokens[0],value:tokens[1]});
			}
		}
		
	}
}