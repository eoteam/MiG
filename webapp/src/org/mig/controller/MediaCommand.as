package org.mig.controller
{
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	
	import org.mig.events.MediaEvent;
	import org.mig.events.NotificationEvent;
	import org.mig.events.ViewEvent;
	import org.mig.model.vo.ContentNode;
	import org.mig.model.vo.UpdateData;
	import org.mig.model.vo.app.StatusResult;
	import org.mig.model.vo.media.DirectoryNode;
	import org.mig.model.vo.media.FileNode;
	import org.mig.model.vo.media.MediaData;
	import org.mig.model.vo.media.MimeTypes;
	import org.mig.services.FileService;
	import org.mig.services.interfaces.IContentService;
	import org.mig.services.interfaces.IFileService;
	import org.mig.services.interfaces.IMediaService;
	import org.mig.utils.GlobalUtils;
	import org.robotlegs.mvcs.Command;
	
	public class MediaCommand extends Command
	{
		[Inject]
		public var mediaService:IMediaService;
		
		[Inject]
		public var fileService:IFileService;
		
		[Inject]
		public var contentService:IContentService;		
		
		[Inject]
		public var event:MediaEvent;
		
		private var deleteCount:int = 0;
		private var deleteTracker:int = 0;
		private var collectionSort:Sort;
		override public function execute():void {
			var node:DirectoryNode;
			var file:FileNode;
			var item:ContentNode;
			var directory:DirectoryNode;

			switch(event.type) {
				case MediaEvent.RETRIEVE_CHILDREN:
					
					node = event.args[0] as DirectoryNode;
					if(node.parentNode && node.parentNode.children.sort) {
						node.parentNode.children.sort = null; 
						node.children.sort = null;
						node.parentNode.children.refresh();
						node.children.refresh();
					}
					node.state = ContentNode.LOADING;
					node.newFiles = [];
					node.numFolders = node.numFiles = 0;
					fileService.readDirectory(node as DirectoryNode);
					fileService.addHandlers(handleDiskResults);
				break;
				
				case MediaEvent.RETRIEVE_VERBOSE:				
				break;
				
				case MediaEvent.ADD_DIRECTORY:
					/*override public function addNode(node:ContentNode,index:int=-1,update:Boolean=true,swap:Boolean=false):void */
					node = event.args[0] as DirectoryNode;
					var name:String = event.args[1];
					var dirData:MediaData = event.args[2];
					var newDirectory:String = node.directory + name + '/';
					directory = new DirectoryNode(name, dirData, node, newDirectory, node.privileges);
					var index:int = 0;
					for each(item in node.children) {
						index++;
						if(item is DirectoryNode) {
							index = node.children.getItemIndex(item);
							break;
						}
					}
					node.children.addItemAt(directory,index);			
					eventDispatcher.dispatchEvent(new ViewEvent(ViewEvent.REFRESH_MEDIA));
				break;
				
				case MediaEvent.ADD_FILE:
					node = event.args[0] as DirectoryNode;
					var fileData:MediaData = event.args[1];
					file = new FileNode(fileData.name,fileData,node,node.privileges);
					node.children.addItem(file);
					eventDispatcher.dispatchEvent(new ViewEvent(ViewEvent.REFRESH_MEDIA));
				break;
				
				case MediaEvent.DELETE:
					var items:Array = event.args[0] as Array;
					var files:Array = []; 
					var dirs:Array  = [];
					deleteCount=0;	
					for each(item in items) {
					if(item is FileNode)
						files.push(item);
					else 
						dirs.push(item);
					}
					///if the file belongs to any of the directories selected, then skip, because the directory delete 
					//will remove the file from disk, and then the DB delete will look for all the files that have that path
					//otherwise, the file needs file and db delete
					
					for each(file in files) {
						if(!checkDir(file.parentNode as DirectoryNode,dirs)) {
							fileService.deleteFile(file);
							fileService.addHandlers(handleFileDeleted);
							deleteCount++;
						}
					}
					for each(directory in dirs) {
						if(!checkDir(directory.parentNode as DirectoryNode,dirs)) {
							fileService.deleteDirectory(directory);
							fileService.addHandlers(handleDirectoryDeleted);
							deleteCount++
						}
					}
				break;
				case MediaEvent.MOVE:
					total = count = 0;
					for each(var content:ContentNode in event.args[0] as Array) {
						fileService.moveItem(content, event.args[1] as DirectoryNode);
						fileService.addHandlers(handleDiskMove);
					}
				break;
				case MediaEvent.GET_DIRECTORY_SIZE:
					fileService.refreshDirectorySize(event.args[0] as DirectoryNode);
				break;
			}
		}	
		private function checkDir(dir:DirectoryNode,dirs:Array):Boolean {
			if(dir) {
				if(dirs.indexOf(dir) == -1)
					return checkDir(dir.parentNode as DirectoryNode,dirs);
				else
					return true;
			}
			else
				return false;
		}
		

		private function handleDiskResults(data:Object):void {
			var results:Array = data.result as Array;
			var content:DirectoryNode = data.token.directory;	
			//content.children.removeAll();
			for each (var item:MediaData in results) {
				if(item.type.toString() == "folder")
					content.diskFolders.push(item);	
				else
					content.diskFiles.push(item);
			}
			mediaService.retrieveChildren(content);
			mediaService.addHandlers(handleDatabaseResults);
		}
		private function handleDatabaseResults(data:Object):void {
			var results:Array = data.result as Array;
			var content:DirectoryNode = data.token.content;
			var item:MediaData;
			var result:MediaData;
			var file:Object;
			var d:Date = new Date();
			content.state = ContentNode.LOADED;
			
			var found:Boolean = false;
			
			if(results.length > 0) {// some items are stored, correlate disk with DB
				
				for each(result in results) {
					if(result.mimetypeid != MimeTypes.DIRECTORY) {
						for each(item in content.diskFiles) {		
							if(item.name == result.name) {
								found = true;
								var node:FileNode = new FileNode(result.name, result, content,content.privileges);
								content.children.addItem(node);
								content.numFiles += 1;	
								break;
							}
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
					else if(result.mimetypeid == MimeTypes.DIRECTORY) {
						for each(item in content.diskFolders) {	
							if(result.name == item.name) {
								found = true;
								result.childrencount = item.childrencount;
								result.size = item.size;
								var newdirectory:String = content.directory + item.name.toString() + '/';
								var categoryNode:DirectoryNode = new DirectoryNode(result.name, result,content, newdirectory,content.privileges);
								content.children.addItem(categoryNode);
								content.numFolders += 1;
								break;
							}
						}
						if(!found) {
							content.newFolders.push(item);
						}
						
					}
				}
			}	
			if(collectionSort) {
				content.parentNode.children.sort = collectionSort; 
				content.children.sort = collectionSort;
				content.parentNode.children.refresh();
				content.children.refresh();
			}
		
/*		else { //none in DB and all on disk
			for each(item in content.diskFiles) {
				item.modifieddate = d.time;
				item.createthumb = item.createthumb.toString();							
				content.newFiles.push(item);
			}
		}
		for each(result in results) { // not on disk but in DB: virtual asset, namely youtube, remote asset, etc..
			if(result.mimetypeid == MimeTypes.YOUTUBE) {
				node = new FileNode(result.name, content.config, result, content,content.privileges);
				content.children.addItem(node);
				content.numItems += 1;	
			}
		}*/
		}
		private function handleDirectoryDeleted(data:Object):void {
			var result:StatusResult = data.result as StatusResult;
			if(result.success) {
				mediaService.deleteDirectory(data.token.directory as DirectoryNode);
				mediaService.addHandlers(handleDirectoryDBDelete);
			}
		}
		private function handleDirectoryDBDelete(data:Object):void {
			var result:StatusResult = data.result as StatusResult;
			var node:DirectoryNode = data.token.directory as DirectoryNode;	
			if(result.success) {
				deleteTracker++;
				eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.NOTIFY,"Directory deleted successfully"));
				node.parentNode.children.removeItemAt(node.parentNode.children.getItemIndex(node));
				checkDeleteCount();
			}			
		}
		private function handleFileDeleted(data:Object):void {
			var result:StatusResult = data.result as StatusResult;
			var file:FileNode = data.token.file as FileNode;		
			if(result.success) {
				mediaService.deleteFile(file);
				mediaService.addHandlers(handleFileDBDelete);
			}
		}
		private function handleFileDBDelete(data:Object):void {
			var result:StatusResult = data.result as StatusResult;
			var node:FileNode = data.token.file as FileNode;	
			if(result.success) {
				deleteTracker++;
				eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.NOTIFY,"File deleted successfully"));
				node.parentNode.children.removeItemAt(node.parentNode.children.getItemIndex(node));
				checkDeleteCount();
			}				
		}
		private function checkDeleteCount():void {
			if(deleteTracker == deleteCount)
				eventDispatcher.dispatchEvent(new ViewEvent(ViewEvent.REFRESH_MEDIA));
		}
		private var total:int;
		private var count:int;
		
		private function handleDiskMove(data:Object):void {
			var result:StatusResult = data.result as StatusResult;
			if(result.success) {
				var dir:DirectoryNode = data.token.directory as DirectoryNode;
				var content:ContentNode = data.token.content as ContentNode;
				var  update:UpdateData;
				if(content is FileNode) {
					update = new UpdateData();
					update.id = content.data.id;
					update.path = dir.directory;
					mediaService.updateContent(content as FileNode,update);
					mediaService.addHandlers(handleDBMove);
					total++;
				}
				else {
					var newdir:String = dir.directory + content.baseLabel + '/';
					if(content.state == ContentNode.LOADED) {
						var arr:Array = [];
						GlobalUtils.accumulateFiles(content as DirectoryNode,arr);
						for each(var file:FileNode in arr) {
							update = new UpdateData();
							update.id = file.data.id;
							if(file.parentNode == content)
								update.path = newdir;
							else
								update.path = dir.directory.substr(0,dir.directory.length-1) + DirectoryNode(file.parentNode).directory; 
							mediaService.updateContent(file,update);
							mediaService.addHandlers(handleDBMove);
							total++;
						}
						if(arr.length == 0) {
							eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.NOTIFY,"Folder moved successfully"));
							eventDispatcher.dispatchEvent(new MediaEvent(MediaEvent.GET_DIRECTORY_SIZE,content));
						}
					}
					else if(content.state == ContentNode.NOT_LOADED) {
						mediaService.updateFilesByDirectory(content as DirectoryNode,newdir);
						mediaService.addHandlers(handleDBMove);
						total++;
					}
					DirectoryNode(content).directory = newdir;
				}
			}
		}
		private function handleDBMove(data:Object):void {
			var result:StatusResult = data.result as StatusResult;
			if(result.success) {
				count++;
				if(total == count)
					eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.NOTIFY,"Files moved successfully"));
			}		
		}			
	}
}