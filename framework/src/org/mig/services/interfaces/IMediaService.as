package org.mig.services.interfaces
{
	import org.mig.model.vo.media.MediaCategoryNode;

	public interface IMediaService extends IService
	{
		function retrieveChildrenFromDisk(content:MediaCategoryNode):void;
		
		function retrieveChildrenFromDatabase(content:MediaCategoryNode):void;
	}
}