package org.mig.view.mediators
{
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	import mx.logging.Log;
	
	import org.mig.events.AppEvent;
	import org.mig.model.AppModel;
	import org.mig.model.vo.user.UserToken;
	import org.mig.services.interfaces.IUserService;
	import org.mig.utils.LSOHandler;
	import org.mig.view.components.LoginView;
	import org.mig.view.interfaces.ILoginView;
	import org.robotlegs.mvcs.Mediator;
	
	public class LoginViewMediator extends Mediator
	{
		[Inject]
		public var loginView:LoginView;
		
		[Inject]
		public var userService:IUserService;
		
		[Inject]
		public var appModel:AppModel;
		
		private var loginObject:Object;
		private var loginHandler:LSOHandler;
		
		private var remember:Boolean;
		private var savedUser:String ="";
		private var savedPass:String = "";
		

		override public function onRegister():void {
			eventMap.mapListener(loginView, "logIn", onLogin, Event);
			eventMap.mapListener(loginView, "logOut", onLogOut, Event);
			eventMap.mapListener(loginView, "saveInfo", onSaveInfo, Event);
			eventMap.mapListener(loginView, "forgotInfo",onForgotInfo,Event);
			
			eventMap.mapListener(eventDispatcher,AppEvent.LOGGEDIN,handleUserLoggedin);

			
			//seems that the view is already created
			loginHandler = new LSOHandler("login");
			if (loginHandler.getObject()) {
				loginObject = loginHandler.getObject();
				loginView.rememberLogin.selected = remember =  loginObject.remember;
				if(loginObject.remember) {
					loginView.usernameField.text = loginObject.username;
					loginView.passwordField.text = loginObject.password;
				}
			}
		}
		private function onLogin(event:Event):void {
			userService.login(new UserToken(loginView.usernameField.text,loginView.passwordField.text));
		}
		private function onForgotInfo(event:Event):void {
			userService.sendUserInfo(loginView.emailField.text);
		}
		private function onLogOut(event:Event):void {
			
		}
		private function onSaveInfo(event:Event):void {
			
		}
		
		//Service notifications
		private function handleInfoSent():void {
			loginView.emailField.text = '';
			loginView.stack.selectedIndex = 0;
		}
		private function handleUserLoggedin(event:AppEvent):void {
			loginView.statusText.text = "";
			loginView.prompt = "User: "+ appModel.user.toString();
			loginView.user = appModel.user;
			
			//loginView.visible = false;
			loginView.viewIndex = 2;
			var userLogin:Object;
			if(loginView.rememberLogin.selected)
				userLogin = {remember:true,id:appModel.user.id.toString(),username:appModel.user.username.toString(),password:appModel.user.password.toString()};
			else
				userLogin = {remember:false};
			loginHandler.addObject(userLogin);
			loginObject = loginHandler.getObject();
			loginView.visible = false;
		}

	}
}