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
	import mx.rpc.http.HTTPService;
	import mx.rpc.xml.SimpleXMLDecoder;
	
	import org.mig.controller.Constants;
	import org.mig.events.AlertEvent;
	import org.robotlegs.mvcs.Actor;
	
	public class AbstractXMLHTTPService extends Actor
	{
		protected var service:HTTPService;
		protected var resultHandler:Function;
		protected var faultHandler:Function;
		
		public function AbstractXMLHTTPService() {
			super();
		}
		protected function decodeResults(xml:XMLDocument,decodeClass:Class):Array {
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
		protected function fault(info:Object):void {
			eventDispatcher.dispatchEvent(new AlertEvent( AlertEvent.SHOW_ALERT, "crap","Crap"));
		}
		protected function createService(params:Object,result:Function):AsyncToken {
			service = new HTTPService();
			service.method = URLRequestMethod.POST;
			service.url = Constants.EXECUTE;
			service.resultFormat = HTTPService.RESULT_FORMAT_TEXT;
			var token:AsyncToken;
			if(params != null)
				token = service.send(params);
			else
				token = service.send();
			var responder:Responder = new Responder(result,fault);
			token.addResponder(responder);
			return token;
		}
		public function addResultHandler(resultHandler:Function):void {
			this.resultHandler = resultHandler;
		}
		public function addFaultHandler(faultHandler:Function):void {
			this.faultHandler = faultHandler;
		}
	}
}