package org.mig.view.mediators.main
{
	import mx.collections.ArrayCollection;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	
	import org.mig.events.NotificationEvent;
	import org.mig.events.ViewEvent;
	import org.mig.model.ContentModel;
	import org.mig.model.vo.StatusResult;
	import org.mig.model.vo.content.ContainerNode;
	import org.mig.model.vo.content.ContentData;
	import org.mig.model.vo.content.ContentStatus;
	import org.mig.services.interfaces.IContentService;
	import org.mig.services.interfaces.IService;
	import org.mig.utils.GlobalUtils;
	import org.mig.view.components.main.PendingListView;
	import org.mig.view.constants.DraggableViews;
	import org.robotlegs.mvcs.Mediator;
	
	public class PendingListMediator extends Mediator
	{
		[Inject]
		public var view:PendingListView;
		
		[Inject]
		public var contentModel:ContentModel;
		
		[Inject]
		public var contentService:IContentService;
		override public function onRegister():void {
			eventMap.mapListener(eventDispatcher,ViewEvent.VALIDATE_CONTENT,validateContent);
			view.pendingList.addEventListener(DragEvent.DRAG_START,handleDragStart);
			view.pendingList.addEventListener(DragEvent.DRAG_COMPLETE,handleDragComplete);
			view.addEventListener(DragEvent.DRAG_ENTER,handleDragEnter);
			view.addEventListener(DragEvent.DRAG_DROP,handleDragDrop);
			view.addEventListener(DragEvent.DRAG_EXIT,handleDragExit);
		}
		private function validateContent(event:ViewEvent):void {
			view.dataProvider = new ArrayCollection();
			addChildren(contentModel.contentModel);
		}
		private function addChildren(node:ContainerNode):void {
			if(node.children.length > 0) {
				for each(var item:ContainerNode in node.children) {
						if(item.data.statusid == ContentStatus.DRAFT) {
							view.dataProvider.addItem(item);
						}
					addChildren(item);
				}
			}		
		}
		private function handleDragStart(event:DragEvent):void {
			eventDispatcher.dispatchEvent(new ViewEvent(ViewEvent.TOGGLE_PUBLISH_DROP_BOX,true));
		}
		private function handleDragComplete(event:DragEvent):void {
			eventDispatcher.dispatchEvent(new ViewEvent(ViewEvent.TOGGLE_PUBLISH_DROP_BOX,false));
		}	
		private function handleDragEnter(event:DragEvent):void {
			if(event.dragSource.hasFormat(DraggableViews.CONTENT_TREE_CONTAINERS))
			{
				var containers:Array = event.dragSource.dataForFormat(DraggableViews.CONTENT_TREE_CONTAINERS) as Array;
				var accept:Boolean = true;
				for each(var item:ContainerNode in containers) {
					if(item.isFixed) {
						accept = false;
						break;
					}
				}
				if(accept)
				{
					//Application.application.mainView.contentTree.toggleState(true);
					event.action = DragManager.COPY;
					DragManager.acceptDragDrop(view);
					DragManager.showFeedback("copy");
					view.dropBox.visible = true;
				}
			}
		}
		private var pendingArray:Array;
		private function handleDragDrop(event:DragEvent):void {
			pendingArray = new Array();
			var containers:Array = event.dragSource.dataForFormat(DraggableViews.CONTENT_TREE_CONTAINERS) as Array;
			for each(var item:ContainerNode in containers) {
				var tmp:Array = GlobalUtils.accumulateChildren(item)
				for each(var n:ContainerNode in tmp) {
					pendingArray.push(n);
				}
			}
			contentService.updateContainersStatus(pendingArray,ContentStatus.DRAFT);
			contentService.addHandlers(handlePendingContainers);
			view.pendingSpinner.visible = true;
		}
		private function handlePendingContainers(data:Object):void {
			var result:StatusResult = data.result as StatusResult;
			var containers:Array = data.token.containers;
			if(result.success) {
				for each(var container:ContainerNode in containers) {
					ContentData(container.data).statusid = ContentStatus.DRAFT; 
				}
				eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.NOTIFY,"Containers drafted successfully"));
				eventDispatcher.dispatchEvent(new ViewEvent(ViewEvent.VALIDATE_CONTENT));
				view.pendingSpinner.visible = false;
				view.dropBox.visible = false;
			}
		}
		private function handleDragExit(event:DragEvent):void {
			view.dropBox.visible = false;
		}
	}
}