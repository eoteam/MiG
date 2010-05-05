package org.mig.controller
{
	import org.mig.events.ContentEvent;
	import org.mig.services.interfaces.IContentService;
	import org.robotlegs.mvcs.Actor;

	public class UpdateContentCommand extends Actor
	{
		[Inject]
		public var service:IContentService;
		
		[Inject]
		public var event:ContentEvent;
		
		override public function execute():void {
			service.retrieve(event.content);
			service.addHandlers(processChildren,service.faultHandler);
		}
	}
}