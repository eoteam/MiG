package org.mig.model.vo
{
	/**
	 * @flowerModelElementId _edGDUM2REd--irTzzklAjg
	 */
	[Bindable]
	public class ConfigurationObject extends BaseVO
	{
		public var name:String;
		public var labelfield:String;
		public var contentview:String;
		
		public var createContent:String;
		public var retrieveContent:String;
		public var updateContent:String;
		public var deleteContent:String;
		public var tablename:String;
		
		public function ConfigurationObject()
		{
			super();
		}
	}
}	