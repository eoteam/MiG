package org.mig.controller
{
	import flash.events.Event;
	
	import org.mig.events.AppEvent;
	import org.mig.events.ContentEvent;
	import org.mig.events.MediaEvent;
	import org.mig.model.AppModel;
	import org.mig.model.ContentModel;
	import org.mig.model.vo.content.ContainerNode;
	import org.mig.model.vo.media.MediaCategoryNode;
	import org.mig.services.interfaces.IAppService;
	import org.robotlegs.mvcs.Command;
	
	public class StartupCommand extends Command
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
			
			switch(event.type) {
				
				case AppEvent.STARTUP:
					service.loadConfig();
				break;
				
				case AppEvent.LOGGEDIN:
					service.loadConfigFile(appModel.configfile);
				break;
				
				case AppEvent.CONFIG_FILE_LOADED:
					
					//parse config
					var config:XML = appModel.config;			
					var mediaConfig:XML 		= config.controller[0]; //XML(config.controller.(@id == "mediaController"));
					appModel.fileDir			= mediaConfig.@fileDir;
					appModel.thumbDir			= mediaConfig.@thumbDir;
					appModel.mediaURL			= mediaConfig.@mediaURL;
					appModel.thumbURL			= mediaConfig.@thumbURL;
					
					var contentConfig:XML 		= config.controller[1]; //XML(config.controller.(@id == "contentController"));
					appModel.rootURL 			= contentConfig.@rootURL;
					appModel.pendingURL			= contentConfig.@pendingURL;
					appModel.publishedURL		= contentConfig.@publishedURL;
					appModel.textEditorColor 	= contentConfig.@textEditorColor;
					appModel.htmlRendering		= contentConfig.@renderer == "html" ? true:false;
					appModel.textFormat			= contentConfig.@textformat;
										
					//populating content model
					var root:XML = XML(contentConfig.child[0].toString());
					contentModel.contentModel = new ContainerNode (root.@name, root,null,null,appModel.user.privileges,true,true,false);
					eventDispatcher.dispatchEvent(new ContentEvent(ContentEvent.RETRIEVE_CHILDREN,contentModel.contentModel));
					
					//populate media model
					contentModel.mediaModel = new MediaCategoryNode("files", mediaConfig.child[0], null, null,appModel.fileDir,appModel.user.privileges);
					eventDispatcher.dispatchEvent(new MediaEvent(ContentEvent.RETRIEVE_CHILDREN,contentModel.mediaModel));
					//populating customfields
					service.loadCustomFieldGroups()
					service.addHandlers(handleCustomFieldGroups);
					
				break;
			}
			
		}
		private function handleConfigLoaded(data:Object):void {
			service.loadConfigFile(appModel.configfile);
		}
		private function handleCustomFieldGroups(data:Object):void {
			service.loadCustomFields();
			service.addHandlers(handleCustomFields);
		}
		private function handleCustomFields(data:Object):void {
			service.loadTemplates();
		}
	}
}