package  org.mig.model.vo.media
{

	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.managers.PopUpManagerChildList;
	import mx.rpc.AsyncToken;
	
	import org.mig.model.vo.ContentNode;
	
	[Bindable]
	public class DirectoryNode extends ContentNode {
		
		public var directory:String;
		public var numFolders:int = 0;
		public var numItems:int = 0;
		public var diskFiles:Array;
		public var newFiles:Array;
		
		public function DirectoryNode(baseLabel:String, config:XML, data:MediaData, parentContent:ContentNode, directory:String,privileges:int) {
			super(baseLabel, config, data, parentContent,privileges);	
			this.directory = directory;
			numItems = 0;
			numFolders = 0;
			diskFiles = [];
			newFiles = [];
			if(data.childrencount > 0 )
				children.addItem({label: 'loading ...', data:null});
		}	
		/*		
		override protected function update(value:UpdateData):void {
			//rename the folder on disk, update all of it
			//var command:FileCommand = new FileCommand(this,ResponseType.STATUS,null,Constants.,params);
			//command.execute();
		}
		*/
		
		
		/*		
		private function handleSelection(event:Event):void
		{
			if(event.type == "yesSelected")
			{
				_operation = new XmlHttpOperation(Constants.REMOVEDIR_PHP);
				var params:Object = new Object();
				params.directory = directory;
				if(params.directory == null || params.directory == "")
				{	
					params.directory = " ";
				}
				params.rootDir = config.@directory;
				params.fileType = config.@type;				
				_operation.params = params;	
				_operation.addEventListener(Event.COMPLETE, handleDirRemoveComplete);				
				_operation.execute();				
				for each(var file:ContentNode in children)
				{
					if(file is MediaContainerNode)
					MediaContainerNode(file).removeItemDB();
					else if(file is MediaCategoryNode)
					MediaCategoryNode(file).removeItem();
				}					
			}
		}	
		
		
		/*
		private function handleThumbComplete(event:Event):void {
			var result:XML  = XML(event.target.xml);
			if(result.success.toString() == "true") {
				thumbCount++;
				var file:Object = event.target.tokens.file;
				file.thumb = result.thumb.toString();
				file.video_proxy = result.video_proxy.toString();
				if(thumbCount == thumbTotal) {
				if(newFiles.length > 0)
				{
					var scannedSet:Object = new Object();
					scannedSet.uploadPath = this.directory;
					scannedSet.node = this;
					scannedSet.files = newFiles;
					scannedSet.done = "0";
					//ControllerLocator.fileUploadController.scannedSets.addItem(scannedSet);	
				}
				}
			}
		}*/
	}
}