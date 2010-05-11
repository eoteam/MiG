import com.map.controller.Constants;
import com.map.controller.ControllerLocator;
import com.map.controller.MediaManagerController;
import com.map.event.ApplicationEvent;
import com.map.event.EventBus;
import com.map.manager.ManagerBase;
import com.map.model.ContentNode;
import com.map.model.MediaCategoryNode;
import com.map.model.MediaContainerNode;
import com.map.services.XmlHttpOperation;
import com.mapx.manager.UserManager;
import com.mapx.view.content.SystemPopup;
import com.thanksmister.controls.ImageCache;

import flash.display.Bitmap;
import flash.display.Shape;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.ProgressEvent;
import flash.net.FileReference;
import flash.net.URLRequest;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;

import mx.binding.utils.BindingUtils;
import mx.binding.utils.ChangeWatcher;
import mx.collections.ArrayCollection;
import mx.collections.HierarchicalData;
import mx.controls.AdvancedDataGrid;
import mx.controls.advancedDataGridClasses.AdvancedDataGridHeaderRenderer;
import mx.core.Application;
import mx.core.UIComponent;
import mx.core.UITextField;
import mx.events.CloseEvent;
import mx.events.CollectionEvent;
import mx.events.DragEvent;
import mx.events.ListEvent;
import mx.managers.DragManager;
import mx.managers.PopUpManager;
import mx.managers.PopUpManagerChildList;

[Bindable] public var linkedResource:ContentNode;
[Bindable] public var useParentDirectory:Boolean = false; 
[Bindable] public var currentLocation:Array;
[Bindable] public var _dpFlat:ArrayCollection;

public var searchNode:ContentNode;
public var searchMode:Boolean = false;

[Embed(source='/migAssets/library.swf#folderIcon')]
private var dirIcon:Class;

private static var singleton:MediaManager;

[Bindable] private var _dpTile:ArrayCollection;
[Bindable] private var _dpList:HierarchicalData;
[Bindable] private var _selectedContent:ContentNode;
[Bindable] private var _scalePercent:Number = 0.5;


private var contentWatcher:ChangeWatcher;
private var searchInput:RegExp;
private var currentlySelected:Object
private var prevFolder:ContentNode;
private var stop:Boolean = true;
private var found:Boolean = false;
private var draggedItems:Array;
private var _linkingMode:Boolean = false;
private var _managerInitialized:Boolean = false;
private var downloadRef:FileReference = new FileReference();
private	var downloadView:DownloadProgressView;


public function set managerInitialized(value:Boolean):void {
	_managerInitialized = value;
	if(!value && contentWatcher)
		contentWatcher.unwatch();	
}
public function get managerInitialized():Boolean {
	return _managerInitialized;
}
public function set selectedContent(content:ContentNode):void {
	if(_selectedContent != content)
	{	
		_selectedContent = content;	
		if(_selectedContent)
		{
			this.managerInitialized = true;
			
			if(_selectedContent == ControllerLocator.mediaManagerController.contentModel)
				this.useParentDirectory = false;
			else
				this.useParentDirectory = true;	
			_dpList = new HierarchicalData(_selectedContent.children);
			_dpTile = _selectedContent.children;
			if(_dpFlat == null)
			{
			}
			currentLocation = String(MediaCategoryNode(_selectedContent).directoryMapping).split("/");
			ControllerLocator.fileUploadController.uploadPath = MediaCategoryNode(_selectedContent).directoryMapping;
			this.callLater(handleSearchResult);
		}
		else
		{
			_managerInitialized = false;
		}	
		if(_selectedContent)
			refresh();
	}	
}
public function get selectedContent():ContentNode {
	return _selectedContent;
}
public function set scalePercent(newVal:Number):void {
	_scalePercent = newVal;
	this.thumbView.invalidateDisplayList();
	thumbView.invalidateSize();	
}

