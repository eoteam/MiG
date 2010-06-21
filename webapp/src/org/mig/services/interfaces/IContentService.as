package org.mig.services.interfaces
{
	import org.mig.model.vo.ContentData;
	import org.mig.model.vo.ContentNode;
	import org.mig.model.vo.UpdateData;
	import org.mig.model.vo.content.ContainerNode;
	import org.mig.model.vo.manager.Term;

	public interface IContentService extends IService
	{
		function loadTemplates():void;
		
		function loadMimeTypes():void;
		
		function loadTerms():void;

		function loadCategoriesCustomFields():void;
		
		function retrieveContentRoot():void;
		
		function retrieveChildren(content:ContentNode):void;
		
		function retrieveVerbose(content:ContentNode):void;
		
		function deleteContainer(content:ContainerNode):void;
		
		function duplicateContainer(content:ContainerNode):void;
		
		function createContainer(title:String,config:XML):void;
		
		function updateContainer(container:ContainerNode,update:UpdateData):void;
		
		function updateContainersStatus(containers:Array,statusid:int):void;
		
		//function updateContent(vo:ContentData,config:XML):void;
	}
}