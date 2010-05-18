package org.mig.controller
{
	import com.darronschall.serialization.ObjectTranslator;
	
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	
	import org.mig.events.MediaEvent;
	import org.mig.events.NotificationEvent;
	import org.mig.events.UploadEvent;
	import org.mig.model.AppModel;
	import org.mig.model.ContentModel;
	import org.mig.model.vo.media.MediaData;
	import org.mig.services.interfaces.IFileService;
	import org.mig.services.interfaces.IMediaService;
	import org.robotlegs.mvcs.Command;
	
	public class UploadCommand extends Command
	{
		[Inject]
		public var event:UploadEvent;
		
		[Inject]
		public var appModel:AppModel;
		
		[Inject]
		public var contentModel:ContentModel;
		
		[Inject]
		public var fileService:IFileService;
		
		[Inject]
		public var mediaService:IMediaService;
		
		private var files:Array;
		private var runningStatus:String;
		private var index:int;
		
		override public function execute():void {
			files = event.args[0] as Array;
			runningStatus = '<p>Completed Files:</p>';
			index = 0;
			switch(event.type) {
				case UploadEvent.UPLOAD:
					uploadFile(0);
				break;
			}
		}
		
		private function uploadFile(index:int):void {
			eventDispatcher.dispatchEvent(new UploadEvent(UploadEvent.FILE_START,"File "+(index+1).toString() + "/"+files.length.toString()));
			fileService.uploadFile(files[index] as FileReference);
			FileReference(files[index]).addEventListener(DataEvent.UPLOAD_COMPLETE_DATA,uploadCompleteDataHandler);
		}
		private function uploadCompleteDataHandler(event:DataEvent):void {
			trace("UPLOAD_COMPLETE_DATA\n",event.data	,"\n=====================");
			var result:XML = XML(event.data);
			var file:Object = new Object();
			for each(var prop:XML in result.children()) {
				file[prop.name()] = prop.toString();
			}
			mediaService.addFile(file);
			mediaService.addHandlers(handleDatabaseAdd);
		}
		private function handleDatabaseAdd(data:Object):void {
			var item:MediaData = data.result[0] as MediaData;
			eventDispatcher.dispatchEvent(new MediaEvent(MediaEvent.ADD_FILE,contentModel.currentDirectory,item));
			eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.NOTIFY,"File uploaded successfully"));
			runningStatus += item.name + "<br />";
			eventDispatcher.dispatchEvent(new UploadEvent(UploadEvent.FILE_END,runningStatus));
			index++;
			if(index == files.length) {
				eventDispatcher.dispatchEvent(new UploadEvent(UploadEvent.COMPLETE));
			}
			else
				uploadFile(index);
		}
		
	}
}