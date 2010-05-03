package org.mig.services.interfaces
{
	public interface IService
	{
		function addResultHandler(resultHandler:Function):void;
	
		function addFaultHandler(faultHandler:Function):void;
	}
}