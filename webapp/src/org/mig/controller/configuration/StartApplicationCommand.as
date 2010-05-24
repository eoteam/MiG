package org.mig.controller.configuration
{
	import org.mig.events.AppEvent;
	import org.mig.services.interfaces.IAppService;
	import org.robotlegs.mvcs.Command;
	
	public class StartApplicationCommand extends Command
	{
		[Inject]
		public var service:IAppService;
		
		override public function execute():void
		{
			trace("Application Started");
			service.loadConfig();
			eventDispatcher.dispatchEvent(new AppEvent(AppEvent.STARTUP));
		}
	}
}