package org.mig.services
{
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	
	import org.mig.controller.Constants;
	import org.mig.events.UploadEvent;
	import org.mig.model.AppModel;
	import org.mig.model.ContentModel;
	import org.mig.model.vo.media.DirectoryNode;
	import org.mig.model.vo.media.MediaData;
	import org.mig.services.interfaces.IFileService;
	import org.robotlegs.mvcs.Actor;

	public class FileService extends AbstractService implements IFileService 
	{

		[Inject]
		public var appModel:AppModel;
		
		[Inject]
		public var contentModel:ContentModel;
		
		public function uploadFile(file:FileReference):void {

			var fileDir:String = appModel.fileDir + contentModel.currentDirectory.directory;
			var thumbDir:String = appModel.thumbDir+ contentModel.currentDirectory.directory;
			
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
		
		public function addFile(file:Object):void {
			
		}
		
		public function getXMP(file:String):void {
			
		}
		
		public function getID3(file:String):void {
			
		}
		public function readDirectory(directory:DirectoryNode):void {
			var params:Object = new Object();
			params.mapping = appModel.fileDir+directory.directory;
			var service:XMLHTTPService = this.createService(params,ResponseType.DATA,MediaData,null,null,Constants.GETMEDIACONTENT);
			service.token.content = directory;
		}
		public function deleteFile(file:String):void {
			
		}
		
		public function deleteDirectory(directory:DirectoryNode):void {
			
		}
		private function fileUploadComplete(event:Event):void {	
			
		}
		private function handleHttpStatus(event:HTTPStatusEvent):void {
			trace("Upload HTTPStatus\n",event.status,"\n=====================");
		}				
		private function ioErrorHandler(event:IOErrorEvent):void {
			/*var newError:String = "ioErrorHandler: " + event
			
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
			var result:XML = XML(event.data);
			trace("Upload Complete\t",result,"\n=====================");
		}
		private function progressHandler(event:ProgressEvent):void {
			var progress:Number = event.bytesLoaded/event.bytesTotal;
			var progressString:String = progress.toString()+'%';
			trace("Upload Progress\t",progress,"\n=====================");
			eventDispatcher.dispatchEvent(new UploadEvent(UploadEvent.FILE_PROGRESS,null,progress,progressString));
			/*			var newError:String = Number(event.bytesLoaded/event.bytesTotal).toString();
			generateErrorOutput(newError);

			var percentLoaded:Number = event.bytesLoaded/event.bytesTotal;
			this.uploadProgress = percentLoaded;*/
		}		
	}
}