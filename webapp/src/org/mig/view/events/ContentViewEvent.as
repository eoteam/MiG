package org.mig.view.events
{
	import flash.events.Event;
	
	public class ContentViewEvent extends Event
	{
		public static const PUBLISH:String = "submit";
		public static const DRAFT:String = "draft";
		public static const CANCEL:String = "cancel";
		public static const LOAD_CHILDREN:String = "loadChildren";
		
		public var args:Array
		public function ContentViewEvent(type:String,...args)
		{
			this.args = args;
			super(type, false, false);
		}
	}
}