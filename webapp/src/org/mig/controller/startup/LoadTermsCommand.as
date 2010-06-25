package org.mig.controller.startup
{
	import mx.charts.AreaChart;
	import mx.collections.ArrayCollection;
	
	import org.mig.collections.DataCollection;
	import org.mig.events.AppEvent;
	import org.mig.model.AppModel;
	import org.mig.model.ContentModel;
	import org.mig.model.vo.manager.Term;
	import org.mig.services.interfaces.IAppService;
	import org.mig.services.interfaces.IContentService;
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.utilities.statemachine.StateEvent;
	
	public class LoadTermsCommand extends Command
	{
		[Inject]
		public var appService:IContentService;
		
		[Inject]
		public var appModel:AppModel;
		
		[Inject]
		public var contentModel:ContentModel;
		
		override public function execute():void {
			appService.loadTerms();
			appService.addHandlers(handleTerms);
		}
		private function handleTerms(data:Object):void {
			
			var results:Array = data.result as Array;
			var i:Term;
			var flatCategoryTerms:Array = [];
			for each(i in results) {
				if(i.taxonomy == 'tag')
					contentModel.tagTerms.addItem(i);
				else {
					contentModel.categoryTermsFlat.addItem(i);
					if(i.id == i.parentid) 
						contentModel.categoryTerms.push(i);
				}
			}		
			for each(i in contentModel.categoryTermsFlat)
			{
				for each(var j:Term in contentModel.categoryTermsFlat)
				{
					if(i.parentid == j.id && i != j)
					{
						if(!j.children)
							j.children = []
						j.children.push(i);
						i.parent = j;
						break;
					}
				}
			}
			contentModel.tagTerms.state = contentModel.categoryTermsFlat.state = DataCollection.COMMITED;	
			trace("Startup: Terms Complete");
			appModel.startupCount = 5;
			eventDispatcher.dispatchEvent(new AppEvent(AppEvent.STARTUP_PROGRESS,"Terms loaded"));
			eventDispatcher.dispatchEvent(new StateEvent(StateEvent.ACTION, AppStartupStateConstants.LOAD_TERMS_COMPLETE));
		}
	}
}