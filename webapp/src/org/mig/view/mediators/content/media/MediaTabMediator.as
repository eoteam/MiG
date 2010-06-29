package org.mig.view.mediators.content.media
{
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.core.ClassFactory;
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.events.IndexChangedEvent;
	import mx.events.ListEvent;
	import mx.managers.DragManager;
	import mx.utils.ArrayUtil;
	
	import org.mig.events.ViewEvent;
	import org.mig.model.AppModel;
	import org.mig.model.vo.ContentNode;
	import org.mig.model.vo.content.ContainerNode;
	import org.mig.model.vo.content.ContainerData;
	import org.mig.model.vo.content.SubContainerNode;
	import org.mig.model.vo.media.DirectoryNode;
	import org.mig.model.vo.media.FileNode;
	import org.mig.model.vo.media.MediaData;
	import org.mig.model.vo.relational.ContentMedia;
	import org.mig.utils.GlobalUtils;
	import org.mig.view.components.content.ContentTabItem;
	import org.mig.view.components.content.media.MediaTab;
	import org.mig.view.constants.DraggableViews;
	import org.mig.view.events.ListItemEvent;
	import org.robotlegs.mvcs.Mediator;
	
	import spark.components.supportClasses.ItemRenderer;
	import spark.layouts.supportClasses.DropLocation;
	
	public class MediaTabMediator extends Mediator
	{
		[Inject]
		public var view:MediaTab;
		
		[Inject]
		public var appModel:AppModel;
		
		private var fixedListDirty:Boolean = false;
		private var animListDirty:Boolean = false;
		
		private var type:String;
		private var dragFormats:Array;
		private var types:ArrayList;
		override public function onRegister():void {
			
			var content:SubContainerNode = view.content as SubContainerNode;
			types = new ArrayList();
			
			var imageRenderer:ClassFactory;
			var tmp:Array = content.config.@usage.toString().split(",");
			for each(var item:String in tmp)
			{
				type = item.split(' ').join('_').toLowerCase();
				content.children.filterFunction = filterByUsage;
				content.children.refresh();		
				var dp:ArrayList = new ArrayList();
				for each(var item2:ContentMedia in content.children)
					dp.addItem(item2);
				types.addItem({type:item,baseLabel:item,label:item + ' ('+content.children.length+')',dataProvider:dp});
			}
			content.children.filterFunction = null;
			content.children.refresh();
			
			var classToUse:String = content.config.@itemView;
			var classRef:Class = getDefinitionByName(classToUse) as Class; 
			imageRenderer = new ClassFactory(classRef);
			dragFormats = String(content.config.@formats.toString()).split(",");			
			
			
						
			view.animatedList.addEventListener("orderChange",handleAnimatedListOrderChange);
			view.animatedList.itemRenderer = imageRenderer;
			
			view.thumbURL = appModel.thumbURL;
			view.scaleSlider.value = view.scalePercent = 1;
			
			view.stack.addEventListener(Event.CHANGE, handleStackChange);
			
			view.addEventListener(ViewEvent.SHOW_CONTENT_MEDIA_DETAIL,handleDetailView);
			view.currentState = "usage";
			view.addEventListener("viewBtn",handleViewButtons);
			
			view.detailView.colorPicker.dataProvider = appModel.colors;
			
			view.usageList.dataProvider = types;
			view.usageList.invalidateDisplayList();
			view.usageList.addEventListener(ListItemEvent.ITEM_DOUBLE_CLICK,handleUsageSelection);
			view.usageList.addEventListener(DragEvent.DRAG_ENTER,handleUsageListDragEnter);
			
		}
		private function handleViewButtons(event:DataEvent):void {
			var index:int = Number(event.data);
			handleView(index);
		}
		private function handleDetailView(event:ViewEvent):void {
			view.detailView.visible = true;
			
		}
		private function filterByUsage(item:ContentMedia):Boolean
		{
			if(item.usage_type.toString().toLowerCase() == type)
				return true;
			else
				return false;
		}
		private function handleStackChange(event:IndexChangedEvent):void {
/*			if(stack.selectedIndex == 3)
				view.slideShowContainer.opened = true;
			else
				slideShowContainer.opened = false;*/
		}
		
		private function handleUsageSelection(event:Event):void {
			view.fixedList.dataProvider = view.usageList.selectedItem.dataProvider;
			view.animatedList.dataProvider = view.usageList.selectedItem.dataProvider;
			//slideShowContainer.dataProvider = usageList.selectedItem.dataProvider;
			view.scaleSlider.value = 1;
			handleView(1);
			
		}
		private function handleAnimatedListOrderChange(event:Event):void {
			//fixedListDirty=true;
			//fixedListDirty=true;			
		}
		private function handleView(index:int):void
		{
			view.stack.selectedIndex = index;
			switch(index)
			{
				case 1:
					view.view1Selected = true;
					view.view2Selected = view.view3Selected = false;
					view.currentState = "view1";
					if(animListDirty)
					{
						animListDirty = false;
						view.animatedList.refresh();
					}
					break;
				case 2:
					view.view2Selected = true;
					view.view1Selected = view.view3Selected = false
					view.currentState = "view2";
					if(fixedListDirty)
					{
						fixedListDirty = false;
						view.fixedList.invalidateProperties();
					}
					break;
				case 3:
					var items:Array;
					if(view.stack.selectedIndex == 1)
					{
						items = view.animatedList.selectedItems;
					}
					else if(view.stack.selectedIndex == 2)
					{
						items = ArrayUtil.toArray(view.fixedList.selectedItems);			
					}
					if(items && items.length > 0 )
					{
						var index:int = ArrayCollection(view.usageList.selectedItem.dataProvider).getItemIndex(items[0]);
					}
					
					/*slideShowContainer.index = 0;
					slideShowContainer.loadMedia();*/
					/*if(animListDirty || fixedListDirty)
						slideShowContainer.dataProvider = usageList.selectedItem.dataProvider;*/
					view.view3Selected = true;
					view.view2Selected = view.view1Selected = false
					view.currentState = "view3";
					break;
			}
		}	
		private function handleUsageListDragEnter(event:DragEvent):void {
			if(event.dragSource.hasFormat(DraggableViews.MEDIA_ITEMS)) {
				var location:DropLocation = view.usageList.layout.calculateDropLocation(event);
				view.usageList.selectedIndex = location.dropIndex;
				if(location.dropIndex >= 0 && location.dropIndex < view.usageList.dataProvider.length) {
					var renderer:ItemRenderer = view.usageList.dataGroup.getElementAt(location.dropIndex) as ItemRenderer;
					DragManager.showFeedback(DragManager.COPY);
					DragManager.acceptDragDrop(renderer);
					renderer.addEventListener(DragEvent.DRAG_DROP,handleUsageListDragDrop);
				}
			}
		}
		private function handleUsageListDragDrop(event:DragEvent):void {
			var type:Object = view.usageList.selectedItem;
			var dp:ArrayList = type.dataProvider;
			var usage_type:String = type.type;
			var items:Array = event.dragSource.dataForFormat(DraggableViews.MEDIA_ITEMS) as Array;
			var files:Array = [];
			for each(var item:ContentNode in items) {
				if(item is FileNode)
					files.push(item);
				else
					GlobalUtils.accumulateFiles(item as DirectoryNode,files);
			}
			for each(var file:FileNode in files) {	
				var newItem:ContentMedia = new ContentMedia;
				var fileData:MediaData = file.data as MediaData;

				newItem.contentid = view.content.data.id;
				
				newItem.mediaid		= fileData.id;
				newItem.path		= fileData.path;
				newItem.name		= fileData.name;
				newItem.mimetypeid	= fileData.mimetypeid;
				newItem.thumb		= fileData.thumb;
				newItem.video_proxy = fileData.video_proxy;
				newItem.size		= fileData.size;
				newItem.playtime	= fileData.playtime;
				newItem.url			= fileData.url;
				newItem.extension	= fileData.extension;
				newItem.width		= fileData.width;
				newItem.height		= fileData.height;
				newItem.rating		= fileData.rating;
				newItem.color		= fileData.color;
				
				newItem.usage_type = usage_type;
				newItem.displayorder = dp.length + 1;
				newItem.added = false;
				dp.addItem(newItem);
				
			}
			type.label =  type.baseLabel + ' ('+dp.length+')';		
			view.usageList.invalidateProperties();
		}
	}
}