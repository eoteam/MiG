package org.mig.services.interfaces
{
	import org.mig.model.vo.ContentData;
	import org.mig.model.vo.ValueObject;

	public interface IAppService extends IService
	{
		function loadConfigFile(url:String):void;
		
		function loadCustomFields():void;
		
		function loadCustomFieldGroups():void ;
		
		function loadColors():void;
		
		function duplicateObject(vo:ContentData,config:XML,relatedField:String,relatedTables:String):void;
	}
}