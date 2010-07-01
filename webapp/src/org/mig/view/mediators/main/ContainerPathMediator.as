package org.mig.view.mediators.main
{
	import org.mig.events.ContentEvent;
	import org.mig.events.ViewEvent;
	import org.mig.model.vo.ContentNode;
	import org.mig.model.vo.content.ContainerData;
	import org.mig.model.vo.content.ContainerNode;
	import org.mig.view.components.main.ContainerPathView;
	import org.mig.view.events.ContentViewEvent;
	import org.robotlegs.mvcs.Mediator;
	
	public class ContainerPathMediator extends Mediator
	{
		[Inject]
		public var view:ContainerPathView;

		override public function onRegister():void {
			eventMap.mapListener(eventDispatcher,ContentEvent.SELECT,handleContent,ContentEvent);
			eventMap.mapListener(view,ContentViewEvent.CONTAINER_SELECTED,handleContainer,ContentViewEvent);
		}
		private function handleContent(event:ContentEvent):void {
			view.content = event.args[0] as ContentNode;
		}
		private function handleContainer(event:ContentViewEvent):void {
			var container:ContainerNode = event.args[0] as ContainerNode;
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