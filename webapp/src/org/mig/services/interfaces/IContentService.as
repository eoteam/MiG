package org.mig.services.interfaces
{
	import org.mig.model.vo.ContentNode;
	import org.mig.model.vo.UpdateData;
	import org.mig.model.vo.content.ContainerNode;

	public interface IContentService extends IService
	{
		function retrieveContentRoot():void;
		
		function retrieveChildren(content:ContentNode):void;
		
		function retrieveVerbose(content:ContentNode):void;
		
		function deleteContainer(content:ContainerNode):void;
		
		function duplicateContainer(content:ContainerNode):void;
		
		function createContainer(title:String,config:XML):void;
		
		function updateContainer(container:ContainerNode,update:UpdateData):void;
		
		function updateContainersStatus(containers:Array,statusid:int):void;
	}
}