package org.mig.view.mediators.managers.media
{
	import mx.collections.HierarchicalData;
	
	import org.mig.events.MediaEvent;
	import org.mig.model.AppModel;
	import org.mig.model.ContentModel;
	import org.mig.view.components.managers.media.MediaManager;
	import org.robotlegs.mvcs.Mediator;
	
	public class MediaManagerMediator extends Mediator
	{
		[Inject]
		public var view:MediaManager;
		
		[Inject]
		public var contentModel:ContentModel;

		[Inject]
		public var appModel:AppModel;
		
		override public function onRegister():void {
			
			eventMap.mapListener(eventDispatcher,MediaEvent.RETRIEVE_CHILDREN,handleContent,MediaEvent); 
			view.listView.thumbURL =  appModel.thumbURL;
		}
		
		private function handleContent(event:MediaEvent):void {
			var dpList:HierarchicalData = new HierarchicalData(contentModel.mediaModel.children);
			view.listView.dataProvider = dpList;
		}
	}
}