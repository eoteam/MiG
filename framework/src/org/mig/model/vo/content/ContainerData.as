package org.mig.model.vo.content
{
	import org.mig.model.vo.ContentData;
	import org.mig.model.vo.ValueObject;

	/**
	 * @flowerModelElementId _ec7rQM2REd--irTzzklAjg
	 */
	[Bindable] 
	public dynamic class ContainerData extends ContentData
	{
		public var parentid:int;		
		public var statusid:int;
		public var migtitle:String;
		public var is_fixed:int;
		public var templateid:int;
		public var deleted:int;
		

	}
}