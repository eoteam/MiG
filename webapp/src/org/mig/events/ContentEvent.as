package org.mig.events
{
	import flash.events.Event;
	
	import org.mig.model.vo.ContentNode;

	public class ContentEvent extends Event
	{
		public static const RETRIEVE:String = "retrieve";
		public static const DELETE:String = "delete"; //
		public static const CREATE:String = "create"; //some data, config and parent ref
		public static const UPDATE:String = "update";
		
		public static const SELECT:String = "selected";
		
		public var content:ContentNode;
		public function ContentEvent(type:String,content:ContentNode)
		{
			this.content = content;
			super(type,true,true);
		}
		override public function clone() : Event
		{
			return new ContentEvent(this.type,this.content);
		}
	}
}