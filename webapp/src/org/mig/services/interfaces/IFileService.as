package org.mig.services.interfaces
{
	import flash.net.FileReference;
	
	import org.mig.model.vo.media.DirectoryNode;

	public interface IFileService extends IService
	{
		function uploadFile(file:FileReference,directory:DirectoryNode):void;
		
		function getXMP(name:String):void;
		
		function getID3(name:String):void;
		
		function deleteFile(name:String):void;
		
		function deleteDirectory(node:DirectoryNode):void;
		
		function readDirectory(node:DirectoryNode):void;
		
		function addDirectory(name:String):void;
	}
}