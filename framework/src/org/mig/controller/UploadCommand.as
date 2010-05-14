package org.mig.controller
{
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	
	import org.mig.events.UploadEvent;
	import org.mig.model.AppModel;
	import org.mig.model.ContentModel;
	import org.robotlegs.mvcs.Command;
	
	public class UploadCommand extends Command
	{
		[Inject]
		public var event:UploadEvent;
		
		[Inject]
		public var appModel:AppModel;
		
		[Inject]
		public var contentModel:ContentModel;
		
		private var files:Array;
		private var index:int;
		
		override public function execute():void {
			files = event.files;
			index = 0;
			switch(event.type) {
				case UploadEvent.UPLOAD:
					uploadFile(0);
				break;
			}
		}
		
		private function uploadFile(index:int):void {
		
			var file:FileReference = files[index];
			var fileDir:String = appModel.fileDir + "/" + contentModel.currentDirectory.directory;
			var thumbDir:String = appModel.thumbDir+ "/" + contentModel.currentDirectory.directory;
		
			var extArr:Array = file.name.split('.');
			var fileExtension:String = String(extArr[extArr.length-1]).toLowerCase();
			var fileType:String = contentModel.getMimetypeByExtension(fileExtension);
			
			file.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			file.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHttpStatus);
			file.addEventListener(Event.COMPLETE, fileUploadComplete);
			file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, uploadCompleteDataHandler);
			file.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			file.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			try  
			{       	        	
				var newURL:String = Constants.UPLOAD_FILE + "?directory=" + fileDir + "/&thumbsDir=" + thumbDir + "/&fileType=" + fileType;
				var uploadURL:URLRequest = new URLRequest(newURL);
				file.upload(uploadURL, "Filedata")
			}  
			catch (error:Error) {  
			
			} 
		}
		private function fileUploadComplete(event:Event):void {	
			
		}
		private function handleHttpStatus(event:HTTPStatusEvent):void {
			//trace("HTTP STATUS EVENT");
		}				
		private function ioErrorHandler(event:IOErrorEvent):void {
/*			var newError:String = "ioErrorHandler: " + event
			
			var percentLoaded:Number = 0;
			this.uploadProgress = 0;
			this.currentFileIndex++;
			if(this.currentFileIndex<this.selectedFiles.length)
				uploadNextFile(this.currentFileIndex);*/
		}        
		private function securityErrorHandler(event:SecurityErrorEvent):void  {
/*			var newError:String = "securityErrorHandler: " + event
			var percentLoaded:Number = 0;
			this.uploadProgress = 0;
			this.currentFileIndex++;
			if(this.currentFileIndex<this.selectedFiles.length)
				uploadNextFile(this.currentFileIndex);*/
		}
		private function uploadCompleteDataHandler(event:DataEvent):void {
/*			this.uploadProgress = 1; 		
			var file:FileReference = event.target as FileReference;
			var d:XML = XML(event.data);
			resumeFileUploadComplete(d.filename.toString(),d.thumb.toString(),d.video_proxy.toString());*/
			index++;
			if(index == files.length) {
				
			}
			else
				uploadFile(index);
			
		}
		private function progressHandler(event:ProgressEvent):void {
/*			var newError:String = Number(event.bytesLoaded/event.bytesTotal).toString();
			generateErrorOutput(newError);
			this.bytesLoaded = event.bytesLoaded;
			this.bytesTotal = event.bytesTotal;
			var percentLoaded:Number = event.bytesLoaded/event.bytesTotal;
			this.uploadProgress = percentLoaded;*/
		}		
		
	}
}