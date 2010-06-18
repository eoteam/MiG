package org.mig.view.mediators.managers.tags
{
	import mx.collections.HierarchicalData;
	import mx.events.FlexEvent;
	
	import org.mig.model.ContentModel;
	import org.mig.view.components.managers.tags.TagManagerView;
	import org.robotlegs.mvcs.Mediator;
	
	public class TagManagerMediator extends Mediator
	{
		[Inject]
		public var view:TagManagerView;
		
		[Inject]
		public var contentModel:ContentModel;
		
		override public function onRegister():void {
			view.addEventListener(FlexEvent.SHOW,handleContent);
		}
		private function handleContent(event:FlexEvent):void {
			view.termsGrid.dataProvider = contentModel.tagTerms;
			view.catGrid.dataProvider = new HierarchicalData(contentModel.categoryTerms.source);
		}
	}
}