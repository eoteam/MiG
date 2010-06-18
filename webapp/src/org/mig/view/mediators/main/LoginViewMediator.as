package org.mig.view.mediators.main
{
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	import mx.logging.Log;
	
	import org.mig.events.AppEvent;
	import org.mig.model.AppModel;
	import org.mig.model.vo.app.StatusResult;
	import org.mig.model.vo.UpdateData;
	import org.mig.model.vo.user.UserToken;
	import org.mig.services.interfaces.IUserService;
	import org.mig.utils.LSOHandler;
	import org.mig.view.components.main.LoginView;
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
			eventMap.mapListener(eventDispatcher,AppEvent.LOGIN_ERROR,handleLoginError);
			
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
		private function handleLoginError(event:AppEvent):void {
			loginView.statusText.text = "Incorrect Login. Please Try Again."
			loginView.statusText.visible = true;
			loginView.statusText.visible = false;
		}
		private function onLogin(event:Event):void {
			userService.login(new UserToken(loginView.usernameField.text,loginView.passwordField.text));
		}
		private function onForgotInfo(event:Event):void {
			userService.sendUserInfo(loginView.emailField.text);
			userService.addHandlers(handleInfoSent);
		}
		private function onLogOut(event:Event):void {
			
		}
		private function onSaveInfo(event:Event):void {
			
		}	
		//Service notifications
		private function handleInfoSent(data:Object):void {
			var result:StatusResult = data.result as StatusResult;
			if(result.success) {
				loginView.emailField.text = '';
				loginView.stack.selectedIndex = 0;
				loginView.statusText.visible = true;
				loginView.statusText.text = "Your information has been sent to your address";
				loginView.statusText.visible = false;
			}
			else {
				loginView.statusText.visible = true;
				loginView.statusText.text = "An error occured. Please verify that you provided the correct email address";
				loginView.statusText.visible = false;
			}
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
			
			/*
			for each(var group:UserGroup in userGroups)
			{
			if(group.groupid.toString() == _data.usergroupid.toString())
			{
			_user.group = group.parentid;
			_user.privileges = UserPrivileges.translateStringToInt(group.groupname);
			break;
			}
			}   */
			//Mediator stuff


		}

	}
}