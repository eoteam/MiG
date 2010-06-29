package org.mig.controller.startup
{
	import org.mig.events.AppEvent;
	import org.mig.model.AppModel;
	import org.mig.model.vo.app.CustomField;
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
			var results:Array = data.result as Array;
			for each(var item:CustomField in results) {
				appModel.customfieldsFlat.push(item);
				for each(var group:Object in appModel.customfields) {
					if(item.groupid == group.id) {
						group.children.push(item);
						break;
					}
				}
			}
			trace("Startup: CustomFields Complete");
			appModel.startupCount = 8;
			eventDispatcher.dispatchEvent(new AppEvent(AppEvent.STARTUP_PROGRESS,"CustomFields loaded")); 
			eventDispatcher.dispatchEvent(new StateEvent(StateEvent.ACTION, AppStartupStateConstants.LOAD_CFS_COMPLETE));
			
		}
	}
}