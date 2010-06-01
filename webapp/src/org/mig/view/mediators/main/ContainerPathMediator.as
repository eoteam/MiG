package org.mig.view.mediators.main
{
	import org.mig.events.ContentEvent;
	import org.mig.events.ViewEvent;
	import org.mig.model.vo.ContentNode;
	import org.mig.view.components.main.ContainerPathView;
	import org.robotlegs.mvcs.Mediator;
	
	public class ContainerPathMediator extends Mediator
	{
		[Inject]
		public var view:ContainerPathView;

		override public function onRegister():void {
			eventMap.mapListener(eventDispatcher,ContentEvent.SELECT,handleContent,ContentEvent);
		}
		private function handleContent(event:ContentEvent):void {
			view.content = event.args[0] as ContentNode;
		}
	}
}