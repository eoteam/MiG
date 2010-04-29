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
	
	import org.mig.events.AlertEvent;
	import org.robotlegs.mvcs.Actor;
	
	public class AbstractXMLHTTPService extends Actor implements IResponder
	{
		public function AbstractXMLHTTPService()
		{
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
		public function result(data:Object):void {
			//if(data.token.responseType == ResponseType.DATA) {
				var results:Array = decodeResults(new XMLDocument(data.result.toString()),data.token.decode as Class);
				data.token.callback(results,data.token);
			//}
			//else data.token.callback(data.result,data.token); 
		}
		public function fault(info:Object):void {
			eventDispatcher.dispatchEvent(new AlertEvent( AlertEvent.SHOW_ALERT, "crap","Crap"));
		}
		protected function createService(params:Object,url:String,callback:Function,responseType:String,decode:Class=null):AsyncToken {
			var service:HTTPService = new HTTPService();
			service.method = URLRequestMethod.POST;
			service.url = url;
			if(responseType == ResponseType.DATA)
				service.resultFormat = HTTPService.RESULT_FORMAT_TEXT;
			else
				service.resultFormat = HTTPService.RESULT_FORMAT_OBJECT;
			var token:AsyncToken;
			if(params != null)
				token = service.send(params);
			else
				token = service.send();
			token.decode = decode==null?Object:decode;
			token.callback = callback;
			token.responseType = responseType;
			token.addResponder(this);
			trace(url);
			return token;
		}
	}
}