package org.mig.services.interfaces
{
	import org.mig.model.vo.ConfigurationObject;
	import org.mig.model.vo.ContentData;
	import org.mig.model.vo.ValueObject;

	public interface IAppService extends IService
	{
		function loadSettings():void;
		
		function loadManagers():void;
				
		function loadColors():void;
		
		function duplicateObject(vo:ContentData,config:ConfigurationObject,relatedField:String,relatedTables:String):void;
		
		
	}
}