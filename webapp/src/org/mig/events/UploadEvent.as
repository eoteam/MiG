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
		public var progress:Number;
		public var status:String;
		//public var status
		public function UploadEvent(type:String,files:Array=null,progress:Number=NaN,status:String=null)
		{
			this.files = files;
			this.progress = progress;
			this.status = status;
			super(type, true, true);
		}
		override public function clone() : Event
		{
			return new UploadEvent(this.type,this.files,this.progress,this.status);
		}
	}
}