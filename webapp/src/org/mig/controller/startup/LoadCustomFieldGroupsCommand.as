package org.mig.controller.startup
{
	import org.mig.events.AppEvent;
	import org.mig.model.AppModel;
	import org.mig.model.ContentModel;
	import org.mig.services.interfaces.IAppService;
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.utilities.statemachine.StateEvent;
	
	public class LoadCustomFieldGroupsCommand extends Command
	{
		[Inject]
		public var service:IAppService;
		
		[Inject]
		public var contentModel:ContentModel;
		
		[Inject]
		public var appModel:AppModel;
		
		override public function execute():void {
			service.loadCustomFieldGroups()
			service.addHandlers(handleCustomFieldGroups);
		}
		private function handleCustomFieldGroups(data:Object):void {
			trace("Startup: CustomField Groups Complete");
			appModel.startupCount = 5;
			eventDispatcher.dispatchEvent(new AppEvent(AppEvent.STARTUP_PROGRESS,"CustomField Groups loaded"));
			eventDispatcher.dispatchEvent(new StateEvent(StateEvent.ACTION, AppStartupStateConstants.LOAD_CFGROUPS_COMPLETE));	
			
		}
	}
}