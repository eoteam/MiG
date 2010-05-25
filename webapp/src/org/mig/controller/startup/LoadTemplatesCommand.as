package org.mig.controller.startup
{
	import org.mig.events.AppEvent;
	import org.mig.model.AppModel;
	import org.mig.services.interfaces.IAppService;
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.utilities.statemachine.StateEvent;
	
	public class LoadTemplatesCommand extends Command
	{
		[Inject]
		public var service:IAppService;
		
		[Inject]
		public var appModel:AppModel;
		
		override public function execute():void {
			service.loadTemplates();
			service.addHandlers(handleTemplates);
		}
		private function handleTemplates(data:Object):void {
			trace("Startup: Templates Complete");
			appModel.startupCount = 7;	
			eventDispatcher.dispatchEvent(new AppEvent(AppEvent.STARTUP_PROGRESS,"Templates loaded"));
			eventDispatcher.dispatchEvent(new StateEvent(StateEvent.ACTION, AppStartupStateConstants.LOAD_TEMPLATES_COMPLETE));	
			
		}
	}
}