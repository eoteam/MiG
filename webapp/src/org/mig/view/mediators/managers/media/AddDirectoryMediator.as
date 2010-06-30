package org.mig.view.mediators.managers.media
{
	import flash.events.MouseEvent;
	
	import org.mig.events.MediaEvent;
	import org.mig.events.NotificationEvent;
	import org.mig.model.ContentModel;
	import org.mig.model.vo.app.StatusResult;
	import org.mig.model.vo.media.DirectoryNode;
	import org.mig.model.vo.media.MediaData;
	import org.mig.services.interfaces.IFileService;
	import org.mig.services.interfaces.IMediaService;
	import org.mig.view.components.managers.media.AddDirectoryView;
	import org.robotlegs.mvcs.Mediator;
	
	public class AddDirectoryMediator extends Mediator
	{
		[Inject]
		public var view:AddDirectoryView;
		
		[Inject] 
		public var mediaService:IMediaService;
		
		[Inject]
		public var fileService:IFileService;
		
		[Inject]
		public var contentModel:ContentModel;
		
		override public function onRegister():void {
			
			view.submitButton.addEventListener(MouseEvent.CLICK,handleSubmitButton);
		}
		private function handleSubmitButton(event:MouseEvent):void {
			if(view.nameInput.text.length > 0) {
				fileService.createDirectory(view.nameInput.text);
				fileService.addHandlers(handleDirectoryAddedToDisk);
			}
		}
		private function handleDirectoryAddedToDisk(data:Object):void {
			var mediaData:MediaData = data.result[0] as MediaData;	
			
			if(mediaData) {
				mediaService.createDirectory(mediaData);
				mediaService.addHandlers(handleDirectoryAddedToDB);
			}
			else {
				
			}
		}
		private function handleDirectoryAddedToDB(data:Object):void {
			view.close();
			var result:StatusResult = data.result as StatusResult;
			var mediaData:MediaData = data.token.media as MediaData;
			var directory:DirectoryNode = contentModel.currentDirectory;
			if(result.success) {
				//this is written in a way that that makes the command unaware of the current directory
				//is this event ADD_DIRECTORY meant to  allow adding directories to other directories other than the currrently selected one?
				eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.NOTIFY,"Directory added successfully"));
				eventDispatcher.dispatchEvent(new MediaEvent(MediaEvent.ADD_DIRECTORY,directory,view.nameInput.text,mediaData));
			}
		}
	}
}