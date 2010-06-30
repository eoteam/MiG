package org.mig.services.interfaces
{
	import org.mig.model.vo.ContentNode;
	import org.mig.model.vo.UpdateData;
	import org.mig.model.vo.media.DirectoryNode;
	import org.mig.model.vo.media.FileNode;
	import org.mig.model.vo.media.MediaData;

	public interface IMediaService extends IService
	{
		
		function retrieveChildren(directory:DirectoryNode):void;
			
		function addFile(file:Object,directory:DirectoryNode):void;
		
		function deleteDirectory(directory:DirectoryNode):void;
		
		function deleteFile(file:FileNode):void;
		
		function updateContent(content:ContentNode,update:UpdateData):void;
		
		function updateDirectory(directory:DirectoryNode, name:String):void;
		
		function updateFilesByDirectory(directory:DirectoryNode,newdir:String):void;
		
		function createDirectory(media:MediaData):void;
	}
}