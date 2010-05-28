package org.mig.controller.startup
{
	import org.mig.events.AppEvent;
	import org.mig.model.AppModel;
	import org.mig.services.interfaces.IAppService;
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.utilities.statemachine.StateEvent;
	
	public class LoadCustomFieldsCommand extends Command
	{
		[Inject]
		public var service:IAppService;
		
		[Inject]
		public var appModel:AppModel;
		
		override public function execute():void {
			service.loadCustomFields();
			service.addHandlers(handleCustomFields);
		}
		private function handleCustomFields(data:Object):void {
			trace("Startup: CustomFields Complete");
			appModel.startupCount = 6
			eventDispatcher.dispatchEvent(new AppEvent(AppEvent.STARTUP_PROGRESS,"CustomFields loaded")); 
			eventDispatcher.dispatchEvent(new StateEvent(StateEvent.ACTION, AppStartupStateConstants.LOAD_CFS_COMPLETE));
			
		}
	}
}