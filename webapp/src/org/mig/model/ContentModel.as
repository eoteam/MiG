package org.mig.model
{
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.PropertyChangeEvent;
	
	import org.mig.model.vo.content.ContainerNode;
	import org.mig.model.vo.manager.Term;
	import org.mig.model.vo.media.DirectoryNode;
	import org.mig.model.vo.media.MimeType;
	import org.mig.model.vo.media.MimeTypes;
	import org.mig.utils.GlobalUtils;
	import org.robotlegs.mvcs.Actor;

	public class ContentModel extends Actor
	{
		//content
		public var contentModel:ContainerNode;
		public var templates:ArrayCollection;
		public var currentContainer:ContainerNode;
		public var configEelements:XML;
		public var defaultCreate:String;
		public var defaultUpdate:String;
		public var defaultRetrieve:String;
		public var defaultDelete:String;
		public var defaultTable:String;
		
		//media
		public var mediaModel:DirectoryNode;
		public var currentDirectory:DirectoryNode;
		public var mimetypes:Array;
		
		//tags
		public var tagTerms:ArrayCollection;
		public var categoryTerms:ArrayCollection;

		public function ContentModel() {
			tagTerms = new ArrayCollection();
			categoryTerms = new ArrayCollection();
			templates = new ArrayCollection();
			tagTerms.addEventListener(CollectionEvent.COLLECTION_CHANGE,handleTagTerms);
			categoryTerms.addEventListener(CollectionEvent.COLLECTION_CHANGE,handleCategoryTerms);
		}
		
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
		private function handleTagTerms(event:CollectionEvent):void {
			if(event.kind == CollectionEventKind.UPDATE) {
				for each(var change:PropertyChangeEvent in event.items) {
					var term:Term = change.source as Term;
					term.edited = true;
					if(change.property == "name")
						term.slug = GlobalUtils.sanitizeString(term.name);
				}
			}
		}
		private function handleCategoryTerms(event:CollectionEvent):void {
			if(event.kind == CollectionEventKind.UPDATE) {
				for each(var term:Term in categoryTerms) {
					term.slug = GlobalUtils.sanitizeString(term.name);
				}
			}
		}
	}
}