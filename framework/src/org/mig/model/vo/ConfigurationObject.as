package org.mig.model.vo
{
	[Bindable]
	public class ConfigurationObject extends ContentData
	{
		public var labelfield:String;
		public var contentview:String;
		public var createContent:String;
		public var retriveContent:String;
		public var updateContent:String;
		public var deleteContent:String;
		
		public function ConfigurationObject()
		{
			super();
		}
	}
}