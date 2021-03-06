package org.mig.controller.startup
{
	import org.mig.events.AppEvent;
	import org.mig.events.MediaEvent;
	import org.mig.model.AppModel;
	import org.mig.model.ContentModel;
	import org.mig.model.vo.media.DirectoryNode;
	import org.mig.model.vo.media.MediaData;
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.utilities.statemachine.StateEvent;
	
	public class LoadMediaCommand extends Command
	{
		[Inject]
		public var contentModel:ContentModel;
		
		[Inject]
		public var appModel:AppModel;
		
		override public function execute():void {
			var data:MediaData = new MediaData();
			data.id = 0;
			var rootDir:DirectoryNode = new DirectoryNode("files", data, null,'/',appModel.user.privileges);
			rootDir.childrencount = 1;
			contentModel.currentDirectory = contentModel.mediaModel = rootDir;
			eventDispatcher.dispatchEvent(new MediaEvent(MediaEvent.RETRIEVE_CHILDREN,contentModel.mediaModel));
			
			trace("Startup: Media Model Complete");
			appModel.startupCount = 7;
			eventDispatcher.dispatchEvent(new AppEvent(AppEvent.STARTUP_PROGRESS,"Media Model initiated"));
			eventDispatcher.dispatchEvent(new StateEvent(StateEvent.ACTION, AppStartupStateConstants.LOAD_MEDIA_COMPLETE));
			
		}
	}
}