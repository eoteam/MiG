package org.mig.services
{
	import org.mig.controller.Constants;
	import org.mig.model.AppModel;
	import org.mig.model.ContentModel;
	import org.mig.model.vo.ContentNode;
	import org.mig.model.vo.media.DirectoryNode;
	import org.mig.model.vo.media.MediaData;
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
			params.action = content.config.@action.toString();
			params.tablename = content.config.@tablename;
			params.path = content.directory+'/';
			var service:XMLHTTPService = this.createService(params,ResponseType.DATA,MediaData);
			service.token.content = content;
		}
		public function addFolder(name:String):void {
			var content:DirectoryNode = contentModel.currentDirectory;
			var params:Object = new Object();
			params.directory = content.directory;
			params.rootDir = appModel.fileDir;
			params.folderName = name;
			if(params.directory == null || params.directory == "")
				params.directory = " ";	
			var service:XMLHTTPService = this.createService(params,ResponseType.DATA,MediaData,null,null,Constants.CREATE_DIR);
		
		}
	}
}