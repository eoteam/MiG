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
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import org.mig.controller.Constants;
	import org.mig.events.UploadEvent;
	import org.mig.events.ViewEvent;
	import org.mig.model.AppModel;
	import org.mig.model.ContentModel;
	import org.mig.model.vo.ContentNode;
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
		
		private var downloadRef:FileReference;
		
		public function FileService() {
			super();
			this.url = Constants.FILE_EXECUTE;
		}
		public function uploadFile(file:FileReference,directory:DirectoryNode):void {

			var fileDir:String = directory.directory;
		
			var extArr:Array = file.name.split('.');
			var fileExtension:String = String(extArr[extArr.length-1]).toLowerCase();
			var fileType:String = contentModel.getMimetypeString(fileExtension);
			
			file.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			file.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			file.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			
/*			file.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHttpStatus);
			file.addEventListener(Event.COMPLETE, fileUploadComplete);*/
			try {       	        	
				var newURL:String = Constants.UPLOAD_FILE + "?directory=" + directory.directory +  "&fileType=" + fileType;
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
			params.name = name;
			params.action = ValidFunctions.CREATE_DIRECTORY;
			if(params.directory == null || params.directory == "")
				params.directory = " ";	
			var service:XMLHTTPService = this.createService(params,ResponseType.DATA,MediaData);
		}
		public function getXMP(file:String):void {
			
		}
		public function getID3(file:String):void {
			
		}
		public function readDirectory(directory:DirectoryNode):void {
			var params:Object = new Object();
			params.directory = directory.directory;
			params.action = ValidFunctions.READ_DIRECTORY;
			var service:XMLHTTPService = this.createService(params,ResponseType.DATA,MediaData);
			service.token.directory = directory;
		}
		public function deleteFile(file:FileNode):void {
			var parentNode:DirectoryNode = file.parentNode as DirectoryNode;
			var params:Object = new Object();
			params.action = ValidFunctions.DELETE_FILE;
			params.file = parentNode.directory+file.baseLabel;
			if(MediaData(file.data).mimetypeid == MimeTypes.IMAGE || MediaData(file.data).mimetypeid == MimeTypes.VIDEO)
				params.removethumb = 1;
			else
				params.removethumb = 0; 
			var service:XMLHTTPService = this.createService(params,ResponseType.STATUS);
			service.token.file = file;
		}
		public function deleteDirectory(directory:DirectoryNode):void {
			var params:Object = new Object();
			params.directory = directory.directory;
			params.action = ValidFunctions.DELETE_DIRECTORY;
			var service:XMLHTTPService = this.createService(params,ResponseType.STATUS);
			service.token.directory = directory;
		}	
		public function downloadFiles(files:Array):void {
			var items:String = '';
			for each(var item:ContentNode in files) {
				if(item is FileNode)
					items += MediaData(item.data).path+item.label + ',';
				else
					items += DirectoryNode(item).directory + ',';
			}
			items = items.substr(0,items.length-1);

			var params:URLVariables = new URLVariables();
			params.action = ValidFunctions.DOWNLOAD_ZIP;
			params.files = items;
			var request:URLRequest = new URLRequest();
			request.method = URLRequestMethod.POST;
			request.data = params;
			request.url = Constants.FILE_EXECUTE;
			downloadRef = new FileReference();
			downloadRef.download(request,"archive.zip");
			downloadRef.addEventListener(ProgressEvent.PROGRESS,handleProgress);
			downloadRef.addEventListener(Event.CANCEL,handleDownloadCancel);
		}
		public function handleDownloadCancel(event:Event):void {
			eventDispatcher.dispatchEvent(new ViewEvent(ViewEvent.FILE_DOWNLOAD_CANCEL));
		}
		public function cancelDownload():void {
			downloadRef.cancel();
		}
		public function renameFile(file:FileNode,name:String):void {
			var params:Object = new Object();
			params.action = ValidFunctions.RENAME_ITEM;
			params.oldname = MediaData(file.data).path + MediaData(file.data).name;
			params.newname = MediaData(file.data).path + name;
			var service:XMLHTTPService = this.createService(params,ResponseType.STATUS);
			service.token.file = file;	
		}
		public function renameDirectory(directory:DirectoryNode,name:String):void {
			var params:Object = new Object();
			params.action = ValidFunctions.RENAME_ITEM;
			params.oldname = directory.directory;
			params.newname = DirectoryNode(directory.parentNode).directory + name + '/';
			var service:XMLHTTPService = this.createService(params,ResponseType.STATUS);
			service.token.directory = directory;	
		}
		public function moveItem(content:ContentNode,to:DirectoryNode):void {
			var params:Object = new Object();
			params.action = ValidFunctions.RENAME_ITEM;
			if(content is FileNode) {
				params.oldname = MediaData(content.data).path + MediaData(content.data).name;
				params.newname = to.directory + MediaData(content.data).name;		
			}
			else { 
				params.oldname = DirectoryNode(content).directory;
				params.newname = to.directory + DirectoryNode(content).baseLabel + '/';		
			}
			var service:XMLHTTPService = this.createService(params,ResponseType.STATUS);
			service.token.content = content;
			service.token.directory = to;
		}
		private function handleProgress(event:ProgressEvent):void {
			eventDispatcher.dispatchEvent(new ViewEvent(ViewEvent.FILE_DOWNLOAD_PROGRESS,event.bytesLoaded,event.bytesTotal));
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