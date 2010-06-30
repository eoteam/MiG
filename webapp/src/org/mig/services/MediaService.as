package org.mig.services
{
	import org.mig.controller.Constants;
	import org.mig.model.AppModel;
	import org.mig.model.ContentModel;
	import org.mig.model.vo.ContentNode;
	import org.mig.model.vo.UpdateData;
	import org.mig.model.vo.app.StatusResult;
	import org.mig.model.vo.media.DirectoryNode;
	import org.mig.model.vo.media.FileNode;
	import org.mig.model.vo.media.MediaData;
	import org.mig.model.vo.media.MimeTypes;
	import org.mig.services.interfaces.IMediaService;

	public class MediaService extends AbstractService implements IMediaService
	{
		[Inject]
		public var appModel:AppModel;
		
		[Inject]
		public var contentModel:ContentModel;
		
		public function MediaService() {
			super();
		}	
		public function retrieveChildren(content:DirectoryNode):void {
			var params:Object = new Object();
			params.action = content.config.@retrieveContent.toString();
			params.tablename = content.config.@tablename;
			params.path = content.directory;
			var service:XMLHTTPService = this.createService(params,ResponseType.DATA,MediaData);
			service.token.content = content;
		}
		public function addFile(file:Object,directory:DirectoryNode):void {
			var date:Date = new Date();
			var time:Number = Math.round(date.time / 1000);
			var params:Object = new Object();
			params.action = directory.config.@createContent;
			params.tablename = directory.config.@tablename;
			params.name = file.name;
			params.extension = file.extension;
			params.size = file.size;
			params.thumb = file.thumb;
			params.video_proxy = file.video_proxy;
			params.playtime = file.playtime;			
			params.createdby = appModel.user.id;
			params.createdate = time;
			params.createdby = appModel.user.id;
			params.modifieddate = time;
			params.modifiedby = appModel.user.id;
			params.mimetypeid = contentModel.getMimetypeId(file.extension);
			params.path = directory.directory ;
			params.width = file.width;
			params.height = file.height;
			params.verbose = true;
			//params.tags = file.tags;
			this.createService(params,ResponseType.DATA,MediaData);
		}
		public function createDirectory(media:MediaData):void {
			var date:Date = new Date();
			var time:Number = Math.round(date.time / 1000);
			var params:Object = new Object();
			params.action = contentModel.currentDirectory.config.@createContent.toString();
			params.tablename = "media";
			params.name = media.name;
			params.path = contentModel.currentDirectory.directory;
			params.createdby = appModel.user.id;
			params.modifiedby = appModel.user.id;
			params.createdate = time;
			params.modifieddate = time;
			params.mimetypeid = MimeTypes.DIRECTORY;
			var service:XMLHTTPService = this.createService(params,ResponseType.STATUS);
			service.token.media = media;
		}
		public function deleteDirectory(directory:DirectoryNode):void {
			var params:Object = new Object();
			params.action = directory.config.@deleteDirectory;
			params.path = '/'+MediaData(directory.data).name + '/';
			var service:XMLHTTPService = this.createService(params,ResponseType.STATUS);
			service.token.directory = directory;
		}
		public function deleteFile(file:FileNode):void {
			var params:Object = new Object();
			params.action = file.config.@deleteFile;
			params.tablename = file.config.@tablename;
			params.id = file.data.id;
			var service:XMLHTTPService = this.createService(params,ResponseType.STATUS);
			service.token.file = file;	
		}
		public function updateFile(file:FileNode,update:UpdateData):void {
			var params:Object = new Object();
			params.action = file.config.@updateContent;
			params.tablename = file.config.@tablename;
			for (var prop:String in update) {
				params[prop] = update[prop];
			}
			var service:XMLHTTPService = this.createService(params,ResponseType.STATUS,null,handleFileUpdated);
			service.token.file = file;	
			service.token.update = update;
		}
		public function updateDirectory(directory:DirectoryNode,name:String):void {
			var params:Object = new Object();
			params.action = directory.config.@updateDirectory;
			params.oldpath = directory.baseLabel;
			params.newpath = name;
			var service:XMLHTTPService = this.createService(params,ResponseType.STATUS);
			service.token.directory = directory;	
		}
		public function updateFilesByDirectory(directory:DirectoryNode,newdir:String):void {
			var params:Object = new Object();
			params.action = directory.config.@updateDirectory;
			params.oldpath = directory.directory;
			params.newpath = newdir;
			var service:XMLHTTPService = this.createService(params,ResponseType.STATUS);
			service.token.directory = directory;
		}
		private function handleFileUpdated(data:Object):void {
			var status:StatusResult = data.result as StatusResult;
			if(status.success) {
				var file:FileNode = data.token.file as FileNode;
				var update:UpdateData = data.token.update as UpdateData;
				for (var prop:String in update)
					file.data[prop] = update[prop];
			}	
		}
		
	}
}