package org.mig.controller.configuration
{
	import org.mig.AppConfigStateConstants;
	
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.utilities.statemachine.StateEvent;

	import org.mig.services.AppService;
	import org.mig.services.ContentService;
	import org.mig.services.FileService;
	import org.mig.services.MediaService;
	import org.mig.services.UserService;
	import org.mig.services.interfaces.IAppService;
	import org.mig.services.interfaces.IContentService;
	import org.mig.services.interfaces.IFileService;
	import org.mig.services.interfaces.IMediaService;
	import org.mig.services.interfaces.IUserService;
	
	public class ConfigureServicesCommand extends Command
	{
		override public function execute():void
		{
			
			//services
			injector.mapSingletonOf(IUserService,UserService); 
			injector.mapSingletonOf(IAppService, AppService);
			injector.mapSingletonOf(IContentService,ContentService);
			injector.mapSingletonOf(IMediaService,MediaService);
			injector.mapSingletonOf(IFileService,FileService);
			
			trace("Configure: Services Complete");
			eventDispatcher.dispatchEvent( new StateEvent(StateEvent.ACTION, AppConfigStateConstants.CONFIGURE_SERVICES_COMPLETE));
		}
	}
}