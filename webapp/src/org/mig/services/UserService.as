	package org.mig.services
{
	
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.xml.XMLDocument;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.Responder;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	import mx.rpc.xml.SimpleXMLDecoder;
	
	import org.mig.controller.Constants;
	import org.mig.events.AlertEvent;
	import org.mig.events.AppEvent;
	import org.mig.model.AppModel;
	import org.mig.model.vo.UpdateData;
	import org.mig.model.vo.user.User;
	import org.mig.model.vo.user.UserGroup;
	import org.mig.model.vo.user.UserToken;
	import org.mig.services.interfaces.IUserService;
	import org.robotlegs.mvcs.Actor;

	//XMLHTTP
	public class UserService extends AbstractService implements IUserService
	{
		[Inject]
		public var appModel:AppModel;
		
		public function login(value:UserToken):void {
			var params:Object = new Object();
			params.username = value.username;
			params.password = value.password;
			params.action = "validateUser";	
			this.createService(params,ResponseType.DATA,User,handleLogin);
		}
		public function loadUsers():void {
			
		}
		public function sendUserInfo(email:String):void {
			var params:Object = new Object();
			params.action = "sendUserInformation";
			params.email =  email;
			this.createService(params,ResponseType.STATUS);
		}
		public function loadUserGroups():void {
			var params:Object = new Object();
			params.action = "getData";
			params.tablename = "usergroups";
			this.createService(params,ResponseType.DATA,UserGroup,handleUserGroups);
		}	
		public function saveUserInfo(token:UserToken):void {
			
		}
		private function handleLogin(data:ResultEvent):void {	
			var results:Array = data.result as Array;
			if(results.length > 0) {
				appModel.user = results[0];
				eventDispatcher.dispatchEvent(new AppEvent(AppEvent.LOGGEDIN));		
				//update last login
				var today:Date = new Date();
				var params:Object = new Object();
				params.lastlogin = Math.round(today.time/1000).toString();
				params.action = "updateRecord";
				params.tablename = "user";
				params.id = appModel.user.id;
				this.createService(params,ResponseType.STATUS)
			}
			else
				eventDispatcher.dispatchEvent(new AppEvent(AppEvent.LOGIN_ERROR));
		}
		private function handleUserGroups(data:ResultEvent):void {
			
		}
		private function handleRequestSent(data:ResultEvent):void {
			
		}
	}
}