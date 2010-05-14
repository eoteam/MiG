package org.mig.events
{
	import flash.events.Event;
	
	import org.mig.model.vo.ContentNode;
	import org.mig.model.vo.UpdateData;
	
	public class MediaEvent extends Event
	{
		public static const RETRIEVE_CHILDREN:String = "retrieveChildren";
		public static const RETRIEVE_VERBOSE:String = "retrieveVerbose";
		public static const ADD_CHILD_NODE:String = "addChildNode";
		
		public static const DELETE:String = "delete"; //
		public static const CREATE:String = "create"; //some data, config and parent ref
		public static const UPDATE:String = "update";
		
		public static const SELECT:String = "selected";
		public static const MULTIPLE_SELECT:String = "multipleSelect";
		
		public var content:ContentNode; //content, media or subcontainers
		public var updateData:UpdateData;
		public var child:ContentNode;
		
		public function MediaEvent(type:String,content:ContentNode,updateData:UpdateData=null,child:ContentNode=null) {
			this.content = content;
			this.updateData = updateData;
			this.child = child;
			super(type,true,true);
		}
		override public function clone() : Event {
			return new MediaEvent(this.type,this.content,this.updateData,this.child);
		}
	}
}