[Bindable]
public function get scalePercent():Number
{
	return _scalePercent;	
}
public function set linkingMode(value:Boolean):void {
	_linkingMode = value;
	if(value)
	{
		this.addEventListener(MouseEvent.MOUSE_OVER,checkItem);
		Object(this.selectedChild)..getChildAt(0).addEventListener(MouseEvent.MOUSE_OUT, handleMouseOut);
		Object(Object(this.selectedChild)..getChildAt(0)).menuSelectionMode = true;
	}
	else
	{
		this.removeEventListener(MouseEvent.MOUSE_OVER,checkItem);
		Object(this.selectedChild)..getChildAt(0).removeEventListener(MouseEvent.MOUSE_OUT, handleMouseOut);
	}
}
public static function getInstance():MediaManager {
	if ( MediaManager.singleton )
	{
		trace(singleton.uid);
		return MediaManager.singleton;
	}else{
		MediaManager.singleton = new MediaManager();
		trace(singleton.uid);
		return MediaManager.singleton;
	}            
}
public function initializeManager():void {
	managerInitialized = true;
	var mediaManagerController:MediaManagerController = ControllerLocator.mediaManagerController;
	contentWatcher = BindingUtils.bindProperty(this, "selectedContent", mediaManagerController, "selectedContent");
	mediaManagerController.selectedContent.children.addEventListener(CollectionEvent.COLLECTION_CHANGE,handleChange);
}
public function goUp():void {
	ControllerLocator.mediaManagerController.selectedContent = _selectedContent._parentNode;	
}
public function search(input:String):void {
	if(input != '')
	{
		searchInput  = new RegExp(input,"i/g");
		_dpFlat.filterFunction = searchByString;
		_dpFlat.refresh();
		listView.dataProvider = new HierarchicalData(_dpFlat);
		if(thumbView)
			thumbView.dataProvider = _dpFlat;
		EventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.FIND_XMP,[searchInput]));
		searchMode = true;
		addContextMenu();
	}
	else
	{
		if(_selectedContent == ControllerLocator.mediaManagerController.contentModel)
			this.useParentDirectory = false;
		else
			this.useParentDirectory = true;	
		listView.dataProvider = _dpList;
		if(thumbView)
			thumbView.dataProvider = _dpTile;	
		EventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.FIND_XMP,['']));		
		_dpFlat.filterFunction = null;
		_dpFlat.refresh();		
		searchMode = false;
		addContextMenu();
	}
}
public function handleUserField(data:Object):String {
	var label:String ='';
	if(data)
	{
		if(data.createdby != undefined && data.createdby != 0)
		{
			var userName:String =  UserManager(ManagerBase.getInstance(UserManager)).findUserById(Number(data.createdby));
			label = userName;
		}
	}
	return label;
}
public function handleSizeField(data:Object):String {
	var label:String;
	if(data)
	{
		if (data.size < 1024)
			label = data.size + " B";
		else if ((data.size > 1024) && (data.size < 1048576))
			label = Math.round(data.size / 1024).toString() + " KB";
		else if (data.size > 1048576)
			label = Math.round(data.size / 1048576).toString() + " MB";
		
	}
	return label;
	
}
public function handleDateField(data:Object):String {
	var label:String ="";
	if(data)
	{
		if(data is MediaContainerNode)
		{
			var d:Date = new Date();
			d.time=data.createdate;
			label=d.toDateString()	
		}
	}
	return label;
}
public function handleExtensionField(data:Object):String {
	var label:String='';
	if(data)
	{
		if(data is MediaContainerNode)
		{
			var arr:Array = data.label.split('.');
			if(arr.length>1)
				label = '.'+arr[arr.length-1];
		} 
	}
	return label;
}
public function handleDelete(data:Object):void {
	ContentNode(data).removeData();
}
public function deleteItems():void {
	var popup:SystemPopup = new SystemPopup();
	popup.includeCancel = false;
	var fileList:String="";	
	var contents:Array = new Array();
	for each(var item:ContentNode in Object(Object(this.selectedChild).getChildAt(0)).selectedItems)
	{
		if(item is MediaContainerNode)
		{
			if(MediaContainerNode(item).contentTitles.length > 0)
			{
				for each(var title:String in MediaContainerNode(item).contentTitles)
				{
					if(contents.indexOf(title) == -1)
					{
						fileList += "<p><font face='Transit-Bold'>"+title+"</font></p>";
						contents.push(title);
					}
				} 
			}		
		}
		else
			fileList += getContentList(item as MediaCategoryNode,contents);
	}	
	if(fileList != '')
		popup.message = "<p>You are about to delete asset(s) that are used by the following containers:</p>"+fileList + 
			"<br />Are you sure you want to continue?";
	else
		popup.message = "<p>You are about to delete asset(s)</p>"+"<br />Are you sure you want to continue?";
	popup.addEventListener('yesSelected',handleYesSelection);
	PopUpManager.addPopUp(popup,Application.application.mainView,true,PopUpManagerChildList.POPUP);		
}

