package org.mig.controller.startup
{
	import org.mig.events.AppEvent;
	import org.mig.model.AppModel;
	import org.mig.model.ContentModel;
	import org.mig.services.interfaces.IContentService;
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.utilities.statemachine.FSMInjector;
	import org.robotlegs.utilities.statemachine.StateEvent;
	import org.robotlegs.utilities.statemachine.StateMachine;
	
	public class LoadContentTabsCommand extends Command
	{
		[Inject]
		public var service:IContentService;
		
		[Inject]
		public var appModel:AppModel;
		
		[Inject]
		public var contentModel:ContentModel;
		
		override public function execute():void {
			service.loadContentTabs();
			service.addHandlers(handleContentTabs);
		}
		private function handleContentTabs(data:Object):void {
			contentModel.contentTabs = data.result as Array;
			
			trace("Startup: Content Tabs Complete");
			appModel.startupCount = 3;	
			eventDispatcher.dispatchEvent(new AppEvent(AppEvent.STARTUP_PROGRESS,"Content Tabs loaded"));
			eventDispatcher.dispatchEvent(new StateEvent(StateEvent.ACTION, AppStartupStateConstants.LOAD_CONTENTTABS_COMPLETE)); 	
 		}
	}
}