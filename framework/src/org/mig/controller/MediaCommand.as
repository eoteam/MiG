package org.mig.controller
{
	import org.mig.events.MediaEvent;
	import org.mig.model.vo.media.MediaCategoryNode;
	import org.mig.model.vo.media.MediaData;
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
			content.diskFiles = [];		
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
				}
				else
					content.diskFiles.push(item);
			}
			service.retrieveChildrenFromDatabase(content);
			service.addHandlers(handleDatabaseResults);
		}
		private function handleDatabaseResults(data:Object):void {
			var results:Array = data.result as Array;
		}
	}
}