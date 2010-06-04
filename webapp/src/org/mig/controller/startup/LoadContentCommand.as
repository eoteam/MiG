package org.mig.controller.startup
{
	import org.mig.events.AppEvent;
	import org.mig.events.ContentEvent;
	import org.mig.model.AppModel;
	import org.mig.model.ContentModel;
	import org.mig.model.vo.BaseContentData;
	import org.mig.model.vo.content.ContainerNode;
	import org.mig.model.vo.content.ContentData;
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.utilities.statemachine.StateEvent;
	
	public class LoadContentCommand extends Command
	{
		[Inject]
		public var contentModel:ContentModel;
		
		[Inject]
		public var appModel:AppModel;
		
		override public function execute():void {
			var contentConfig:XML 		= appModel.config.controller[1]; //XML(config.controller.(@id == "contentController"));
			var root:XML = XML(contentConfig.child[0].toString());
			var data:ContentData = new ContentData();
			data.id = 0;
			data.count = 10000;
			contentModel.contentModel = new ContainerNode (root.@name, root,data,null,appModel.user.privileges,true,true,false);
			eventDispatcher.dispatchEvent(new ContentEvent(ContentEvent.RETRIEVE_CHILDREN,contentModel.contentModel));
			
			trace("Startup: Content Model Complete");
			appModel.startupCount = 2;
			eventDispatcher.dispatchEvent(new AppEvent(AppEvent.STARTUP_PROGRESS,"Content Model initiated"));
			eventDispatcher.dispatchEvent(new StateEvent(StateEvent.ACTION, AppStartupStateConstants.LOAD_CONTENT_COMPLETE));
		}
	}
}