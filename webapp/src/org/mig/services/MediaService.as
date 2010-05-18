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
		public function addFile(file:Object):void {
			var date:Date = new Date();
			var time:Number = Math.round(date.time / 1000);
			var params:Object = new Object();
			params.action = "insertRecord";
			params.tablename = "media";
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
			params.path = contentModel.currentDirectory.directory + '/';
			params.width = file.width;
			params.height = file.height;
			params.verbose = true;
			//params.tags = file.tags;
			this.createService(params,ResponseType.DATA,MediaData);
		}
	}
}