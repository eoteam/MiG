package org.mig.model.vo.content
{
	import org.mig.model.vo.ConfigurationObject;
	
	[Bindable]
	public dynamic class ContentTab extends ConfigurationObject
	{
		public var itemview:String;
		public var dto:String;
		public var vars:String;
		public var orderby:String = "id";
		public var orderdirection:String = "ASC";
		public var templateids:String;
		
		public function ContentTab()
		{
			super();
		}
	}
}