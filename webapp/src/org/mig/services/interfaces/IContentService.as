package org.mig.services.interfaces
{
	import org.mig.model.vo.ConfigurationObject;
	import org.mig.model.vo.ContentData;
	import org.mig.model.vo.ContentNode;
	import org.mig.model.vo.UpdateData;
	import org.mig.model.vo.content.ContainerNode;
	import org.mig.model.vo.content.ContentTab;
	import org.mig.model.vo.content.Template;
	import org.mig.model.vo.manager.ManagerConfig;
	import org.mig.model.vo.manager.Term;

	public interface IContentService extends IService
	{
		function loadTemplates():void;
		
		function loadRelatedCustomfields(config:ManagerConfig,...args):void;
		
		function loadContentTabs():void;
		
		//function loadContentTabParameters(tab:ContentTab):void;
		
		function loadTemplateContentTabParameters(template:Template):void;
		
		function loadMimeTypes():void;
		
		function loadTerms():void;
		
		function retrieveContentRoot():void;
		
		function retrieveChildren(content:ContentNode):void;
		
		function retrieveContainer(content:ContentNode,verbose:Boolean=true):void;
		
		function deleteContainer(content:ContainerNode):void;
		
		function createContainer(title:String,template:Template):void;
		
		function updateContainer(container:ContainerNode,update:UpdateData):void;
		
		function updateContainersStatus(containers:Array,statusid:int):void;
		
		//refactor this later
		function retrieveContent(id:int,config:ConfigurationObject,clazz:Class):void;
		
		function updateContent(vo:ContentData,config:ConfigurationObject,customfields:Array):void;
		
		function createContent(vo:ContentData,config:ConfigurationObject,customfields:Array,status:Boolean=false):void;
		
		function deleteContent(vo:ContentData,config:ConfigurationObject,...args):void;
	}
}