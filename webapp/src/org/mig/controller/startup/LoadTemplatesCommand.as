package org.mig.controller.startup
{
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	
	import mx.utils.ObjectUtil;
	
	import org.mig.collections.DataCollection;
	import org.mig.events.AppEvent;
	import org.mig.model.AppModel;
	import org.mig.model.ContentModel;
	import org.mig.model.vo.ContentNode;
	import org.mig.model.vo.app.CustomField;
	import org.mig.model.vo.content.ContentTab;
	import org.mig.model.vo.content.ContentTabParameter;
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
		private var counter:int;
		
		private function handleTemplates(data:Object):void {
			var results:Array = data.result as Array;
			for each(var item:Template in results) {				
				contentModel.templates.addItem(item);
				templateId = item.id;
				//templateIds = new RegExp(item.id.toString() , "gi");
				
				contentModel.templatesCustomFields.filterFunction = filterByTemplateId;
				contentModel.templatesCustomFields.refresh();
				for each(var cf:CustomField in contentModel.templatesCustomFields) {
					item.customfields.addItem(cf);
				}
				service.loadTemplateContentTabParameters(item);
				service.addHandlers(handleTemplateContentTabParams);
			}
			contentModel.templatesCustomFields.filterFunction = null;
			contentModel.templatesCustomFields.refresh();

		}
		
		private function handleTemplateContentTabParams(data:Object):void {		
			var template:Template = data.token.template as Template;
			var results:Array = data.result as Array;
			for each (var tab:ContentTab in contentModel.contentTabs) {
				if(tab.templateids) {
					var ids:Array = tab.templateids.split(',');
					if(ids.indexOf(template.id.toString()) != -1) {
	
						var newTab:ContentTab = new ContentTab();
						newTab.id = tab.id;
						newTab.type = tab.name;
						newTab.contentview = tab.contentview;
						newTab.editview = tab.editview;
						newTab.itemview = tab.itemview;
						newTab.createContent = tab.createContent;
						newTab.retrieveContent = tab.retrieveContent;
						newTab.updateContent = tab.updateContent;
						newTab.deleteContent = tab.deleteContent;
						newTab.dto = tab.dto;
						newTab.labelfield = tab.labelfield;
						newTab.orderby = tab.orderby;
						newTab.orderdirection = tab.orderdirection;
						newTab.tablename = tab.tablename;
						newTab.vars = tab.vars;
						template.contentTabs.addItem(newTab);
						
						if(results.length > 0) {
/*							for each(var param:Object in tab.parameters) {
								for each(var result:Object in results) {
									if(param.id == result.parameterid) {
										for (var prop:String in param)
											result[prop] = param[prop];
										newTab.parameters.push(result);
									}
								}
							}	*/

							for each(var result:ContentTabParameter in results) {
								if(result.tabid == newTab.id) {
									if(result.is_label == 1) {
										newTab.name = result.value;
										newTab.labelParameter = result;
									}
									else
										newTab.parameters.addItem(result);
								}
							}
							newTab.parameters.state = DataCollection.COMMITED;
						}
					}
				}
			}	
			template.contentTabs.state = DataCollection.COMMITED;
			counter++;
			if(counter == contentModel.templates.length) {
				trace("Startup: Templates Complete");
				appModel.startupCount = 5;	
				eventDispatcher.dispatchEvent(new AppEvent(AppEvent.STARTUP_PROGRESS,"Templates loaded"));
				eventDispatcher.dispatchEvent(new StateEvent(StateEvent.ACTION, AppStartupStateConstants.LOAD_TEMPLATES_COMPLETE));	
			}
		}
		
		private function filterByTemplateId(item:CustomField):Boolean {
			return item.templateid == templateId ? true:false;
		}
	}
}