package org.mig.view.mediators.managers.media
{
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import org.mig.events.ViewEvent;
	import org.mig.services.interfaces.IFileService;
	import org.mig.view.components.managers.media.DownloadView;
	import org.robotlegs.mvcs.Mediator;
	
	public class DownloadMediator extends Mediator
	{
		[Inject]
		public var fileService:IFileService;
		
		[Inject]
		public var view:DownloadView;
		
		override public function onRegister():void {
			eventMap.mapListener(eventDispatcher,ViewEvent.FILE_DOWNLOAD_PROGRESS,handleDownloadProgress,ViewEvent);
			eventMap.mapListener(eventDispatcher,ViewEvent.FILE_DOWNLOAD_CANCEL,handleDownloadCancel,ViewEvent);
			view.fileName = "archive";
			view.prompt = "Preparing archive ...";
			view.addEventListener(CloseEvent.CLOSE,handleDownloadViewClose);
			fileService.downloadFiles(view.files);
		}
		private function handleDownloadProgress(event:ViewEvent):void {
			view.prompt = "Downloading...";
			view.uploadProgress = event.args[0] / event.args[1];
			if(event.args[0] == event.args[1])
				PopUpManager.removePopUp(view);
		}
		private function handleDownloadViewClose(event:CloseEvent):void {
			fileService.cancelDownload();
		}
		private function handleDownloadCancel(event:ViewEvent):void {
			PopUpManager.removePopUp(view);
		}
	}
}