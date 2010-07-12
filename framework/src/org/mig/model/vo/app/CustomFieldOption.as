package org.mig.model.vo.app
{
	import org.mig.model.vo.ValueObject;

	[Bindable]
	public class CustomFieldOption
	{
		public var index:int;
		public var value:String = '';
		public var selected:Boolean = false;
		
		public var vo:ValueObject;
		public var customfield:CustomField;
	}
}