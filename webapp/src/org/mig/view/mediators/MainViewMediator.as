package org.mig.view.mediators
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import org.mig.events.AppEvent;
	import org.mig.model.AppModel;
	import org.mig.view.components.MainView;
	import org.robotlegs.mvcs.Actor;
	import org.robotlegs.mvcs.Mediator;

	public class MainViewMediator extends Mediator
	{
		[Inject]
		public var mainView:MainView;
		
		[Inject]
		public var appModel:AppModel;
		
		public override function onRegister():void {
			eventMap.mapListener(eventDispatcher,AppEvent.LOGGEDIN,handleLoggedIn,AppEvent);
		}
		private function handleLoggedIn(event:Event):void {
			MovieClip(mainView.mainLogo.content).play();
			mainView.logoFadeOut.play();
			mainView.bgLogoHolder.visible = true;
			mainView.bodyContainer.visible = true;	
			mainView.topLogo.visible = true;
			mainView.appOptionsCombo.enabled = true;
			mainView.helpCombo.enabled = true;
			
			//data wiring
			mainView.appOptionsCombo.prompt = appModel.prompt;
			mainView.appOptionsCombo.dataProvider = [appModel.publishedURL,appModel.pendingURL];
		}
	}
}