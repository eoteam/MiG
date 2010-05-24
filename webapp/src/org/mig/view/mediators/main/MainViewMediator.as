package org.mig.view.mediators.main
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	import mx.utils.NameUtil;
	
	import org.mig.events.AppEvent;
	import org.mig.events.ViewEvent;
	import org.mig.model.AppModel;
	import org.mig.view.components.main.MainView;
	import org.robotlegs.mvcs.Actor;
	import org.robotlegs.mvcs.Mediator;

	public class MainViewMediator extends Mediator
	{
		[Inject]
		public var view:MainView;
		
		[Inject]
		public var appModel:AppModel;
		
		public override function onRegister():void {
			eventMap.mapListener(eventDispatcher,AppEvent.CONFIG_LOADED,handleConfig,AppEvent);
			eventMap.mapListener(eventDispatcher,AppEvent.CONFIG_FILE_LOADED,handleConfigFile,AppEvent);
			eventMap.mapListener(eventDispatcher,ViewEvent.RESIZE_MANAGER_TREE,handleManagersTreeResize,ViewEvent);
			
			addListeners();
		}
		private function addListeners():void {
			view.trashButton.addEventListener(MouseEvent.CLICK,handleTrashClick);
			view.trashButton.addEventListener(DragEvent.DRAG_ENTER,handleTrashDragOver);
			view.trashButton.addEventListener(DragEvent.DRAG_DROP,handleTrashDragDrop);
		}
		private function handleConfigFile(event:Event):void {
			MovieClip(view.mainLogo.content).play();
			view.logoFadeOut.play();
			view.bgLogoHolder.visible = true;
			view.bodyContainer.visible = true;	
			view.topLogo.visible = true;
			view.appOptionsCombo.enabled = true;
			view.helpCombo.enabled = true;
			view.appOptionsCombo.dataProvider = [appModel.publishedURL,appModel.pendingURL];
		}
		private function handleConfig(event:Event):void {
			//data wiring
			view.appOptionsCombo.prompt = appModel.prompt;
			view.appOptionsCombo.selectedIndex = -1;
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
	}
}