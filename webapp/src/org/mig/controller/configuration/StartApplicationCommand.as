package org.mig.controller.configuration
{
	import mx.core.FlexGlobals;
	
	import org.mig.events.AppEvent;
	import org.mig.model.AppModel;
	import org.mig.services.interfaces.IAppService;
	import org.robotlegs.mvcs.Command;
	
	public class StartApplicationCommand extends Command
	{
		[Inject]
		public var service:IAppService;
		
		[Inject]
		public var appModel:AppModel;
		
		override public function execute():void
		{
			trace("Application Started");
			//service.loadConfig();
			//service.addHandlers(configHandler);
			//eventDispatcher.dispatchEvent(new AppEvent(AppEvent.STARTUP));
			appModel.prompt = FlexGlobals.topLevelApplication.parameters.prompt;
			eventDispatcher.dispatchEvent(new AppEvent(AppEvent.BOOTSTRAP_COMPLETE));	
		}
/*		private function configHandler(data:Object):void {
			var results:Array = data.result as Array;
			for each(var item:Object in results) {
				switch(item.name) {
					case "prompt":
					
						break;
					case "configfile":
						appModel.configfile = item.value;
						break;
				}
			}
			
		}*/
	}
}