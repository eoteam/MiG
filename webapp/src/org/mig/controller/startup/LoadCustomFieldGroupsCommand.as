package org.mig.controller.startup
{
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
		
		override public function execute():void {
			service.loadCustomFieldGroups()
			service.addHandlers(handleCustomFieldGroups);
		}
		private function handleCustomFieldGroups(data:Object):void {
			trace("Startup: CustomField Groups Complete");
			eventDispatcher.dispatchEvent(new StateEvent(StateEvent.ACTION, AppStartupStateConstants.LOAD_CFGROUPS_COMPLETE));		
		}
	}
}