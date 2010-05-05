package org.mig.view.mediators.main
{
	import flash.events.Event;
	
	import mx.events.DragEvent;
	import mx.events.ListEvent;
	import mx.events.TreeEvent;
	
	import org.mig.events.AppEvent;
	import org.mig.events.ContentEvent;
	import org.mig.model.ContentModel;
	import org.mig.model.vo.BaseContentData;
	import org.mig.model.vo.ContentNode;
	import org.mig.utils.GlobalUtils;
	import org.mig.view.components.main.ContentTree;
	import org.robotlegs.mvcs.Mediator;

	public class ContentTreeMediator extends Mediator
	{
		[Inject] 
		public var view:ContentTree;
		
		[Inject]
		public var contentModel:ContentModel;
		
		override public function onRegister():void {
			eventMap.mapListener(eventDispatcher,AppEvent.CONFIG_LOADED,handleContent);
			eventMap.mapListener(eventDispatcher,ContentEvent.RETRIEVE,handleContent);
			
			
			view.addEventListener(DragEvent.DRAG_START,handleDragStart);
			view.addEventListener(DragEvent.DRAG_DROP,handleDragDrop);
			view.addEventListener(DragEvent.DRAG_ENTER,handleDragEnter);
			view.addEventListener(DragEvent.DRAG_OVER,handleDragOver);
			view.addEventListener(DragEvent.DRAG_COMPLETE,handleDragComplete);
			
			view.addEventListener(TreeEvent.ITEM_OPENING,handleItemOpen);
			view.addEventListener(TreeEvent.ITEM_OPEN,handleItemOpen);
			
			view.addEventListener(ListEvent.CHANGE,handleItemClick);
			view.addEventListener(ListEvent.ITEM_DOUBLE_CLICK,handleItemDoubleClick);	
			
			addContextMenu();

		}
		
		private function handleContent(event:Event):void {
			view.dataProvider = contentModel.contentModel;
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
			var selectedNode:ContentNode = view.selectedItem as ContentNode;
			eventDispatcher.dispatchEvent(new ContentEvent(ContentEvent.SELECT,selectedNode));
			
		}
		
		private function addContextMenu():void {
			GlobalUtils.createContextMenu(["Delete Item(s)","Rename","Duplicate Item(s)"],menuItemSelectHandler,null,[view]);
		}
		private function menuItemSelectHandler(event:Event):void {
			switch(event.target.caption)
			{
				case "Delete Item(s)":
					//if(this.selectedItems)
						//startDelete();
					break;	
				case "Rename":
					break;	
				case "Duplicate Item(s)":
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
	}
}