private function initList():void {
	listView.addEventListener(CollectionEvent.COLLECTION_CHANGE, setLoading);
}
private function initThumb():void {
	Object(this.parentDocument).setCurrentState('loading', true);
	listView.addEventListener(CollectionEvent.COLLECTION_CHANGE, setLoading);
	if(searchMode)
		thumbView.dataProvider = _dpFlat;
}
private function setLoading(event:CollectionEvent=null):void {
	Object(this.parentDocument).setCurrentState('loading', true);	
}
private function setLoaded():void {
	Object(this.parentDocument).setCurrentState('loaded', true);
}
private function refresh(event:Event=null):void {
	_dpFlat = new ArrayCollection();
	accumulateChildren(ControllerLocator.mediaManagerController.contentModel as ContentNode);
}
private function accumulateChildren(content:ContentNode):void {
	_dpFlat.addItem(content);
 	for each(var item:ContentNode in content.children)
	{
		if(item is MediaContainerNode)
		{
			if(_dpFlat.contains(item) == false)
				_dpFlat.addItem(item);	
		}
		else if(item is MediaCategoryNode)
			accumulateChildren(item);
	}	
}
private function handleSearchResult():void {
	if(searchNode)
	{
		Object(this.selectedChild).getChildAt(0).selectedItems = [searchNode];
		Object(this.selectedChild).getChildAt(0).invalidateProperties();
		searchNode = null;
	}
}


