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
		
		public static const SELECT:String = "selected";
		
		public var content:ContentNode; //content, media or subcontainers
		public var updateData:UpdateData;
		
		public function ContentEvent(type:String,content:ContentNode,updateData:UpdateData=null) {
			this.content = content;
			this.updateData = updateData;
			super(type,true,true);
		}
		override public function clone() : Event
		{
			return new ContentEvent(this.type,this.content,this.updateData);
		}
	}
}