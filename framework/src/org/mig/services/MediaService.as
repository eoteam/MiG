package org.mig.services
{
	import org.mig.controller.Constants;
	import org.mig.model.AppModel;
	import org.mig.model.vo.ContentNode;
	import org.mig.model.vo.media.MediaCategoryNode;
	import org.mig.model.vo.media.MediaData;
	import org.mig.services.interfaces.IMediaService;

	public class MediaService extends AbstractService implements IMediaService
	{
		[Inject]
		public var appModel:AppModel;
		
		public function MediaService() {
			super();
		}	
		public function retrieveChildrenFromDisk(content:MediaCategoryNode):void {
			var params:Object = new Object();
			params.mapping = appModel.fileDir+content.directory;
			var service:XMLHTTPService = this.createService(params,ResponseType.DATA,MediaData,null,null,Constants.GETMEDIACONTENT);
			service.token.content = content;
		}
		public function retrieveChildrenFromDatabase(content:MediaCategoryNode):void {
			var params:Object = new Object();
			params.action = content.config.@action.toString();
			params.verbosity = 1;
			params.include_unused=1;
			params.path = content.directory+'/';
			var service:XMLHTTPService = this.createService(params,ResponseType.DATA,MediaData);
			service.token.content = content;
		}
	}
}