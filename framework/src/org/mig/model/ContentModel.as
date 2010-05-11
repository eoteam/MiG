package org.mig.model
{
	import mx.collections.ArrayCollection;
	
	import org.mig.model.vo.content.ContainerNode;
	import org.mig.model.vo.media.MediaCategoryNode;
	import org.robotlegs.mvcs.Actor;

	public class ContentModel extends Actor
	{
		public var contentModel:ContainerNode;
		public var templates:ArrayCollection = new ArrayCollection();
		
		public var mediaModel:MediaCategoryNode;
		//public var mediaModel:MediaCategoryNode;
	}
}