private function searchByString(item:Object):Boolean
{
	var file:MediaContainerNode;
	if(item is MediaContainerNode)
	{
		file = item as MediaContainerNode;
		trace(file.name);
		if(String(file.name).search(searchInput) != -1 || String(file.tags).search(searchInput) != -1)
		{
			return true;
		}
		else 
		{
			return false;
		}
	}
	else
	{
		return !(item._baseLabel.toLowerCase().search(searchInput) == -1);
	}
}
private function handleDoubleClickThumb(event:Event):void {
	ControllerLocator.mediaManagerController.selectedContent = MediaCategoryNode(thumbView.selectedItem);
}
private function handleDoubleClickList(event:Event):void {
	ControllerLocator.mediaManagerController.selectedContent = MediaCategoryNode(listView.selectedItem);
}
private function handleYesSelection(event:Event):void {
	for each(var item:ContentNode in Object(Object(this.selectedChild).getChildAt(0)).selectedItems)
	{
		item.removeData();
	}
}
private function getContentList(item:MediaCategoryNode,contents:Array):String {
	var result:String = "";
	for each(var file:ContentNode in item.children)
	{
		if(file is MediaContainerNode)
		{
			//result += "<p><font face='Transit-Bold'>"+file.label+"</font></p>";	
			if(MediaContainerNode(file).contentTitles.length > 0)
			{					
				for each(var title:String in MediaContainerNode(file).contentTitles)
				{
					if(contents.indexOf(title) == -1)
					{
						result += "<p><font face='Transit-Bold'>"+title+"</font></p>";
						contents.push(title);
					}						
				}
			}
		}
		else
			result += getContentList(file as MediaCategoryNode,contents);
	}	
	return result;		
}
private function handleChange(event:Event):void {
	this.selectedContent = ControllerLocator.mediaManagerController.selectedContent;
}
private function checkItem(event:MouseEvent):void {
	var currPoint:Point = new Point(this.mouseX,this.mouseY);
	var objects:Array = this.systemManager.getObjectsUnderPoint(this.localToGlobal(currPoint));
	var node:ContentNode;
	for each(var obj:Object in objects)
	{
		if(this.selectedIndex == 0)
		{
			if(obj is UITextField && !(obj.parent is AdvancedDataGridHeaderRenderer))
			{
				node = obj.parent.data;
				listView.selectedItems = [node];
				listView.invalidateProperties();
				if(obj.parent.data is MediaCategoryNode)
				{
					if(prevFolder != node)
						listView.expandItem(prevFolder,false,true);
					listView.expandItem(node,true,true);
					prevFolder = node;
				}
				else
				{
					this.linkedResource = node;
				}
				found = true;
				return;		
			}
		}
		else
		{
			if( (obj is Shape && obj.parent.parent is ImageCache ) ||
				(obj is Bitmap && obj.parent is ImageCache) || 	
				(obj is UITextField && obj.document.data is ContentNode) )
			{
				if(obj is UITextField)
					node = obj.document.data;
				else if(obj is Bitmap)
					node = ImageCache(obj.parent).parentDocument.data;
				else
					node = ImageCache(obj.parent.parent).parentDocument.data;
				thumbView.selectedItems = [node];
				thumbView.validateProperties();
				if(blink.isPlaying)
				{
					if(UIComponent(thumbView.itemToItemRenderer(prevFolder)))
					{
						stop = true;
						blink.end();
						blink.target.alpha = 1;
						
					}
				}				
				if(node is MediaCategoryNode)
				{
					prevFolder = node;
					blink.target = thumbView.itemToItemRenderer(node) as UIComponent;
					blink.play();
				}
				else
					this.linkedResource = node;
				found = true;	
				return;
			}
		}
		found = false;
	}
}
private function handleEffectEnd():void
{
	if(!stop)
	{
	//if(prevFolder is MediaCategoryNode  && prevFolder.label != "..")
	//{
	//	if(_selectedContent.children.contains(parentFolder))
	//		_selectedContent.children.removeItemAt(_selectedContent.children.getItemIndex(parentFolder));			
		ControllerLocator.mediaManagerController.selectedContent = MediaCategoryNode(prevFolder);
	//}
	//else if(prevFolder.label == "..")
	//{
		//_selectedContent.children.removeItemAt(_selectedContent.children.getItemIndex(parentFolder));
		//ControllerLocator.mediaManagerController.selectedContent = _selectedContent._parentNode;
	//}
	}
	else
		stop = false;
}	
private function handleMouseOut(event:MouseEvent):void
{
	if(!found)
	{
		stop = true;
		if(blink.isPlaying)
		{
			blink.end();
			blink.target.alpha = 1;
		}
		linkedResource = null;
	}
}
private function handleItemClick(event:ListEvent):void {
	if(event.itemRenderer.data is MediaContainerNode && event.itemRenderer.data != currentlySelected && event.target.selectedItems.length==1)
	{	
		currentlySelected = event.itemRenderer.data;
		EventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.MEDIAFILE,[event.itemRenderer.data]));
	}
	else if( event.target.selectedItems.length > 1)
		EventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.MEDIAFILE,["multiple files"]));
}
private function handleKeyDown(event:Event):void {
	if(event.currentTarget.selectedItem is MediaContainerNode)
		EventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.MEDIAFILE,[event.currentTarget.selectedItem]));
}	
private function handleListDragDrop(event:DragEvent):void
{
	var currNodeOver:Object = listView.indexToItemRenderer(listView.calculateDropIndex(event));
	if(currNodeOver && currNodeOver.data is MediaCategoryNode)
	{			
		for each(var child:ContentNode in draggedItems)
		{	
			child._parentNode.removeNode(child);
			MediaCategoryNode(currNodeOver.data).addNode(child);
		}
		_dpList = new HierarchicalData(_selectedContent.children);
	}	
	else if(listView.calculateDropIndex(event) == 0)	
	{
	}
}	
private function handleListDragStart(event:Event):void
{
	draggedItems = [];
	for each(var item:Object in listView.selectedItems)
		draggedItems.push(item);	
}

