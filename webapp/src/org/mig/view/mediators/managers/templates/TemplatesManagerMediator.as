package org.mig.view.mediators.managers.templates
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.events.CollectionEvent;
	import mx.events.DragEvent;
	
	import org.mig.collections.DataCollection;
	import org.mig.controller.startup.AppStartupStateConstants;
	import org.mig.events.AppEvent;
	import org.mig.events.NotificationEvent;
	import org.mig.model.AppModel;
	import org.mig.model.ContentModel;
	import org.mig.model.vo.app.CustomField;
	import org.mig.model.vo.app.CustomFieldTypes;
	import org.mig.model.vo.app.StatusResult;
	import org.mig.model.vo.content.Template;
	import org.mig.services.interfaces.IContentService;
	import org.mig.view.components.managers.templates.CustomFieldView;
	import org.mig.view.components.managers.templates.TemplatesManagerView;
	import org.mig.view.events.ContentViewEvent;
	import org.robotlegs.mvcs.Mediator;
	import org.robotlegs.utilities.statemachine.StateEvent;
	
	import spark.events.IndexChangeEvent;
	
	public class TemplatesManagerMediator extends Mediator
	{
		[Inject]
		public var view:TemplatesManagerView;
		
		[Inject]
		public var contentModel:ContentModel;

		[Inject]
		public var appModel:AppModel;
		
		[Inject]
		public var contentService:IContentService;
		
		override public function onRegister():void {
			eventMap.mapListener(eventDispatcher,StateEvent.ACTION,handleTemplatesLoaded);
			eventMap.mapListener(eventDispatcher,AppEvent.CONFIG_FILE_LOADED,handleConfigLoaded,AppEvent);
			view.templateList.addEventListener(IndexChangeEvent.CHANGE,handleTemplateList);
			view.customFieldTypes = CustomFieldTypes.TYPES;
			view.cfList.addEventListener(ContentViewEvent.CUSTOMFIELD_DRAG_START,handleDragStart);
			view.cfList.addEventListener(DragEvent.DRAG_COMPLETE,handleListDragDrop);
			view.addFieldButton.addEventListener(MouseEvent.CLICK,handleAddButton);
			view.submitButton.addEventListener(MouseEvent.CLICK,handleSubmitButton);
			view.cfList.addEventListener("addCustomField",handleChange);
			view.cfList.addEventListener("removeCustomField",handleChange);
			view.cfList.addEventListener("changeCustomField",handleChange);
		}
		private function handleConfigLoaded(event:AppEvent):void {
			view.name = contentModel.templatesConfig.@name.toString();
		} 
		private function handleTemplatesLoaded(event:StateEvent):void {
			if(event.action == AppStartupStateConstants.LOAD_TEMPLATES_COMPLETE) {
				view.templateList.dataProvider = contentModel.templates;
			}
		}
		private function handleDragStart(event:ContentViewEvent):void {
			view.cfList.dragEnabled = view.cfList.dropEnabled = true;
		}
		private function handleListDragDrop(event:DragEvent):void {
			view.cfList.dragEnabled = view.cfList.dropEnabled = false;
		}
		private function handleTemplateList(event:IndexChangeEvent):void {
			var item:Template = view.templateList.selectedItem as Template;
			//view.cfHolder.removeAllElements();
			view.cfList.dataProvider = item.customfields;
			item.customfields.addEventListener(CollectionEvent.COLLECTION_CHANGE,handleChange);
			/*for each(var customfield:ContentCustomField in item.customfields) {
				var cfView:CustomFieldView = new CustomFieldView();
				cfView.field = customfield;
				view.cfHolder.addElement(cfView);
				cfView.customFieldTypes = CustomFieldTypes.TYPES;
				cfView.percentWidth = 100;
			}*/
		}
		private function handleChange(event:Event):void {
			view.submitButton.enabled = true;
			var selectedTemplate:Template = view.templateList.selectedItem as Template;
			selectedTemplate.customfields.state = DataCollection.MODIFIED;
		}
		private function handleAddButton(event:MouseEvent):void {
			var templateCF:CustomField = new CustomField();
			view.cfList.dataProvider.addItem(templateCF);
		}
		public var cudTotal:int;
		public var cudCount:int;
		private function handleSubmitButton(event:MouseEvent):void {
			cudTotal = cudCount = 0;
			var customfield:CustomField
			var selectedTemplate:Template = view.templateList.selectedItem as Template;
			for each(customfield in  selectedTemplate.customfields.deletedItems.source) {
				cudTotal++;
				contentService.deleteContent(customfield,contentModel.templatesConfig.customfields[0]);
			}
			for each(customfield in  selectedTemplate.customfields.modifiedItems.source) {
				cudTotal++;
				delete customfield.updateData.optionsArray;
				customfield.updateData.customfieldid = customfield.customfieldid;
				contentService.updateContent(customfield,contentModel.templatesConfig.customfields[0],[]);
				contentService.addHandlers(handleCustomfieldUpdated);
			}			
		}
		private function handleCustomfieldUpdated(data:Object):void {
			var status:StatusResult = data.result as StatusResult;
			if(status.success) {
				checkCudCount();
				var selectedTemplate:Template = view.templateList.selectedItem as Template;
				selectedTemplate.customfields.setItemNotModified(data.token.content as CustomField);
			}	
		}
		private function checkCudCount():void {
			cudCount++;
			if(cudCount == cudTotal) {
				eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.NOTIFY,"Custom Fields updated successfully"));
				view.submitButton.enabled = false;	
				//view.categoriesView.selectedCategoryLabel.text = view.categoriesView.categoryList.selectedItem.name;
				//view.categoriesView.categoryList.invalidateList();
				//view.categoriesView.refresh();
			}
		}		
	}
}