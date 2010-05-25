package org.mig.controller.startup
{
	import org.mig.events.AppEvent;
	import org.mig.model.AppModel;
	import org.mig.services.interfaces.IAppService;
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.utilities.statemachine.StateEvent;
	
	public class LoadConfigCommand extends Command
	{
		[Inject]
		public var service:IAppService;
		
		[Inject] 
		public var appModel:AppModel;
		
		override public function execute():void {
			service.loadConfigFile(appModel.configfile);
			service.addHandlers(handleConfigLoaded);
		}
		private function handleConfigLoaded(data:Object): void {
			var config:XML = 			appModel.config;			
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

			trace("Startup: Config File Loaded");
			appModel.startupCount = 1;
			eventDispatcher.dispatchEvent(new AppEvent(AppEvent.STARTUP_PROGRESS,"Configuration loaded ..."));
			eventDispatcher.dispatchEvent(new AppEvent(AppEvent.CONFIG_FILE_LOADED));
			eventDispatcher.dispatchEvent(new StateEvent(StateEvent.ACTION, AppStartupStateConstants.LOAD_CONFIG_COMPLETE));
		}
	}
}