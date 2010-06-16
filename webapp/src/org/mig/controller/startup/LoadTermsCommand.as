package org.mig.controller.startup
{
	import org.mig.events.AppEvent;
	import org.mig.model.AppModel;
	import org.mig.services.interfaces.IAppService;
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.utilities.statemachine.StateEvent;
	
	public class LoadTermsCommand extends Command
	{
		[Inject]
		public var appService:IAppService;
		
		[Inject]
		public var appModel:AppModel;
		
		override public function execute():void {
			appService.loadTerms();
			appService.addHandlers(handleTerms);
		}
		private function handleTerms(data:Object):void {
			
			trace("Startup: Terms Complete");
			appModel.startupCount = 5;
			eventDispatcher.dispatchEvent(new AppEvent(AppEvent.STARTUP_PROGRESS,"Terms loaded"));
			eventDispatcher.dispatchEvent(new StateEvent(StateEvent.ACTION, AppStartupStateConstants.LOAD_TERMS_COMPLETE));
		}
	}
}