package org.mig.controller.startup
{
	import org.mig.events.AppEvent;
	import org.mig.model.AppModel;
	import org.mig.model.ContentModel;
	import org.mig.model.vo.content.ContentTab;
	import org.mig.services.interfaces.IAppService;
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
			
			for each(var tab:ContentTab in contentModel.contentTabs) {
				service.loadContentTabParameters(tab);
				service.addHandlers(handleTabParameters);
			}
		}
		private var counter:int;
		private function handleTabParameters(data:Object):void {
			var tab:ContentTab = data.token.tab as ContentTab;
			tab.parameters = data.result as Array;
			counter++;
			if(counter == contentModel.contentTabs.length) {
			
				trace("Startup: Content Tabs Complete");
				appModel.startupCount = 4;	
				eventDispatcher.dispatchEvent(new AppEvent(AppEvent.STARTUP_PROGRESS,"Content Tabs loaded"));
				eventDispatcher.dispatchEvent(new StateEvent(StateEvent.ACTION, AppStartupStateConstants.LOAD_CONTENTTABS_COMPLETE)); 	
 			}
		}
	}
}