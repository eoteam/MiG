package org.mig.events
{
	import flash.events.Event;
	

	public class UploadEvent extends Event
	{

		public static const UPLOAD:String = "uploadFiles";
		public static const FILE_START:String = "fileStart";
		public static const FILE_END:String = "fileEnd";
		public static const CANCEL:String = "cancelUpload";		
		public static const PROGRESS:String = "uploadProgress";
		public static const COMPLETE:String = "uploadComplete";
		public static const ERROR:String = "uploadError";
		
		public var args:Array;
		
		public function UploadEvent(type:String,...args) {
			this.args = args;
			super(type, true, true);
		}
		override public function clone() : Event {
			return new UploadEvent(this.type,this.args);
		}
	}
}