package org.mig.controller.startup
{

	import org.mig.events.AppEvent;
	import org.mig.model.AppModel;
	import org.mig.model.ContentModel;
	import org.mig.services.interfaces.IAppService;
	import org.mig.services.interfaces.IContentService;
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.utilities.statemachine.StateEvent;
	
	public class LoadMimeTypesCommand extends Command
	{
		[Inject]
		public var service:IContentService;
		
		[Inject]
		public var contentModel:ContentModel;
		
		[Inject]
		public var appModel:AppModel;
		
		override public function execute():void {
			service.loadMimeTypes();
			service.addHandlers(handleMimeTypes);
		}
		private function handleMimeTypes(data:Object):void {
			contentModel.mimetypes = data.result as Array;	
			trace("Startup: Mimetypes Complete");
			appModel.startupCount = 8;
			eventDispatcher.dispatchEvent(new AppEvent(AppEvent.STARTUP_PROGRESS,"MimeTypes loaded")); 
			eventDispatcher.dispatchEvent(new StateEvent(StateEvent.ACTION, AppStartupStateConstants.LOAD_MIMETYPES_COMPLETE));
			
		}
	}
}