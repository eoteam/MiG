package org.mig.view.mediators.main
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
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
		public var mainView:MainView;
		
		[Inject]
		public var appModel:AppModel;
		
		public override function onRegister():void {
			eventMap.mapListener(eventDispatcher,AppEvent.CONFIG_LOADED,handleConfig,AppEvent);
			eventMap.mapListener(eventDispatcher,AppEvent.CONFIG_FILE_LOADED,handleConfigFile,AppEvent);
			eventMap.mapListener(eventDispatcher,ViewEvent.RESIZE_MANAGER_TREE,handleManagersTreeResize,ViewEvent);
		}
		private function handleConfigFile(event:Event):void {
			MovieClip(mainView.mainLogo.content).play();
			mainView.logoFadeOut.play();
			mainView.bgLogoHolder.visible = true;
			mainView.bodyContainer.visible = true;	
			mainView.topLogo.visible = true;
			mainView.appOptionsCombo.enabled = true;
			mainView.helpCombo.enabled = true;
			mainView.appOptionsCombo.dataProvider = [appModel.publishedURL,appModel.pendingURL];
		}
		private function handleConfig(event:Event):void {
			//data wiring
			mainView.appOptionsCombo.prompt = appModel.prompt;
			mainView.appOptionsCombo.selectedIndex = -1;
		}
		
		private function handleManagersTreeResize(event:ViewEvent):void {
			mainView.openManagers.heightTo = event.args[0] as Number;
			mainView.openManagers.play();
		}
	}
}