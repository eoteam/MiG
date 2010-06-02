package org.mig.view.events
{
	import flash.events.Event;
	
	public class ContentViewEvent extends Event
	{
		public static const PUBLISH:String = "submit";
		public static const DRAFT:String = "draft";
		public static const CANCEL:String = "cancel";
		
		public function ContentViewEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}