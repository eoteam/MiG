package org.mig.view.mediators.managers.templates
{
	import org.mig.controller.startup.AppStartupStateConstants;
	import org.mig.events.AppEvent;
	import org.mig.model.AppModel;
	import org.mig.model.ContentModel;
	import org.mig.model.vo.app.ContentCustomField;
	import org.mig.model.vo.app.CustomFieldTypes;
	import org.mig.model.vo.content.Template;
	import org.mig.view.components.managers.templates.CustomFieldView;
	import org.mig.view.components.managers.templates.TemplatesManagerView;
	import org.robotlegs.mvcs.Mediator;
	import org.robotlegs.utilities.statemachine.StateEvent;
	
	import spark.events.IndexChangeEvent;
	
	public class TemplatesManagerMediator extends Mediator
	{
		[Inject]
		public var view:TemplatesManagerView;
		
		[Inject]
		public var contentModel:ContentModel;

		[Inject]
		public var appModel:AppModel;
		
		override public function onRegister():void {
			eventMap.mapListener(eventDispatcher,StateEvent.ACTION,handleTemplatesLoaded);
			eventMap.mapListener(eventDispatcher,AppEvent.CONFIG_FILE_LOADED,handleConfigLoaded,AppEvent);
			view.templateList.addEventListener(IndexChangeEvent.CHANGE,handleTemplateList);
		}
		private function handleConfigLoaded(event:AppEvent):void {
			view.name = contentModel.templatesConfig.@name.toString();
		} 
		private function handleTemplatesLoaded(event:StateEvent):void {
			if(event.action == AppStartupStateConstants.LOAD_TEMPLATES_COMPLETE) {
				view.templateList.dataProvider = contentModel.templates;
			}
		}
		private function handleTemplateList(event:IndexChangeEvent):void {
			var item:Template = view.templateList.selectedItem as Template;
			view.cfHolder.removeAllElements();
			for each(var customfield:ContentCustomField in item.customfields) {
				var cfView:CustomFieldView = new CustomFieldView();
				cfView.field = customfield;
				view.cfHolder.addElement(cfView);
				cfView.customFieldTypes = CustomFieldTypes.TYPES;
				cfView.percentWidth = 100;
			}
		}
	}
}