package org.mig.services.interfaces
{
	public interface IService
	{
		function addHandlers(resultHandler:Function,faultHandler:Function=null):void;
		
		function addProperties(prop:String, value:*):void;
	}
}