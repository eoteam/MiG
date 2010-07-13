package org.mig.view.mediators.managers.templates
{
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.describeType;
	
	import mx.collections.ArrayList;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.DragEvent;
	import mx.events.FlexEvent;
	import mx.events.PropertyChangeEvent;
	import mx.managers.DragManager;
	
	import org.flexunit.internals.builders.NullBuilder;
	import org.mig.collections.DataCollection;
	import org.mig.controller.startup.AppStartupStateConstants;
	import org.mig.events.AppEvent;
	import org.mig.events.NotificationEvent;
	import org.mig.events.ViewEvent;
	import org.mig.model.AppModel;
	import org.mig.model.ContentModel;
	import org.mig.model.vo.UpdateData;
	import org.mig.model.vo.app.CustomField;
	import org.mig.model.vo.app.CustomFieldOption;
	import org.mig.model.vo.app.CustomFieldTypes;
	import org.mig.model.vo.app.StatusResult;
	import org.mig.model.vo.content.Template;
	import org.mig.services.interfaces.IAppService;
	import org.mig.services.interfaces.IContentService;
	import org.mig.utils.GlobalUtils;
	import org.mig.view.components.managers.templates.CustomFieldView;
	import org.mig.view.components.managers.templates.TemplatesManagerView;
	import org.mig.view.events.ContentViewEvent;
	import org.robotlegs.mvcs.Mediator;
	import org.robotlegs.utilities.statemachine.StateEvent;
	
	import spark.components.supportClasses.ItemRenderer;
	import spark.events.IndexChangeEvent;
	import spark.layouts.supportClasses.DropLocation;
	
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
		
		[Inject]
		public var appService:IAppService;
		
		private var previouslySelectedTemplate:Template;
		public var cudTotal:int;
		public var cudCount:int;
		
		override public function onRegister():void {
			eventMap.mapListener(eventDispatcher,StateEvent.ACTION,handleTemplatesLoaded);
			eventMap.mapListener(eventDispatcher,AppEvent.CONFIG_FILE_LOADED,handleConfigLoaded,AppEvent);
			
			view.customFieldTypes = CustomFieldTypes.TYPES;
			
			view.templateList.addEventListener(IndexChangeEvent.CHANGE,handleTemplateList);
			view.templateList.addEventListener(DragEvent.DRAG_ENTER,handleTemplateListDragEnter);
			view.templateList.addEventListener(DragEvent.DRAG_DROP,handleTemplateListDragDrop);
			
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
		private function menuItemSelectHandler(event:ContextMenuEvent):void{
			contentModel.templates.state = DataCollection.MODIFIED;
			var template:Template
			switch(event.target.caption) {
				case "Remove":
					for each(template in view.templateList.selectedItems) {
						contentModel.templates.removeItemAt(contentModel.templates.getItemIndex(template));
				}
				break;
				case "Duplicate":
					for each(template in view.templateList.selectedItems)  {
						appService.duplicateObject(template,contentModel.templatesConfig.child[0],"templateid","template_customfields");
						appService.addHandlers(handleDuplicated);
					}
				break;
				case "Add":
					template = new Template();
					template.name = "new";
					contentModel.templates.addItem(template);
				break
			}
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
				contentModel.templates.addEventListener(CollectionEvent.COLLECTION_CHANGE,handleTemplatesChanged);
				GlobalUtils.createContextMenu(["Add","Remove","Duplicate"],menuItemSelectHandler,null,[view.templateList]);	
				
			}
/*			if(event.action == AppStartupStateConstants.LOAD_TEMPLATES_CFS_COMPLETE) {
				view.fieldsList.dataProvider = contentModel.templatesCustomFields;
			}*/
		}
		private function handleTemplatesChanged(event:CollectionEvent):void {
			if(event.kind == CollectionEventKind.UPDATE) {
				for each(var prop:PropertyChangeEvent in event.items) {
					if(prop.property == "name")  {
						view.submitButton.enabled = true;
						contentModel.templates.state = DataCollection.MODIFIED;
					}	
				}
			}
		}
		private function handleDragStart(event:ContentViewEvent):void {
			view.cfList.dragEnabled = view.cfList.dropEnabled = true;
		}
		private function handleListDragDrop(event:DragEvent):void {
			view.cfList.dragEnabled = view.cfList.dropEnabled = false;
			if(event.target == event.relatedObject) {
				var template:Template = view.templateList.selectedItem as Template;
				//change the displayorder	
				for each(var customfield:CustomField in template.customfields.source) {
					customfield.displayorder = template.customfields.getItemIndex(customfield)+1;
				}
			}
		}
		private function handleTemplateList(event:IndexChangeEvent):void {
			var item:Template;
			var option:CustomFieldOption;
			var field:CustomField;
			if(event.oldIndex != -1) {
				item = view.templateList.dataProvider.getItemAt(event.oldIndex) as Template;
				//restore the twistedness where CustomFieldOption have switched the vo to the CF and the CF to a defaultvalueCF
				for each(field in item.customfields.source) {
					for each(option in field.optionsArray.source) {
						option.customfield = field;
						option.vo = null;
					}
				}
			}
			item = view.templateList.dataProvider.getItemAt(event.newIndex) as Template;
			view.cfList.dataProvider = null;
			view.callLater(addChangeListener,[item]);
		}
		private function handleTemplateListDragEnter(event:DragEvent):void {
			if(event.dragInitiator == view.cfList) {
				var location:DropLocation = view.templateList.layout.calculateDropLocation(event);
				if(location.dropIndex >= 0 && location.dropIndex < view.templateList.dataProvider.length) {
					DragManager.acceptDragDrop(view.templateList);
					DragManager.showFeedback(DragManager.COPY);
				}
				else {
					event.preventDefault();
					//event.target.hideDropFeedback(event);
					DragManager.showFeedback(DragManager.NONE);
				}
			}
			else {
				event.preventDefault();
				//event.target.hideDropFeedback(event);
				DragManager.showFeedback(DragManager.NONE);
			}
		}
		private function handleTemplateListDragDrop(event:DragEvent):void {
			var location:DropLocation = view.templateList.layout.calculateDropLocation(event);
			var template:Template = view.templateList.dataProvider.getItemAt(location.dropIndex) as Template;
			for each(var field:CustomField in view.cfList.selectedItems) {
				if(template.customfields.getItemIndex(field) == -1) {
					contentModel.templatesCustomFields.state = DataCollection.MODIFIED;
					template.customfields.addItem(field);
					field.templateids += ","+template.id.toString();
					field.newTemplates.push(template.id.toString());
					field.displayorder = template.customfields.length+1;
				}
			}
		}
		private function addChangeListener(template:Template):void {		
			view.cfList.dataProvider = template.customfields;
			template.customfields.addEventListener(CollectionEvent.COLLECTION_CHANGE,handleChange);
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
			contentModel.templatesCustomFields.state = DataCollection.MODIFIED;
			if(event && event.target is ItemRenderer) {
				var field:CustomField = view.cfList.selectedItem as CustomField;
				if(contentModel.templatesCustomFields.modifiedItems.getItemIndex(field) == -1 && 
				   contentModel.templatesCustomFields.newItems.getItemIndex(field) == -1)
						contentModel.templatesCustomFields.modifiedItems.addItem(field);
			}
		}
		private function handleAddButton(event:MouseEvent):void {
			//view.fieldsList.visible = true;
			var template:Template = view.templateList.selectedItem as Template;
			var templateCF:CustomField = new CustomField();
			view.cfList.dataProvider.addItem(templateCF);
			templateCF.templateids = template.id.toString();
			templateCF.groupid = 1;
			templateCF.displayorder = view.cfList.dataProvider.getItemIndex(templateCF)+1;
		}
		private function handleSubmitButton(event:MouseEvent):void {
			cudTotal = cudCount = 0;
			var customfield:CustomField;
			var template:Template;
			var t:String;
			//var selectedTemplate:Template = view.templateList.selectedItem as Template;
			var time:Number = Math.round((new Date().time/1000));
			for each(customfield in  contentModel.templatesCustomFields.deletedItems.source) {
				cudTotal++;
				contentService.deleteContent(customfield,contentModel.templatesConfig.customfields[0]);
				contentService.addHandlers(handleCustomFieldDeleted);
			}
			for each(customfield in  contentModel.templatesCustomFields.modifiedItems.source) {
							
				delete customfield.updateData.optionsArray;
				delete customfield.updateData.templateids;
				delete customfield.updateData.newTemplates;
				var i:int;
				for (var p:String in customfield.updateData) {
					i++;
				}
				if(i > 0 ) { //properties are changed
					cudTotal++;	
					customfield.updateData.customfieldid = customfield.id;
					customfield.modifiedby = appModel.user.id;
					customfield.modifieddate = time;
					contentService.updateContent(customfield,contentModel.templatesConfig.customfields[0],[]);
					contentService.addHandlers(handleCustomfieldUpdated);
				}
				for each(t in customfield.newTemplates) {
					//only adding relational row
					cudTotal++;
					customfield.updateData.templateid = t;
					customfield.updateData.customfieldid = customfield.id;
					customfield.modifiedby = appModel.user.id;
					customfield.modifieddate = time;
					contentService.createContent(customfield,contentModel.templatesConfig.customfields[0],[],true);
					contentService.addHandlers(handleCustomfieldCreated);
				}
			}
			for each(customfield in contentModel.templatesCustomFields.newItems.source) {
				var templateids:Array = customfield.templateids.split(',');
				for each(t in templateids) {
					cudTotal++;
					delete customfield.updateData.templateids;
					delete customfield.updateData.optionsArray;
					customfield.updateData.templateid = t; //sneaky
					customfield.updateData.tablename2 = "content";
					customfield.createdby = customfield.modifiedby = appModel.user.id;
					customfield.modifieddate = customfield.createdate= time;
					contentService.createContent(customfield,contentModel.templatesConfig.customfields[0],[],true);
					contentService.addHandlers(handleCustomfieldCreated);
				}
			}
			for each(template in contentModel.templates.modifiedItems.source) {
				cudTotal++;
				template.modifiedby = appModel.user.id;
				template.modifieddate = time;
				contentService.updateContent(template,contentModel.templatesConfig.child[0],[]);
				contentService.addHandlers(handleTemplateUpdated);
			}
			for each(template in contentModel.templates.newItems.source) {
				cudTotal++;
				template.createdby = template.modifiedby = appModel.user.id;
				template.modifieddate = template.createdate= time;
				contentService.createContent(template,contentModel.templatesConfig.child[0],[]);
				contentService.addHandlers(handleTemplateCreated);
			}
			for each(template in  contentModel.templates.deletedItems.source) {
				cudTotal++;
				contentService.deleteContent(template,contentModel.templatesConfig.child[0]);
				contentService.addHandlers(handleTemplateDeleted);
			}			
		}
		private function handleCustomfieldUpdated(data:Object):void {
			var status:StatusResult = data.result as StatusResult;
			if(status.success) {
				contentModel.templatesCustomFields.setItemNotModified(data.token.content as CustomField);
				checkCudCount();
			}	
		}
		private function handleCustomfieldCreated(data:Object):void {
			var status:StatusResult = data.result as StatusResult;
			if(status.success) {
				var selectedTemplate:Template = view.templateList.selectedItem as Template;
				var ids:Array = status.message.split(',');
				var field:CustomField = data.token.content as CustomField;
				field.id = ids[0]; field.customfieldid = ids[1]; 
				delete field["templateid"];
				field.updateData = new UpdateData();
				contentModel.templatesCustomFields.setItemNotNew(data.token.content as CustomField);
				checkCudCount();
			}	
		}	
		private function handleCustomFieldDeleted(data:Object):void {
			var status:StatusResult = data.result as StatusResult;
			if(status.success) {
				contentModel.templatesCustomFields.deletedItems.removeItem(data.token.content as CustomField);
				checkCudCount();
			}
		}
		private function handleTemplateDeleted(data:Object):void {
			var status:StatusResult = data.result as StatusResult;
			if(status.success) {
				contentModel.templates.deletedItems.removeItem(data.token.content as Template);
				checkCudCount();
			}
		}
		private function handleTemplateUpdated(data:Object):void {
			var status:StatusResult = data.result as StatusResult;
			if(status.success) {
				contentModel.templates.setItemNotModified(data.token.content as Template);
				checkCudCount();
			}	
		}
		private function handleTemplateCreated(data:Object):void {
			var results:Array = data.result as Array;
			if(results.length == 1) {
				contentModel.templates.setItemNotNew(data.token.content as Template);
				checkCudCount();
			}	
		}
		private function checkCudCount():void {
			cudCount++;
			if(cudCount == cudTotal) {
				eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.NOTIFY,"Template Manager updated successfully"));
				view.submitButton.enabled = false;	
				eventDispatcher.dispatchEvent(new ViewEvent(ViewEvent.REFRESH_SELECTED_CONTENT));
			}
		}		
		private function handleDuplicated(data:Object):void {
			var status:StatusResult = data.result as StatusResult;
			var template:Template = data.token.vo as Template;
			if(status.success) {
				var id:int = Number(status.message);
				var newTemplate:Template = new Template();
				newTemplate.id = id;
				newTemplate.name = template.name;
				for each(var field:CustomField in template.customfields.source) {
					newTemplate.customfields.addItem(field);
					field.templateids += ","+id;
				}
				contentModel.templates.addItem(newTemplate);
				contentModel.templates.setItemNotNew(newTemplate);
				contentModel.templates.setItemNotModified(newTemplate);
				view.submitButton.enabled = false;
				eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.NOTIFY,"Template Manager updated successfully"));
/*				contentService.loadRelatedCustomfields(contentModel.templatesConfig.customfields[0],{name:'templateid',value:id});	
				contentService.addHandlers(hanleDuplicatedRetrieve);
				contentService.addProperties("template",newTemplate);*/
			}
		}
		/*private function hanleDuplicatedRetrieve(data:Object):void {
			var results:Array = data.result as Array;
			var template:Template = data.token.template as Template;
			if(results.length > 0) {
				
				for each(var result:CustomField in results) {
					contentModel.templatesCustomFields.addItem(result);
					contentModel.templatesCustomFields.setItemNotModified(result);
					contentModel.templatesCustomFields.setItemNotNew(result);	
					template.customfields.addItem(result);
				}
				contentModel.templates.addItem(template);
				contentModel.templates.setItemNotNew(template);
				contentModel.templates.setItemNotModified(template);
				view.submitButton.enabled = false;
				eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.NOTIFY,"Template Manager updated successfully"));
			}
		}*/
	}
}