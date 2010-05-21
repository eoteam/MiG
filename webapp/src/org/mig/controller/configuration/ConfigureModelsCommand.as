package org.mig.controller.configuration
{
	import org.mig.AppConfigStateConstants;
	import org.mig.model.AppModel;
	import org.mig.model.ContentModel;
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.utilities.statemachine.StateEvent;

	public class ConfigureModelsCommand extends Command
	{
		override public function execute():void
		{
			injector.mapSingleton(AppModel);
			injector.mapSingleton(ContentModel);

			//let the state machine know this step is complete 
			trace("Configure Models Complete");
			eventDispatcher.dispatchEvent( new StateEvent(StateEvent.ACTION, AppConfigStateConstants.CONFIGURE_MODELS_COMPLETE));
		}
	}
}