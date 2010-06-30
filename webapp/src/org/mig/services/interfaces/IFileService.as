package org.mig.services.interfaces
{
	import flash.net.FileReference;
	
	import org.mig.model.vo.ContentNode;
	import org.mig.model.vo.media.DirectoryNode;
	import org.mig.model.vo.media.FileNode;

	public interface IFileService extends IService
	{
		function uploadFile(file:FileReference,directory:DirectoryNode):void;
		
		function getXMP(name:String):void;
		
		function getID3(name:String):void;
		
		function deleteFile(node:FileNode):void;
		
		function deleteDirectory(node:DirectoryNode):void;
		
		function readDirectory(node:DirectoryNode):void;
		
		function createDirectory(name:String):void;
		
		function refreshDirectorySize(directory:DirectoryNode):void;
	
		function downloadFiles(files:Array):void;
		
		function cancelDownload():void;
		
		function renameFile(file:FileNode,name:String):void;
		
		function renameDirectory(directory:DirectoryNode,name:String):void;
		
		function moveItem(content:ContentNode,to:DirectoryNode):void;	
	}
}