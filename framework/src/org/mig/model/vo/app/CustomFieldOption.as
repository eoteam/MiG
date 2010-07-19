package org.mig.model.vo.app
{
	import org.mig.model.vo.ContentData;

	[Bindable]
	public class CustomFieldOption
	{
		public var index:int;
		public var value:String = '';
		public var selected:Boolean = false;
		
		public var vo:ContentData;
		public var customfield:CustomField;
	}
}