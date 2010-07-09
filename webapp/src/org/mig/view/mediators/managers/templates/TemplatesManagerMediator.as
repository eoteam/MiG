package org.mig.view.mediators.managers.templates
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.DragEvent;
	import mx.events.FlexEvent;
	
	import org.flexunit.internals.builders.NullBuilder;
	import org.mig.collections.DataCollection;
	import org.mig.controller.startup.AppStartupStateConstants;
	import org.mig.events.AppEvent;
	import org.mig.events.NotificationEvent;
	import org.mig.events.ViewEvent;
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
	
	import spark.components.supportClasses.ItemRenderer;
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
		
		private var previouslySelectedTemplate:Template;
		
		override public function onRegister():void {
			eventMap.mapListener(eventDispatcher,StateEvent.ACTION,handleTemplatesLoaded);
			eventMap.mapListener(eventDispatcher,AppEvent.CONFIG_FILE_LOADED,handleConfigLoaded,AppEvent);
			
			
			view.customFieldTypes = CustomFieldTypes.TYPES;
			view.templateList.addEventListener(IndexChangeEvent.CHANGE,handleTemplateList);
			view.addFieldButton.addEventListener(MouseEvent.CLICK,handleAddButton);
			view.submitButton.addEventListener(MouseEvent.CLICK,handleSubmitButton);
			
			view.cfList.addEventListener("addCustomFieldOption",enableSubmit);
			view.cfList.addEventListener("removeCustomFieldOption",enableSubmit);
			view.cfList.addEventListener("changeCustomFieldOption",enableSubmit);
			
			view.cfList.addEventListener(ContentViewEvent.CUSTOMFIELD_DRAG_START,handleDragStart);
			view.cfList.addEventListener(DragEvent.DRAG_COMPLETE,handleListDragDrop);			
			view.addEventListener(FlexEvent.HIDE,handleHide);
			view.addEventListener(FlexEvent.SHOW,handleShow);
		}
		private function handleHide(event:FlexEvent):void {
			previouslySelectedTemplate = view.templateList.selectedItem as Template;
		}
		private function handleShow(event:FlexEvent):void {
			view.templateList.selectedItem = previouslySelectedTemplate
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
			var template:Template = view.templateList.selectedItem as Template;
			//change the displayorder
			for each(var customfield:CustomField in template.customfields.source) {
				customfield.displayorder = template.customfields.getItemIndex(customfield)+1;
			}
		}
		private function handleTemplateList(event:IndexChangeEvent):void {
			var item:Template = view.templateList.selectedItem as Template;
			view.cfList.dataProvider = item.customfields;
			view.callLater(addChangeListener);
		}
		private function addChangeListener():void {
			var item:Template = view.templateList.selectedItem as Template;
			item.customfields.addEventListener(CollectionEvent.COLLECTION_CHANGE,handleChange);
		}
		private function handleChange(event:CollectionEvent):void {
			var field:CustomField;
			switch (event.kind) {
				
				case "add":
					contentModel.templatesCustomFields.state = DataCollection.MODIFIED;
					for each(field in event.items) 
						contentModel.templatesCustomFields.addItem(field);
				break;
				case "remove":
					contentModel.templatesCustomFields.state = DataCollection.MODIFIED;
					for each(field in event.items) 
						contentModel.templatesCustomFields.removeItemAt(contentModel.templatesCustomFields.getItemIndex(field));
				break;
			}
			enableSubmit();
		}
		private function enableSubmit(event:Event=null):void {
			view.submitButton.enabled = true;
			if(event && event.target is ItemRenderer) {
				var field:CustomField = view.cfList.selectedItem as CustomField;
				if(contentModel.templatesCustomFields.modifiedItems.getItemIndex(field) == -1 && 
				   contentModel.templatesCustomFields.deletedItems.getItemIndex(field) == -1)
						contentModel.templatesCustomFields.modifiedItems.addItem(field);
			}
		}
		private function handleAddButton(event:MouseEvent):void {
			var template:Template = view.templateList.selectedItem as Template;
			var templateCF:CustomField = new CustomField();
			view.cfList.dataProvider.addItem(templateCF);
			templateCF.templateid = template.id;
			templateCF.displayorder = view.cfList.dataProvider.getItemIndex(templateCF)+1;
		}
		public var cudTotal:int;
		public var cudCount:int;
		private function handleSubmitButton(event:MouseEvent):void {
			cudTotal = cudCount = 0;
			var customfield:CustomField;
			//var selectedTemplate:Template = view.templateList.selectedItem as Template;
			var time:Number = Math.round((new Date().time/1000));
			for each(customfield in  contentModel.templatesCustomFields.deletedItems.source) {
				cudTotal++;
				contentService.deleteContent(customfield,contentModel.templatesConfig.customfields[0]);
			}
			for each(customfield in  contentModel.templatesCustomFields.modifiedItems.source) {
				cudTotal++;
				delete customfield.updateData.optionsArray;
				customfield.updateData.customfieldid = customfield.customfieldid;
				customfield.modifiedby = appModel.user.id;
				customfield.modifieddate = time;
				contentService.updateContent(customfield,contentModel.templatesConfig.customfields[0],[]);
				contentService.addHandlers(handleCustomfieldUpdated);
			}	
			for each(customfield in contentModel.templatesCustomFields.newItems.source) {
				cudTotal++;
				customfield.createdby = customfield.modifiedby = appModel.user.id;
				customfield.modifieddate = customfield.createdate= time;
				contentService.createContent(customfield,contentModel.templatesConfig.customfields[0],[],true);
				contentService.addHandlers(handleCustomfieldCreated);
			}
		}
		private function handleCustomfieldUpdated(data:Object):void {
			var status:StatusResult = data.result as StatusResult;
			if(status.success) {
				checkCudCount();
				contentModel.templatesCustomFields.setItemNotModified(data.token.content as CustomField);
			}	
		}
		private function handleCustomfieldCreated(data:Object):void {
			var status:StatusResult = data.result as StatusResult;
			if(status.success) {
				checkCudCount();
				var selectedTemplate:Template = view.templateList.selectedItem as Template;
				var ids:Array = status.message.split(',');
				var field:CustomField = data.token.content as CustomField;
				field.id = ids[0]; field.customfieldid = ids[1]; field.fieldid = ids[2];
				contentModel.templatesCustomFields.setItemNotModified(data.token.content as CustomField);
			}	
		}			
		private function checkCudCount():void {
			cudCount++;
			if(cudCount == cudTotal) {
				eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.NOTIFY,"Custom Fields updated successfully"));
				view.submitButton.enabled = false;	
				eventDispatcher.dispatchEvent(new ViewEvent(ViewEvent.REFRESH_SELECTED_CONTENT));
			}
		}		
	}
}