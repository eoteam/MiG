package org.mig.services.interfaces
{
	import org.mig.model.vo.ContentNode;

	public interface IContentService extends IService
	{
		function retrieve(content:ContentNode):void;
		
	}
}