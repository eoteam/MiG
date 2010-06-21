package org.mig.view.mediators.managers.tags
{
		import flash.events.Event;
		import flash.events.MouseEvent;
		
		import mx.collections.HierarchicalData;
		import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
		import mx.controls.dataGridClasses.DataGridColumn;
		import mx.core.ClassFactory;
		import mx.events.CollectionEvent;
		import mx.events.FlexEvent;
		
		import org.mig.collections.DataCollection;
		import org.mig.controller.startup.AppStartupStateConstants;
		import org.mig.events.AppEvent;
		import org.mig.events.NotificationEvent;
		import org.mig.model.ContentModel;
		import org.mig.model.vo.UpdateData;
		import org.mig.model.vo.app.CustomField;
		import org.mig.model.vo.app.StatusResult;
		import org.mig.model.vo.manager.Term;
		import org.mig.services.interfaces.IContentService;
		import org.mig.utils.GlobalUtils;
		import org.mig.view.components.managers.tags.TagManagerView;
		import org.mig.view.renderers.ADGCustomField;
		import org.robotlegs.mvcs.Mediator;
		import org.robotlegs.utilities.statemachine.StateEvent;
	
	public class TagManagerMediator extends Mediator
	{
		[Inject]
		public var view:TagManagerView;
		
		[Inject]
		public var contentModel:ContentModel;
		
		[Inject]
		public var contentService:IContentService;
		
		override public function onRegister():void {
			eventMap.mapListener(eventDispatcher,StateEvent.ACTION,handleTermsLoaded);
			eventMap.mapListener(eventDispatcher,AppEvent.CONFIG_FILE_LOADED,handleConfigLoaded,AppEvent);
			view.addEventListener(FlexEvent.SHOW,handleContent);
			view.insertButton.addEventListener(MouseEvent.CLICK,handleInsertButton);
			view.submitButton.addEventListener(MouseEvent.CLICK, handleSubmitButton);
			view.trashButton1.addEventListener(MouseEvent.CLICK,handleTagDeleteButton)
		}
		private function handleConfigLoaded(event:AppEvent):void {
			view.name = contentModel.termsConfig.@name.toString();
		}
		private function handleTermsLoaded(event:StateEvent):void {
			if(event.action == AppStartupStateConstants.LOAD_CATEGORIESCF_COMPLETE) {
				contentModel.tagTerms.addEventListener("stateChange",handleTermsStateChange);
				contentModel.categoryTerms.addEventListener("stateChange",handleTermsStateChange);
				contentModel.tagTerms.addEventListener(CollectionEvent.COLLECTION_CHANGE,handleTermsStateChange);
				contentModel.categoryTerms.addEventListener(CollectionEvent.COLLECTION_CHANGE,handleTermsStateChange);
				
				var cols:Array = view.catGrid.columns;
				for each(var categoryTerm:Term in contentModel.categoryTerms) {
					for each(var cf:Object in contentModel.categoriesCustomFields) {
						var dgc:AdvancedDataGridColumn = new AdvancedDataGridColumn(CustomField(cf.customfield).name);
						var renderer:ClassFactory = new ClassFactory(ADGCustomField);
						renderer.properties = {customfield: cf};
						dgc.itemRenderer = renderer;
						dgc.editable = false;
						cols.push(dgc);	
					}
				}
				view.catGrid.columns = cols;
			}
		}
		private function handleContent(event:FlexEvent):void {
			view.termsGrid.dataProvider = contentModel.tagTerms;
			view.catGrid.dataProvider = new HierarchicalData(contentModel.categoryTerms.source);
		}
		private function handleInsertButton	(event:MouseEvent):void {
			var term:Term = new Term();
			term.taxonomy = "tag";
			term.updateData.taxonomy = "tag";
			contentModel.tagTerms.addItemAt(term,0);
		}
		private function handleTermsStateChange(event:Event):void {
			if(contentModel.tagTerms.state == DataCollection.MODIFIED || contentModel.categoryTerms.state == DataCollection.MODIFIED)
				view.submitButton.enabled = true; 
		}
		public var cudTotal:int;
		public var cudCount:int;
		
		private function handleSubmitButton(event:Event):void {
			cudCount = cudTotal = 0;
			var term:Term;
			for each(term in contentModel.tagTerms.modifiedItems.source) {
				contentService.updateContent(term,contentModel.termsConfig.child[0]);
				contentService.addHandlers(handleTagTermUpdated);
				cudTotal++;
			}
			for each(term in contentModel.tagTerms.newItems.source) {
				contentService.createContent(term,contentModel.termsConfig.child[0]);
				contentService.addHandlers(handleTagTermCreated);
				cudTotal++;
			}
		}
		private function handleTagDeleteButton(event:MouseEvent):void {
			for each(var item:Term in view.termsGrid.selectedItem) {
				//if(contentModel.
			}
		}
		private function handleTagTermUpdated(data:Object):void {
			var status:StatusResult = data.result as StatusResult;
			if(status.success) {
				cudCount++;
				if(cudCount == cudTotal)
					eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.NOTIFY,"Tags & Categories updated successfully"));
				contentModel.tagTerms.setItemNotModified(data.token.content as Term);
			}	
		}
		private function handleTagTermCreated(data:Object):void {
			var results:Array = data.result as Array;
			if(results.length == 1) {
				cudCount++;
				if(cudCount == cudTotal)
					eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.NOTIFY,"Tags & Categories updated successfully"));
				contentModel.tagTerms.setItemNotNew(data.token.content as Term);
			}	
		}
	}
}