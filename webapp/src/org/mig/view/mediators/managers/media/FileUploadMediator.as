package org.mig.view.mediators.managers.media
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
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
			eventMap.mapListener(eventDispatcher,UploadEvent.FILE_PROGRESS,handleFileProgress,UploadEvent);
		}
		private function handleUploadButton(event:Event):void {
			files = view.selectedFiles;
			view.currentState = "uploading";
			eventDispatcher.dispatchEvent(new UploadEvent(UploadEvent.UPLOAD,files));	
		}
		private function handleFileProgress(event:UploadEvent):void {
			view.progress = event.status;
			view.uploadProgress = event.progress;
		}
	}
}