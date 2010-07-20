package org.mig.controller.configuration
{
	import org.mig.AppConfigStateConstants;
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.utilities.statemachine.StateEvent;
	
	public class ConfigureViewsCommand extends Command
	{
		override public function execute():void {
			mediatorMap.mapView(ConfigTest,ConfigTestMediator);
			
			trace("Configure: Views Complete");
			//notifiy the state machine that we are done with this step
			eventDispatcher.dispatchEvent( new StateEvent(StateEvent.ACTION, AppConfigStateConstants.CONFIGURE_VIEWS_COMPLETE)); 
		}
	}
}