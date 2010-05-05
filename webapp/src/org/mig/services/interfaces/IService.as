package org.mig.services.interfaces
{
	public interface IService
	{
		function addHandlers(resultHandler:Function,faultHandler:Function):void;
		
		function get resultHandler():Function;
		
		function get faultHandler():Function;
		
	}
}