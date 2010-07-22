package org.mig.controller.startup
{
	import org.mig.events.AppEvent;
	import org.mig.model.AppModel;
	import org.mig.model.ContentModel;
	import org.mig.model.vo.ConfigurationObject;
	import org.mig.model.vo.manager.ManagerConfig;
	import org.mig.services.interfaces.IAppService;
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.utilities.statemachine.StateEvent;
	
	public class LoadManagersCommand extends Command
	{
		[Inject]
		public var appService:IAppService;
		
		[Inject]
		public var appModel:AppModel;
		
		[Inject]
		public var contentModel:ContentModel;
		
		override public function execute():void {
			appService.loadManagers();
			appService.addHandlers(handleManagers);
		}
		private function handleManagers(data:Object):void {
			var results:Array = data.result as Array;
			
			appModel.managers = results;
			for each(var item:ManagerConfig in results) {
				item.customfieldsConfig = new ConfigurationObject();
				item.customfieldsConfig.tablename = item['cfTablename'];
				item.customfieldsConfig.createContent = item['cfCreateContent'];
				item.customfieldsConfig.retrieveContent = item['cfRetrieveContent'];
				item.customfieldsConfig.updateContent = item['cfUpdateContent'];
				item.customfieldsConfig.deleteContent = item['cfDeleteContent'];
				
				if(contentModel.hasOwnProperty(item.type))
					contentModel[item.type] = item;
			}

			trace("Startup: Managers Loaded");
			appModel.startupCount = 2;
				
			eventDispatcher.dispatchEvent(new AppEvent(AppEvent.STARTUP_PROGRESS,"Managers loaded ..."));
			eventDispatcher.dispatchEvent(new StateEvent(StateEvent.ACTION, AppStartupStateConstants.LOAD_MANAGERS_COMPLETE));			
		}
		
	}
}