private function handleListDragEnter(event:DragEvent):void
{
	if(event.dragInitiator == this.listView)
	{
		var currNodeOver:Object = listView.indexToItemRenderer(listView.calculateDropIndex(event));
		if(currNodeOver)
		{
			listView.selectedItem = currNodeOver.data;
			if(currNodeOver.data is MediaCategoryNode)
			{
				DragManager.showFeedback(DragManager.MOVE);
			}
			else
			{
				listView.hideDropFeedback(event);
				DragManager.showFeedback(DragManager.NONE);
			}
		}
	}
}
private function addContextMenu():void
{
	Application.application.globalUtils.createContextMenu(["Delete.","Rename","Download","New Folder"],menuItemSelectHandler,null,[listView]);
/*	rightClickMenu = new ContextMenu();
	rightClickMenu.hideBuiltInItems();

	var deleteItems:ContextMenuItem = new ContextMenuItem("Delete.");
	deleteItems.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);  	
	rightClickMenu.customItems.push(deleteItems);
	
	var renameItem:ContextMenuItem = new ContextMenuItem("Rename");
	renameItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);
	rightClickMenu.customItems.push(renameItem);

	var downloadItem:ContextMenuItem = new ContextMenuItem("Download");
	downloadItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);
	rightClickMenu.customItems.push(downloadItem);
	
	if(newFolder)
	{
		var folderItem:ContextMenuItem = new ContextMenuItem("New Folder");
		folderItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);
		rightClickMenu.customItems.push(folderItem);
	}	
	rightClickMenu.addEventListener(ContextMenuEvent.MENU_SELECT, contextMenu_menuSelect);*/
	
	downloadRef.addEventListener(ProgressEvent.PROGRESS,handleProgress);
	downloadRef.addEventListener(Event.CANCEL,handleCancelDownload);
	EventBus.getInstance().addEventListener(ApplicationEvent.UPLOAD_COMPLETE,refresh);	
}
private function handleCancelDownload(event:Event):void
{
	PopUpManager.removePopUp(downloadView);
}
private function handleProgress(event:ProgressEvent):void
{
	this.downloadView.prompt = "Downloading...";
	this.downloadView.uploadProgress = event.bytesLoaded / event.bytesTotal;
	if(event.bytesTotal == event.bytesLoaded)
	{
		PopUpManager.removePopUp(downloadView); 
	}
}
private function contextMenu_menuSelect(evt:ContextMenuEvent):void
{
    listView.selectedIndex = lastRollOverIndex;
    trace(lastRollOverIndex);
}

private function menuItemSelectHandler(event:ContextMenuEvent):void
{
	switch(event.target.caption)
	{
		case "Rename":	
			if(listView.selectedItems.length == 1)
			{
				var contentView:RenameItemView = PopUpManager.createPopUp
								(DisplayObject(Application.application),RenameItemView,false,PopUpManagerChildList.POPUP) as RenameItemView; 
				contentView.content = listView.selectedItem as ContentNode;
				PopUpManager.centerPopUp(contentView);			
			}
		break;
		case "Delete.":
			deleteItems();
		break;
		case "Download":
/* 			var operation:XmlHttpOperation = new XmlHttpOperation("php/execute.php");
			operation.addEventListener(Event.COMPLETE,handleZipComplete);
			var params:Object = new Object();
			var prefix:String = this.parentApplication.parameters.prompt.toString().split(' ').join('-');
			params.action= "ZipFolder";
			params.prefix =  prefix; */
			var files:String = '';
			for each(var item:ContentNode in listView.selectedItems)
			{
				if(item is MediaCategoryNode)
					ControllerLocator.mediaManagerController.fileDir+'/'+MediaCategoryNode(item).directoryMapping+ ',';	
				else
					files +=  ControllerLocator.mediaManagerController.fileDir+MediaContainerNode(item).path+item.label + ',';
			}
			files = files.substr(0,files.length-1);
/* 			params.files = files;
			operation.params = params;
			operation.execute(); */
			//this.setLoading();
		    var request:URLRequest = new URLRequest();
		    request.url = Constants.ZIP_DOWNLOAD+files;
		   	downloadRef.download(request,"archive.zip");
		    downloadView = PopUpManager.createPopUp
								(DisplayObject(Application.application),DownloadProgressView,false,PopUpManagerChildList.POPUP) as DownloadProgressView; 
		   	downloadView.fileName = "archive";
		   	downloadView.prompt = "Preparing archive ...";
		   	this.downloadView.addEventListener(CloseEvent.CLOSE,handleDownloadViewClose);
		   	PopUpManager.centerPopUp(downloadView);		
		break;
		case "New Folder":
			var newContentNode:ContentNode = this.selectedContent;
			if (newContentNode != null && newContentNode.config.@addDirectoryView.length() > 0)
			{
				var addView:AddDirectoryView = PopUpManager.createPopUp(DisplayObject(Application.application), 
													Class(getDefinitionByName(newContentNode.config.@addDirectoryView)), 
													false,PopUpManagerChildList.POPUP) as AddDirectoryView;
				addView.content = newContentNode;
				PopUpManager.centerPopUp(addView);
			}		
		break;
	}	
}
private function handleDownloadViewClose(event:CloseEvent):void {
	this.downloadRef.cancel();
}
private function handleZipComplete(e:Event):void {
	setLoaded();
}