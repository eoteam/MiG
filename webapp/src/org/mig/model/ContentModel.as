package org.mig.model
{
	import mx.collections.ArrayCollection;
	
	import org.mig.model.vo.content.ContainerNode;
	import org.mig.model.vo.media.DirectoryNode;
	import org.mig.model.vo.media.MimeType;
	import org.mig.model.vo.media.MimeTypes;
	import org.robotlegs.mvcs.Actor;

	public class ContentModel extends Actor
	{
		public var contentModel:ContainerNode;
		public var templates:ArrayCollection = new ArrayCollection();
		public var currentContainer:ContainerNode;
		public var configEelements:XML;
		
		
		public var mediaModel:DirectoryNode;
		public var currentDirectory:DirectoryNode;
		public var mimetypes:Array;
		
		public var containersToLoad:Number = 0;
		public var containersLoaded:Number = 0;
		
		public var mediaToLoad:Number;
		public var mediaLoaded:Number;
		
		public var defaultCreate:String;
		public var defaultUpdate:String;
		public var defaultRetrieve:String;
		public var defaultDelete:String;
		
		public function getMimetypeString(extension:String):String {
			for each(var mimetype:MimeType in mimetypes) {
				for each(var ext:String  in mimetype.extensionsArray) {
					if(ext.toLowerCase() == extension.toLowerCase()) {
						return mimetype.name;
					}
				}
			}
			return "file";
		}
		public function getMimetypeId(extension:String):int {
			for each(var mimetype:MimeType in mimetypes) {
				for each(var ext:String  in mimetype.extensionsArray) {
					if(ext.toLowerCase() == extension.toLowerCase()) {
						return mimetype.id;
					}
				}
			}
			return MimeTypes.FILE;
		}		
	}
}