package org.mig.services.interfaces
{
	public interface IAppService extends IService
	{
		function loadConfig():void;
		
		function loadConfigFile(url:String):void;
		
		function loadCustomFields():void;
		
		function loadCustomFieldGroups():void ;
		
		//these are loaded by the app service but stored in the content model...
		function loadTemplates():void;
		
		function loadMimeTypes():void;
		
		function loadTerms():void;
		
		//function update
	}
}