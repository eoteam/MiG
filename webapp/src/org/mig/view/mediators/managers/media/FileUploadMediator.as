package org.mig.view.mediators.managers.media
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flashx.textLayout.conversion.TextConverter;
	
	import org.mig.events.UploadEvent;
	import org.mig.view.components.managers.media.FileUploadView;
	import org.robotlegs.mvcs.Mediator;
	
	public class FileUploadMediator extends Mediator
	{
		[Inject]
		public var view:FileUploadView;
		
		private var files:Array;
		override public function onRegister():void {
			view.uploadBtn.addEventListener(MouseEvent.CLICK,handleUploadButton);
			view.stopBtn.addEventListener(MouseEvent.CLICK,handleStopButton);
			
			eventMap.mapListener(eventDispatcher,UploadEvent.PROGRESS,handleFileProgress,UploadEvent);
			eventMap.mapListener(eventDispatcher,UploadEvent.FILE_START,handleFileStart,UploadEvent);
			eventMap.mapListener(eventDispatcher,UploadEvent.FILE_END,handleFileEnd,UploadEvent);
			eventMap.mapListener(eventDispatcher,UploadEvent.COMPLETE,handleComplete,UploadEvent);
		}
		private function handleUploadButton(event:Event):void {
			files = view.selectedFiles;
			view.currentState = "uploading";
			eventDispatcher.dispatchEvent(new UploadEvent(UploadEvent.UPLOAD,files));	
		}
		private function handleStopButton(event:Event):void {
			if(view.currentState == "uploading")
				eventDispatcher.dispatchEvent(new UploadEvent(UploadEvent.CANCEL));
			view.currentState = "browse";
			view.selectedFiles = null;
		}
		private function handleFileProgress(event:UploadEvent):void {
			view.progressText2.text = event.args[1];
			view.uploadProgress = event.args[0];
		}
		private function handleFileStart(event:UploadEvent):void {
			view.progressText1.text = event.args[0];
		}
		private function handleFileEnd(event:UploadEvent):void {
			view.completedFilesList.textFlow = TextConverter.importToFlow(event.args[0],TextConverter.TEXT_FIELD_HTML_FORMAT);
		}
		private function handleComplete(event:UploadEvent):void {
			view.progressText2.text = view.progressText1.text = view.completedFilesList.text = '';
			view.uploadProgress = 0;
			view.currentState = "browse";
			view.selectedFiles = null;
		}

	}
}