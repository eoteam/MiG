package org.mig.controller.startup
{
	import org.mig.events.MediaEvent;
	import org.mig.model.AppModel;
	import org.mig.model.ContentModel;
	import org.mig.model.vo.media.DirectoryNode;
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.utilities.statemachine.StateEvent;
	
	public class LoadMediaCommand extends Command
	{
		[Inject]
		public var contentModel:ContentModel;
		
		[Inject]
		public var appModel:AppModel;
		
		override public function execute():void {
			var mediaConfig:XML = appModel.config.controller[0]; //XML(config.controller.(@id == "mediaController"));
			contentModel.currentDirectory = contentModel.mediaModel = new DirectoryNode("files", mediaConfig.child[0], null, null,'/',appModel.user.privileges);
			eventDispatcher.dispatchEvent(new MediaEvent(MediaEvent.RETRIEVE_CHILDREN,contentModel.mediaModel));
			
			trace("Startup: Media Model Complete");
			eventDispatcher.dispatchEvent(new StateEvent(StateEvent.ACTION, AppStartupStateConstants.LOAD_MEDIA_COMPLETE));
		}
	}
}