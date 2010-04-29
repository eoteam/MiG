package org.mig.view
{
	import flash.events.Event;
	
	import org.mig.events.AppEvent;
	import org.mig.events.ContentEvent;
	import org.mig.model.ContentModel;
	import org.mig.view.components.ContentTree;
	import org.robotlegs.mvcs.Mediator;

	public class ContentTreeMediator extends Mediator
	{
		[Inject] 
		public var view:ContentTree;
		
		[Inject]
		public var contentModel:ContentModel;
		
		override public function onRegister():void {
			eventMap.mapListener(eventDispatcher,AppEvent.CONFIG_LOADED,handleContent);
			eventMap.mapListener(eventDispatcher,ContentEvent.RETRIEVE,handleContent);

		}
		private function handleContent(event:Event):void {
			view.dataProvider = contentModel.contentModel;
		}
	}
}