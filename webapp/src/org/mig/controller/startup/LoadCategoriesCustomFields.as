package org.mig.controller.startup
{
	import org.mig.collections.DataCollection;
	import org.mig.events.AppEvent;
	import org.mig.model.AppModel;
	import org.mig.model.ContentModel;
	import org.mig.model.vo.app.CustomField;
	import org.mig.services.interfaces.IContentService;
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.utilities.statemachine.StateEvent;
	
	public class LoadCategoriesCustomFields extends Command
	{
		[Inject]
		public var contentModel:ContentModel;

		[Inject]
		public var appModel:AppModel;
		
		[Inject]
		public var service:IContentService;
		
		override public function execute():void {
			service.loadRelatedCustomfields(contentModel.termsConfig);
			service.addHandlers(handleCategoriesCustomFields);
		}
		private function handleCategoriesCustomFields(data:Object):void {
			var results:Array = data.result as Array;
			for each(var result:CustomField in results) {
				contentModel.categoriesCustomFields.addItem(result);	
			}		
			contentModel.categoriesCustomFields.state = DataCollection.COMMITED;
			trace("Startup: Categories CustomFields Complete");
			appModel.startupCount = 9;
			eventDispatcher.dispatchEvent(new AppEvent(AppEvent.STARTUP_PROGRESS,"Categories CustomFields loaded"));
			eventDispatcher.dispatchEvent(new StateEvent(StateEvent.ACTION, AppStartupStateConstants.LOAD_CATEGORIES_CFS_COMPLETE));
		}
	}
}