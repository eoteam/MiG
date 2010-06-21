package org.mig.view.mediators.managers.customfields
{
	import mx.collections.HierarchicalData;
	
	import org.mig.controller.startup.AppStartupStateConstants;
	import org.mig.events.AppEvent;
	import org.mig.model.AppModel;
	import org.mig.model.vo.app.CustomFieldTypes;
	import org.mig.view.components.managers.customfields.CustomFieldsManagerView;
	import org.robotlegs.mvcs.Mediator;
	import org.robotlegs.utilities.statemachine.StateEvent;
	
	public class CustomFiledsManagerMediator extends Mediator
	{
		[Inject]
		public var view:CustomFieldsManagerView;
		
		[Inject]
		public var appModel:AppModel;
		
		override public function onRegister():void {
			eventMap.mapListener(eventDispatcher,AppEvent.CONFIG_FILE_LOADED,handleConfigFile,AppEvent);
			eventMap.mapListener(eventDispatcher,StateEvent.ACTION,handleCustomFieldsLoaded,StateEvent);
		}
		private function handleConfigFile(event:AppEvent):void {
			view.name = appModel.config.manager[2].@name;	
		}
		private function handleCustomFieldsLoaded(event:StateEvent):void {
			if(event.action == AppStartupStateConstants.LOAD_CFS_COMPLETE) {
				view.types = CustomFieldTypes.TYPES;
				view.catGrid.dataProvider = new HierarchicalData(appModel.customfields);	
			}
		}
	}
}