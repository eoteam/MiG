package org.mig.services
{
	import flash.xml.XMLDocument;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;
	
	import org.mig.controller.Constants;
	import org.mig.model.vo.ContentNode;
	import org.mig.model.vo.content.ContainerNode;
	import org.mig.model.vo.content.ContentData;
	import org.mig.model.vo.content.SubContainerNode;
	import org.mig.model.vo.user.UserPrivileges;
	import org.mig.services.interfaces.IContentService;

	public class ContentService extends AbstractService implements IContentService
	{
		public function ContentService() {
			
		}
		public function retrieveChildren(content:ContentNode):void {
			//this is fine here, params are a map object. Im guessing REST will form a URL, but awareness of these vars is tricky
			var params:Object = new Object();
			if(content is ContainerNode) {
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
				params.action = content.config.@action.toString();			
				params.deleted = 0;
				if(content.config.attribute("orderby").length() > 0) 
					params.orderby = content.config.@orderby.toString();
				if(content.config.attribute("orderdirection").length() > 0) 
					params.orderdirection = content.config.@orderdirection.toString();
				if(content.config.attribute("verbosity").length() > 0)
					params.verbosity = content.config.@verbosity.toString();
				else
					params.verbosity = 0;
			}
			else if(content is SubContainerNode) {
				if(SubContainerNode(content).queryVars != null) {
					params.action = content.config.@getContent.toString();
					if(content.config.attribute("tablename").length() > 0) 
						params.tablename = content.config.@tablename.toString();
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
				}
			}
			var service:XMLHTTPService = this.createService(params,ResponseType.DATA,ContentData);
			service.token.content = content;
		}
		public function retrieveVerbose(content:ContentNode):void {
			if(content is ContainerNode) {
				var params:Object = new Object();
				params.action = "getContent";
				params.contentid = content.data.id;
				params.verbosity = 1;
				this.createService(params,ResponseType.DATA,ContentData);
			}
		}
	}
}