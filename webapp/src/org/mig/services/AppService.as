package org.mig.services
{
	import flash.net.URLRequestMethod;
	
	import mx.rpc.Responder;
	import mx.rpc.http.HTTPService;
	
	import org.mig.model.ContentModel;
	import org.mig.model.vo.ValueObject;
	import org.mig.model.vo.app.CustomField;
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
		public function loadConfigFile(url:String):void {
			var suffix:String = (new Date()).getTime().toString();

			var service:XMLHTTPService = new XMLHTTPService(url + "?" + suffix,null,null,null);
			services.push(service);
			service.service.resultFormat = HTTPService.RESULT_FORMAT_E4X;
			service.service.method = URLRequestMethod.GET;
			service.execute();
			service.token.id = services.indexOf(service);
			//service.token.addResponder(new Responder(configfileHandler,fault));
			service.token.addResponder(new Responder(result,fault));
		}
		public function loadCustomFieldGroups():void {
			var params:Object = new  Object();
			params.action = ValidFunctions.GET_DATA;
			params.tablename = "customfieldgroups"; 
			this.createService(params,ResponseType.DATA,Object);
		}		
		public function loadCustomFields():void {
			var params:Object = new  Object();
			params.action = ValidFunctions.GET_DATA;
			params.tablename = "customfields";
			this.createService(params,ResponseType.DATA,CustomField);
		}
		public function loadColors():void {
			var params:Object = new  Object();
			params.action = ValidFunctions.GET_DATA;
			params.tablename = "colors";
			this.createService(params,ResponseType.DATA,Object);			
		}
		public function duplicateObject(vo:ValueObject,config:XML,relatedField:String,relatedTables:String):void {
			var params:Object = new  Object();
			params.action = ValidFunctions.DUPLICATE_OBJECT;
			params.id = vo.id;
			params.tablename = config.@tablename.toString();
			params.relatedField = relatedField;
			params.relatedTables = relatedTables;
			var service:XMLHTTPService = this.createService(params,ResponseType.STATUS);
			service.token.vo = vo;
		}
	}
}