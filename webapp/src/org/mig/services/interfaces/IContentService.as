package org.mig.services.interfaces
{
	import org.mig.model.vo.ContentNode;
	import org.mig.model.vo.content.ContainerNode;

	public interface IContentService extends IService
	{
		function retrieveChildren(content:ContentNode):void;
		
		function retrieveVerbose(content:ContentNode):void;
		
		function deleteContainer(content:ContainerNode):void;
		
		function duplicateContainer(content:ContainerNode):void;
	}
}