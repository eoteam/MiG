package org.mig.events
{
	import flash.events.Event;
	
	public class ViewEvent extends Event
	{
		public static const RESIZE_MANAGER_TREE:String = "resizeManagerTree";
		public static const MANAGER_SELECTED:String = "managerSelected";
		public static const REFRESH_MEDIA:String = "refreshMedia";
		public var args:Array;
		
		public function ViewEvent(type:String,...args)
		{
			this.args = args;
			super(type, true, true);
		}
		override public function clone() : Event
		{
			return new ViewEvent(this.type,this.args);
		}
	}
}