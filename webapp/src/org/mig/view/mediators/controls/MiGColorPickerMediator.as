package org.mig.view.mediators.controls
{
	import mx.states.State;
	
	import org.mig.controller.startup.AppStartupStateConstants;
	import org.mig.model.AppModel;
	import org.mig.view.controls.MiGColorPicker;
	import org.robotlegs.mvcs.Mediator;
	import org.robotlegs.utilities.statemachine.StateEvent;
	
	public class MiGColorPickerMediator extends Mediator
	{
		[Inject]
		public var view:MiGColorPicker;
		
		[Inject]
		public var appModel:AppModel;
		
		override public function onRegister():void {
			if(appModel.colors)
				view.dataProvider = appModel.colors;
			else
				eventMap.mapListener(eventDispatcher,StateEvent.ACTION,handleColorsLoaded);
		}
		private function handleColorsLoaded(event:StateEvent):void {
			if(event.action ==  AppStartupStateConstants.LOAD_COLORS_COMPLETE) {
				view.dataProvider = appModel.colors;
			}
		}
	}
}