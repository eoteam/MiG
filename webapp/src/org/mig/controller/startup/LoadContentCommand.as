package org.mig.controller.startup
{
	import org.mig.events.AppEvent;
	import org.mig.events.ContentEvent;
	import org.mig.model.AppModel;
	import org.mig.model.ContentModel;
	import org.mig.model.vo.BaseContentData;
	import org.mig.model.vo.content.ContainerNode;
	import org.mig.model.vo.content.ContentData;
	import org.mig.services.interfaces.IContentService;
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.utilities.statemachine.StateEvent;
	
	public class LoadContentCommand extends Command
	{
		[Inject]
		public var contentModel:ContentModel;
		
		[Inject]
		public var appModel:AppModel;
		
		[Inject]
		public var service:IContentService;
		
		override public function execute():void {
			service.retrieveContentRoot()
			service.addHandlers(handleContentLoaded);
		}
		private function handleContentLoaded(data:Object):void {
			var result:ContentData 	= data.result[0] as ContentData;
			var contentConfig:XML 	= appModel.config.controller[1]; //XML(config.controller.(@id == "contentController"));
			var root:XML = XML(contentConfig.child[0].toString());
			contentModel.contentModel = new ContainerNode (root.@name, root,result,null,appModel.user.privileges,true,true,false);
			
			trace("Startup: Content Model Complete");
			appModel.startupCount = 2;
			eventDispatcher.dispatchEvent(new AppEvent(AppEvent.STARTUP_PROGRESS,"Content Model initiated"));
			eventDispatcher.dispatchEvent(new StateEvent(StateEvent.ACTION, AppStartupStateConstants.LOAD_CONTENT_COMPLETE));
		}
	}
}