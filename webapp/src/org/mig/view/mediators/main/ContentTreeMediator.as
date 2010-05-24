package org.mig.view.mediators.main
{
	import flash.events.Event;
	
	import mx.core.DragSource;
	import mx.events.DragEvent;
	import mx.events.ListEvent;
	import mx.events.TreeEvent;
	import mx.managers.PopUpManager;
	import mx.managers.PopUpManagerChildList;
	
	import org.mig.events.AppEvent;
	import org.mig.events.ContentEvent;
	import org.mig.events.ViewEvent;
	import org.mig.model.ContentModel;
	import org.mig.model.vo.BaseContentData;
	import org.mig.model.vo.ContentNode;
	import org.mig.model.vo.content.ContainerNode;
	import org.mig.model.vo.content.ContentData;
	import org.mig.utils.GlobalUtils;
	import org.mig.view.components.main.ContentTree;
	import org.mig.view.components.main.SystemPopup;
	import org.robotlegs.mvcs.Mediator;

	public class ContentTreeMediator extends Mediator
	{
		[Inject] 
		public var view:ContentTree;
		
		[Inject]
		public var contentModel:ContentModel;
		
		override public function onRegister():void {
			eventMap.mapListener(eventDispatcher,AppEvent.CONFIG_FILE_LOADED,handleContent);
			eventMap.mapListener(eventDispatcher,ContentEvent.RETRIEVE_CHILDREN,handleContent);
			eventMap.mapListener(eventDispatcher,ViewEvent.DELETE_CONTAINERS,deleteItems);
			eventMap.mapListener(eventDispatcher,ViewEvent.ENABLE_CONTENT_TREE,enableTree);
			
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
		}
		private function handleContent(event:Event):void {
			if(event is ContentEvent && ContentEvent(event).args[0] is ContainerNode)
				view.dataProvider = contentModel.contentModel;
		}
		private function enableTree(event:Event):void {
			view.enabled = true;
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
			var selectedNode:ContainerNode = view.selectedItem as ContainerNode;
			if(ContentData(selectedNode.data).loaded)
				eventDispatcher.dispatchEvent(new ContentEvent(ContentEvent.SELECT,selectedNode));
			else 
				eventDispatcher.dispatchEvent(new ContentEvent(ContentEvent.RETRIEVE_VERBOSE,selectedNode));
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
					if(!node.isFixed && !node.isRoot)
						itemsToDelete.push(node)
					else {
						popup = createPopup("<p>You cant delete this container:</p>" +
							"<font face='Transit-Bold'>"+node.label + "</font><br /><br />"+
							"Please try again");
						popup.includeCancel = popup.includeYes = false;
						popup.noLabelText = "Continue";
						return;
					}
				}
				for each(node in itemsToDelete)
					accumulateChildren(node,itemsToDelete);	
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
		private function accumulateChildren(node:ContainerNode,arr:Array):void {
			if(node.children) {
				for each(var item:ContainerNode in node.children) {
					arr.push(item);
					accumulateChildren(item,arr);
				}
			}
		}
		private function handleDeleteSelection(event:Event):void {
			eventDispatcher.dispatchEvent(new ContentEvent(ContentEvent.DELETE,itemsToDelete));
		}
	}
}