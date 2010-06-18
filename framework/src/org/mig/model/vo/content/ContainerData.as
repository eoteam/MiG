package org.mig.model.vo.content
{
	import org.mig.model.vo.ConfigurableContentData;
	import org.mig.model.vo.ContentData;
	import org.mig.model.vo.ValueObject;

	[Bindable] 
	public dynamic class ContainerData extends ConfigurableContentData
	{
		public var parentid:int;		
		public var statusid:int;
		public var migtitle:String;
		public var is_fixed:int;
		public var templateid:int;
		public var deleted:int;
		
		// this used when a content is partially loaded, content table, maybe media when not all the file info is needed --xmp and id3
	}
}