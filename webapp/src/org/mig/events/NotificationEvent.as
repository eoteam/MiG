package org.mig.events
{
	import flash.events.DataEvent;
	import flash.events.Event;
	
	public class NotificationEvent extends DataEvent
	{
		public static const NOTIFY:String = "notify";
		
		public function NotificationEvent(type:String, message:String)
		{
			super(type, true, true,message);
		}
		override public function clone() : Event
		{
			return new NotificationEvent(this.type,this.data);
		}
	}
}