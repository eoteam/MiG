package org.mig.events
{
	import flash.events.Event;
	
	public class UploadEvent extends Event
	{

		public static const UPLOAD:String = "uploadFiles";
		public static const CANCEL:String = "cancelUpload";
		public static const ADD:String = "addFiles";
		
		public static const FILE_PROGRESS:String = "fileProgress";
		//public static const FILE_COMPLETE
		public var files:Array;
		//public var status
		public function UploadEvent(type:String,files:Array)
		{
			this.files = files;
			super(type, true, true);
		}
		override public function clone() : Event
		{
			return new UploadEvent(this.type,this.files);
		}
	}
}