package org.mig.controller
{
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;
	
	import org.mig.events.ContentEvent;
	import org.mig.model.vo.ContentNode;
	import org.mig.model.vo.content.ContainerNode;
	import org.mig.model.vo.content.ContentData;
	import org.mig.services.ContentService;
	import org.mig.services.interfaces.IContentService;
	import org.robotlegs.mvcs.Command;
	
	public class RetrieveContentCommand extends Command
	{
		[Inject]
		public var service:IContentService;
		
		[Inject]
		public var event:ContentEvent;
		
		override public function execute():void {
			service.retrieve(event.content);
			service.addHandlers(processChildren);
		}
		public function processChildren(data:Object):void {
			var results:Array = data.result as Array;
			var nesting:Boolean;
			var fixed:Boolean;
			var content:ContainerNode = data.token.content as ContainerNode;
			if(results.length > 0) {
				content.isBranch = true;
				for each (var item:ContentData in results) {
					var resultLabel:String = item[content.config.@labelField];
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
					var node:ContainerNode = new ContainerNode(resultLabel, containerConfig, item,content,content.privileges,false,fixed,nesting);
					//node.addEventListener(ContentNodeEvent.READY,handleNodeReady);
					content.children.addItem(node);
					eventDispatcher.dispatchEvent(new ContentEvent(ContentEvent.RETRIEVE,node));
				}
			}
			//updateLabel();			
		}
	}
}