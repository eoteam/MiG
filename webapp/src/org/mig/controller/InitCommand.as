package org.mig.controller
{
	import org.mig.events.AppEvent;
	import org.mig.events.ContentEvent;
	import org.mig.model.AppModel;
	import org.mig.model.ContentModel;
	import org.mig.model.vo.content.ContainerNode;
	import org.mig.services.interfaces.IAppService;
	import org.robotlegs.mvcs.Command;
	
	public class InitCommand extends Command
	{
		[Inject]
		public var service:IAppService;
		
		[Inject]
		public var event:AppEvent;
		
		[Inject]
		public var contentModel:ContentModel;
		
		[Inject]
		public var appModel:AppModel;
		
		override public function execute():void {
			if(event.type == AppEvent.LOGGEDIN)
				service.loadConfig();
			else if(event.type == AppEvent.CONFIG_LOADED) {
				
				//populating content model
				var config:XML = appModel.config;
				var contentConfig:XML =  XML(config..config.(@id == "contentController").toString());
				var root:XML = XML(contentConfig.root[0].toString());
				contentModel.contentModel = new ContainerNode (root.@name, root,null,null,appModel.user.privileges,true,true,false);
				eventDispatcher.dispatchEvent(new ContentEvent(ContentEvent.RETRIEVE,contentModel.contentModel));
				
				
				//populating customfields
				service.loadCustomFields();
				service.addHandlers(handleCustomfields);
			}
		}
		//private function handleCustomfields
	}
}