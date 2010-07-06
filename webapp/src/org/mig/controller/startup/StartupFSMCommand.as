package org.mig.controller.startup
{
	import org.mig.model.AppModel;
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.utilities.statemachine.FSMInjector;
	import org.robotlegs.utilities.statemachine.StateEvent;
	import org.robotlegs.utilities.statemachine.StateMachine;
	
	public class StartupFSMCommand extends Command
	{
		
		[Inject]
		public var appModel:AppModel;
		
		override public function execute():void {
			
			appModel.startupItems = 10;
			
			var fsmInjector:FSMInjector = new FSMInjector( AppStartupStateConstants.FSM );
			var stateMachine:StateMachine = new StateMachine(eventDispatcher);
			
			commandMap.mapEvent( AppStartupStateConstants.LOAD_CONFIG, 			LoadConfigCommand, 				StateEvent, true );

			commandMap.mapEvent( AppStartupStateConstants.LOAD_CONTENT, 		LoadContentCommand,				StateEvent, true );		
			commandMap.mapEvent( AppStartupStateConstants.LOAD_TEMPLATES_CFS,	LoadTemplatesCFSCommand,		StateEvent, true);
			commandMap.mapEvent( AppStartupStateConstants.LOAD_TEMPLATES,		LoadTemplatesCommand,			StateEvent, true);
			
			commandMap.mapEvent( AppStartupStateConstants.LOAD_MEDIA,			LoadMediaCommand,				StateEvent, true );
			commandMap.mapEvent( AppStartupStateConstants.LOAD_MIMETYPES,		LoadMimeTypesCommand,			StateEvent, true );
			
			commandMap.mapEvent( AppStartupStateConstants.LOAD_CATEGORIES_CFS,	LoadCategoriesCustomFields,		StateEvent, true );
			commandMap.mapEvent( AppStartupStateConstants.LOAD_TERMS,			LoadTermsCommand,				StateEvent, true );

			commandMap.mapEvent( AppStartupStateConstants.LOAD_COLORS,			LoadColorsCommand,				StateEvent, true); 
			
			commandMap.mapEvent( AppStartupStateConstants.STARTUP_COMPLETE,		StartupCompleteCommand,			StateEvent, true );
			commandMap.mapEvent( AppStartupStateConstants.FAIL,StartupFailedCommand, StateEvent, true );

			
			//injecting the state machine into the FSMInjector
			fsmInjector.inject(stateMachine);
			
			//start the state machine
			eventDispatcher.dispatchEvent( new StateEvent(StateEvent.ACTION, AppStartupStateConstants.STARTED));
			
		}
	}
}