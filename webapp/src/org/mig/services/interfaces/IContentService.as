package org.mig.services.interfaces
{
	import org.mig.model.vo.ContentNode;

	public interface IContentService extends IService
	{
		function retrieveChildren(content:ContentNode):void;
		
		function retrieveVerbose(content:ContentNode):void;
		
	}
}