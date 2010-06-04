package org.mig.view.mediators.main
{
	import flash.display.MovieClip;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayList;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	import mx.utils.NameUtil;
	
	import org.mig.controller.startup.AppStartupStateConstants;
	import org.mig.events.AppEvent;
	import org.mig.events.ContentEvent;
	import org.mig.events.ViewEvent;
	import org.mig.model.AppModel;
	import org.mig.view.components.main.MainView;
	import org.robotlegs.mvcs.Actor;
	import org.robotlegs.mvcs.Mediator;
	import org.robotlegs.utilities.statemachine.StateEvent;

	public class MainViewMediator extends Mediator
	{
		[Inject]
		public var view:MainView;
		
		[Inject]
		public var appModel:AppModel;
		
		public override function onRegister():void {
			eventMap.mapListener(eventDispatcher, AppEvent.CONFIG_LOADED,		handleConfig,			AppEvent);
			eventMap.mapListener(eventDispatcher, AppEvent.CONFIG_FILE_LOADED,	handleConfigFile,		AppEvent);
			eventMap.mapListener(eventDispatcher, AppEvent.STARTUP,				handleStartupProgress,	AppEvent); 
			eventMap.mapListener(eventDispatcher, AppEvent.STARTUP_PROGRESS,	handleStartupProgress,	AppEvent); 
			eventMap.mapListener(eventDispatcher, AppEvent.STARTUP_COMPLETE,	handleStartupProgress,	AppEvent);
			
			eventMap.mapListener(eventDispatcher,ViewEvent.RESIZE_MANAGER_TREE,handleManagersTreeResize,ViewEvent);
			eventMap.mapListener(eventDispatcher,ViewEvent.ENABLE_NEWCONTENT,handleNewContent,ViewEvent); 
			
			addListeners();
		}
		private function addListeners():void {
			view.trashButton.addEventListener(MouseEvent.CLICK,handleTrashClick);
			view.trashButton.addEventListener(DragEvent.DRAG_ENTER,handleTrashDragOver);
			view.trashButton.addEventListener(DragEvent.DRAG_DROP,handleTrashDragDrop);
			view.fullScreenButton.addEventListener(MouseEvent.CLICK,handleFullScreen);
			//view.addButton.addEventListener(MouseEvent.CLICK,handleAddClick);
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
			if(event.type == AppEvent.STARTUP_COMPLETE)
				view.preloader.visible = false;
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
		private function handleTrashDragOver(event:DragEvent):void {
			if(event.dragSource.hasFormat("ContentTree")) {
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
	}
}