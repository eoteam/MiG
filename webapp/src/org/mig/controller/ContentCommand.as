package org.mig.controller
{
	import flash.text.engine.ContentElement;
	
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;
	
	import org.mig.events.ContentEvent;
	import org.mig.events.NotificationEvent;
	import org.mig.events.ViewEvent;
	import org.mig.model.ContentModel;
	import org.mig.model.vo.ConfigurableContentData;
	import org.mig.model.vo.ContentData;
	import org.mig.model.vo.ContentNode;
	import org.mig.model.vo.app.StatusResult;
	import org.mig.model.vo.content.ContainerData;
	import org.mig.model.vo.content.ContainerNode;
	import org.mig.model.vo.content.SubContainerNode;
	import org.mig.model.vo.media.DirectoryNode;
	import org.mig.services.ContentService;
	import org.mig.services.interfaces.IAppService;
	import org.mig.services.interfaces.IContentService;
	import org.robotlegs.mvcs.Command;
	
	public class ContentCommand extends Command
	{
		[Inject]
		public var appService:IAppService;		
		
		[Inject]
		public var service:IContentService;
		
		[Inject]
		public var event:ContentEvent;
		
		[Inject]
		public var contentModel:ContentModel;
		
		private var deleteCount:int;
		private var deleteTracker:int;
		
		override public function execute():void {
			switch(event.type) {
				case ContentEvent.RETRIEVE_CHILDREN:
					service.retrieveChildren(event.args[0] as ContentNode);
					service.addHandlers(processChildren);
					ContentNode(event.args[0]).state = ContentNode.LOADING;
				break;
				
				case ContentEvent.RETRIEVE_VERBOSE:
					service.retrieveContainer(event.args[0] as ContentNode);
					service.addHandlers(handleLoadComplete);
				break;
				case ContentEvent.DELETE:
					deleteTracker = 0;
					deleteCount = event.args[0].length;
					for each(var node:ContainerNode in event.args[0]) {
						service.deleteContainer(node);
						service.addHandlers(handleContainerDelete);
						node.state = ContentNode.LOADING;
					}
				break; 
				case ContentEvent.DUPLICATE:
					for each(var item:ContainerNode in event.args[0]) {
					if(!item.isRoot && !item.isFixed) {
						var tables:String = "content_media,content_content,content_users,content_terms,comments";
						appService.duplicateObject(item.data,item.config,"contentid",tables);
						appService.addHandlers(handleDuplicate);
					}	
				}
				break;
				case ContentEvent.CREATE:
					service.createContainer(event.args[0] as String, event.args[1] as XML);
					service.addHandlers(handleNewContainer);
				break;
				case ContentEvent.SELECT:
					contentModel.currentContainer = event.args[0] as ContainerNode;
				break;
			}
		}
		private function handleLoadComplete(data:Object):void {
			ContainerNode(event.args[0]).data = data.result[0]; 
			ContainerData(ContainerNode(event.args[0]).data).loaded = true;
			eventDispatcher.dispatchEvent(new ContentEvent(ContentEvent.SELECT,event.args[0]));
		}
		private function handleContainerDelete(data:Object):void {
			var result:StatusResult = data.result as StatusResult;
			var node:ContainerNode = data.token.content as ContainerNode;
			node.state = ContentNode.LOADED;
			if(result.success) {
				var index:int = node.parentNode.children.getItemIndex(node);
				node.parentNode.children.removeItemAt(index);
				eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.NOTIFY,"Container delete successfully"));
				deleteTracker++;
				if(deleteTracker == deleteCount) {
					//eventDispatcher.dispatchEvent(new ViewEvent(ViewEvent.REFRESH_CONTENT));
				}
			}
		}
		private function handleDuplicate(data:Object):void {
			var status:StatusResult = data.result as StatusResult;
			var node:ContainerNode = data.token.content as ContainerNode;
			if(status) {
				var id:int = Number(status.message);
				var contentData:ContainerData = new ContainerData();
				contentData.id = id;	
				var newNode:ContainerNode = new ContainerNode(node.baseLabel,node.config,contentData,node.parentNode,node.privileges,false,false,node.isNesting);
				node.parentNode.children.addItemAt(newNode,0);
				if(node.state == ContentNode.NOT_LOADED)
					service.retrieveContainer(newNode,false);
				else
					service.retrieveContainer(newNode,true);
				service.addHandlers(handleDuplicatedContentLoaded);
			}
		}
		private function handleDuplicatedContentLoaded(data:Object):void {	
			var node:ContainerNode = data.token.content as ContainerNode;
			var contentData:ContainerData = data.result[0] as ContainerData;		
			node.data = contentData;
			eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.NOTIFY,"Container duplicated successfully"));
			//eventDispatcher.dispatchEvent(new ViewEvent(ViewEvent.REFRESH_CONTENT));
			
			/*			dupTracker++;
			if(dupTracker == dupCount)
			{
				for each(var p:ContentNode in parentNodesToUpdate)
				{
					p.updateChildrenOrder(Application.application.user.id);
				}
				var rend:ContentTreeRenderer;
				var item:Object;
				for each(item in prevSelected)
				{
					if(this.selectedItems.indexOf(item) == -1)
					{	
						rend = ContentTreeRenderer(this.itemToItemRenderer(item));
						if(rend)
							rend.setColorHalfOff();
					}
				}
				prevSelected = [];
			}*/
		}

		private function processChildren(data:Object):void {
			var results:Array = data.result as Array;
			var nesting:Boolean;
			var fixed:Boolean;
			var node:ContainerNode;
			var item:ContainerData;
			var resultLabel:String; 
			var content:ContentNode = data.token.content;
						
			if(content is ContainerNode) {	
/*				contentModel.containersLoaded++;
				trace("Loading Content: " ,contentModel.containersLoaded,contentModel.containersToLoad);
				if(contentModel.containersLoaded == contentModel.containersToLoad) {
					eventDispatcher.dispatchEvent(new ViewEvent(ViewEvent.ENABLE_CONTENT_TREE));
				}*/
				if(results.length > 0) {
					ContainerNode(content).isBranch = true;
					for each (item in results) {
						resultLabel = item[content.config.@labelField];
						var containerConfig:XML; 			
						fixed = item.is_fixed.toString() == "1" ? true:false;
						nesting = false;
						if(ContainerNode(content).isNesting) {
							containerConfig = ObjectUtil.copy(content.config) as XML; //replicate the same config 
							nesting = true;
						}
						else {
							if(fixed) {	
								for each(var child:XML  in content.config.child) {							
									if(child.@is_fixed.toString() == '1' && child.@id.toString() == item.id) {
										containerConfig = child;
										break;
									}	
								}
							}		
							else {
								for each(child  in content.config.child) {
									var allowedTemplates:Array = child.@templateid.toString().split(',');
									if(allowedTemplates.indexOf(item.templateid.toString()) != -1) {
										containerConfig = child;
										break;
									}
								}
							}				
							if(containerConfig.attribute("nesting").length() > 0 && containerConfig.@nesting == "1") {
								containerConfig = ObjectUtil.copy(containerConfig) as XML; //replicate the same config
								nesting = true;
							}
						}
						node = new ContainerNode(resultLabel, containerConfig, item,content,content.privileges,false,fixed,nesting);
						content.children.addItem(node);
						content.state = ContentNode.LOADED;
						eventDispatcher.dispatchEvent(new ViewEvent(ViewEvent.VALIDATE_CONTENT));
					}
				}
			}
			else if(content is SubContainerNode) {
				ContainerData(content.data).loaded = true;
				for each (var reldata:ContentData in results) {
					//resultLabel = reldata[content.config.@labelField];				
					//var relnode:ContentNode = new ContentNode(resultLabel,content.config,reldata,content,content.privileges);
					content.children.addItem(reldata);
				}
			}	
		}
		private function handleNewContainer(data:Object):void {
			if(contentModel.currentContainer.state == ContentNode.LOADED) {
			var config:XML = data.token.config as XML;
			var contentData:ContainerData = data.result[0] as ContainerData;
			var is_fixed:Boolean = contentData.is_fixed == 0 ?false:true;
			var nesting:Boolean = false;
			if(config.attribute("nesting").length() > 0) {
				nesting = config.@nesting.toString() == "0" ? false : true;
			}
			var node:ContainerNode = new ContainerNode(contentData.migtitle,config,contentData,contentModel.currentContainer,
													   contentModel.currentContainer.privileges,false,is_fixed,nesting);
			contentModel.currentContainer.children.addItemAt(node,0);
			}
			contentModel.currentContainer.data.childrencount += 1;
			eventDispatcher.dispatchEvent(new ViewEvent(ViewEvent.ENABLE_NEW_CONTENT,true,false));
			eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.NOTIFY,"Container created successfully"));
		}
	}
}


