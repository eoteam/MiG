package org.mig.view
{
	import flash.events.Event;
	
	import org.mig.events.LoginEvent;
	import org.mig.view.components.StatusModule;
	import org.robotlegs.mvcs.Mediator;
	
	public class StatusModuleMediator extends Mediator
	{
		[Inject]
		public var view:StatusModule;

		override public function onRegister():void {
			eventMap.mapListener(eventDispatcher,LoginEvent.INFO_SENT,statusProxy,LoginEvent);
		}
		private function statusProxy(event:Event):void {
			if(event is LoginEvent) {
				if(LoginEvent(event).type == LoginEvent.INFO_SENT)
					view.updateStatus("Your login information has been sent to your email address");
			}
		}
	}
}