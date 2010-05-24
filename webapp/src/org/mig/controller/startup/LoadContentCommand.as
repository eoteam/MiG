package org.mig.controller.startup
{
	import org.mig.events.ContentEvent;
	import org.mig.model.AppModel;
	import org.mig.model.ContentModel;
	import org.mig.model.vo.content.ContainerNode;
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
			contentModel.contentModel = new ContainerNode (root.@name, root,null,null,appModel.user.privileges,true,true,false);
			eventDispatcher.dispatchEvent(new ContentEvent(ContentEvent.RETRIEVE_CHILDREN,contentModel.contentModel));
			
			trace("Startup: Content Model Complete");
			eventDispatcher.dispatchEvent(new StateEvent(StateEvent.ACTION, AppStartupStateConstants.LOAD_CONTENT_COMPLETE));
		}
	}
}