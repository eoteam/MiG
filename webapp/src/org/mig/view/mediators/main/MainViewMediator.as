package org.mig.view.mediators.main
{
	import flash.display.MovieClip;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayList;
	import mx.events.DragEvent;
	import mx.events.ResizeEvent;
	import mx.managers.DragManager;
	import mx.utils.NameUtil;
	
	import org.mig.controller.startup.AppStartupStateConstants;
	import org.mig.events.AppEvent;
	import org.mig.events.ContentEvent;
	import org.mig.events.NotificationEvent;
	import org.mig.events.ViewEvent;
	import org.mig.model.AppModel;
	import org.mig.model.vo.app.StatusResult;
	import org.mig.model.vo.content.ContainerNode;
	import org.mig.model.vo.content.ContainerData;
	import org.mig.model.vo.content.ContentStatus;
	import org.mig.services.interfaces.IContentService;
	import org.mig.view.components.main.MainView;
	import org.mig.view.constants.DraggableViews;
	import org.robotlegs.mvcs.Actor;
	import org.robotlegs.mvcs.Mediator;
	import org.robotlegs.utilities.statemachine.StateEvent;
	
	public class MainViewMediator extends Mediator
	{
		[Inject]
		public var view:MainView;
		
		[Inject]
		public var appModel:AppModel;
		
		[Inject]
		public var contentService:IContentService;
		
		private var pendingContainersDropped:Boolean = false;
		
		public override function onRegister():void {
			eventMap.mapListener( eventDispatcher, AppEvent.CONFIG_LOADED,		handleConfig,			AppEvent);
			eventMap.mapListener( eventDispatcher, AppEvent.CONFIG_FILE_LOADED,	handleConfigFile,		AppEvent);
			eventMap.mapListener( eventDispatcher, AppEvent.STARTUP,			handleStartupProgress,	AppEvent); 
			eventMap.mapListener( eventDispatcher, AppEvent.STARTUP_PROGRESS,	handleStartupProgress,	AppEvent); 
			eventMap.mapListener( eventDispatcher, AppEvent.STARTUP_COMPLETE,	handleStartupProgress,	AppEvent);
			
			eventMap.mapListener( eventDispatcher, ViewEvent.RESIZE_MANAGER_TREE,		handleManagersTreeResize,	ViewEvent);
			eventMap.mapListener( eventDispatcher, ViewEvent.ENABLE_NEW_CONTENT,		handleNewContent,			ViewEvent); 
			eventMap.mapListener( eventDispatcher, ViewEvent.TOGGLE_PUBLISH_DROP_BOX,	handlePublishDropBox,		ViewEvent); 
		
			addListeners();
		}
		private function addListeners():void {
			view.trashButton.addEventListener(MouseEvent.CLICK,handleTrashClick);
			view.trashButton.addEventListener(DragEvent.DRAG_ENTER,handleTrashDragEnter);
			view.trashButton.addEventListener(DragEvent.DRAG_DROP,handleTrashDragDrop);
			view.fullScreenButton.addEventListener(MouseEvent.CLICK,handleFullScreen);
			view.idCheckBox.addEventListener(Event.CHANGE,handleIdCheck);
			view.publishDropBox.addEventListener( DragEvent.DRAG_ENTER,	handleDropBoxDragEnter);
			view.publishDropBox.addEventListener( DragEvent.DRAG_DROP,	handleDropBoxDragDrop);

			//view.addButton.addEventListener(MouseEvent.CLICK,handleAddClick);
		}
		private function handleIdCheck(event:Event):void {
			view.contentTree.labelField = view.idCheckBox.selected ? "debugLabel" : "label";
		}
		private function handleStartupProgress(event:AppEvent):void {

			view.preloader.visible = true;
			if(event.args) 
				view.startupStep.text = event.args[0];
			var c:Number = view.preloaderHolder.width > view.preloaderHolder.height ? view.preloaderHolder.height : view.preloaderHolder.height;
			var bgColor:uint = 0x000000;
			var bgStrokeColor:uint = 0x666666;
			var fillColor:uint = 0xAAAAAA;
			view.preloaderHolder.graphics.clear();
			view.preloaderHolder.graphics.beginFill(bgColor);
			view.preloaderHolder.graphics.lineStyle(1,bgStrokeColor,1);
			view.preloaderHolder.graphics.drawRect(0,0,c,2);
			view.preloaderHolder.graphics.endFill();
			view.preloaderHolder.graphics.lineStyle(0,0,0);
			var progressWidth:Number = (appModel.startupCount / appModel.startupItems) * c;
			view.preloaderHolder.graphics.beginFill(fillColor);
			view.preloaderHolder.graphics.drawRect(0,0,progressWidth,2);
			view.preloaderHolder.graphics.endFill();
			if(event.type == AppEvent.STARTUP_COMPLETE) {
				view.preloader.visible = false;
			}
		}
		private function handleConfigFile(event:Event):void {
			MovieClip(view.mainLogo.content).play();
			view.logoFadeOut.play();
			view.bgLogoHolder.visible = true;
			view.bodyContainer.visible = true;	
			view.topLogo.visible = true;
			view.appOptionsCombo.enabled = true;
			view.helpCombo.enabled = true;
			view.appOptionsCombo.dataProvider = new ArrayList([appModel.publishedURL,appModel.pendingURL]);
		}
		private function handleConfig(event:Event):void {
			//data wiring
			view.appOptionsCombo.openButton.label = appModel.prompt;
		}
		
		private function handleManagersTreeResize(event:ViewEvent):void {
			view.openManagers.heightTo = event.args[0] as Number;
			view.openManagers.play();
		}
		private function handleTrashClick(event:Event):void {
			eventDispatcher.dispatchEvent(new ViewEvent(ViewEvent.DELETE_CONTAINERS));
		}
		private function handleTrashDragEnter(event:DragEvent):void {
			if(event.dragSource.hasFormat(DraggableViews.CONTENT_TREE_CONTAINERS)) {
				DragManager.acceptDragDrop(view.trashButton);
				DragManager.showFeedback(DragManager.COPY);
			}
		}
		private function handleTrashDragDrop(event:DragEvent):void {
			eventDispatcher.dispatchEvent(new ViewEvent(ViewEvent.DELETE_CONTAINERS));
		}
		
		private function handleFullScreen(evt:MouseEvent):void {
			try {
				if (view.fullScreenButton.selected)
					this.contextView.stage.displayState = StageDisplayState.FULL_SCREEN;
				else 
					this.contextView.stage.displayState = StageDisplayState.NORMAL;	
			}	
			catch (any:*) {
				// ignore
			}
		}
		private function handleNewContent(event:ViewEvent):void {
			var enable:Boolean = event.args[0] as Boolean;
			view.addButton.enabled = enable;
			if(!enable)
				view.addButton.selected = enable;
		}
		private function handlePublishDropBox(event:ViewEvent):void {
			view.publishDropBox.visible = event.args[0] as Boolean;
		}
		private function handleDropBoxDragEnter(event:DragEvent):void {
			if(event.dragSource.hasFormat(DraggableViews.PENDING_LIST_CONTAINERS)) {
				DragManager.showFeedback("copy");
				DragManager.acceptDragDrop(view.publishDropBox); 
			}
		}
		private function handleDropBoxDragDrop(event:DragEvent):void {
			var containers:Array = event.dragSource.dataForFormat(DraggableViews.PENDING_LIST_CONTAINERS) as Array;
			contentService.updateContainersStatus(containers,ContentStatus.PUBLISHED);
			contentService.addHandlers(handleContentDraft);
			view.publishSpinner.visible = true;
			pendingContainersDropped = true;	
		}
		private function handleContentDraft(data:Object):void {
			var result:StatusResult = data.result as StatusResult;
			var containers:Array = data.token.containers;
			if(result.success) {
				for each(var container:ContainerNode in containers) {
					ContainerData(container.data).statusid = ContentStatus.PUBLISHED;
				}
				eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.NOTIFY,"Containers published successfully"));
				eventDispatcher.dispatchEvent(new ViewEvent(ViewEvent.VALIDATE_CONTENT));
				view.publishSpinner.visible = view.publishDropBox.visible = false;
			}
		}
	}
}