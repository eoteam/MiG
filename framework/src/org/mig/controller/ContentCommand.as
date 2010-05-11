package org.mig.controller
{
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;
	
	import org.mig.events.ContentEvent;
	import org.mig.model.vo.ContentNode;
	import org.mig.model.vo.content.ContainerNode;
	import org.mig.model.vo.content.ContentData;
	import org.mig.model.vo.content.SubContainerNode;
	import org.mig.model.vo.media.MediaCategoryNode;
	import org.mig.services.ContentService;
	import org.mig.services.interfaces.IContentService;
	import org.robotlegs.mvcs.Command;
	
	public class ContentCommand extends Command
	{
		[Inject]
		public var service:IContentService;
		
		[Inject]
		public var event:ContentEvent;
		
		override public function execute():void {
			switch(event.type) {
				case ContentEvent.RETRIEVE_CHILDREN:
					service.retrieveChildren(event.content);
					service.addHandlers(processChildren);
				break;
				
				case ContentEvent.RETRIEVE_VERBOSE:
					service.retrieveVerbose(event.content);
					service.addHandlers(handleLoadComplete);
				break;
			}
		}
		private function handleLoadComplete(data:Object):void {
			event.content.data = data.result[0]; 
			ContentData(event.content.data).loaded = true;
			eventDispatcher.dispatchEvent(new ContentEvent(ContentEvent.SELECT,event.content));
		}
		private function processChildren(data:Object):void {
			var results:Array = data.result as Array;
			var nesting:Boolean;
			var fixed:Boolean;
			var node:ContainerNode;
			var item:ContentData;
			var resultLabel:String; 
			var content:ContentNode = data.token.content;
			if(results.length > 0) {
				
				if(content is ContainerNode) { 
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
						//node.addEventListener(ContentNodeEvent.READY,handleNodeReady);
						content.children.addItem(node);
						eventDispatcher.dispatchEvent(new ContentEvent(ContentEvent.RETRIEVE_CHILDREN,node));
					}
				}
				else if(content is SubContainerNode) {
					ContentData(content.data).loaded = true;
					for each (item in results) {
						resultLabel = item[content.config.@labelField];				
/*						resultLabel = resultLabel.replace(/<.*?>/g, "");
						resultLabel = resultLabel.replace(/]]>/g, "");*/
						node = new ContainerNode(resultLabel,content.config.object[0],item,content,content.privileges,false,false,false);
						//node.addEventListener(ContentNodeEvent.READY,handleNodeReady);
						content.children.addItem(node);
					}
				}
			}			
		}
	}
}