package org.mig.view.mediators.managers.tags
{
		import flash.events.Event;
		import flash.events.MouseEvent;
		
		import mx.collections.HierarchicalData;
		import mx.events.CollectionEvent;
		import mx.events.FlexEvent;
		
		import org.mig.collections.DataCollection;
		import org.mig.controller.startup.AppStartupStateConstants;
		import org.mig.model.ContentModel;
		import org.mig.model.vo.manager.Term;
		import org.mig.view.components.managers.tags.TagManagerView;
		import org.robotlegs.mvcs.Mediator;
		import org.robotlegs.utilities.statemachine.StateEvent;
	
	public class TagManagerMediator extends Mediator
	{
		[Inject]
		public var view:TagManagerView;
		
		[Inject]
		public var contentModel:ContentModel;
		
		override public function onRegister():void {
			eventMap.mapListener(eventDispatcher,StateEvent.ACTION,handleTermsLoaded);
			view.addEventListener(FlexEvent.SHOW,handleContent);
			view.insertButton.addEventListener(MouseEvent.CLICK,handleInsertButton);
			view.submitButton.addEventListener(MouseEvent.CLICK, handleSubmitButton);
		}
		private function handleTermsLoaded(event:StateEvent):void {
			if(event.action == AppStartupStateConstants.LOAD_TERMS_COMPLETE) {
				contentModel.tagTerms.addEventListener("stateChange",handleTermsStateChange);
				contentModel.categoryTerms.addEventListener("stateChange",handleTermsStateChange);
				contentModel.tagTerms.addEventListener(CollectionEvent.COLLECTION_CHANGE,handleTermsStateChange);
				contentModel.categoryTerms.addEventListener(CollectionEvent.COLLECTION_CHANGE,handleTermsStateChange);
			}
		}
		private function handleContent(event:FlexEvent):void {
			view.termsGrid.dataProvider = contentModel.tagTerms;
			view.catGrid.dataProvider = new HierarchicalData(contentModel.categoryTerms.source);
		}
		private function handleInsertButton	(event:MouseEvent):void {
			var term:Term = new Term();
			term.taxonomy = "tag";
			contentModel.tagTerms.addItemAt(term,0);
		}
		private function handleTermsStateChange(event:Event):void {
			if(contentModel.tagTerms.state == DataCollection.MODIFIED || contentModel.categoryTerms.state == DataCollection.MODIFIED)
				view.submitButton.enabled = true; 
		}
		private function handleSubmitButton(event:Event):void {
			//for each(
		}
	}
}