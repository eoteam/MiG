package org.mig.services
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.xml.XMLDocument;
	
	import mx.core.ClassFactory;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;
	
	import org.mig.controller.Constants;
	import org.mig.model.AppModel;
	import org.mig.model.ContentModel;
	import org.mig.model.vo.ConfigurationObject;
	import org.mig.model.vo.ContentData;
	import org.mig.model.vo.ContentNode;
	import org.mig.model.vo.UpdateData;
	import org.mig.model.vo.app.CustomField;
	import org.mig.model.vo.app.StatusResult;
	import org.mig.model.vo.content.ContainerData;
	import org.mig.model.vo.content.ContainerNode;
	import org.mig.model.vo.content.ContentStatus;
	import org.mig.model.vo.content.ContentTab;
	import org.mig.model.vo.content.ContentTabParameter;
	import org.mig.model.vo.content.SubContainerNode;
	import org.mig.model.vo.content.Template;
	import org.mig.model.vo.manager.ManagerConfig;
	import org.mig.model.vo.manager.Term;
	import org.mig.model.vo.media.MimeType;
	import org.mig.model.vo.user.UserPrivileges;
	import org.mig.services.interfaces.IContentService;

	public class ContentService extends AbstractService implements IContentService
	{
		[Inject]
		public var contentModel:ContentModel;
		
		[Inject]
		public var appModel:AppModel;
		
		public function ContentService() {
			
		}
		public function loadRelatedCustomfields(config:ManagerConfig,...args):void {
			var params:Object = new  Object();
			params.action = ValidFunctions.GET_RELATED_CUSTOMFIELDS;
			params.tablename = config.customfieldsConfig.tablename;
			for each(var prop:Object in args) {
				params[prop.name] = prop.value;
			}
			this.createService(params,ResponseType.DATA,CustomField);				
		}
		public function loadTemplates():void {
			var params:Object = new  Object();
			params.action = ValidFunctions.GET_DATA;
			params.tablename = "templates";
			params.orderby= "id";
			this.createService(params,ResponseType.DATA,Template);		
		}
		public function loadContentTabs():void {
			var params:Object = new  Object();
			params.action = ValidFunctions.GET_CONTENTTABS;
			//params.tablename = "contenttabs";
			this.createService(params,ResponseType.DATA,ContentTab);				
		}
		public function loadTemplateContentTabParameters(template:Template):void {
			var params:Object = new  Object();
			params.action = ValidFunctions.GET_TEMPLATE_CONTENTTABS_PARAMS;
			params.templateid = template.id;
			this.createService(params,ResponseType.DATA,ContentTabParameter).token.template = template;
		}
		public function loadMimeTypes():void {
			var params:Object = new Object();
			params.action = ValidFunctions.GET_DATA;
			params.tablename = "mimetypes";
			this.createService(params,ResponseType.DATA,MimeType);
		}
		public function loadTerms():void {
			var params:Object = new Object();
			params.action = contentModel.termsConfig.retrieveContent;
			this.createService(params,ResponseType.DATA,Term)
		}
		public function retrieveContentRoot():void {
			var params:Object = new Object();
			/*var contentConfig:XML 	= appModel.config.controller[1]; //XML(config.controller.(@id == "contentController"));
			var root:XML = XML(contentConfig.child[0].toString());
			root.@retrieveContent = contentModel.defaultRetrieve;
			params.action = root.@reieveContent.toString();*/
			params.action = ValidFunctions.GET_ROOT;
			this.createService(params,ResponseType.DATA,ContainerData);
		}
		public function retrieveChildren(content:ContentNode):void {
			//this is fine here, params are a map object. Im guessing REST will form a URL, but awareness of these vars is tricky
			if(content is ContainerNode)
				loadContainer(content as ContainerNode);
			else if(content is SubContainerNode)
				loadSubContainer(content as SubContainerNode);
		}
		public function createContainer(title:String,template:Template):void {
			var date:Date = new Date();
			var time:Number = Math.round(date.time / 1000);
			var params:Object = new Object();
			params.action = template.createContent;
			params.tablename = template.tablename;
			//if(contentModel.currentContainer.config.attribute("templateid").length() > 0)
			//{
			params.templateid = template.id;
			
			for each(var field:CustomField in template.customfields) {
				if(field.defaultvalue != null) {
					params[field.name] = field.defaultvalue;
				}
			}
			
			
			//}
			if(contentModel.currentContainer.isRoot)
				params.parentid = 0;
			else
				params.parentid = contentModel.currentContainer.data.id;
			params.migtitle = title;
			params.is_fixed = template.is_fixed;
			params.createdby = appModel.user.id;
			params.modifiedby = appModel.user.id;
			params.createdate = time;
			params.modifieddate = time;
			params.statusid = ContentStatus.DRAFT;
			params.verbose = true;
			this.createService(params,ResponseType.DATA,ContainerData).token.template = template;	
		}		
		public function retrieveContainer(content:ContentNode,verbose:Boolean=true):void {
			if(content is ContainerNode) {
				var params:Object = new Object();
				params.action = ValidFunctions.GET_CONTENT;
				params.contentid = content.data.id;
				if(verbose)
					params.verbosity = 1;
				else
					params.verbosity = 0;
				this.createService(params,ResponseType.DATA,ContainerData);
			}
		}
		public function updateContainer(container:ContainerNode,update:UpdateData):void {
			var params:Object = new Object();
			for (var prop:String in update)
				params[prop] = update[prop];
			params.action = ValidFunctions.UPDATE_RECORD;
			params.tablename = container.template.tablename;
			params.id = update.id;
			var service:XMLHTTPService = this.createService(params,ResponseType.STATUS);
			service.token.content = container;
			service.token.update = update;
		}		
		public function deleteContainer(container:ContainerNode):void {
			var params:Object = new Object();
			params.action = container.template.deleteContent;
			params.tablename = "content";
			params.id = container.data.id;
			if(params.action == ValidFunctions.UPDATE_RECORD) {
				params.deleted = 1;
			}
			var service:XMLHTTPService = this.createService(params,ResponseType.STATUS);
			service.token.content = container;
		}
/*		public function duplicateContainer(container:ContainerNode):void {
			var params:Object = new Object();
			params.action = ValidFunctions.DUPLICATE_CONTENT;
			params.id = container.data.id;
			this.createService(params,ResponseType.DATA,ContainerData).token.content = container;
		}*/

		public function updateContainersStatus(containers:Array,statusid:int):void {
			var params:Object = new Object();
			params.action = ValidFunctions.UPDATE_RECORDS;
			params.tablename = "content";
			var ids:String = '';
			for each(var container:ContainerNode in containers) {
				ids += container.data.id + ',';
			}
			ids += ids.substr(0,ids.length-1);
			params.updatefield = "statusid";
			params.updatevalue = statusid;
			params.idfield = "id";
			params.idvalues = ids;
			this.createService(params,ResponseType.STATUS).token.containers = containers;
		}
		public function createContent(vo:ContentData,config:ConfigurationObject,customfields:Array,status:Boolean=false):void {
			var updateData:UpdateData = vo.updateData;
			var params:Object = new Object();
			var service:XMLHTTPService
			for (var prop:String in updateData) {
				if(prop != "modified" && prop != "updateData" && prop != "mx_internal_uid")
					params[prop] = updateData[prop];
			}
			params.action = config.createContent;
			if(ValidFunctions.FUNCTIONS_WITH_TABLENAME.indexOf(params.action) != -1)
				params.tablename = config.tablename
			//if(config.attribute("createVerbose").length() > 0) {
			//	params.verbose = config.@createVerbose.toString() == "true" ? true:false;
			//}
			//reverse translate customfields
			/*			for (prop in params) {
			for each(var customfield:CustomField in customfields) {
			if(prop == customfield.name)
			var value:String = params[prop];
			if(value != null) {
			delete params[prop];
			params["customfield"+customfield.fieldid] = value;
			}
			}
			}*/
			
			if(!status) {
				var classToUse:String = flash.utils.getQualifiedClassName(vo);
				var classRef:Class = flash.utils.getDefinitionByName(classToUse) as Class; 
				//var resultClass:ClassFactory = new ClassFactory(classRef);
				service = this.createService(params,ResponseType.DATA,classRef,handleContentCreated);
			}
			else {
				service = this.createService(params,ResponseType.STATUS,null,handleContentCreatedStatus);
			}
			service.service.showBusyCursor = true;
			service.token.content = vo;
		}
		public function retrieveContent(id:int,config:ConfigurationObject,clazz:Class):void {
			var params:Object = new Object();
			params.action = config.retrieveContent;
			params.tablename = config.tablename;
			params.id = id;
			this.createService(params,ResponseType.DATA,clazz);
		}
		public function updateContent(vo:ContentData,config:ConfigurationObject,customfields:Array):void {
			var updateData:UpdateData = vo.updateData;
			var params:Object = new Object();
			for (var prop:String in updateData) {
				if(prop != "modified" && prop != "updateData")
					params[prop] = updateData[prop];
			}
			params.action = config.updateContent;
			if(ValidFunctions.FUNCTIONS_WITH_TABLENAME.indexOf(params.action) != -1)
				params.tablename = config.tablename;
			params.id = vo.id;
			
			//reverse translate customfields
/*			for (prop in params) {
				for each(var customfield:CustomField in customfields) {
					if(prop == customfield.name)
					var value:String = params[prop];
					if(value != null) {
						delete params[prop];
						params["customfield"+customfield.fieldid] = value;
					}
				}
			}*/
			var service:XMLHTTPService = this.createService(params,ResponseType.STATUS,null,handleContentUpdated);
			service.service.showBusyCursor = true;
			service.token.content = vo;
			service.token.update = updateData;
		}
		public function deleteContent(vo:ContentData,config:ConfigurationObject,...args):void {
			var params:Object = new Object();
			params.action = config.deleteContent;
			if(ValidFunctions.FUNCTIONS_WITH_TABLENAME.indexOf(params.action) != -1)
					params.tablename = config.tablename;	
			params.id = vo.id;
			for each(var arg:Object in args) {
				params[arg.name] = arg.value;
			}
			//var classToUse:String = flash.utils.getQualifiedClassName(vo);
			//var classRef:Class = flash.utils.getDefinitionByName(classToUse) as Class; 
			//var resultClass:ClassFactory = new ClassFactory(classRef);
			var service:XMLHTTPService = this.createService(params,ResponseType.STATUS);
			service.service.showBusyCursor = true;
			service.token.content = vo;			
		}
		private function handleContentUpdated(data:Object):void {
			var status:StatusResult = data.result as StatusResult;
			if(status.success) {
				var vo:ContentData = data.token.content as ContentData;
				for (var prop:String in vo.updateData)
					vo[prop] = vo.updateData[prop];
				vo.updateData = new UpdateData();
			}	
		}
		private function handleContentCreated(data:Object):void {
			var results:Array = data.result as Array;
			if(results.length == 1) {
				var result:ContentData = results[0] as ContentData;
				var vo:ContentData = data.token.content as ContentData;
				vo.id = results[0].id;
				vo.updateData = new UpdateData();
			}	
		}
		private function handleContentCreatedStatus(data:Object):void {
			var result:StatusResult = data.result as StatusResult;
			if(result.success) {
				var vo:ContentData = data.token.content as ContentData;
				vo.updateData = new UpdateData();
			}	
		}
		private function loadContainer(container:ContainerNode):void {
			var params:Object = new Object();
			var execute:Boolean = false;			
			if(container.isRoot) { //Containers ?????
				if(container.privileges ==  UserPrivileges.MiGAdmin)
					params.parentid = "1,2";
				else
					params.parentid = 1;
			}
			else {//Anything else, even fixed ones, will onyl get their children
				params.parentid = ContainerData(container.data).id.toString();
//				if(container.isNesting)
//					execute = true; //good for content leaves AND relational nodes in tabs and trays
//				else {
//					//this.dispatchEvent(new ContentNodeEvent(ContentNodeEvent.READY,this,true));
//					return;
//				}
			}		
			params.action = container.template.retrieveContent;
			params.deleted = 0;
			params.orderby = container.template.orderby;
			params.orderdirection = container.template.orderdirection
			params.verbosity = container.template.verbosity;
			var service:XMLHTTPService = this.createService(params,ResponseType.DATA,ContainerData);
			service.token.content = container;
		}
		private function loadSubContainer(content:SubContainerNode):void {
			if(content.queryVars != null) {
				var params:Object = new Object();
				params.action = content.tab.retrieveContent;
				if(params.action == "getData") {
					params.tablename = content.tab.tablename;
				}
				params.orderby = content.tab.orderby;
				params.orderdirection = content.tab.orderdirection;
				
/*				params.include_children = 1;
				params.children_depth = content.config.@children_depth.toString();	
				params.deleted = content.config.@deleted.toString();*/
				
				for (var item:String in SubContainerNode(content).queryVars) {
					if(SubContainerNode(content).queryVars[item] == "")
						params[item] = 0;
					else
						params[item] = SubContainerNode(content).queryVars[item];
				}
				var classToUse:String = content.tab.dto;
				var classRef:Class = getDefinitionByName(classToUse) as Class;
				var service:XMLHTTPService = this.createService(params,ResponseType.DATA,classRef);
				service.token.content = content;				
			}
		}
	}
}