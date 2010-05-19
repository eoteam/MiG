package org.mig.events
{
	import flash.events.Event;
	
	import org.mig.model.vo.ContentNode;
	import org.mig.model.vo.UpdateData;
	
	public class MediaEvent extends Event
	{
		public static const RETRIEVE_CHILDREN:String = "retrieveChildren";
		public static const RETRIEVE_VERBOSE:String = "retrieveVerbose";
		public static const ADD_DIRECTORY:String = "addDirectory"; //add folders, move files around?
		public static const ADD_FILE:String = "addFile";
		
		public static const DELETE:String = "delete"; //
		public static const CREATE:String = "create"; //some data, config and parent ref
		public static const UPDATE:String = "update";
		
		public static const SELECT:String = "selected";
		public static const MULTIPLE_SELECT:String = "multipleSelect";
	
		
		public var args:Array;
		
		public function MediaEvent(type:String,...args) {
			this.args = args;
			super(type,true,true);
		}
		override public function clone() : Event {
			return new MediaEvent(this.type,this.args);
		}
	}
}