package org.mig.controller.configuration
{
	import org.mig.events.AppEvent;
	import org.robotlegs.mvcs.Command;
	
	public class StartApplicationCommand extends Command
	{
		override public function execute():void
		{
			trace("Application Started");
			eventDispatcher.dispatchEvent(new AppEvent(AppEvent.STARTUP));
		}
	}
}