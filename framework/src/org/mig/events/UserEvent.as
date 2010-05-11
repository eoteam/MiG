package org.mig.events
{
	import flash.events.Event;
	
	import org.mig.model.vo.user.UserToken;
	
	public class UserEvent extends Event
	{
		public static const LOGIN:String = "login";
		public static const ERROR:String = "error";
		public static const FORGOT:String = "forgot";
		public static const INFO_SENT:String = "infoSent";
		public static const UPDATE:String = "updateUserInfo";
		public static const UPDATE_COMPLETE:String = "updatedUserInfo";
		
		public var token:UserToken;
		
		public function UserEvent(type:String,token:UserToken)
		{
			this.token = token;
			super(type,true,true);
		}
		override public function clone() : Event
		{
			return new UserEvent(this.type,this.token);
		}
	}
}