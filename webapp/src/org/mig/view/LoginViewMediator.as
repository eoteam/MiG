package org.mig.view
{
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	import mx.logging.Log;
	
	import org.mig.events.AppEvent;
	import org.mig.events.LoginEvent;
	import org.mig.model.AppModel;
	import org.mig.model.vo.user.LoginToken;
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
			eventMap.mapListener(loginView, LoginEvent.LOGIN, onLogin, LoginEvent);
			eventMap.mapListener(loginView,"forgotInfo",handleForgotInfo,Event);
			
			eventMap.mapListener(eventDispatcher,AppEvent.LOGGEDIN,handleUserLoggedin);
			eventMap.mapListener(eventDispatcher,LoginEvent.INFO_SENT,handleInfoSent);
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
		private function onLogin(event:LoginEvent):void {
			userService.login(event.token);
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
		}
		private function handleForgotInfo(event:Event):void {
			eventDispatcher.dispatchEvent(new LoginEvent(LoginEvent.FORGOT,new LoginToken('','',loginView.emailField.text)));
		}
		private function handleInfoSent(event:Event):void {
			loginView.emailField.text = '';
			loginView.stack.selectedIndex = 0;
		}
	}
}