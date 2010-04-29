package org.mig.events
{
	import flash.events.Event;
	
	import org.mig.model.vo.user.LoginToken;
	
	public class LoginEvent extends Event
	{
		public static const LOGIN:String = "login";
		public static const ERROR:String = "error";
		public static const FORGOT:String = "forgot";
		public static const INFO_SENT:String = "infoSent";
		
		public var token:LoginToken;
		
		public function LoginEvent(type:String,token:LoginToken)
		{
			this.token = token;
			super(type,true,true);
		}
		override public function clone() : Event
		{
			return new LoginEvent(this.type,this.token);
		}
	}
}