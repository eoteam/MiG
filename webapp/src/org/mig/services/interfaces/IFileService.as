package org.mig.services.interfaces
{
	import flash.net.FileReference;
	
	import org.mig.model.vo.media.DirectoryNode;

	public interface IFileService
	{
		function uploadFile(file:FileReference):void;
		
		function addFile(file:Object):void;
		
		function getXMP(file:String):void;
		
		function getID3(file:String):void;
		
		function deleteFile(file:String):void;
		
		function deleteDirectory(node:DirectoryNode):void;
		
		function readDirectory(node:DirectoryNode):void;
		
	}
}