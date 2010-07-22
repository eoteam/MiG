package org.mig.model.vo.content
{
	import org.mig.model.vo.ConfigurationObject;
	
	[Bindable]
	public class ContentTab extends ConfigurationObject
	{
		public var itemview:String;
		public var dto:String;
		public var vars:String;
		public var orderby:String = "id";
		public var orderdirection:String = "ASC";
		public var templateids:String;
		public var parameterids:String;
		
		public var parameters:Array = [];
		
		public function ContentTab()
		{
			super();
		}
	}
}