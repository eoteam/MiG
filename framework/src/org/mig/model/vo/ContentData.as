package org.mig.model.vo
{
	import mx.collections.ArrayCollection;

	[Bindable]
	public dynamic class ContentData extends ValueObject
	{
		public var modified:Boolean = false;
		
		public var createdby:int;
		public var createdate:Number;
		public var modifiedby:int;
		public var modifieddate:Number;		
		
		public var updateData:UpdateData = new UpdateData();
		
		public var parent:ContentData;
		public var children:Array;
		
	}
}