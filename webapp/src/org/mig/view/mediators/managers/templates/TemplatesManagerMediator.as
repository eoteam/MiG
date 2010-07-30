package org.mig.view.mediators.managers.templates
{
	import flash.display.DisplayObject;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayList;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.DragEvent;
	import mx.events.FlexEvent;
	import mx.events.PropertyChangeEvent;
	import mx.managers.DragManager;
	
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
	import org.mig.model.vo.content.ContentTab;
	import org.mig.model.vo.content.Template;
	import org.mig.services.interfaces.IAppService;
	import org.mig.services.interfaces.IContentService;
	import org.mig.utils.ClassUtils;
	import org.mig.utils.GlobalUtils;
	import org.mig.view.components.managers.templates.TabBaseView;
	import org.mig.view.components.managers.templates.TemplatesManagerView;
	import org.mig.view.events.ContentViewEvent;
	import org.mig.view.events.UIEvent;
	import org.mig.view.renderers.ListCellEditor;
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
			eventMap.mapListener(eventDispatcher,AppEvent.STARTUP_COMPLETE,handleConfigLoaded,AppEvent);
			eventMap.mapListener(eventDispatcher,ContentViewEvent.TEMPLATE_MODIFIED,enableSubmit);
			
			view.templateList.addEventListener(IndexChangeEvent.CHANGE,handleTemplateList,false,0,true);
			view.templateList.addEventListener(DragEvent.DRAG_ENTER,handleTemplateListDragEnter,false,0,true);
			view.templateList.addEventListener(DragEvent.DRAG_DROP,handleTemplateListDragDrop,false,0,true);
			
			view.addFieldButton.addEventListener(MouseEvent.CLICK,handleAddFieldButton,false,0,true);
			view.submitButton.addEventListener(MouseEvent.CLICK,handleSubmitButton,false,0,true);
			view.actionButton.dataProvider = ["Add","Remove","Duplicate","Rename"];
			view.actionButton.addEventListener(UIEvent.SELECT,handleActionSelection);
			
			
			//view.cfList.addEventListener("addCustomFieldOption",enableSubmit,false,0,true);
			//view.cfList.addEventListener("removeCustomFieldOption",enableSubmit,false,0,true);
			//view.cfList.addEventListener("changeCustomFieldOption",enableSubmit,false,0,true);		
						
			view.addEventListener(FlexEvent.HIDE,handleHide,false,0,true);
			view.addEventListener(FlexEvent.SHOW,handleShow,false,0,true);
			
			
		}
		private function menuItemSelectHandler(event:ContextMenuEvent):void{
			processSelection(event.target.caption);
		}
		private function handleActionSelection(event:UIEvent):void {
			processSelection(event.data.toString());
		}
		private function processSelection(action:String):void {
			var template:Template;
			switch(action) {
				case "Remove":
					for each(template in view.templateList.selectedItems) {
						contentModel.templates.removeItemAt(contentModel.templates.getItemIndex(template));
					}
				break;
				
				case "Duplicate":
					for each(template in view.templateList.selectedItems)  {
						appService.duplicateObject(template,contentModel.templatesConfig,"templateid","templates_customfields");
						appService.addHandlers(handleDuplicated);
					}
				break;
				
				case "Add":
					template = new Template();
					template.name = "new";
					contentModel.templates.addItem(template);
				break;
				
				case "Rename":
					if(view.templateList.selectedItem) {
						var editor:ListCellEditor = ListCellEditor(view.templateList.dataGroup.getChildAt(view.templateList.selectedIndex));
						editor.startEditing();
						editor.input.setFocus();
						editor.input.selectRange(editor.input.text.length,editor.input.text.length);
					}
				break;
			}
		}
		
		private function handleHide(event:FlexEvent):void {
			previouslySelectedTemplate = view.templateList.selectedItem as Template;
		}
		private function handleShow(event:FlexEvent):void {
			view.templateList.selectedItem = previouslySelectedTemplate;
			contentModel.templatesCustomFields.state = DataCollection.MODIFIED;
			contentModel.templates.state = DataCollection.MODIFIED;
		}
		private function handleConfigLoaded(event:AppEvent):void {
			view.name = contentModel.templatesConfig.name;
		} 
		private function handleTemplatesLoaded(event:StateEvent):void {
			if(event.action == AppStartupStateConstants.LOAD_TEMPLATES_COMPLETE) {
				view.templateList.dataProvider = contentModel.templates;
				contentModel.templates.addEventListener(CollectionEvent.COLLECTION_CHANGE,handleTemplatesChanged,false,0,true);
				contentModel.templatesCustomFields.addEventListener(CollectionEvent.COLLECTION_CHANGE,handleChange,false,0,true);
				GlobalUtils.createContextMenu(["Add","Remove","Duplicate"],menuItemSelectHandler,null,[view.templateList]);	
				view.addTabButton.dataProvider = contentModel.contentTabs;
				view.addTabButton.labelField = "name";
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
					}	
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
					field.ready = false;
					for each(option in field.optionsArray.source) {
						option.customfield = field;
						option.vo = null;
					}
				}
			}
			item = view.templateList.dataProvider.getItemAt(event.newIndex) as Template;
			//view.cfList.dataProvider = null;
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
					view.submitButton.enabled = true;
					var newField:CustomField = duplicateField(template,field);
				}
			}
		}
		private function addChangeListener(template:Template):void {		
			view.cfList.dataProvider = template.customfields;
			var len:int = view.tabStack.getChildren().length;
			for each(var c:DisplayObject in view.tabStack.getChildren()) {
				if(c != view.templateDetailView)
					view.tabStack.removeChild(c);
			}
			for each(var tab:ContentTab in template.contentTabs.source) {
				var tabContainer:TabBaseView = ClassUtils.instantiateClass(tab.editview) as TabBaseView;
				tabContainer.percentHeight = tabContainer.percentWidth = 100;
				tabContainer.tab = tab;
				tabContainer.template = template;
				//tabContainer.dataProvider = new ArrayList(tab.parameters);
				view.tabStack.addChild(tabContainer);
				tabContainer.label = tab.name;
			}
		}
		private function handleChange(event:CollectionEvent):void {
			var field:CustomField;
			switch (event.kind) {			
				case "add":
					for each(field in event.items) 
						contentModel.templatesCustomFields.addItem(field);
				break;
				case "remove":
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
				   contentModel.templatesCustomFields.newItems.getItemIndex(field) == -1)
						contentModel.templatesCustomFields.modifiedItems.addItem(field);
			}
		}
		private function handleAddFieldButton(event:MouseEvent):void {
			var template:Template = view.templateList.selectedItem as Template;
			var templateCF:CustomField = new CustomField();
			view.cfList.dataProvider.addItem(templateCF);
			templateCF.templateid = template.id;
			templateCF.groupid = 1;
			templateCF.displayorder = view.cfList.dataProvider.getItemIndex(templateCF)+1;
		}
		private function handleSubmitButton(event:MouseEvent):void {
			eventDispatcher.dispatchEvent(new ContentViewEvent(ContentViewEvent.COMMIT_TEMPLATES));
			cudTotal = cudCount = 0;
			var customfield:CustomField;
			var template:Template;
			var t:String;
			var time:Number = Math.round((new Date().time/1000));
			for each(customfield in  contentModel.templatesCustomFields.deletedItems.source) {
				cudTotal++;
				if(customfield.globalDelete) {
					var arg1:Object = {name:'customfieldid',value:customfield.customfieldid};
					var arg2:Object = {name:'tablename2',value:'content'};
					contentService.deleteContent(customfield,contentModel.templatesConfig.customfieldsConfig,arg1,arg2);					
				}
				else {
					contentService.deleteContent(customfield,contentModel.templatesConfig.customfieldsConfig);
				}
				contentService.addHandlers(handleCustomFieldDeleted);	
			}
			for each(customfield in  contentModel.templatesCustomFields.modifiedItems.source) {				
				var c:int;
				for(t in customfield.updateData)
					c++;
				if(c>0) {
					cudTotal++;	
					customfield.updateData.customfieldid = customfield.customfieldid;
					customfield.updateData.tablename2 = "content";
					
					customfield.modifiedby = appModel.user.id;
					customfield.modifieddate = time;
					contentService.updateContent(customfield,contentModel.templatesConfig.customfieldsConfig,[]);
					contentService.addHandlers(handleCustomfieldUpdated);
				}
				else {
					contentModel.templatesCustomFields.setItemNotModified(customfield);
				}
			}
			for each(customfield in contentModel.templatesCustomFields.newItems.source) {
				cudTotal++;
				if(customfield.customfieldid != 0)
					customfield.updateData.customfieldid = customfield.customfieldid;
				customfield.updateData.tablename2 = "content";
				customfield.updateData.templateid = customfield.templateid;
				
				customfield.createdby = customfield.modifiedby = appModel.user.id;
				customfield.modifieddate = customfield.createdate= time;
				contentService.createContent(customfield,contentModel.templatesConfig.customfieldsConfig,[],true);
				contentService.addHandlers(handleCustomfieldCreated);
			}
			for each(template in contentModel.templates.modifiedItems.source) {
				cudTotal++;
				template.modifiedby = appModel.user.id;
				template.modifieddate = time;
				contentService.updateContent(template,contentModel.templatesConfig,[]);
				contentService.addHandlers(handleTemplateUpdated);	
			}
			for each(template in contentModel.templates.newItems.source) {
				cudTotal++;
				template.createdby = template.modifiedby = appModel.user.id;
				template.modifieddate = template.createdate= time;
				contentService.createContent(template,contentModel.templatesConfig,[]);
				contentService.addHandlers(handleTemplateCreated);
			}
			for each(template in  contentModel.templates.deletedItems.source) {
				cudTotal++;
				contentService.deleteContent(template,contentModel.templatesConfig);
				contentService.addHandlers(handleTemplateDeleted);
			}	
			if(cudTotal == 0)
				view.submitButton.enabled = false;
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
				var field:CustomField = data.token.content as CustomField;
				if(!field.globalDelete)
					contentModel.templatesCustomFields.deletedItems.removeItem(field);
				else {
					for each(var template:Template in contentModel.templates) {
						for each(var cf:CustomField in template.customfields.source) {
							if(cf.customfieldid == field.customfieldid) {
								template.customfields.removeItem(cf);
							}
						}
					}
				}
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
					var newField:CustomField = duplicateField(newTemplate,field);	
					contentModel.templatesCustomFields.setItemNotNew(newField);
					contentModel.templatesCustomFields.setItemNotModified(newField);					
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
		private function duplicateField(template:Template,field:CustomField):CustomField {
			var newField:CustomField = new CustomField();
			template.customfields.addItem(newField);
			
			newField.templateid = template.id;
			newField.customfieldid = field.customfieldid;
			newField.displayorder = template.customfields.length+1;
			
			newField.typeid = field.typeid;
			newField.groupid = field.groupid;
			newField.optionsArray = field.optionsArray;
			newField.displayname = field.displayname
			newField.name = field.name;
			newField.defaultvalue = field.defaultvalue;
			newField.description = field.description;
			return newField;
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