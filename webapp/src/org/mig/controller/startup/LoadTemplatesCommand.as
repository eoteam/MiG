package org.mig.controller.startup
{
	import org.mig.events.AppEvent;
	import org.mig.model.AppModel;
	import org.mig.model.ContentModel;
	import org.mig.model.vo.CustomField;
	import org.mig.model.vo.content.Template;
	import org.mig.model.vo.content.TemplateCustomField;
	import org.mig.services.interfaces.IAppService;
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.utilities.statemachine.StateEvent;
	
	public class LoadTemplatesCommand extends Command
	{
		[Inject]
		public var service:IAppService;
		
		[Inject]
		public var appModel:AppModel;
		
		[Inject]
		public var contentModel:ContentModel;
		
		override public function execute():void {
			service.loadTemplates();
			service.addHandlers(handleTemplates);
		}
		private function handleTemplates(data:Object):void {
			var results:Array = data.result as Array;
			for each(var item:Object in results) {
				var template:Template = new Template();
				template.name = item.name;
				template.id = Number(item.id);
				contentModel.templates.addItem(template);
				if(item.rowids != '') {
					var cfs1:Array = item.rowids.split(',');
					var cfs2:Array = item.customfieldids.split(',');
					var cfs3:Array = item.fieldids.split(',');
					var cfs4:Array = item.displayorders.split(',');
					var cfs5:Array = item.rowids.split(',');
					
					for (var i:int=0;i<cfs1.length;i++) {
						var templateCustomField:TemplateCustomField = new TemplateCustomField();
						templateCustomField.id = cfs1[i];
						templateCustomField.fieldid = cfs3[i];
						templateCustomField.displayorder = cfs4[i];
						templateCustomField.visible = cfs5[i] == '1'?true:false;
						
						var cfid:int = cfs2[i];
						for each(var field:CustomField in appModel.customfieldsFlat) {
							if(field.id == cfid) {
								templateCustomField.customfield = field;
								break;
							}
						}
						template.customfields.addItem(templateCustomField);
					}
				}
			}
			trace("Startup: Templates Complete");
			appModel.startupCount = 7;	
			eventDispatcher.dispatchEvent(new AppEvent(AppEvent.STARTUP_PROGRESS,"Templates loaded"));
			eventDispatcher.dispatchEvent(new StateEvent(StateEvent.ACTION, AppStartupStateConstants.LOAD_TEMPLATES_COMPLETE));	
		}
	}
}