package org.mig.controller
{
	import org.mig.events.LoginEvent;
	import org.mig.services.interfaces.IUserService;
	import org.robotlegs.mvcs.Command;

	public class LoginCommand extends Command
	{
		[Inject]
		public var event:LoginEvent;
		
		[Inject]
		public var service:IUserService;
		
		
		override public function execute():void
		{
			switch(event.type) {
			
			case LoginEvent.LOGIN:
				service.login(event.token);
			break;	
			
			case LoginEvent.FORGOT:
				service.sendUserInfo(event.token.email);
			break;
			
			}
		}
	}
}