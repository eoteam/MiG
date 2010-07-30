package org.mig.view.events
{
	import flash.events.Event;
	
	public class UIEvent extends Event
	{
		public static const SELECT:String = "select";
		public var data:Object;
		
		public function UIEvent(type:String, mydata:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			data = mydata;
		}
	}
}