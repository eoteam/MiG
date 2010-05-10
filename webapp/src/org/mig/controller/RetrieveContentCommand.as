package org.mig.controller
{
	import org.mig.events.ContentEvent;
	import org.mig.model.vo.BaseContentData;
	import org.mig.services.interfaces.IContentService;
	import org.robotlegs.mvcs.Command;
	
	public class RetrieveContentCommand extends Command
	{
		[Inject]
		public var service:IContentService;
		
		[Inject]
		public var event:ContentEvent;
		
		override public function execute():void {
			service.retrieveVerbose(event.content);
			service.addHandlers(handleLoadComplete);
		}
		private function handleLoadComplete(data:Object):void {
			event.content.data = data.result[0]; 
			BaseContentData(event.content.data).loaded = true;
			eventDispatcher.dispatchEvent(new ContentEvent(ContentEvent.SELECT,event.content));
		}
	}
}