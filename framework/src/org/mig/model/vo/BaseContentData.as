package org.mig.model.vo
{
	public dynamic class BaseContentData extends ValueObject
	{
		public var modified:Boolean = false;
		public var createdby:int;
		public var createdate:Number;
		public var modifiedby:int;
		public var modifieddate:Number;		
		public var loaded:Boolean = false;
		public var count:int;
	}
}