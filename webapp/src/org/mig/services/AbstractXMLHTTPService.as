package org.mig.services
{
	import com.darronschall.serialization.ObjectTranslator;
	
	import flash.errors.IllegalOperationError;
	import flash.net.URLRequestMethod;
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
	import org.robotlegs.mvcs.Actor;
	
	public class AbstractXMLHTTPService extends Actor
	{
		protected var service:HTTPService;
		protected var token:AsyncToken;
		protected var decodeClass:Class = Object;
		
		public function AbstractXMLHTTPService() {
			super();
			service = new HTTPService();
			service.method = URLRequestMethod.POST;
			service.url = Constants.EXECUTE;
			service.resultFormat = HTTPService.RESULT_FORMAT_OBJECT;
			service.concurrency = Concurrency.MULTIPLE;
		}
		protected function decodeData(xml:XMLDocument):Array {
			var children:Array = [];
			var xmlDecoder:SimpleXMLDecoder = new SimpleXMLDecoder();
			if (xml.firstChild.childNodes.length > 0) {
				var objectTree:Object = xmlDecoder.decodeXML(xml.firstChild);
				var results:Array;
				
				if (objectTree.result is Array) 
					results = objectTree.result;
				else if(objectTree.result is Object)
					results = [objectTree.result];
				for (var i:int=0; i < results.length; i++) { 
					var item:Object = ObjectTranslator.objectToInstance(results[i], decodeClass);
					children.push(item);
				}
			}
			return children;
		}
		protected function decodeStatus(xml:XMLDocument):StatusResult {
			var children:Array = [];
			var xmlDecoder:SimpleXMLDecoder = new SimpleXMLDecoder();
			if (xml.firstChild.childNodes.length > 0) {
				var objectTree:Object = xmlDecoder.decodeXML(xml.firstChild);
				var result:StatusResult = new StatusResult();
				for(var prop:String in objectTree)
					result[prop] = objectTree[prop];
			}
			return result;
		}
		protected function result(event:ResultEvent):void {
			if(event.token.resultCallBack) {
				trace("RESULT handler now!");
				event.token.resultCallBack(event);
			}
		}
		protected function fault(info:Object):void {
			eventDispatcher.dispatchEvent(new AlertEvent( AlertEvent.SHOW_ALERT, "crap","Crap"));
		}
		protected function createService(params:Object,responseType:String,decodeClass:Class=null,resultFunction:Function=null,faultFunction:Function=null):AsyncToken {

			service.xmlDecode = (responseType == ResponseType.DATA) ? decodeData:decodeStatus;
			if(params != null)
				token = service.send(params);
			else
				token = service.send();
			token.params = params;
			if(decodeClass)
				this.decodeClass = decodeClass;
			else
				this.decodeClass = Object;
			
			var faultHandler:Function = faultFunction==null?this.fault:faultFunction;
			var resultHandler:Function = resultFunction==null?this.result:resultFunction;
			token.addResponder(new Responder(resultHandler,faultHandler));
			if(resultFunction != null)
				token.addResponder(new Responder(result,fault));
			return token;
		}
		public function addHandlers(resultHandler:Function,faultHandler:Function=null):void {
			token.resultCallBack = resultHandler;
			token.faultCallBack = faultHandler;
		}	
	}
}