package org.mig.model.vo
{
	[Bindable]
	public dynamic class ContentData extends ValueObject
	{
		public var modified:Boolean = false;
		public var createdby:int;
		public var createdate:Number;
		public var modifiedby:int;
		public var modifieddate:Number;		
	}
}