package org.mig.view.mediators.main
{
	import flash.events.Event;
	
	import mx.core.DragSource;
	import mx.events.DragEvent;
	import mx.events.ListEvent;
	import mx.events.TreeEvent;
	import mx.managers.PopUpManager;
	import mx.managers.PopUpManagerChildList;
	import mx.utils.ArrayUtil;
	
	import org.mig.controller.startup.AppStartupStateConstants;
	import org.mig.events.AppEvent;
	import org.mig.events.ContentEvent;
	import org.mig.events.NotificationEvent;
	import org.mig.events.ViewEvent;
	import org.mig.model.ContentModel;
	import org.mig.model.vo.ContentData;
	import org.mig.model.vo.ContentNode;
	import org.mig.model.vo.app.StatusResult;
	import org.mig.model.vo.UpdateData;
	import org.mig.model.vo.content.ContainerNode;
	import org.mig.model.vo.content.ContainerData;
	import org.mig.services.interfaces.IContentService;
	import org.mig.utils.GlobalUtils;
	import org.mig.view.components.main.ContentTree;
	import org.mig.view.components.main.SystemPopup;
	import org.mig.view.events.ContentViewEvent;
	import org.mig.view.components.main.ContentTreeRenderer;
	import org.robotlegs.mvcs.Mediator;
	import org.robotlegs.utilities.statemachine.StateEvent;

	public class ContentTreeMediator extends Mediator
	{
		[Inject] 
		public var view:ContentTree;
		
		[Inject]
		public var contentModel:ContentModel;
		
		[Inject]
		public var contentService:IContentService;

		override public function onRegister():void {
			//eventMap.mapListener(eventDispatcher,AppEvent.CONFIG_FILE_LOADED,handleContent);
			eventMap.mapListener(eventDispatcher,StateEvent.ACTION,handleContent); 
			eventMap.mapListener(eventDispatcher,ViewEvent.DELETE_CONTAINERS,deleteItems);
			eventMap.mapListener(eventDispatcher,ViewEvent.ENABLE_CONTENT_TREE,enableTree);
			eventMap.mapListener(eventDispatcher,ViewEvent.VALIDATE_CONTENT,validateContent);
		
			eventMap.mapListener(eventDispatcher,ContentEvent.SELECT,handleSelectedContent);
			addListeners();
			addContextMenu();

		}
		private function addListeners():void {
			view.addEventListener(DragEvent.DRAG_START,handleDragStart);
			view.addEventListener(DragEvent.DRAG_DROP,handleDragDrop);
			view.addEventListener(DragEvent.DRAG_ENTER,handleDragEnter);
			view.addEventListener(DragEvent.DRAG_OVER,handleDragOver);
			view.addEventListener(DragEvent.DRAG_COMPLETE,handleDragComplete);
			
			view.addEventListener(TreeEvent.ITEM_OPENING,handleItemOpen);
			view.addEventListener(TreeEvent.ITEM_OPEN,handleItemOpen);
			
			view.addEventListener(ListEvent.CHANGE,handleItemClick);
			view.addEventListener(ListEvent.ITEM_DOUBLE_CLICK,handleItemDoubleClick);	
			
			view.addEventListener(ContentViewEvent.LOAD_CHILDREN,handleLoadChildren);
			view.addEventListener(ContentViewEvent.TITLE_CHANGED,handleTitleChanged);
		}
		private function handleLoadChildren(event:ContentViewEvent):void {
			var node:ContainerNode = event.args[0];
			eventDispatcher.dispatchEvent(new ContentEvent(ContentEvent.RETRIEVE_CHILDREN,node));
		}
		private function handleContent(event:StateEvent):void {
			if(event.action == AppStartupStateConstants.LOAD_CONTENT_COMPLETE) {	
				view.dataProvider = contentModel.contentModel;
			}
		}
		private function enableTree(event:Event):void {
			view.enabled = true;
		}
		private function validateContent(event:ViewEvent):void {
			view.validateNow();
		}
		
		private function handleDragStart(event:DragEvent):void {
			
		}
		private function handleDragDrop(event:DragEvent):void {
			
		}	
		private function handleDragEnter(event:DragEvent):void {
			
		}
		private function handleDragOver(event:DragEvent):void {
			
		}	
		private function handleDragComplete(event:DragEvent):void {
			
		}
		private function handleItemOpen(event:TreeEvent):void {
			
		}
		private function handleItemClick(event:ListEvent):void {
			
		}
		private function handleItemDoubleClick(event:ListEvent):void {
			var selectedNode:ContainerNode = event.itemRenderer.data as ContainerNode
			if(!selectedNode.isRoot) {
				if(ContainerData(selectedNode.data).loaded)
					eventDispatcher.dispatchEvent(new ContentEvent(ContentEvent.SELECT,selectedNode));
				else 
					eventDispatcher.dispatchEvent(new ContentEvent(ContentEvent.RETRIEVE_VERBOSE,selectedNode));
			}
			else {
				eventDispatcher.dispatchEvent(new ContentEvent(ContentEvent.SELECT,selectedNode));
			}
		}
		private function addContextMenu():void {
			GlobalUtils.createContextMenu(["Delete Item(s)","Rename","Duplicate Item(s)"],menuItemSelectHandler,null,[view]);
		}
		private function menuItemSelectHandler(event:Event):void {
			switch(event.target.caption)
			{
				case "Delete Item(s)":
					deleteItems();
				break;	
				case "Rename":
					var f:ContentTreeRenderer = view.itemToItemRenderer(view.selectedItem) as ContentTreeRenderer;
					if(f) {
						f.editable = true;
						view.dragEnabled = view.dropEnabled = false; 
						view.editMode = true;
					}
				break;	
				case "Duplicate Item(s)":
					eventDispatcher.dispatchEvent(new ContentEvent(ContentEvent.DUPLICATE,view.selectedItems));
/*					dupCount = 0;
					dupTracker = 0;
					parentNodesToUpdate = [];
					for each(var item:ContainerNode in this.selectedItems)
					{
						if(!item.isRoot && !item.isFixed)
						{
							dupCount++;
							if(parentNodesToUpdate.indexOf(item._parentNode) == -1)
								parentNodesToUpdate.push(item._parentNode);
							var op:XmlHttpOperation = new XmlHttpOperation(Constants.EXECUTE);
							var params:Object = new Object();
							params.action = "duplicateContent";
							params.id = item.data.id.toString();
							op.params = params;
							var tokens:Object = new Object();
							tokens.node = item;
							op.tokens = tokens;
							op.addEventListener(Event.COMPLETE,hanldeDuplicate);
							op.execute();
						}	
					}*/
					break;			
			}
		}
		private var itemsToDelete:Array; 
		private function deleteItems(event:Event=null):void {
			itemsToDelete = [];
			var popup:SystemPopup; 
			if(view.selectedItems.length > 0 ) {		
				for each(var node:ContainerNode in view.selectedItems) {
					if(node.isFixed || node.isRoot) {
						popup = createPopup("<p>You cant delete this container:</p>" +
							"<font face='Transit-Bold'>"+node.label + "</font><br /><br />"+
							"Please try again");
						popup.includeCancel = popup.includeYes = false;
						popup.noLabelText = "Continue";
						return;
					}
					GlobalUtils.accumulateChildren(node,itemsToDelete);

				}
				var itemsString:String = '';
				for each(node in itemsToDelete) {
					itemsString += "<font face='Transit-Bold'>"+node.label+"</font><br/>";
					//node.addEventListener(ContentNodeEvent.NODE_DELETED,handleNodeDeleted);
				}	
				popup = createPopup("<p>You are about to delete the following containers:</p>"+ itemsString+
					"<br/>Are you sure you want to continue?");
				popup.addEventListener("yesSelected", handleDeleteSelection);
				popup.includeCancel = false;
			}
		}
		private function createPopup(message:String):SystemPopup {
			var popup:SystemPopup = new SystemPopup();
			popup.message = message;
			PopUpManager.addPopUp(popup,this.contextView,true,PopUpManagerChildList.POPUP);
			return popup;
		}
		private function handleDeleteSelection(event:Event):void {
			eventDispatcher.dispatchEvent(new ContentEvent(ContentEvent.DELETE,itemsToDelete));
		}
		private function handleSelectedContent(event:ContentEvent):void {
			var container:ContainerNode = event.args[0] as ContainerNode;
			if(view.selectedItem != container) {
				view.selectedItem = container;
				view.expandItem(container,true,true);
			}
		}
		private function handleTitleChanged(event:ContentViewEvent):void {
			
			view.dragEnabled = view.dropEnabled = true; 
			view.editMode = false;
			var container:ContainerNode = event.args[0] as ContainerNode;
			var newtitle:String = event.args[1] as String;
			if(newtitle != container.baseLabel) {
			
				var update:UpdateData = new UpdateData();
				update.id = container.data.id;
				update.migtitle = newtitle;
				contentService.updateContainer(container,update);
				contentService.addHandlers(handleTitle);
				container.state = ContentNode.LOADING;
			}
		}
		private function handleTitle(data:Object):void {
			var result:StatusResult = data.result as StatusResult;
			if(result.success) {
				eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.NOTIFY,"Title changed successfully"));
				var container:ContainerNode = data.token.content as ContainerNode;
				var update:UpdateData = data.token.update as UpdateData;
				container.baseLabel = update.migtitle;
				container.state = ContentNode.LOADED;
			}
		}
	}
}