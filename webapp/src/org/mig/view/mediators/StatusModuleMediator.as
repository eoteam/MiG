package org.mig.view.mediators
{
	import flash.events.Event;
	
	import org.mig.events.UserEvent;
	import org.mig.view.components.StatusModule;
	import org.robotlegs.mvcs.Mediator;
	
	public class StatusModuleMediator extends Mediator
	{
		[Inject]
		public var view:StatusModule;

		override public function onRegister():void {
			eventMap.mapListener(eventDispatcher,UserEvent.INFO_SENT,statusProxy,UserEvent);
			eventMap.mapListener(eventDispatcher,UserEvent.UPDATE_COMPLETE,statusProxy,UserEvent);
		}
		private function statusProxy(event:Event):void {
			if(event is UserEvent) {
				if(UserEvent(event).type == UserEvent.INFO_SENT)
					view.updateStatus("Your login information has been sent to your email address");
				else if(UserEvent(event).type == UserEvent.UPDATE_COMPLETE)
					view.updateStatus("Your information has been updated");
			}
		}
	}
}