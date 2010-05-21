package org.mig.services.interfaces
{
	import org.mig.model.vo.media.DirectoryNode;
	import org.mig.model.vo.media.FileNode;

	public interface IMediaService extends IService
	{
		
		function retrieveChildren(directory:DirectoryNode):void;
			
		function addFile(file:Object,directory:DirectoryNode):void;
		
		function deleteDirectory(directory:DirectoryNode):void;
		
		function deleteFile(file:FileNode):void;
	}
}