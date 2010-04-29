package org.mig.controller
{
	import mx.controls.Alert;
	
	import org.mig.events.AlertEvent;
	import org.robotlegs.mvcs.Command;
	
	public class ShowAlertCommand extends Command
	{
		[Inject]public var event:AlertEvent;
		
		override public function execute() : void
		{
			Alert.show( event.message, event.title );
		}
	}
}