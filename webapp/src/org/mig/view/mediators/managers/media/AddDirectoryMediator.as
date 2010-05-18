package org.mig.view.mediators.managers.media
{
	import flash.events.MouseEvent;
	
	import org.mig.events.MediaEvent;
	import org.mig.events.NotificationEvent;
	import org.mig.model.ContentModel;
	import org.mig.model.vo.StatusResult;
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
				fileService.addDirectory(view.nameInput.text);
				fileService.addHandlers(handleDirectoryAdded);
			}
		}
		private function handleDirectoryAdded(data:Object):void {
			var mediaData:MediaData = data.result[0] as MediaData;	
			view.close();
			var directory:DirectoryNode = contentModel.currentDirectory;
			if(mediaData) {
				eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.NOTIFY,"Directory added successfully"));
				var newDirectory:String = directory.directory + "/" + view.nameInput.text;
				var newNode:DirectoryNode = new DirectoryNode(view.nameInput.text,directory.config,mediaData,directory,newDirectory,directory.privileges);
				eventDispatcher.dispatchEvent(new MediaEvent(MediaEvent.ADD_CHILD_NODE,directory,null,newNode));
			}
			else {
				
			}
		}
	}
}