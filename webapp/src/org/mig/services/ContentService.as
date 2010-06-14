package org.mig.services
{
	import flash.xml.XMLDocument;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;
	import flash.utils.getDefinitionByName;
	
	import org.mig.controller.Constants;
	import org.mig.model.AppModel;
	import org.mig.model.ContentModel;
	import org.mig.model.vo.ContentNode;
	import org.mig.model.vo.CustomField;
	import org.mig.model.vo.UpdateData;
	import org.mig.model.vo.content.ContainerNode;
	import org.mig.model.vo.content.ContentData;
	import org.mig.model.vo.content.ContentStatus;
	import org.mig.model.vo.content.SubContainerNode;
	import org.mig.model.vo.content.Template;
	import org.mig.model.vo.content.TemplateCustomField;
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
		public function retrieveContentRoot():void {
			var params:Object = new Object();
			/*var contentConfig:XML 	= appModel.config.controller[1]; //XML(config.controller.(@id == "contentController"));
			var root:XML = XML(contentConfig.child[0].toString());
			root.@retrieveContent = contentModel.defaultRetrieve;
			params.action = root.@retrieveContent.toString();*/
			params.action = ValidFunctions.GET_ROOT;
			this.createService(params,ResponseType.DATA,ContentData);
		}
		public function retrieveChildren(content:ContentNode):void {
			//this is fine here, params are a map object. Im guessing REST will form a URL, but awareness of these vars is tricky
			if(content is ContainerNode)
				loadContainer(content);
			else if(content is SubContainerNode)
				loadSubContainer(content);
		}
		public function retrieveVerbose(content:ContentNode):void {
			if(content is ContainerNode) {
				var params:Object = new Object();
				params.action = ValidFunctions.GET_CONTENT;
				params.contentid = content.data.id;
				params.verbosity = 1;
				this.createService(params,ResponseType.DATA,ContentData);
			}
		}
		public function deleteContainer(container:ContainerNode):void {
			var params:Object = new Object();
			params.action = container.config.@deleteContent.toString();
			params.tablename = "content";
			params.id = container.data.id;
			if(params.action == ValidFunctions.UPDATE_RECORD) {
				params.deleted = 1;
			}
			var service:XMLHTTPService = this.createService(params,ResponseType.STATUS);
			service.token.content = container;
		}
		public function duplicateContainer(container:ContainerNode):void {
			var params:Object = new Object();
			params.action = ValidFunctions.DUPLICATE_CONTENT;
			params.id = container.data.id;
			this.createService(params,ResponseType.DATA,ContentData).token.content = container;
		}
		public function updateContainer(container:ContainerNode,update:UpdateData):void {
			var params:Object = new Object();
			for (var prop:String in update)
				params[prop] = update[prop];
			params.action = ValidFunctions.UPDATE_RECORD;
			params.tablename = container.config.@tablename.toString();
			params.id = update.id;
			var service:XMLHTTPService = this.createService(params,ResponseType.STATUS);
			service.token.content = container;
			service.token.update = update;
		}
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
		public function createContainer(title:String,config:XML):void {
			var date:Date = new Date();
			var time:Number = Math.round(date.time / 1000);
			var params:Object = new Object();
			params.action = ValidFunctions.INSERT_RECORD;
			params.tablename = config.@tablename.toString();
			
			if(contentModel.currentContainer.config.attribute("templateid").length() > 0)
			{
				params.templateid = contentModel.currentContainer.config.@templateid.toString();
				for each(var template:Template in contentModel.templates) {
					if(params.templateid == template.id) {
						for each(var field:TemplateCustomField in template.customfields) {
							if(field.customfield.defaultvalue != null) {
								params["customfield"+field.fieldid] = field.customfield.defaultvalue;
							}
						}
					}
				}
			}
			if(contentModel.currentContainer.isRoot)
				params.parentid = 0;
			else
				params.parentid = contentModel.currentContainer.data.id;
			params.migtitle = title;
			params.is_fixed = config.@is_fixed.toString();
			params.createdby = appModel.user.id;
			params.modifiedby = appModel.user.id;
			params.createdate = time;
			params.modifieddate = time;
			params.statusid = ContentStatus.DRAFT;
			params.verbose = true;
			this.createService(params,ResponseType.DATA,ContentData).token.config = config;	
		}
		private function loadContainer(content:ContentNode):void {
			var params:Object = new Object();
			var execute:Boolean = false;			
			if(ContainerNode(content).isRoot) { //Containers
				if(content.privileges ==  UserPrivileges.MiGAdmin)
					params.parentid = "1,2	";
				else
					params.parentid = 1;
			}
			else {//Anything else, even fixed ones, will onyl get their children
				params.parentid = ContentData(content.data).id.toString();
				if(ContainerNode(content).isNesting || content.config.children().length() > 0)
					execute = true; //good for content leaves AND relational nodes in tabs and trays
				else {
					//this.dispatchEvent(new ContentNodeEvent(ContentNodeEvent.READY,this,true));
					return;
				}
			}		
			params.action = content.config.@retrieveContent.toString();			
			params.deleted = 0;
			if(content.config.attribute("orderby").length() > 0) 
				params.orderby = content.config.@orderby.toString();
			if(content.config.attribute("orderdirection").length() > 0) 
				params.orderdirection = content.config.@orderdirection.toString();
			if(content.config.attribute("verbosity").length() > 0)
				params.verbosity = content.config.@verbosity.toString();
			else
				params.verbosity = 0;
			var service:XMLHTTPService = this.createService(params,ResponseType.DATA,ContentData);
			service.token.content = content;
		}
		private function loadSubContainer(content:ContentNode):void {
			if(SubContainerNode(content).queryVars != null) {
				var params:Object = new Object();
				params.action = content.config.@retrieveContent.toString();
				if(params.action == "getData") {
					if(content.config.attribute("tablename").length() > 0) 
						params.tablename = content.config.@tablename.toString();
				}
				if(content.config.attribute("verbosity").length() > 0) 	
					params.verbosity = content.config.@verbosity.toString();
				if(content.config.attribute("orderby").length() > 0) 
					params.orderby = content.config.@orderby.toString();
				if(content.config.attribute("orderdirection").length() > 0)
					params.orderdirection = content.config.@orderdirection.toString();					
				if(content.config.attribute("include_children").length() > 0)
					params.include_children = 1;
				if(content.config.attribute("children_depth").length() > 0)
					params.children_depth = content.config.@children_depth.toString();	
				if(content.config.attribute("deleted").length() > 0)
					params.deleted = content.config.@deleted.toString();							
				for (var item:String in SubContainerNode(content).queryVars) {
					if(SubContainerNode(content).queryVars[item] == "")
						params[item] = 0;
					else
						params[item] = SubContainerNode(content).queryVars[item];
				}
				var classToUse:String = content.config.@dataObject;
				var classRef:Class = getDefinitionByName(classToUse) as Class;
				var service:XMLHTTPService = this.createService(params,ResponseType.DATA,classRef);
				service.token.content = content;				
			}
		}
	}
}