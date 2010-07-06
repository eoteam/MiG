package org.mig.view.mediators.managers.tags
{
		import flash.events.Event;
		import flash.events.MouseEvent;
		
		import mx.collections.ArrayCollection;
		import mx.collections.ArrayList;
		import mx.collections.HierarchicalData;
		import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
		import mx.controls.dataGridClasses.DataGridColumn;
		import mx.core.ClassFactory;
		import mx.events.CollectionEvent;
		import mx.events.DataGridEvent;
		import mx.events.FlexEvent;
		import mx.events.ListEvent;
		
		import org.mig.collections.DataCollection;
		import org.mig.controller.startup.AppStartupStateConstants;
		import org.mig.events.AppEvent;
		import org.mig.events.NotificationEvent;
		import org.mig.model.ContentModel;
		import org.mig.model.vo.UpdateData;
		import org.mig.model.vo.app.CustomField;
		import org.mig.model.vo.app.CustomFieldTypes;
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
			
			addListeners();
		}
		private function addListeners():void {
			view.addEventListener(FlexEvent.SHOW,handleContent);
			view.insertButton.addEventListener(MouseEvent.CLICK,handleInsertButton);
			view.trashButton1.addEventListener(MouseEvent.CLICK,handleTagDeleteButton);
			view.trashButton2.addEventListener(MouseEvent.CLICK,handleCategoryDeleteButton);
			view.submitButton.addEventListener(MouseEvent.CLICK,handleSubmitButton);
			//view.termsGrid.addEventListener(DataGridEvent.ITEM_EDIT_END,handleTagEditEnd);
			
			view.categoriesView.categoryList.addEventListener(ListEvent.ITEM_CLICK,handleCategoryListClick);
			view.insertParentButton.addEventListener(MouseEvent.CLICK,handleInsertParentCategory);
			view.insertChildButton.addEventListener(MouseEvent.CLICK,handleInsertChildCategory);
			
		}
		private function handleConfigLoaded(event:AppEvent):void {
			view.name = contentModel.termsConfig.@name.toString();
		}
		private function handleTermsLoaded(event:StateEvent):void {
			if(event.action == AppStartupStateConstants.LOAD_CATEGORIES_CFS_COMPLETE) {	
				contentModel.tagTerms.addEventListener(CollectionEvent.COLLECTION_CHANGE,handleChange);
				contentModel.categoryTermsFlat.addEventListener(CollectionEvent.COLLECTION_CHANGE,handleChange);
			/*	var cols:Array = view.catGrid.columns;
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
*/			}
		}
		private function handleContent(event:FlexEvent):void {
			view.termsGrid.dataProvider = contentModel.tagTerms;
			view.categoriesView.categoryList.dataProvider = contentModel.categoryTerms;
			/*view.categoriesView.parentList.labelField = "name";
			view.categoriesView.childrenList.labelField = "name";
			view.categoriesView.parentList.headerText = "Group";
			view.categoriesView.parentList.sortField = "name";
			view.categoriesView.childrenList.sortField = "name";
			view.categoriesView.childrenList.headerText = "Category";*/
			var desc:ArrayList = new ArrayList();
			var cf:CustomField;
			cf = new CustomField();
			cf.typeid = CustomFieldTypes.STRING;
			cf.name = "name";
			cf.displayname = "Name";
			desc.addItem(cf);
			
			cf = new CustomField();
			cf.typeid = CustomFieldTypes.STRING;
			cf.name = "slug";
			cf.displayname = "Slug";
			desc.addItem(cf);
			
			for each(var item:CustomField in contentModel.categoriesCustomFields)
				desc.addItem(item);
						
			view.categoriesView.inspector.dataProvider = desc;
		}
		private function handleInsertButton	(event:MouseEvent):void {
			var term:Term = new Term();
			term.taxonomy = "tag";
			term.updateData.taxonomy = "tag";
			contentModel.tagTerms.addItemAt(term,0);
		}
		public var cudTotal:int;
		public var cudCount:int;
		
		/*private function handleTagEditEnd(event:DataGridEvent):void {
			var term:Term = event.itemRenderer.data as Term;
			if(contentModel.tagTerms.isItemNew(term)) {
				contentService.createContent(term,contentModel.termsConfig.child[0]);
				contentService.addHandlers(handleTagTermCreated);	
			} 
			else if(contentModel.tagTerms.isItemModified(term)) {
				contentService.updateContent(term,contentModel.termsConfig.child[0]);
				contentService.addHandlers(handleTagTermUpdated);
			}
		}*/
		private function handleChange(event:Event):void {
			view.submitButton.enabled = true;
		}
		private function handleSubmitButton(event:Event):void {
			cudCount = cudTotal = 0;
			var term:Term;
			for each(term in contentModel.tagTerms.modifiedItems.source) {
				contentService.updateContent(term,contentModel.termsConfig.child[0],contentModel.categoriesCustomFields);
				contentService.addHandlers(handleTagTermUpdated);
				cudTotal++;
			}
			for each(term in contentModel.tagTerms.newItems.source) {
				contentService.createContent(term,contentModel.termsConfig.child[0],contentModel.categoriesCustomFields);
				contentService.addHandlers(handleTagTermCreated);
				cudTotal++;
			}
			for each(term in contentModel.categoryTermsFlat.modifiedItems.source) {
				contentService.updateContent(term,contentModel.termsConfig.child[0],contentModel.categoriesCustomFields);
				contentService.addHandlers(handleCategoryTermUpdated);
				cudTotal++;	
			}
			for each(term in contentModel.categoryTermsFlat.newItems.source) {
				if(term.name != "new") {
					contentService.createContent(term,contentModel.termsConfig.child[0],contentModel.categoriesCustomFields);
					contentService.addHandlers(handleCategoryTermCreated);
					cudTotal++;
				}
			}
		}
		private function handleTagDeleteButton(event:MouseEvent):void {
			cudCount = cudTotal = 0;
			for each(var item:Term in view.termsGrid.selectedItems) {
				if(contentModel.tagTerms.isItemNew(item)) 
					contentModel.tagTerms.removeItemAt(contentModel.tagTerms.getItemIndex(item));
				else {
					contentService.deleteContent(item,contentModel.termsConfig.child[0]);
					contentService.addHandlers(handleTagTermDeleted);
					cudTotal++;
				}
			}
		}
		private function handleCategoryDeleteButton(event:MouseEvent):void {
			cudCount = cudTotal = 0;
			var items:Array = [];
			for each(var item:Term in view.categoriesView.categoryList.selectedItems) {
				GlobalUtils.accumulateChildren(item,items);
			}
			var i:int, j : int;
			for (i = 0; i < items.length - 1; i++)
				for (j = i + 1; j < items.length; j++)
					if (items[i] === items[j])
						items.splice(j, 1);
			
			for each(item in items) {
				if(contentModel.categoryTermsFlat.isItemNew(item)) 
					contentModel.categoryTermsFlat.removeItemAt(contentModel.categoryTermsFlat.getItemIndex(item));
				else {
					contentService.deleteContent(item,contentModel.termsConfig.child[0]);
					contentService.addHandlers(handleCategoryTermDeleted);
					cudTotal++;
				}
			}
		}

		private function handleTagTermUpdated(data:Object):void {
			var status:StatusResult = data.result as StatusResult;
			if(status.success) {
				checkCudCount();
				contentModel.tagTerms.setItemNotModified(data.token.content as Term);
			}	
		}
		private function handleTagTermCreated(data:Object):void {
			var results:Array = data.result as Array;
			if(results.length == 1) {
				checkCudCount();
				contentModel.tagTerms.setItemNotNew(data.token.content as Term);
			}	
		}
		private function handleTagTermDeleted(data:Object):void {
			var status:StatusResult = data.result as StatusResult;
			if(status.success) {
				checkCudCount();
				contentModel.tagTerms.removeItemAt(contentModel.tagTerms.getItemIndex(data.token.content as Term));
			}				
		}
		private function handleCategoryTermUpdated(data:Object):void {
			var status:StatusResult = data.result as StatusResult;
			if(status.success) {
				checkCudCount();
				contentModel.categoryTermsFlat.setItemNotModified(data.token.content as Term);
			}	
		}
		private function handleCategoryTermCreated(data:Object):void {
			var results:Array = data.result as Array;
			if(results.length == 1) {
				checkCudCount();
				contentModel.categoryTermsFlat.setItemNotNew(data.token.content as Term);
			}	
		}
		private function handleCategoryTermDeleted(data:Object):void {
			var status:StatusResult = data.result as StatusResult;
			if(status.success) {
				var term:Term = data.token.content as Term;
				contentModel.categoryTermsFlat.removeItemAt(contentModel.categoryTermsFlat.getItemIndex(term));
				if(term.parent == null)
					contentModel.categoryTerms.splice(contentModel.categoryTerms.indexOf(term,1));
				else
					term.parent.children.splice(term.parent.children.indexOf(term,1));		
				checkCudCount();
			}				
		}		
		private function handleCategoryListClick(event:ListEvent):void {
			view.insertChildButton.enabled = true;
		}
		private function handleInsertParentCategory(event:MouseEvent):void {
			var term:Term = new Term();
			term.taxonomy = "category";
			term.updateData.taxonomy = "category";
			term.name = term.slug = 'new';
			for each(var cf:Object in contentModel.categoriesCustomFields) {
				term[cf.customfield.name] = '';
			}
			var currentTerm:Term = view.categoriesView.categoryList.selectedItem as Term;
			if(currentTerm && currentTerm.parent) {
				currentTerm.parent.children.push(term);
				term.parent = currentTerm.parent;
			}
			else {
				contentModel.categoryTermsFlat.addItem(term);
				contentModel.categoryTerms.push(term);
			}
			view.categoriesView.categoryList.invalidateList();
		}
		private function handleInsertChildCategory(event:MouseEvent):void {
			var currentTerm:Term = view.categoriesView.categoryList.selectedItem as Term;
			var term:Term = new Term();
			term.taxonomy = "category";
			term.updateData.taxonomy = "category";
			term.name = term.slug = 'new';
			for each(var cf:Object in contentModel.categoriesCustomFields) {
				term[cf.customfield.name] = '';
			}
			if(!currentTerm.children)
				currentTerm.children = [];
			currentTerm.children.push(term);
			contentModel.categoryTermsFlat.addItem(term);
			term.parentid = currentTerm.id;
			term.updateData.parentid = currentTerm.id;
			view.categoriesView.categoryList.invalidateList();
			view.categoriesView.categoryList.expandItem(currentTerm,true);
			
		}
		private function checkCudCount():void {
			cudCount++;
			if(cudCount == cudTotal) {
				eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.NOTIFY,"Terms & Catergories updated successfully"));
				view.submitButton.enabled = false;
				view.categoriesView.selectedCategoryLabel.text = view.categoriesView.categoryList.selectedItem.name;
				view.categoriesView.categoryList.invalidateList();
				view.categoriesView.refresh();
			}
		}
	}
}