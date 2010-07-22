package org.mig.controller.startup
{
	import org.mig.events.AppEvent;
	import org.mig.model.AppModel;
	import org.robotlegs.mvcs.Command;
	
	public class StartupCompleteCommand extends Command
	{
		[Inject]
		public var appModel:AppModel;
		
		override public function execute():void {
			appModel.startupCount = 12;
			trace("Startup: Startup Complete"); 
			eventDispatcher.dispatchEvent(new AppEvent(AppEvent.STARTUP_COMPLETE));
		}
	}
}