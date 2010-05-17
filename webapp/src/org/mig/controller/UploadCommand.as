package org.mig.controller
{
	import flash.events.DataEvent;
	import flash.events.Event;

	import flash.net.FileReference;
	import flash.net.URLRequest;
	
	import org.mig.events.UploadEvent;
	import org.mig.model.AppModel;
	import org.mig.model.ContentModel;
	import org.robotlegs.mvcs.Command;
	
	public class UploadCommand extends Command
	{
		[Inject]
		public var event:UploadEvent;
		
		[Inject]
		public var appModel:AppModel;
		
		[Inject]
		public var contentModel:ContentModel;
		
		private var files:Array;
		private var index:int;
		
		override public function execute():void {
			files = event.files;
			index = 0;
			switch(event.type) {
				case UploadEvent.UPLOAD:
					uploadFile(0);
				break;
			}
		}
		
		private function uploadFile(index:int):void {

		}
	
		private function populateDatabase(filename:String,thumb:String,video_proxy:String,file:Object,tags:Array=null,playTime:Number=NaN):void
		{
			/*var extArr:Array = filename.split('.');
			var fileExtension:String = String('.'+extArr[extArr.length-1]).toLowerCase();
			var fileType:String = getFileType(fileExtension);
			
			var parent:String = '';
			if(this.fileUploadMove)
				parent = file.parent;
			var directory:String = _rootDirectory + "/" + uploadPath+parent;
			var thumbsDir:String = _rootDirectory + "/migThumbs/" + uploadPath+parent;  	
			
			// var operation:XmlHttpOperation = new XmlHttpOperation(Constants.EXECUTE);
			//operation.addEventListener(Event.COMPLETE, handleDatabaseComplete);
			
			var tokens:Object = new Object();
			tokens.index= this.currentFileIndex;
			tokens.directory = directory;
			tokens.thumbsDir = thumbsDir;
			tokens.fileType = fileType;	        
			
			var params:Object = new Object();
			params.action = "insertRecord";
			params.tablename = "media";
			params.size = file.size;
			params.name = filename;
			if(uploadPath != "")
				params.path = "/" + uploadPath + "/"+parent;
			else
				params.path = "/"+parent;
			
			params.thumb = thumb;
			if(video_proxy != "false")
				params.video_proxy = video_proxy;
			params.mimetype = fileType;
			if(fileType == "font")
			{
				params.customfield1 = false; //not compiled 
			}
			params.createdby = Application.application.user.id;
			params.modifiedby = Application.application.user.id;
			params.verbose = false;
			trace(params.name,"\t\t\t",this.currentFileIndex,"\t",this.selectedFiles.length);
			var date:Date = new Date();
			params.createdate = date.time;
			params.modifieddate = date.time;
			if(!isNaN(playTime))
				params.playtime = playTime;
			var tagString:String="";
			if(tags)
			{
				for each(var keyword:String in tags)
				{
					tagString += keyword+",";
				}
				tagString = tagString.substring(0,tagString.length-1);
				params.tags = tagString; 
			}	       
			operation.params = params;
			operation.tokens = tokens;
			operation.execute();     		*/	
		}
		
	}
}