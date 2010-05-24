package org.mig.controller.startup
{

	import org.mig.model.ContentModel;
	import org.mig.services.interfaces.IAppService;
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.utilities.statemachine.StateEvent;
	
	public class LoadMimeTypesCommand extends Command
	{
		[Inject]
		public var service:IAppService;
		
		[Inject]
		public var contentModel:ContentModel;
		
		override public function execute():void {
			service.loadMimeTypes();
			service.addHandlers(handleMimeTypes);
		}
		private function handleMimeTypes(data:Object):void {
			contentModel.mimetypes = data.result as Array;	
			trace("Startup: Mimetypes Complete");
			eventDispatcher.dispatchEvent(new StateEvent(StateEvent.ACTION, AppStartupStateConstants.LOAD_MIMETYPES_COMPLETE));
		}
	}
}