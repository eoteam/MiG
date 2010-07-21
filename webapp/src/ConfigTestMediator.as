package
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.mig.events.AppEvent;
	import org.robotlegs.mvcs.Mediator;
	
	public class ConfigTestMediator extends Mediator
	{
		[Inject]
		public var view:ConfigTest;

		override public function onRegister():void {
			eventMap.mapListener(eventDispatcher,AppEvent.BOOTSTRAP_COMPLETE,handleBootStrapComplete);
			eventMap.mapListener( eventDispatcher, AppEvent.STARTUP,			handleStartupProgress,	AppEvent); 
			eventMap.mapListener( eventDispatcher, AppEvent.STARTUP_PROGRESS,	handleStartupProgress,	AppEvent);
			view.restart.addEventListener(MouseEvent.CLICK,handleBootStrapComplete);
		}
		
		private function handleBootStrapComplete(event:Event):void {
			eventDispatcher.dispatchEvent(new AppEvent(AppEvent.LOGGEDIN));
		}
		
		private function handleStartupProgress(event:AppEvent):void {
			if(event.args) 
				view.log.text += event.args[0] +'\n';
		
		}
	}
}