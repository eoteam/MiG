package org.mig.model.vo.manager
{
	import org.mig.model.vo.ConfigurationObject;
	
	[Bindable]
	public class ManagerConfig extends ConfigurationObject
	{
		public var cfCreateContent:String;
		public var cfRetrieveContent:String;
		public var cfUpdateContent:String;
		public var cfDeleteContent:String;
		public var cfTablename:String;
		public var customfields:Boolean;
		public var type:String;
		
		public function ManagerConfig()
		{
			super();
		}
	}
}