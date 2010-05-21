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
	import org.mig.model.vo.media.FileNode;
	import org.mig.model.vo.media.MediaData;
	import org.mig.model.vo.media.MimeTypes;
	import org.mig.services.interfaces.IFileService;
	import org.robotlegs.mvcs.Actor;

	public class FileService extends AbstractService implements IFileService 
	{

		[Inject]
		public var appModel:AppModel;
		
		[Inject]
		public var contentModel:ContentModel;
		
		public function uploadFile(file:FileReference,directory:DirectoryNode):void {

			var fileDir:String = appModel.fileDir + directory.directory;
			var thumbDir:String = appModel.thumbDir + directory.directory;
			
			var extArr:Array = file.name.split('.');
			var fileExtension:String = String(extArr[extArr.length-1]).toLowerCase();
			var fileType:String = contentModel.getMimetypeString(fileExtension);
			
			file.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			file.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			file.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			
/*			file.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHttpStatus);
			file.addEventListener(Event.COMPLETE, fileUploadComplete);*/
			try  
			{       	        	
				var newURL:String = Constants.UPLOAD_FILE + "?directory=" + fileDir + "/&thumbsDir=" + thumbDir + "/&fileType=" + fileType;
				var uploadURL:URLRequest = new URLRequest(newURL);
				file.upload(uploadURL, "Filedata")
			}  
			catch (error:Error) {  
				
			} 
		}	
		public function addDirectory(name:String):void {
			var content:DirectoryNode = contentModel.currentDirectory;
			var params:Object = new Object();
			params.directory = content.directory;
			params.rootDir = appModel.fileDir;
			params.folderName = name;
			if(params.directory == null || params.directory == "")
				params.directory = " ";	
			var service:XMLHTTPService = this.createService(params,ResponseType.DATA,MediaData,null,null,Constants.CREATE_DIR);
			
		}
		public function getXMP(file:String):void {
			
		}
		
		public function getID3(file:String):void {
			
		}
		public function readDirectory(directory:DirectoryNode):void {
			var params:Object = new Object();
			params.mapping = appModel.fileDir+directory.directory;
			var service:XMLHTTPService = this.createService(params,ResponseType.DATA,MediaData,null,null,Constants.GETMEDIACONTENT);
			service.token.directory = directory;
		}
		public function deleteFile(file:FileNode):void {
			var parentNode:DirectoryNode = file.parentNode as DirectoryNode;
			var params:Object = new Object();
			params.directory = appModel.fileDir
			params.folderName = parentNode.directory;
			params.fileName = file.baseLabel;
			if(MediaData(file.data).mimetypeid == MimeTypes.IMAGE || MediaData(file.data).mimetypeid == MimeTypes.VIDEO)
				params.removethumb = 1;
			else
				params.removethumb = 0; 
			var service:XMLHTTPService = this.createService(params,ResponseType.STATUS,null,null,null,Constants.REMOVE_FILE);
			service.token.file = file;
		}
		public function deleteDirectory(directory:DirectoryNode):void {
			var params:Object = new Object();
			params.directory = directory.directory;
			params.rootDir = appModel.fileDir;
			var service:XMLHTTPService = this.createService(params,ResponseType.STATUS,Object,null,null,Constants.REMOVE_DIR);
			service.token.directory = directory;
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
			/*var newError:String = "securityErrorHandler: " + event
			var percentLoaded:Number = 0;
			this.uploadProgress = 0;
			this.currentFileIndex++;
			if(this.currentFileIndex<this.selectedFiles.length)
			uploadNextFile(this.currentFileIndex);*/
		}
		private function progressHandler(event:ProgressEvent):void {
			var progress:Number = event.bytesLoaded/event.bytesTotal;
			var progressString:String = (progress*100).toString()+'% Complete';
			trace("Upload Progress\t",progress,"\n=====================");
			eventDispatcher.dispatchEvent(new UploadEvent(UploadEvent.PROGRESS,progress,progressString));
		}
		/*private function fileUploadComplete(event:Event):void {	
		trace("Upload Complete");
		}
		private function handleHttpStatus(event:HTTPStatusEvent):void {
		trace("Upload HTTPStatus\n",event.status,"\n=====================");
		}*/		
	}
}