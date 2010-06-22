package org.mig.model.vo
{
	[Bindable]
	public dynamic class ConfigurableContentData extends ValueObject 
	{
		public var loaded:Boolean = false;
		public var childrencount:int;
		
		public var modified:Boolean = false;
		
		public var createdby:int;
		public var createdate:Number;
		public var modifiedby:int;
		public var modifieddate:Number;	
	}
}