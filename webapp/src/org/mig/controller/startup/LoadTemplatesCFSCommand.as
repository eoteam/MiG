package org.mig.controller.startup
{
	import org.mig.events.AppEvent;
	import org.mig.model.AppModel;
	import org.mig.model.ContentModel;
	import org.mig.model.vo.app.CustomField;
	import org.mig.model.vo.content.Template;
	import org.mig.services.interfaces.IAppService;
	import org.mig.services.interfaces.IContentService;
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.utilities.statemachine.StateEvent;
	
	public class LoadTemplatesCFSCommand extends Command
	{
		[Inject]
		public var service:IContentService;
		
		[Inject]
		public var appModel:AppModel;
		
		[Inject]
		public var contentModel:ContentModel;
		
		override public function execute():void {
			service.loadRelatedCustomfields(contentModel.templatesConfig.customfields[0]);
			service.addHandlers(handleTemplates);
		}
		private function handleTemplates(data:Object):void {
			var results:Array = data.result as Array;
			for each(var result:CustomField in results) {
				contentModel.templatesCustomFields.addItem(result);
			}
			trace("Startup: Templates CustomFields Complete");
			appModel.startupCount = 3;	
			eventDispatcher.dispatchEvent(new AppEvent(AppEvent.STARTUP_PROGRESS,"Templates CustomFields loaded"));
			eventDispatcher.dispatchEvent(new StateEvent(StateEvent.ACTION, AppStartupStateConstants.LOAD_TEMPLATES_CFS_COMPLETE));	
		}
	}
}