package org.mig.services.interfaces
{
	import org.mig.model.vo.media.DirectoryNode;

	public interface IMediaService extends IService
	{
		function retrieveChildrenFromDisk(content:DirectoryNode):void;
		
		function retrieveChildrenFromDatabase(content:DirectoryNode):void;
		
		function addFolder(name:String):void;
	}
}