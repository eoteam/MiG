package org.mig.controller.startup
{
	import org.mig.events.AppEvent;
	import org.mig.events.ContentEvent;
	import org.mig.model.AppModel;
	import org.mig.model.ContentModel;
	import org.mig.model.vo.ContentData;
	import org.mig.model.vo.content.ContainerNode;
	import org.mig.model.vo.content.ContainerData;
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
			var result:ContainerData 	= data.result[0] as ContainerData;
			contentModel.contentModel = new ContainerNode (result.migtitle,contentModel.templates[0],result,null,appModel.user.privileges,true,true);
			
			trace("Startup: Content Model Complete");
			appModel.startupCount = 6;
			eventDispatcher.dispatchEvent(new AppEvent(AppEvent.STARTUP_PROGRESS,"Content Model initiated"));
			eventDispatcher.dispatchEvent(new StateEvent(StateEvent.ACTION, AppStartupStateConstants.LOAD_CONTENT_COMPLETE));
		}
	}
}