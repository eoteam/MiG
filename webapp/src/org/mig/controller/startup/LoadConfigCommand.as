package org.mig.controller.startup
{
	import org.mig.events.AppEvent;
	import org.mig.model.AppModel;
	import org.mig.model.ContentModel;
	import org.mig.model.vo.content.ContainerNode;
	import org.mig.services.interfaces.IAppService;
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.utilities.statemachine.StateEvent;
	
	public class LoadConfigCommand extends Command
	{
		[Inject]
		public var service:IAppService;
		
		[Inject] 
		public var appModel:AppModel;
		
		[Inject]
		public var contentModel:ContentModel;
		
		override public function execute():void {
			service.loadConfigFile(appModel.configfile);
			service.addHandlers(handleConfigLoaded);
		}
		private function handleConfigLoaded(data:Object): void {
			var config:XML 				= appModel.config;			
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
			appModel.timeout			= contentConfig.@timeout;
			
			contentModel.defaultCreate		= contentConfig.@createContent;
			contentModel.defaultRetrieve	= contentConfig.@retrieveContent;
			contentModel.defaultUpdate		= contentConfig.@updateContent;
			contentModel.defaultDelete		= contentConfig.@deleteContent;
			contentModel.configEelements 	= config.elements[0];
			//process xml file and
			var containers:XMLList = contentConfig.children();
			for each(var node:XML in containers) {
				processNode(node);
			}
			trace("Startup: Config File Loaded");
			appModel.startupCount = 1;
			
			eventDispatcher.dispatchEvent(new AppEvent(AppEvent.STARTUP_PROGRESS,"Configuration loaded ..."));
			eventDispatcher.dispatchEvent(new AppEvent(AppEvent.CONFIG_FILE_LOADED));
			eventDispatcher.dispatchEvent(new StateEvent(StateEvent.ACTION, AppStartupStateConstants.LOAD_CONFIG_COMPLETE));
		}
		private function processNode(node:XML):void {
			if(node.attribute("createContent").length() == 0) {
				node.@createContent = contentModel.defaultCreate;
			}
			if(node.attribute("retrieveContent").length() == 0) {
				node.@retrieveContent = contentModel.defaultRetrieve;
			}
			if(node.attribute("deleteContent").length() == 0) {
				node.@deleteContent = contentModel.defaultDelete;
			}
			if(node.attribute("updateContent").length() == 0) {
				node.@updateContent = contentModel.defaultUpdate;
			}
			var tabs:XMLList = node.tab;
			var tray:XMLList = node.tray;
			if(tabs.length() > 0 ) {
				
			}
			if(node.children().length() > 0) {
				for each(var subnode:XML in node.children()) {
					processNode(subnode);
				}
			}
		}
	}
}