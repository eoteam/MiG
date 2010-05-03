package org.mig.services.interfaces
{
	import org.mig.model.vo.user.User;
	import org.mig.model.vo.user.UserToken;
	
	public interface IUserService extends IService
	{
		
		function login(login:UserToken):void;
		
		function sendUserInfo(email:String):void;
		
		function saveUserInfo(token:UserToken):void;
		
		function loadUserGroups():void;
		function loadUsers():void;
	}
}