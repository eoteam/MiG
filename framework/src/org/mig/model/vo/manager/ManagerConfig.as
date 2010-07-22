package org.mig.model.vo.manager
{
	import org.mig.model.vo.ConfigurationObject;
	
	[Bindable]
	public class ManagerConfig extends ConfigurationObject
	{		
		public var customfieldsConfig:ConfigurationObject;
		
		public var customfields:Boolean;
		public var type:String;
		
		public function ManagerConfig()
		{
			super();
			children = null;
		}
	}
}