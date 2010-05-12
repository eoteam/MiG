package org.mig.controller
{
	import org.mig.events.MediaEvent;
	import org.mig.model.vo.media.MediaCategoryNode;
	import org.mig.model.vo.media.MediaContainerNode;
	import org.mig.model.vo.media.MediaData;
	import org.mig.model.vo.media.MimeTypes;
	import org.mig.services.interfaces.IMediaService;
	import org.robotlegs.mvcs.Command;

	public class MediaCommand extends Command
	{
		[Inject]
		public var service:IMediaService;
		
		[Inject]
		public var event:MediaEvent;
		
		override public function execute():void {
			switch(event.type) {
				case MediaEvent.RETRIEVE_CHILDREN:
					service.retrieveChildrenFromDisk(event.content as MediaCategoryNode);
					service.addHandlers(handleDiskResults);
				break;
				
				case MediaEvent.RETRIEVE_VERBOSE:
					
				break;
			}
		}	
		private function handleDiskResults(data:Object):void {
			var results:Array = data.result as Array;
			var content:MediaCategoryNode = data.token.content;	
			for each (var item:MediaData in results) {
				if(item.type.toString() == "folder") {
					var newdirectory:String;
					if(content.directory != "" && content.directory != null)
						newdirectory = content.directory + "/" + item.name.toString();
					else
						newdirectory = item.name.toString();
					var categoryNode:MediaCategoryNode = new MediaCategoryNode(item.name, content.config, item,content, newdirectory,content.privileges);
					content.children.addItem(categoryNode);
					content.numFolders += 1;	
					eventDispatcher.dispatchEvent(new MediaEvent(MediaEvent.RETRIEVE_CHILDREN,categoryNode));
				}
				else
					content.diskFiles.push(item);
			}
			service.retrieveChildrenFromDatabase(content);
			service.addHandlers(handleDatabaseResults);
		}
		private function handleDatabaseResults(data:Object):void {
			var results:Array = data.result as Array;
			var content:MediaCategoryNode = data.token.content;
			var item:MediaData;
			var result:MediaData;
			var file:Object;
			var d:Date = new Date();
			if(results.length > 0) {// some files are stored, correlate disk with DB
				for each(item in content.diskFiles) {
					var found:Boolean = false;
					for each(result in results) {
						if(item.name == result.name) {
							found = true;
							var node:MediaContainerNode = new MediaContainerNode(result.name, content.config, result, content,content.privileges);
							content.children.addItem(node);
							content.numItems += 1;	
							break;
						}
						else
							found = false;
					}
					if(!found) {
						
						item.modifieddate = d.time;
						//item.parent = '';
						item.createthumb = item.createthumb.toString();							
						content.newFiles.push(item);	
						/*if(file.createthumb == "1") {
						thumbTotal++;
						trace("thumb total",thumbTotal);
						var op:XmlHttpOperation = new XmlHttpOperation(Constants.CREATE_THUMB);
						op.addEventListener(Event.COMPLETE,handleThumbComplete);			
						var params:Object = new Object();
						params.name = file.name;
						params.path = '/'+this.directory+'/';
						var tokens:Object = new Object();
						tokens.file = file;
						op.tokens = tokens;
						op.params = params;
						op.execute();*/	
					}	
				}
			}
			else { //none in DB and all on disk
				for each(item in content.diskFiles) {
					item.modifieddate = d.time;
					//item.parent = '';
					item.createthumb = item.createthumb.toString();							
					content.newFiles.push(item);
				}
			}
			for each(result in results) { // not on disk but in DB: virtual asset, namely youtube, remote asset, etc..
				if(result.mimetype == MimeTypes.YOUTUBE)
				{
					node = new MediaContainerNode(result.name, content.config, result, content,content.privileges);
					content.children.addItem(node);
					content.numItems += 1;	
				}
			}
		}
	}
}