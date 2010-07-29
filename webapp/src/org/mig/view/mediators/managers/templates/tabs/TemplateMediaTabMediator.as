package org.mig.view.mediators.managers.templates.tabs
{
	import flash.events.MouseEvent;
	
	import mx.events.CollectionEvent;
	import mx.events.FlexEvent;
	
	import org.mig.events.NotificationEvent;
	import org.mig.model.ContentModel;
	import org.mig.model.vo.app.StatusResult;
	import org.mig.model.vo.content.ContentTab;
	import org.mig.model.vo.content.ContentTabParameter;
	import org.mig.model.vo.content.Template;
	import org.mig.services.interfaces.IContentService;
	import org.mig.view.components.managers.templates.tabs.TemplateMediaTab;
	import org.mig.view.events.ContentViewEvent;
	import org.robotlegs.mvcs.Mediator;
	
	public class TemplateMediaTabMediator extends Mediator
	{
		[Inject]
		public var view:TemplateMediaTab;
		
		[Inject]
		public var contentModel:ContentModel;
		
		[Inject]
		public var contentService:IContentService;
		
		public var cudTotal:int;
		public var cudCount:int;
		
		override public function onRegister():void {
			eventMap.mapListener(eventDispatcher,ContentViewEvent.COMMIT_TEMPLATES,handleSubmit);
			view.addEventListener(FlexEvent.CONTENT_CREATION_COMPLETE,handleViewCreated);
		}
		private function handleViewCreated(event:FlexEvent):void {
			view.addButton.addEventListener(MouseEvent.CLICK,handleAddButton);
			view.tab.parameters.addEventListener(CollectionEvent.COLLECTION_CHANGE,handleParametersChange);
		}
		private function handleAddButton(event:MouseEvent):void {
			var param:ContentTabParameter = new ContentTabParameter();
			view.tab.parameters.addItem(param);
			param.name = "usage";
			param.tabid = view.tab.id;
			param.templateid = view.template.id;
			param.value = '';
			param.param2 = '1';
			param.param3 = view.tab.parameters.length.toString();
			param.tabid = view.tab.id;
			param.templateid = view.template.id;
			
		}
		private function handleParametersChange(event:CollectionEvent):void {
			eventDispatcher.dispatchEvent(new ContentViewEvent(ContentViewEvent.TEMPLATE_MODIFIED,view.template));
		}
		private function handleSubmit(event:ContentViewEvent):void {
			cudTotal = cudCount = 0;
			for each(var template:Template in contentModel.templates) {
				for each(var tab:ContentTab in template.contentTabs) {
					var param:ContentTabParameter;
					for each(param in tab.parameters.modifiedItems.source) {
						cudTotal++;
						contentService.updateContent(param,contentModel.contentTabsParametersConfig,[]);
						contentService.addHandlers(handleParamUpdated);
						contentService.currentToken.tab = tab;
					}
					for each(param in tab.parameters.deletedItems.source) {
						cudTotal++;
						contentService.deleteContent(param,contentModel.contentTabsParametersConfig);
						contentService.addHandlers(handleParamDeleted);
						contentService.currentToken.tab = tab;
					}
					for each(param in tab.parameters.newItems.source) {
						cudTotal++;
						contentService.createContent(param,contentModel.contentTabsParametersConfig,[],true);	
						contentService.addHandlers(handleParamCreated);	
						contentService.currentToken.tab = tab;
					}
				}
			}
		}
		private function handleParamDeleted(data:Object):void {
			var status:StatusResult = data.result as StatusResult;
			if(status.success) {
				var tab:ContentTab = data.token.tab as ContentTab;
				tab.parameters.deletedItems.removeItem(data.token.content as ContentTabParameter);
				checkCudCount();
			}
		}
		private function handleParamUpdated(data:Object):void {
			var status:StatusResult = data.result as StatusResult;
			if(status.success) {
				var tab:ContentTab = data.token.tab as ContentTab;
				tab.parameters.setItemNotModified(data.token.content as ContentTabParameter);
				checkCudCount();
			}	
		}
		private function handleParamCreated(data:Object):void {
			var results:Array = data.result as Array;
			if(results.length == 1) {
				var tab:ContentTab = data.token.tab as ContentTab;
				tab.parameters.setItemNotNew(data.token.content as ContentTabParameter);
				checkCudCount();
			}	
		}
		private function checkCudCount():void {
			cudCount++;
			if(cudCount == cudTotal) {
				eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.NOTIFY,"Template Manager updated successfully"));
			}
		}			
	}
}