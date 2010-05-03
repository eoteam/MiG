package org.mig.services
{
	import com.darronschall.serialization.ObjectTranslator;
	
	import flash.net.URLRequestMethod;
	import flash.xml.XMLDocument;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	import mx.rpc.xml.SimpleXMLDecoder;
	
	import org.mig.controller.Constants;
	import org.mig.events.AppEvent;
	import org.mig.events.ContentEvent;
	import org.mig.model.AppModel;
	import org.mig.model.ContentModel;
	import org.mig.model.vo.content.ContainerNode;
	import org.mig.services.interfaces.IAppService;
	import org.robotlegs.mvcs.Actor;

	public class AppService extends AbstractXMLHTTPService implements IAppService
	{
		[Inject]
		public var appModel:AppModel;
		
		[Inject]
		public var contentModel:ContentModel;
		
		public function AppService() {
		}
		public function loadConfig():void {
			var params:Object = new Object();
			params.action = "getData";
			params.tablename = "config";
			this.createService(params,configHandler);
		}
		public function loadConfigFile(url:String):void {
			var service:HTTPService = new HTTPService();
			service.url = url;
			service.resultFormat = HTTPService.RESULT_FORMAT_E4X;
			var token:AsyncToken = service.send();
			token.addResponder( new Responder(configfileHandler, fault));
		}
		private function configHandler(data:ResultEvent):void {
			var results:Array = decodeResults(new XMLDocument(data.result.toString()),Object);
			for each(var item:Object in results) {
				switch(item.name) {
					case "prompt":
						appModel.prompt = item.value;
					break;
					case "configfile":
						appModel.configfile = item.value;
					break;
					default:
						appModel.managers.push(item);
					break
				}
			}
			loadConfigFile(appModel.configfile);
		}
		private function configfileHandler(event:ResultEvent):void {
			var config:XML = event.result as XML;
			appModel.config = config;
			eventDispatcher.dispatchEvent(new AppEvent(AppEvent.CONFIG_LOADED));
		}

	}
}