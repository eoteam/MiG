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
	import org.mig.events.LoginEvent;
	import org.mig.model.AppModel;
	import org.mig.model.vo.user.LoginToken;
	import org.mig.model.vo.user.User;
	import org.mig.model.vo.user.UserGroup;
	import org.mig.services.interfaces.IUserService;
	import org.robotlegs.mvcs.Actor;

	//XMLHTTP
	public class UserService extends AbstractXMLHTTPService implements IUserService
	{
		[Inject]
		public var appModel:AppModel;
		
		public function UserService()
		{
			
		}
		public function login(value:LoginToken):void {
			var params:Object = new Object();
			params.username = value.name;
			params.password = value.password;
			params.action = "validateUser";			
			this.createService(params,Constants.EXECUTE,handleLogin,ResponseType.DATA,User);
		}
		private function handleLogin(results:Array,token:AsyncToken):void {	
			if(results.length > 0)
			{
				appModel.user = results[0];
				eventDispatcher.dispatchEvent(new AppEvent(AppEvent.LOGGEDIN));
				
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
				
				
				/*				var today:Date = new Date();
				var op:XmlHttpOperation = new XmlHttpOperation(Constants.EXECUTE);
				var params:Object = new Object();
				params.lastlogin = today.time;
				params.action = "updateRecord";
				params.tablename = "user";
				params.id = _data.id.toString();
				op.params = params;	
				//_operation.addEventListener(Event.COMPLETE, handleLoginComplete);
				op.addEventListener(ErrorEvent.ERROR, handleError);
				op.execute();*/				  	
			}
			else
			{
				//statusText.text = "Incorrect Login. Please Try Again."
			}
			//currentstate = "LOGGEDIN";*/
		}
		public function loadUserGroups():void {
			var params:Object = new Object();
			params.action = "getData";
			params.tablename = "usergroups";
			
			this.createService(params,Constants.EXECUTE,handleUserGroups,ResponseType.DATA,UserGroup);
		}
		private function handleUserGroups(results:Array):void {

		}	
		
		public function loadUsers():void {
			
		}
		public function sendUserInfo(email:String):void {
			var params:Object = new Object();
			params.action = "sendUserInformation";
			params.email =  email;
			this.createService(params,Constants.EXECUTE,handleRequestComplete,ResponseType.STATUS);
		}
		private function handleRequestComplete(data:Object,token:AsyncToken):void {
			eventDispatcher.dispatchEvent(new LoginEvent(LoginEvent.INFO_SENT,null));
		}
	}
}