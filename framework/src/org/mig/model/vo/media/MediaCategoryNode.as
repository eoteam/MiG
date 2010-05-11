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
	
	public class MediaCategoryNode extends ContentNode {
		
		public var directory:String;
		
		public var numFolders:int = 0;
		public var numItems:int = 0;
		
		public var diskFiles:Array;
		public var newFiles:Array;
		
		public function MediaCategoryNode(baseLabel:String, config:XML, data:MediaData, parentContent:ContentNode, directory:String,privileges:int) {
			this.directory = directory;
			numItems = 0;
			numFolders = 0;
			super(baseLabel, config, data, parentContent,privileges);	
		}	
		/*

		override protected function update(value:UpdateData):void {
			//rename the folder on disk, update all of it
			//var command:FileCommand = new FileCommand(this,ResponseType.STATUS,null,Constants.,params);
			//command.execute();
		}
		override protected function remove(args:Array=null):void {
			for each(var file:ContentNode in children) {
				file.removeData([true]); //recursive remove, these classes never have access to UI, so any alert will have to be handled by the UI before calling this
			}	
			var params:Object = new Object();
			params.directory = directory;
			if(params.directory == null || params.directory == "")	
				params.directory = " ";
			params.rootDir = config.@directory;
			
			var command:FileCommand = new FileCommand(this,Constants.REMOVE_DIR,params,ResponseType.STATUS);
			command.execute();
			
		}

		
		private var thumbCount:int
		private var thumbTotal:int;
		private function handleDBComplete(results:Array,token:AsyncToken=null):void {
			var item:MediaData;
			var result:MediaData;
			newFiles = [];
			thumbCount = 0;
			thumbTotal = 0;
			var file:Object;
			if(results.length > 0) {// some files are stored, correlate disk with DB
				for each(item in diskFiles) {
					var found:Boolean = false;
					for each(result in results) {
						if(item.name == result.name) {
							found = true;
							var node:MediaContainerNode = new MediaContainerNode(result.name, _config, result, this,this.privileges);
							children.addItem(node);
							numItems += 1;	
							break;
						}
						else
							found = false;
					}
					if(!found) {
						addNewFile(item);
					}	
				}
			}
			else { //none in DB and all on disk
				for each(item in diskFiles)
				addNewFile(item);
			}
			for each(result in results) { // not on disk but in DB: virtual asset, namely youtube, remote asset, etc..
				if(result.mimetype == MimeTypes.YOUTUBE)
				{
					node = new MediaContainerNode(result.name, _config, result, this,this.privileges);
					children.addItem(node);
					numItems += 1;	
				}
			}
			//updateLabel();
		}	*/
	/*	private function addNewFile(item:MediaData):void {
			var d:Date = new Date();
			item.modifieddate = d.time;
			//item.parent = '';
			item.createthumb = item.createthumb.toString();							
			newFiles.push(item);	*/		
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
			op.execute();
			}*/
		//}
		/*override public function addNode(node:ContentNode,index:int=-1,update:Boolean=true,swap:Boolean=false):void {
			if(node is MediaCategoryNode) {
				var index:int = 0;
				for each(var child:ContentNode in this.children) {
					index++;
					if(child is MediaContainerNode) {
						index = children.getItemIndex(child);
						break;
					}
				}
				this.children.addItemAt(node,index);
				//dispatchEvent(new ContentNodeEvent(ContentNodeEvent.NODE_ADDED,node));
				//updateLabel();				
			}	
			else    {
				super.addNode(node);
			}
			node.parentNode = this;
		}*/
		/*	
		
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
		public function addMediaContainerNode(newItem:XML,newLabel:String):MediaContainerNode {
		function search(item:Object):Boolean {
		if(item.label.toLowerCase() == newLabel.toLowerCase())
		return true;
		else
		return false;             
		}
		children.filterFunction = search;
		children.refresh();
		if(children.length == 1) {
		var existingChild:MediaContainerNode = MediaContainerNode(children[0]);
		}      
		children.filterFunction = null;
		children.refresh();	        
		var node:MediaContainerNode;
		if(!existingChild) {
		node = new MediaContainerNode(newLabel, _config, newItem, this,this.privileges);
		children.addItem(node);
		updateLabel();
		return node;
		}
		else {
		return null;
		}
		}*/		
		/*		private function handleThumbComplete(event:Event):void {
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