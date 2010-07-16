package org.mig.model
{
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.PropertyChangeEvent;
	
	import org.mig.collections.DataCollection;
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
		public var contentConfig:XML;
		public var contentModel:ContainerNode;
		public var currentContainer:ContainerNode;
		public var templates:DataCollection;
		public var templatesConfig:XML;
		public var templatesCustomFields:DataCollection;
		public var configEelements:XML;
		public var defaultCreate:String;
		public var defaultUpdate:String;
		public var defaultRetrieve:String;
		public var defaultDelete:String;
		public var defaultTable:String;
		
		//media - model media after Terms. Flat VO, single config, single config
		//actuall no, better to have media 2D like content, first layer is metadata about the VOs, 2nd layer is VO
		public var mediaModel:DirectoryNode;
		public var currentDirectory:DirectoryNode;
		public var mimetypes:Array;
		public var mediaConfig:XML;
		
		//tags
		public var tagTerms:DataCollection;
		public var categoryTerms:Array;
		public var categoryTermsFlat:DataCollection;
		public var categoriesCustomFields:DataCollection;	
		public var termsConfig:XML;
		
		public function ContentModel() {
			templates = new DataCollection();
			tagTerms = new DataCollection();
			categoryTerms = []
			categoryTermsFlat = new DataCollection();
			templatesCustomFields = new DataCollection();
			tagTerms.addEventListener(CollectionEvent.COLLECTION_CHANGE,handleTagTerms);
			categoryTermsFlat.addEventListener(CollectionEvent.COLLECTION_CHANGE,handleCategoryTerms);
			categoriesCustomFields = new DataCollection();
		}
		private function handleTagTerms(event:CollectionEvent):void {
			if(event.kind == CollectionEventKind.UPDATE) {
				for each(var change:PropertyChangeEvent in event.items) {
					var term:Term = change.source as Term;
					if(change.property == "name")
						term.slug = GlobalUtils.createSlug(term.name);
					if(!isNaN(term.termid))
						term.updateData.termid = term.termid;
				}
			}
			else if(event.kind == CollectionEventKind.ADD) {
				for each(term in event.items) {
					term.updateData.taxonomy = "tag";	
				}
			}
		}
		private function handleCategoryTerms(event:CollectionEvent):void {
			if(event.kind == CollectionEventKind.UPDATE) {
				for each(var change:PropertyChangeEvent in event.items) {
					var term:Term = change.source as Term;
					if(change.property == "name")
						term.slug = GlobalUtils.createSlug(term.name);
					if(!isNaN(term.termid))
						term.updateData.termid = term.termid;
				}
			}
			else if(event.kind == CollectionEventKind.ADD) {
				for each(term in event.items) {
					term.updateData.taxonomy = "category";	
				}
			}
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
	}
}