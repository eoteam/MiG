package org.mig.events
{
	import flash.events.Event;

	public class AppEvent extends Event
	{
		public static const STARTUP:String = "startup";
		
		public static const LOGGEDIN:String = "loggedin";
		public static const LOGOUT:String = "logout";
		public static const LOGIN_ERROR:String = "loginError";
		
		public static const TIMED_OUT:String = "timedout";
		public static const CONFIG_LOADED:String = "configLoaded";
		public static const CONFIG_FILE_LOADED:String = "configFileLoaded";
		public static const INIT:String = "init";	
		
		public function AppEvent(type:String)
		{
			super(type,true,true);
		}
		override public function clone() : Event
		{
			return new AppEvent(this.type);
		}
	}
}