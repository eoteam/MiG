package org.mig.controller
{
	import org.mig.events.ContentEvent;
	import org.mig.services.interfaces.IContentService;
	import org.robotlegs.mvcs.Actor;
	import org.robotlegs.mvcs.Command;

	public class UpdateContentCommand extends Command
	{
		[Inject]
		public var service:IContentService;
		
		[Inject]
		public var event:ContentEvent;
		
		override public function execute():void {
			//service.retrieve(event.content);
			//service.addHandlers(processChildren,service.faultHandler);
		}
	}
}