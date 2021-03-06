package org.mig.services
{
	import flash.net.URLRequestMethod;
	
	import mx.rpc.Responder;
	import mx.rpc.http.HTTPService;
	
	import org.mig.model.ContentModel;
	import org.mig.model.vo.ConfigurationObject;
	import org.mig.model.vo.ContentData;
	import org.mig.model.vo.ValueObject;
	import org.mig.model.vo.app.CustomField;
	import org.mig.model.vo.manager.ManagerConfig;
	import org.mig.model.vo.manager.Term;
	import org.mig.model.vo.media.MimeType;
	import org.mig.services.interfaces.IAppService;

	public class AppService extends AbstractService implements IAppService
	{
		[Inject]
		public var contentModel:ContentModel;
		
		public function AppService() {
			super();
		}

		public function loadSettings():void {
			var params:Object = new  Object();
			params.action = ValidFunctions.GET_DATA;
			params.tablename = "settings"; 
			this.createService(params,ResponseType.DATA);
		}
		public function loadManagers():void {
			var params:Object = new  Object();
			params.action = ValidFunctions.GET_DATA;
			params.tablename = "managers"; 
			this.createService(params,ResponseType.DATA,ManagerConfig);
		}
		public function loadColors():void {
			var params:Object = new  Object();
			params.action = ValidFunctions.GET_DATA;
			params.tablename = "colors";
			this.createService(params,ResponseType.DATA,Object);			
		}
		
		public function duplicateObject(vo:ContentData,config:ConfigurationObject,relatedField:String,relatedTables:String):void {
			var params:Object = new  Object();
			params.action = ValidFunctions.DUPLICATE_OBJECT;
			params.id = vo.id;
			params.tablename = config.tablename;
			params.relatedField = relatedField;
			params.relatedTables = relatedTables;
			var service:XMLHTTPService = this.createService(params,ResponseType.STATUS);
			service.token.vo = vo;
		}
	}
}