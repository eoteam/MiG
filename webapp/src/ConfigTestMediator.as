package
{
	import org.mig.events.AppEvent;
	import org.robotlegs.mvcs.Mediator;
	
	public class ConfigTestMediator extends Mediator
	{
		[Inject]
		public var view:ConfigTest;

		override public function onRegister():void {
			eventMap.mapListener(eventDispatcher,AppEvent.BOOTSTRAP_COMPLETE,handleBootStrapComplete);
		}
		
		private function handleBootStrapComplete(event:AppEvent):void {
			eventDispatcher.dispatchEvent(new AppEvent(AppEvent.LOGGEDIN));
		}	
	}
}