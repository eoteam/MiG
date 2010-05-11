package org.mig.services.interfaces
{
	public interface IAppService extends IService
	{
		function loadConfig():void;
		
		function loadConfigFile(url:String):void;
		
		function loadCustomFields():void;
		
		function loadCustomFieldGroups():void ;
		
		function loadTemplates():void;
	}
}