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
	
	public class LoadTemplatesCommand extends Command
	{
		[Inject]
		public var service:IContentService;
		
		[Inject]
		public var appModel:AppModel;
		
		[Inject]
		public var contentModel:ContentModel;
		
		override public function execute():void {
			service.loadTemplates();
			service.addHandlers(handleTemplates);
		}
		private var templateId:int;
		private function handleTemplates(data:Object):void {
			var results:Array = data.result as Array;
			for each(var item:Template in results) {				
				contentModel.templates.addItem(item);
				templateId = item.id;
				contentModel.templatesCustomFields.filterFunction = filterByTemplateId;
				contentModel.templatesCustomFields.refresh();
				for each(var cf:CustomField in contentModel.templatesCustomFields) {
					item.customfields.addItem(cf);
				}
			}
			contentModel.templatesCustomFields.filterFunction = null;
			contentModel.templatesCustomFields.refresh();
			trace("Startup: Templates Complete");
			appModel.startupCount = 4;	
			eventDispatcher.dispatchEvent(new AppEvent(AppEvent.STARTUP_PROGRESS,"Templates loaded"));
			eventDispatcher.dispatchEvent(new StateEvent(StateEvent.ACTION, AppStartupStateConstants.LOAD_TEMPLATES_COMPLETE));	
		}
		private function filterByTemplateId(item:CustomField):Boolean {
			return item.templateid == templateId ? true:false;
		}
	}
}