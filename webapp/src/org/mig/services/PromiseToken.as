package org.mig.services
{
	import mx.rpc.AsyncToken;
	import mx.rpc.Responder;
	
	public  class PromiseToken
	{
		public var resultHandler:Function;
		public var faultHandler:Function;
		public var token:AsyncToken;

		public function addHanlders(result:Function,fault:Function):void {
			token.addResponder(new Responder(result,fault));
		}
		public function addCallBacks(result:Function,fault:Function):void {
			token.resultCallBack = result;
			token.faultCallBack = fault;
		}
	}
}