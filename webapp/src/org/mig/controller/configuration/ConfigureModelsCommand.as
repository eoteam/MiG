package org.mig.controller.configuration
{
	import org.mig.AppConfigStateConstants;
	import org.mig.model.AppModel;
	import org.mig.model.ContentModel;
	import org.mig.model.vo.relational.ContentMedia;
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.utilities.statemachine.StateEvent;

	public class ConfigureModelsCommand extends Command
	{
		override public function execute():void
		{
			injector.mapSingleton(AppModel);
			injector.mapSingleton(ContentModel);
			
			//register configurable VOs
			injector.mapClass(ContentMedia,ContentMedia);
			
			trace("Configure: Models Complete");
			eventDispatcher.dispatchEvent( new StateEvent(StateEvent.ACTION, AppConfigStateConstants.CONFIGURE_MODELS_COMPLETE));
		}
	}
}