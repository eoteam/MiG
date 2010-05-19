	package org.mig.services
{
	import com.darronschall.serialization.ObjectTranslator;
	
	import flash.errors.IllegalOperationError;
	import flash.net.URLRequestMethod;
	import flash.utils.Dictionary;
	import flash.xml.XMLDocument;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	import mx.rpc.mxml.Concurrency;
	import mx.rpc.xml.SimpleXMLDecoder;
	
	import org.mig.controller.Constants;
	import org.mig.events.AlertEvent;
	import org.mig.model.vo.StatusResult;
	import org.mig.utils.GUID;
	import org.robotlegs.mvcs.Actor;
	
	public class AbstractService extends Actor
	{

		protected var services:Array = [];
		
		public function AbstractService() {
			super();
		}

		protected function result(event:ResultEvent):void {
			if(event.token.resultCallBack) {
				event.token.resultCallBack(event);
				delete services[event.token.index];
			}
		}
		protected function fault(info:Object):void {
			eventDispatcher.dispatchEvent(new AlertEvent( AlertEvent.SHOW_ALERT, "crap","Crap"));
		}
		protected function createService(params:Object,responseType:String,decodeClass:Class=null,
										 resultFunction:Function=null,faultFunction:Function=null,url:String=null):XMLHTTPService {
		
			var id:String = GUID.create();
			if(!url)
				url = Constants.EXECUTE;
			var service:XMLHTTPService = new XMLHTTPService(url,params,responseType,decodeClass);
			services.push(service);
			service.execute();
			service.token.id = services.indexOf(service);
			var faultHandler:Function = faultFunction==null?this.fault:faultFunction;
			var resultHandler:Function = resultFunction==null?this.result:resultFunction;
			service.token.addResponder(new Responder(resultHandler,faultHandler));
			if(resultFunction != null)
				service.token.addResponder(new Responder(result,fault));
			return service;
		}
		public function addHandlers(resultHandler:Function,faultHandler:Function=null):void {
			var service:XMLHTTPService = services[services.length-1];
			service.token.resultCallBack = resultHandler;
			service.token.faultCallBack = faultHandler;
		}
/*		protected function getService(id:String):XMLHTTPService {
			return services[id] as XMLHTTPService;
		}*/
		
	}
}