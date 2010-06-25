package org.mig.model.vo.app
{
	import org.mig.model.vo.ValueObject;

	[Bindable]
	public class ContentCustomField extends ValueObject
	{
		public var customfield:CustomField;
		public var displayorder:Number;
		public var fieldid:Number;
		public var customfieldid:int;
		
	}
}