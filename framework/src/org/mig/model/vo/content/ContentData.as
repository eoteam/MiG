package org.mig.model.vo.content
{
	import org.mig.model.vo.BaseContentData;
	import org.mig.model.vo.ValueObject;

	[Bindable] 
	public dynamic class ContentData extends BaseContentData
	{
				
		public var statusid:int;
		public var migtitle:String;
		public var is_fixed:int;
		public var templateid:int;
		
		
		// this used when a content is partially loaded, content table, maybe media when not all the file info is needed --xmp and id3
	}
}