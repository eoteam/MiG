package org.mig.services
{
	import org.mig.controller.Constants;
	import org.mig.model.AppModel;
	import org.mig.model.vo.ContentNode;
	import org.mig.model.vo.media.MediaCategoryNode;
	import org.mig.model.vo.media.MediaData;
	import org.mig.services.interfaces.IMediaService;

	public class MediaService extends AbstractXMLHTTPService implements IMediaService
	{
		[Inject]
		public var appModel:AppModel;
		
		public function MediaService() {
			super();
		}	
		public function retrieveChildrenFromDisk(content:MediaCategoryNode):void {
			var params:Object = new Object();
			params.mapping = content.directory;
			service.url = Constants.GETMEDIACONTENT;
			this.createService(params,ResponseType.DATA,MediaData);
			token.content = content;
		}
		public function retrieveChildrenFromDatabase(content:MediaCategoryNode):void {
			var params:Object = new Object();
			params.action = content.config.@action.toString();
			service.url = Constants.EXECUTE;
			params.verbosity = 1;
			params.include_unused=1;
			params.path = content.directory;
			this.createService(params,ResponseType.DATA,MediaData);
			token.content = content;
		}
	}
}