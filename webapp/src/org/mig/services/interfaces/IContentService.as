package org.mig.services.interfaces
{
	import org.mig.model.vo.ContentNode;

	public interface IContentService
	{
		function retrieve(content:ContentNode,callback:Function):void;
		
	}
}