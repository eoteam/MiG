package org.mig.controller.startup
{
	import org.mig.services.interfaces.IAppService;
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.utilities.statemachine.StateEvent;
	
	public class LoadCustomFieldsCommand extends Command
	{
		[Inject]
		public var service:IAppService;
		
		override public function execute():void {
			service.loadCustomFields();
			service.addHandlers(handleCustomFields);
		}
		private function handleCustomFields(data:Object):void {
			trace("Startup: CustomFields Complete");
			eventDispatcher.dispatchEvent(new StateEvent(StateEvent.ACTION, AppStartupStateConstants.LOAD_CFS_COMPLETE));	
		}
	}
}