	package org.mig.view.mediators.managers.media
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.managers.PopUpManager;
	
	import org.mig.events.NotificationEvent;
	import org.mig.events.ViewEvent;
	import org.mig.model.vo.StatusResult;
	import org.mig.model.vo.media.DirectoryNode;
	import org.mig.model.vo.media.FileNode;
	import org.mig.model.vo.media.MediaData;
	import org.mig.services.interfaces.IFileService;
	import org.mig.services.interfaces.IMediaService;
	import org.mig.view.components.managers.media.RenameView;
	import org.robotlegs.mvcs.Mediator;

	
	public class RenameMediator extends Mediator
	{
		[Inject]
		public var view:RenameView;
		
		[Inject]
		public var fileService:IFileService;
		
		[Inject]
		public var mediaService:IMediaService;
		

		override public function onRegister():void {
			view.submitBtn.addEventListener(MouseEvent.CLICK,handleSubmitButton);
			view.input.text = view.content.baseLabel;
		}
		private function handleSubmitButton(event:Event):void {
			if(view.validInput) {
				if(view.content is FileNode) {
					fileService.renameFile(view.content as FileNode,view.input.text);
					fileService.addHandlers(handleDiskFileRename);
				}	
				else if(view.content is DirectoryNode) {
					fileService.renameDirectory(view.content as DirectoryNode,view.input.text);
					fileService.addHandlers(handleDiskDirectoryRename);		
				}	
			}
		}
		private function handleDiskFileRename(data:Object):void {
			var result:StatusResult = data.result as StatusResult;
			if(result.success) {
				mediaService.updateFile(view.content as FileNode,view.input.text);
				mediaService.addHandlers(handleFileDBFileRename);
			}
		}
		private function handleFileDBFileRename(data:Object):void {
			MediaData(view.content.data).name = view.input.text;
			eventDispatcher.dispatchEvent(new ViewEvent(ViewEvent.REFRESH_MEDIA));
			eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.NOTIFY,"File renamed successfully"));
			PopUpManager.removePopUp(view);
		}				
		private function handleDiskDirectoryRename(data:Object):void {
			var result:StatusResult = data.result as StatusResult;
			if(result.success) {
				mediaService.updateDirectory(view.content as DirectoryNode,view.input.text);
				mediaService.addHandlers(handleDBDirectoryRename);
			}
		}		
		private function handleDBDirectoryRename(data:Object):void {
			MediaData(view.content.data).name = view.input.text;
			DirectoryNode(view.content).directory = "/"+view.input.text+"/";
			DirectoryNode(view.content).baseLabel = view.input.text;
			eventDispatcher.dispatchEvent(new ViewEvent(ViewEvent.REFRESH_MEDIA));
			eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.NOTIFY,"Directory renamed successfully")); 
			PopUpManager.removePopUp(view);
		}	
	
	}
}