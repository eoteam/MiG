package org.mig.controller.configuration
{
	import mx.states.State;
	
	import org.mig.AppConfigStateConstants;
	import org.mig.controller.ContentCommand;
	import org.mig.controller.MediaCommand;
	import org.mig.controller.ShowAlertCommand;
	import org.mig.controller.startup.StartupFSMCommand;
	import org.mig.controller.UploadCommand;
	import org.mig.controller.configuration.BootstrapApplicationCommand;
	import org.mig.events.AlertEvent;
	import org.mig.events.AppEvent;
	import org.mig.events.ContentEvent;
	import org.mig.events.MediaEvent;
	import org.mig.events.UploadEvent;
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.utilities.statemachine.StateEvent;

	public class ConfigureCommandsCommand extends Command
	{
		override public function execute():void
		{
			//after login, start sequence FSM
			commandMap.mapEvent(AppEvent.LOGGEDIN,StartupFSMCommand,AppEvent);
			
			//content commands
			commandMap.mapEvent( ContentEvent.RETRIEVE_CHILDREN,	ContentCommand, ContentEvent );
			commandMap.mapEvent( ContentEvent.RETRIEVE_VERBOSE,		ContentCommand, ContentEvent );	
			commandMap.mapEvent( ContentEvent.DELETE,				ContentCommand, ContentEvent );
			commandMap.mapEvent( ContentEvent.DUPLICATE,			ContentCommand, ContentEvent );
			commandMap.mapEvent( ContentEvent.CREATE,				ContentCommand, ContentEvent );
			commandMap.mapEvent( ContentEvent.SELECT, 				ContentCommand, ContentEvent );
			
			//media commands
			commandMap.mapEvent( MediaEvent.RETRIEVE_CHILDREN,		MediaCommand, MediaEvent );
			commandMap.mapEvent( MediaEvent.ADD_DIRECTORY,			MediaCommand, MediaEvent );
			commandMap.mapEvent( MediaEvent.ADD_FILE,				MediaCommand, MediaEvent );
			commandMap.mapEvent( MediaEvent.DELETE,					MediaCommand, MediaEvent );
			commandMap.mapEvent( MediaEvent.MOVE,					MediaCommand, MediaEvent );
			commandMap.mapEvent( MediaEvent.GET_DIRECTORY_SIZE,		MediaCommand, MediaEvent );
			//upload
			commandMap.mapEvent(UploadEvent.UPLOAD,					UploadCommand, UploadEvent );
			commandMap.mapEvent(UploadEvent.CANCEL,					UploadCommand, UploadEvent );
			
			//errors
			commandMap.mapEvent(AlertEvent.SHOW_ALERT, ShowAlertCommand, AlertEvent);
			
			trace("Configure: Commands Complete");
			eventDispatcher.dispatchEvent( new StateEvent(StateEvent.ACTION, AppConfigStateConstants.CONFIGURE_COMMANDS_COMPLETE));
		}
	}
}