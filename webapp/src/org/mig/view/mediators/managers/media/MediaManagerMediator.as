package org.mig.view.mediators.managers.media
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import mx.collections.HierarchicalData;
	import mx.controls.AdvancedDataGrid;
	import mx.events.AdvancedDataGridEvent;
	import mx.events.CloseEvent;
	import mx.events.DragEvent;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.managers.DragManager;
	import mx.managers.PopUpManager;
	import mx.managers.PopUpManagerChildList;
	
	import org.mig.events.AppEvent;
	import org.mig.events.ContentEvent;
	import org.mig.events.MediaEvent;
	import org.mig.events.ViewEvent;
	import org.mig.model.AppModel;
	import org.mig.model.ContentModel;
	import org.mig.model.vo.ContentNode;
	import org.mig.model.vo.media.DirectoryNode;
	import org.mig.model.vo.media.FileNode;
	import org.mig.utils.GlobalUtils;
	import org.mig.view.components.main.SystemPopup;
	import org.mig.view.components.managers.media.AddDirectoryView;
	import org.mig.view.components.managers.media.DownloadView;
	import org.mig.view.components.managers.media.MediaManagerView;
	import org.mig.view.components.managers.media.RenameView;
	import org.mig.view.constants.DraggableViews;
	import org.mig.view.events.ContentViewEvent;
	import org.mig.view.events.ListItemEvent;
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
			eventMap.mapListener(eventDispatcher,ViewEvent.REFRESH_MEDIA,handleRefresh,ViewEvent);
			addListeners();
			addContextMenu();
			initView();
		}
		private function handleConfigLoaded(event:AppEvent):void {
			view.thumbURL = appModel.thumbURL;
			view.name = view.parentDocument.name = contentModel.mediaConfig.@name.toString();
		}
		private function handleRefresh(event:ViewEvent):void {
			if(view.stack.selectedIndex == 0) {
				view.listView.invalidateList();
			}
			else {
				//view.thumbView.i
			}
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
			view.listView.addEventListener(ContentViewEvent.LOAD_CHILDREN,handleLoadChildren);
			view.listView.addEventListener(DragEvent.DRAG_COMPLETE,handleListDragComplete);	
			//view.listView.addEventListener(AdvancedDataGridEvent.ITEM_OPEN,handleListItemOpen);
			
			view.addEventListener('thumbViewCreated',handleThumbView);
		}
		private function initView():void {
			view.user = appModel.user;
			TweenMax.to(view.thumbButton, 0.5, {colorTransform:{tint:0xffffff, tintAmount:1}, ease:Expo.easeOut});
			TweenMax.to(view.listButton, 0.5, {colorTransform:{tint:0xed1c58, tintAmount:1}, ease:Expo.easeOut});
			view.parentdirButton.enabled = false;
			view.parentdirButton.alpha = 0.5;
			view.currentState = "loading";
			view.listView.dragFormat  = DraggableViews.MEDIA_ITEMS;
		}
		private function handleContent(event:FlexEvent):void {
			this.selectedContent = contentModel.currentDirectory as DirectoryNode;
		}
		private function handleThumbView(event:Event):void {
			view.currentState = "loading";
			view.thumbView.dragFormat = DraggableViews.MEDIA_ITEMS;
			view.thumbView.addEventListener(FlexEvent.UPDATE_COMPLETE,handleListUpdate); 
			view.thumbView.addEventListener(ListItemEvent.ITEM_DOUBLE_CLICK, handleThumbItemDoubleClick);	
			view.thumbView.addEventListener(ListEvent.ITEM_CLICK,handleThumbItem);
			view.thumbView.addEventListener(KeyboardEvent.KEY_DOWN,handleThumbItem);
			GlobalUtils.createContextMenu(["Remove","Rename","Download","New Folder"],menuItemSelectHandler,null,[view.thumbView]);
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
			if(view.listView.selectedItem is DirectoryNode) {
				if(DirectoryNode(view.listView.selectedItem).state == ContentNode.NOT_LOADED)
					eventDispatcher.dispatchEvent(new MediaEvent(MediaEvent.RETRIEVE_CHILDREN, view.listView.selectedItem as DirectoryNode)); 
				this.selectedContent = view.listView.selectedItem as DirectoryNode;	
			}
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
			//handleSelection(view.thumbView.selectedItems);
		}
		//functions
		private function toggleView(index:int):void {
			if(index != view.stack.selectedIndex) {
				if(index == 1) {
					TweenMax.to(view.thumbButton, 0.5, {colorTransform:{tint:0xed1c58, tintAmount:1}, ease:Expo.easeOut});
					TweenMax.to(view.listButton, 0.5, {colorTransform:{tint:0xffffff, tintAmount:1}, ease:Expo.easeOut});
					view.scaleSlider.alpha = 1;
					view.scaleSlider.mouseChildren = true;
					view.scaleSlider.mouseEnabled = true;
					view.stack.selectedIndex= 1;
				}
				else {
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
				eventDispatcher.dispatchEvent(new MediaEvent(MediaEvent.MULTIPLE_SELECT));
		}		
		private function search(input:String):void {
			
		}
		private function downloadItems():void {
			var items:Array;
			if(view.stack.selectedIndex == 0)
				items = view.listView.selectedItems;
			else {
				items = new Array();
				if(view.thumbView.selectedItems) {
					for (var i:int=0; i<view.thumbView.selectedItems.length;i++) {
						var item:ContentNode = view.thumbView.selectedItems[i] as ContentNode;
						items.push(item);
					}
				}
			}
			if(items.length > 0 ) {
				var downloadView:DownloadView = PopUpManager.createPopUp(view,DownloadView,false,PopUpManagerChildList.POPUP) as DownloadView; 
				mediatorMap.createMediator( downloadView );
				downloadView.files = items
				PopUpManager.centerPopUp(downloadView);	
			}
		}
		private function deleteItems(event:Event=null):void {
			var popup:SystemPopup = new SystemPopup();
			popup.percentHeight  = popup.percentWidth = 100;
			popup.includeCancel = false;
			var fileList:String="";	
			var contents:Array = new Array();
			var items:Array;
			if(view.stack.selectedIndex == 0)
				items = view.listView.selectedItems;
			else {
				items = new Array();
				if(view.thumbView.selectedItems) {
					for (var i:int=0; i<view.thumbView.selectedItems.length;i++) {
						var item:ContentNode = view.thumbView.selectedItems[i] as ContentNode;
						items.push(item);
					}
				}
			}
			if(items.length > 0 ) {
				for each(item in items) {
					if(item is FileNode) {
						/*if(MediaContainerNode(item).contentTitles.length > 0)
						{
							for each(var title:String in MediaContainerNode(item).contentTitles)
							{
								if(contents.indexOf(title) == -1)
								{
									fileList += "<p><font face='Transit-Bold'>"+title+"</font></p>";
									contents.push(title);
								}
							} 
						}	*/
						if(contents.indexOf(item) == -1) {
							fileList += "<p><font face='Transit-Bold'>"+item.label+"</font></p>";
							contents.push(item);
						}
					}
					else
						fileList += getContentList(item as DirectoryNode,contents);
				}	
				if(fileList != '')
					popup.message = "<p>You are about to delete asset(s) that are used by the following containers:</p>"+fileList + 
						"<br />Are you sure you want to continue?";
				else
					popup.message = "<p>You are about to delete asset(s)</p>"+"<br />Are you sure you want to continue?";
				popup.addEventListener('yesSelected',handleDelete);
				PopUpManager.addPopUp(popup,this.contextView,true,PopUpManagerChildList.POPUP);
			}
		}
		private function getContentList(directory:DirectoryNode,contents:Array):String {
			var result:String = "";
			for each(var item:ContentNode in directory.children) {
				if(item is FileNode) {
					if(contents.indexOf(item) == -1) {
						result += "<p><font face='Transit-Bold'>"+item.label+"</font></p>";
						contents.push(item);
					}
					
					/*if(FileNode(file).contentTitles.length > 0)
					{					
						for each(var title:String in MediaContainerNode(file).contentTitles)
						{
							if(contents.indexOf(title) == -1)
							{
								result += "<p><font face='Transit-Bold'>"+title+"</font></p>";
								contents.push(title);
							}						
						}
					}*/
				}
				else
					result += getContentList(item as DirectoryNode,contents);
			}	
			return result;		
		}
		private function handleDelete(event:Event):void {
			var items:Array;
			if(view.stack.selectedIndex == 0)
				items = view.listView.selectedItems;
			else {
				items = new Array();
				if(view.thumbView.selectedItems) {
					for (var i:int=0; i<view.thumbView.selectedItems.length;i++) {
						var item:ContentNode = view.thumbView.selectedItems[i] as ContentNode;
						items.push(item);
					}
				}
			}
			eventDispatcher.dispatchEvent(new MediaEvent(MediaEvent.DELETE,items));
		}
		private function renameItem():void {
			
			var item:ContentNode = view.stack.selectedIndex == 0 ? view.listView.selectedItem as ContentNode : view.thumbView.selectedItem as ContentNode;
			if(item) {
				var popup:RenameView = new RenameView();
				popup.content = item;
				PopUpManager.addPopUp(popup, view , false , PopUpManagerChildList.POPUP);
				mediatorMap.createMediator( popup );
				PopUpManager.centerPopUp(popup);		
			}
		}
		private function addFolder(event:Event=null):void {
			var popup:AddDirectoryView = new AddDirectoryView();
			PopUpManager.addPopUp(popup, view , false , PopUpManagerChildList.POPUP);
			mediatorMap.createMediator( popup );
			PopUpManager.centerPopUp(popup);
		}
		private function handleListDragDrop(event:DragEvent):void {
			
			// cancel default
			event.preventDefault();
                
			// get the drag format (its always items in our case
			// when you are dragging FROM a Tree its treeItems
			var draggedFormat:String = event.dragSource.formats[0];
                
			// Get the dragged items
			var draggedItems:Array = event.dragSource.dataForFormat(draggedFormat) as Array;
                
			// Calculate the index in the Tree where the items were dropped 
			var dropIndex:int = view.listView.calculateDropIndex(event);
                
			// Set the selected index of the Tree to the dropIndex
			view.listView.selectedIndex = dropIndex;
                
			// Check if we are dropping on a node
                
			// Add each dragged item to the Tree by apppending it
			// as a child of the selected node in the Tree.
			for each( var node:ContentNode in view.listView.selectedItems ) {
				// create item
				// use appendChild to add the item. 
				// (if selected item is an item then append to parent)
				if( view.listView.selectedItem is FileNode) {
					FileNode(view.listView.selectedItem).parentNode.children.addItem(node);
					node.parentNode = FileNode(view.listView.selectedItem).parentNode;
				}
				else {
					DirectoryNode(view.listView.selectedItem).children.addItem(node);  
					node.parentNode =  DirectoryNode(view.listView.selectedItem);             
            	}
			}
			view.listView.invalidateList();
		}
            
		private function handleListDragComplete(event:DragEvent):void {
			var items:Array = event.dragSource.dataForFormat(DraggableViews.MEDIA_ITEMS) as Array;
			for each(var item:ContentNode in items) {
				//move and rename item
				
			}
		}
/*		private function handleListItemOpen(event:AdvancedDataGridEvent):void {
			if(event.itemRenderer){
			if(DirectoryNode(event.itemRenderer.data).state == ContentNode.NOT_LOADED)
			eventDispatcher.dispatchEvent(new MediaEvent(MediaEvent.RETRIEVE_CHILDREN,event.itemRenderer.data)); 
			}

		}*/
		private function handleLoadChildren(event:ContentViewEvent):void {
			var node:DirectoryNode = event.args[0];
			eventDispatcher.dispatchEvent(new MediaEvent(MediaEvent.RETRIEVE_CHILDREN,node));
		}
		//set current node
		private function set selectedContent(value:DirectoryNode):void {
			if(_selectedNode != value) {
				_selectedNode = contentModel.currentDirectory = value;
				view.currentState = "loading";
				//view.listDP = new HierarchicalData(value.children);
				view.tileDP = value.children;
				var arr:Array = String(value.directory).split("/");
				var currentLocation:String = "<font color='#999999'>"+appModel.fileDir;
				if(arr) {
					arr.reverse();
					currentLocation += "<font color='#999999'>";
					var numItems:int = arr.length - 1;	
					for(var i:int = 0; i < arr.length; i++) {
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
}