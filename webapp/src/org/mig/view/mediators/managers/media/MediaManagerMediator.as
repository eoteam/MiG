package org.mig.view.mediators.managers.media
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import mx.collections.HierarchicalData;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.managers.PopUpManager;
	
	import org.mig.events.AppEvent;
	import org.mig.events.MediaEvent;
	import org.mig.model.AppModel;
	import org.mig.model.ContentModel;
	import org.mig.model.vo.ContentNode;
	import org.mig.model.vo.media.DirectoryNode;
	import org.mig.model.vo.media.FileNode;
	import org.mig.utils.GlobalUtils;
	import org.mig.view.components.managers.media.AddDirectoryView;
	import org.mig.view.components.managers.media.MediaManagerView;
	import org.robotlegs.mvcs.Mediator;
	
	public class MediaManagerMediator extends Mediator
	{
		[Inject]
		public var view:MediaManagerView;
		
		[Inject]
		public var contentModel:ContentModel;

		[Inject]
		public var appModel:AppModel;
		
		private var _selectedNode:DirectoryNode;
		
		override public function onRegister():void {
			//eventMap.mapListener(eventDispatcher,MediaEvent.RETRIEVE_CHILDREN,handleContent,MediaEvent); 
			eventMap.mapListener(eventDispatcher,AppEvent.CONFIG_FILE_LOADED,handleConfigLoaded,AppEvent);
			addListeners();
			addContextMenu();
			initView();
		}
		private function handleConfigLoaded(event:AppEvent):void {
			view.thumbURL =  appModel.thumbURL;
		}
		private function addListeners():void {
			view.addDirectoryButton.addEventListener(MouseEvent.CLICK,addFolder);
			view.thumbButton.addEventListener(MouseEvent.CLICK,handleThumbButton);
			view.listButton.addEventListener(MouseEvent.CLICK,handleListButton);
			view.searchInput.addEventListener(FlexEvent.ENTER,handleSearchInput);
			view.clearSearch.addEventListener(MouseEvent.CLICK,handleClearSearch);
			view.trashButton.addEventListener(MouseEvent.CLICK,deleteItems);
			view.parentdirButton.addEventListener(MouseEvent.CLICK,handleParentdirButton);
			view.addEventListener(FlexEvent.SHOW,handleContent);
			
			view.scaleSlider.alpha = 0.2;
			view.scaleSlider.mouseEnabled = false;
			view.scaleSlider.mouseChildren = false;
			
			view.listView.addEventListener(FlexEvent.UPDATE_COMPLETE,handleListUpdate);
			view.listView.addEventListener(ListEvent.ITEM_DOUBLE_CLICK,handleListItemDoubleClick);
			view.listView.addEventListener(ListEvent.ITEM_CLICK,handleListItem);
			view.listView.addEventListener(KeyboardEvent.KEY_DOWN,handleListItem);
			
			view.addEventListener('thumbViewCreated',handleThumbView);
		}
		private function initView():void {
			TweenMax.to(view.thumbButton, 0.5, {colorTransform:{tint:0xffffff, tintAmount:1}, ease:Expo.easeOut});
			TweenMax.to(view.listButton, 0.5, {colorTransform:{tint:0xed1c58, tintAmount:1}, ease:Expo.easeOut});
			view.parentdirButton.enabled = false;
			view.parentdirButton.alpha = 0.5;
			view.currentState = "loading";
		}
		private function handleContent(event:FlexEvent):void {
			this.selectedContent = contentModel.mediaModel as DirectoryNode;
		}
		private function handleThumbView(event:Event):void {
			view.currentState = "loading";
			view.thumbView.addEventListener(FlexEvent.UPDATE_COMPLETE,handleListUpdate);
			view.thumbView.addEventListener(ListEvent.ITEM_DOUBLE_CLICK,handleThumbItemDoubleClick);
			view.thumbView.addEventListener(ListEvent.ITEM_CLICK,handleThumbItem);
			view.thumbView.addEventListener(KeyboardEvent.KEY_DOWN,handleThumbItem);
		}
		private function addContextMenu():void {
			GlobalUtils.createContextMenu(["Remove","Rename","Download","New Folder"],menuItemSelectHandler,null,[view.listView]);
		}
		private function menuItemSelectHandler(event:ContextMenuEvent):void {
			switch(event.target.caption) {
				case "Rename":	
					renameItem();
				break;
				case "Remove":
					deleteItems();
				break;
				case "Download":
					downloadItems();	
				break;
				case "New Folder":
						addFolder();
					break;
			}	
		}
		private function handleListButton(event:Event):void {
			toggleView(0);
		}
		private function handleThumbButton(event:Event):void {
			toggleView(1);
		}	
		private function handleSearchInput(event:Event):void {
			search(view.searchInput.text);
		}
		private function handleClearSearch(event:Event):void {
			view.clearSearch.visible = false;
			view.searchInput.text = '';
			search('');
		}
		private function handleParentdirButton(event:Event):void {
			this.selectedContent = _selectedNode.parentNode as DirectoryNode;
		}	
		//list functions
		private function handleListUpdate(event:Event):void {
			view.currentState = "loaded";
		}
		private function handleListItemDoubleClick(event:Event):void {
			if(view.listView.selectedItem is DirectoryNode)
				this.selectedContent = view.listView.selectedItem as DirectoryNode;	
		}
		private function handleListItem(event:Event):void {
			handleSelection(view.listView.selectedItems);
		}
		//thumb view functions
		private function handleThumbItemDoubleClick(event:Event):void {
			if(view.thumbView.selectedItem is DirectoryNode)
				this.selectedContent = view.thumbView.selectedItem as DirectoryNode;
		}
		private function handleThumbItem(event:Event):void {
			handleSelection(view.thumbView.selectedItems);
		}
		//functions
		private function toggleView(index:int):void {
			if(index != view.stack.selectedIndex)
			{
				if(index == 1)
				{
					TweenMax.to(view.thumbButton, 0.5, {colorTransform:{tint:0xed1c58, tintAmount:1}, ease:Expo.easeOut});
					TweenMax.to(view.listButton, 0.5, {colorTransform:{tint:0xffffff, tintAmount:1}, ease:Expo.easeOut});
					view.scaleSlider.alpha = 1;
					view.scaleSlider.mouseChildren = true;
					view.scaleSlider.mouseEnabled = true;
					view.stack.selectedIndex= 1;
				}
				else
				{
					TweenMax.to(view.thumbButton, 0.5, {colorTransform:{tint:0xffffff, tintAmount:1}, ease:Expo.easeOut});
					TweenMax.to(view.listButton, 0.5, {colorTransform:{tint:0xed1c58, tintAmount:1}, ease:Expo.easeOut});
					view.scaleSlider.alpha = 0.2;
					view.scaleSlider.mouseEnabled = false;
					view.scaleSlider.mouseChildren = false;
					view.stack.selectedIndex= 0;
				}
			}
		}			
		private function handleSelection(items:Array):void {
			if(items.length == 1 && items[0] is DirectoryNode)				
				eventDispatcher.dispatchEvent(new MediaEvent(MediaEvent.SELECT,items[0]));
			else if(items.length > 1)
				eventDispatcher.dispatchEvent(new MediaEvent(MediaEvent.MULTIPLE_SELECT,null));
		}		
		private function search(input:String):void {
			
		}
		private function downloadItems():void {
			/* var operation:XmlHttpOperation = new XmlHttpOperation("php/execute.php");
			operation.addEventListener(Event.COMPLETE,handleZipComplete);
			var params:Object = new Object();
			var prefix:String = this.parentApplication.parameters.prompt.toString().split(' ').join('-');
			params.action= "ZipFolder";
			params.prefix =  prefix; */
			var files:String = '';
/*			for each(var item:ContentNode in listView.selectedItems) {
				if(item is MediaCategoryNode)
					ControllerLocator.mediaManagerController.fileDir+'/'+MediaCategoryNode(item).directoryMapping+ ',';	
				else
					files +=  ControllerLocator.mediaManagerController.fileDir+MediaContainerNode(item).path+item.label + ',';
			}
			files = files.substr(0,files.length-1);*/
			/* 			params.files = files;
			operation.params = params;
			operation.execute(); */
			//this.setLoading();
/*			var request:URLRequest = new URLRequest();
			request.url = Constants.ZIP_DOWNLOAD+files;
			downloadRef.download(request,"archive.zip");
			downloadView = PopUpManager.createPopUp
				(DisplayObject(Application.application),DownloadProgressView,false,PopUpManagerChildList.POPUP) as DownloadProgressView; 
			downloadView.fileName = "archive";
			downloadView.prompt = "Preparing archive ...";
			this.downloadView.addEventListener(CloseEvent.CLOSE,handleDownloadViewClose);
			PopUpManager.centerPopUp(downloadView);		*/
		}
		private function deleteItems(event:Event=null):void {
			
		}
		private function renameItem():void {
			/*if(listView.selectedItems.length == 1)
			{
			var contentView:RenameItemView = PopUpManager.createPopUp
			(DisplayObject(Application.application),RenameItemView,false,PopUpManagerChildList.POPUP) as RenameItemView; 
			contentView.content = listView.selectedItem as ContentNode;
			PopUpManager.centerPopUp(contentView);			
			}*/			
		}
		private function addFolder(event:Event=null):void {
				var popup:AddDirectoryView = new AddDirectoryView();
				PopUpManager.addPopUp( popup, view );
				mediatorMap.createMediator( popup );
				PopUpManager.centerPopUp(popup);
		}

		//set current node
		private function set selectedContent(value:DirectoryNode):void {
			_selectedNode = contentModel.currentDirectory = value;
			view.currentState = "loading";
			view.listDP = new HierarchicalData(value.children);
			view.tileDP = value.children;
			var arr:Array = String(value.directory).split("/");
			var currentLocation:String = '';
			if(arr)
			{
				arr.reverse();
				currentLocation = "<font color='#999999'>/ ";
				var numItems:int = arr.length - 1;	
				for(var i:int = 0; i < arr.length; i++)
				{
					if(i < arr.length-1)
					{
						currentLocation += arr[numItems - i] + " / ";
					}
					else if( i == arr.length-1)
					{
						currentLocation += "</font><font color='#FFFFFF'>"+ arr[numItems - i] + "</font> ";
					}
				}
			}
			view.currentLocation = currentLocation;
			if(value == contentModel.mediaModel) {
				view.parentdirButton.enabled = false;
				view.parentdirButton.alpha = 0.5;
			}
			else {
				view.parentdirButton.enabled = true;
				view.parentdirButton.alpha = 1;
			}
		}
		
	}
}