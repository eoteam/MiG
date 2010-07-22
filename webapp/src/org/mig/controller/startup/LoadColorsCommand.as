package org.mig.controller.startup
{
	import org.mig.events.AppEvent;
	import org.mig.events.ContentEvent;
	import org.mig.model.AppModel;
	import org.mig.model.ContentModel;
	import org.mig.model.vo.ContentData;
	import org.mig.model.vo.content.ContainerData;
	import org.mig.model.vo.content.ContainerNode;
	import org.mig.services.interfaces.IAppService;
	import org.mig.services.interfaces.IContentService;
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.utilities.statemachine.StateEvent;
	
	public class LoadColorsCommand extends Command
	{
		
		[Inject]
		public var appModel:AppModel;
		
		[Inject]
		public var service:IAppService;
		
		override public function execute():void {
			service.loadColors()
			service.addHandlers(handleColorsLoaded);
		}
		private function handleColorsLoaded(data:Object):void {
			var results:Array  = data.result as Array;
			appModel.colors = [];
			for each(var c:Object in results) {
				var color:uint = Number('0x'+c.value.toString().substring(1,c.value.length));
				appModel.colors.push(color);
			}
			
			trace("Startup: Global Colors Complete");
			appModel.startupCount = 11;
			eventDispatcher.dispatchEvent(new AppEvent(AppEvent.STARTUP_PROGRESS,"Global Colors loaded"));
			eventDispatcher.dispatchEvent(new StateEvent(StateEvent.ACTION, AppStartupStateConstants.LOAD_COLORS_COMPLETE));
		}
	}
}