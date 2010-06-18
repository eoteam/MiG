package org.mig.view.mediators.main
{
	import org.mig.events.ContentEvent;
	import org.mig.events.ViewEvent;
	import org.mig.model.vo.ContentNode;
	import org.mig.model.vo.content.ContainerNode;
	import org.mig.model.vo.content.ContainerData;
	import org.mig.view.components.main.ContainerPathView;
	import org.mig.view.events.ContainerPathEvent;
	import org.robotlegs.mvcs.Mediator;
	
	public class ContainerPathMediator extends Mediator
	{
		[Inject]
		public var view:ContainerPathView;

		override public function onRegister():void {
			eventMap.mapListener(eventDispatcher,ContentEvent.SELECT,handleContent,ContentEvent);
			eventMap.mapListener(view,ContainerPathEvent.CONTAINER_SELECTED,handleContainer,ContainerPathEvent);
		}
		private function handleContent(event:ContentEvent):void {
			view.content = event.args[0] as ContentNode;
		}
		private function handleContainer(event:ContainerPathEvent):void {
			var container:ContainerNode = event.container;
			if(!container.isRoot) {
				if(ContainerData(container.data).loaded)
					eventDispatcher.dispatchEvent(new ContentEvent(ContentEvent.SELECT,container));
				else 
					eventDispatcher.dispatchEvent(new ContentEvent(ContentEvent.RETRIEVE_VERBOSE,container));
			}
			else {
				eventDispatcher.dispatchEvent(new ContentEvent(ContentEvent.SELECT,container));
			}
		}
	}
}