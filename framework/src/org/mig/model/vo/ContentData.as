package org.mig.model.vo
{
	import mx.collections.ArrayCollection;

	//User ContainerData MediaData
	/**
	 * @flowerModelElementId _ec7rQc2REd--irTzzklAjg
	 */
	[Bindable]
	public dynamic class ContentData extends BaseVO
	{		
		public var createdby:int;
		public var createdate:Number;
		public var modifiedby:int;
		public var modifieddate:Number;	
			
		public var parent:ContentData;
		public var children:Array = []; //this is used almost by all data structures except content which is wrapped up in the node object
										//and config objects
		
		public function ContentData() 
		{
			stateProps = ["stateProps","isNew","modified","updateData","children","parent"];
		}
	}
}