package org.mig.events
{
	import flash.events.Event;
	
	import org.mig.model.vo.UpdateData;
	import org.mig.model.vo.ContentNode;

	public class ContentEvent extends Event
	{
		public static const RETRIEVE_CHILDREN:String = "retrieveChildren";
		public static const RETRIEVE_VERBOSE:String = "retrieveVerbose";
		public static const DELETE:String = "delete"; //
		public static const CREATE:String = "create"; //some data, config and parent ref
		public static const UPDATE:String = "update";
		public static const DUPLICATE:String = "duplicate";
		public static const SELECT:String = "selected";
		
		public var args:Array;
		
		public function ContentEvent(type:String,...args) {
			this.args = args;
			super(type,true,true);
		}
		override public function clone() : Event {
			return new ContentEvent(this.type);
		}
	}
}