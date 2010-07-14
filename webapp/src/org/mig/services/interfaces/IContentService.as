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
		
		//function loadTemplateCustomfields():void;
		
		function loadMimeTypes():void;
		
		function loadTerms():void;

		function loadRelatedCustomfields(config:XML,...args):void;
		
		function retrieveContentRoot():void;
		
		function retrieveChildren(content:ContentNode):void;
		
		function retrieveContainer(content:ContentNode,verbose:Boolean=true):void;
		
		function deleteContainer(content:ContainerNode):void;
		
		function createContainer(title:String,config:XML):void;
		
		function updateContainer(container:ContainerNode,update:UpdateData):void;
		
		function updateContainersStatus(containers:Array,statusid:int):void;
		
		//refactor this later
		function retrieveContent(id:int,config:XML,clazz:Class):void;
		function updateContent(vo:ContentData,config:XML,customfields:Array):void;
		function createContent(vo:ContentData,config:XML,customfields:Array,status:Boolean=false):void;
		function deleteContent(vo:ContentData,config:XML):void;
	}
}