package org.mig.model.vo.content
{
	import org.mig.model.vo.app.CustomField;
	import org.mig.model.vo.ValueObject;

	[Bindable]
	public class TemplateCustomField extends ValueObject
	{
		public var customfield:CustomField;
		public var displayorder:Number;
		public var fieldid:Number;
		public var visible:Boolean;
		
	}
}