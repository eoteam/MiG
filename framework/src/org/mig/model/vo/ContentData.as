package org.mig.model.vo
{
	import mx.collections.ArrayCollection;

	[Bindable]
	public dynamic class ContentData extends ValueObject
	{
		
		public var createdby:int;
		public var createdate:Number;
		public var modifiedby:int;
		public var modifieddate:Number;		
		

		public var updateData:UpdateData = new UpdateData();
		
		public var parent:ContentData;
		public var children:Array = []; //this is used almost by all data structures except content which is wrapped up in the node object
		
		
		public var isNew:Boolean = true; //needed to discriminate delete from reorder actions of new objects
		public var modified:Boolean = false; //used almost never
		public var stateProps:Array;
		
		public function ContentData() {
			stateProps = ["stateProps","isNew","modified","updateData","children","parent"];
		}
	}
}