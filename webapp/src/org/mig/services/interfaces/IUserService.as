package org.mig.services.interfaces
{
	import org.mig.model.vo.user.LoginToken;
	
	public interface IUserService
	{
		
		function login(login:LoginToken):void;
		function sendUserInfo(email:String):void;
		function loadUserGroups():void;
		function loadUsers():void;
	}
}