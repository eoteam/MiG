package org.mig.controller.startup
{
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.utilities.statemachine.FSMInjector;
	import org.robotlegs.utilities.statemachine.StateEvent;
	import org.robotlegs.utilities.statemachine.StateMachine;
	
	public class StartupCommand extends Command
	{
		
		override public function execute():void {
			
			var fsmInjector:FSMInjector = new FSMInjector( AppStartupStateConstants.FSM );
			var stateMachine:StateMachine = new StateMachine(eventDispatcher);
			
			commandMap.mapEvent( AppStartupStateConstants.LOAD_CONFIG, LoadConfigCommand, StateEvent, true );
			commandMap.mapEvent( AppStartupStateConstants.LOAD_CONTENT, LoadContentCommand, StateEvent, true );
			commandMap.mapEvent( AppStartupStateConstants.LOAD_MEDIA,LoadMediaCommand, StateEvent, true );
			commandMap.mapEvent( AppStartupStateConstants.LOAD_MIMETYPES,LoadMimeTypesCommand, StateEvent, true );
			commandMap.mapEvent( AppStartupStateConstants.LOAD_CFGROUPS, LoadCustomFieldGroupsCommand, StateEvent, true );
			commandMap.mapEvent( AppStartupStateConstants.LOAD_CFS, LoadCustomFieldsCommand,  StateEvent, true);
			commandMap.mapEvent( AppStartupStateConstants.LOADING_TEMPLATES, LoadTemplatesCommand,  StateEvent, true);
			commandMap.mapEvent( AppStartupStateConstants.FAIL,StartupFailedCommand, StateEvent, true );

			//injecting the state machine into the FSMInjector
			fsmInjector.inject(stateMachine);
			
			//start the state machine
			eventDispatcher.dispatchEvent( new StateEvent(StateEvent.ACTION, AppStartupStateConstants.STARTED));
			
		}
	}
}