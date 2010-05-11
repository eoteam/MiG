package org.mig.view.mediators.content.tabs
{
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	
	import mx.collections.ArrayCollection;
	import mx.core.ClassFactory;
	import mx.events.IndexChangedEvent;
	import mx.events.ListEvent;
	
	import org.mig.model.vo.ContentNode;
	import org.mig.model.vo.content.ContainerNode;
	import org.mig.model.vo.content.ContentData;
	import org.mig.model.vo.content.SubContainerNode;
	import org.mig.view.components.content.tabs.MediaTab;
	import org.robotlegs.mvcs.Mediator;
	
	public class MediaTabMediator extends Mediator
	{
		[Inject]
		public var view:MediaTab;
		private var fixedListDirty:Boolean = false;
		private var animListDirty:Boolean = false;
		
		private var type:String;
		private var dragFormats:Array;
		override public function onRegister():void {
			
			
			var content:SubContainerNode = view.content as SubContainerNode;
			var types:Array = [];
			
			var imageRenderer:ClassFactory;
			var tmp:Array = content.config.@usages.toString().split(",");
			for each(var item:String in tmp)
			{
				type = item.split(' ').join('_').toLowerCase();
				content.children.filterFunction = filterByUsage;
				content.children.refresh();		
				var dp:ArrayCollection = new ArrayCollection();
				for each(var item2:ContentNode in content.children)
					dp.addItem(item2);
				types.push({type:item,name:item + ' ('+content.children.length+')',dataProvider:dp});
			}
			var classToUse:String = content.config.object[0].@contentView;
			var classRef:Class = getDefinitionByName(classToUse) as Class; 
			imageRenderer = new ClassFactory(classRef);
			dragFormats = String(content.config.@formats.toString()).split(",");			
			
			view.usageList.dataProvider = types;
			

			view.animatedList.addEventListener("orderChange",handleAnimatedListOrderChange);
			view.animatedList.itemRenderer = imageRenderer;
			view.stack.addEventListener(Event.CHANGE, handleStackChange);
			view.usageList.addEventListener(ListEvent.ITEM_DOUBLE_CLICK,handleUsageSelection);
			view.currentState = "usage";
			view.addEventListener("viewBtn",handleViewButtons);
		}
		private function handleViewButtons(event:DataEvent):void {
			var index:int = Number(event.data);
			handleView(index);
		}
		private function filterByUsage(item:ContainerNode):Boolean
		{
			if(ContentData(item.data).usage_type.toString().toLowerCase() == type)
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
			//view.fixedList.dataProvider = view.usageList.selectedItem.dataProvider;
			view.animatedList.dataProvider = view.usageList.selectedItem.dataProvider;
			//slideShowContainer.dataProvider = usageList.selectedItem.dataProvider;
			view.scaleSlider.value = 1;
			if(view.typeLabel)
				view.typeLabel.text = view.usageList.selectedItem.name;
			if(view.subControlBox)
				handleView(1);
			else
			{
				view.stack.selectedIndex = 1;
				view.currentState = "view3";
			}
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
					view.view1Btn.selected = true;
					view.view2Btn.selected = view.view3Btn.selected = false;
					view.currentState = "view3";
					if(animListDirty)
					{
						animListDirty = false;
						view.animatedList.refresh();
					}
					break;
				case 2:
					view.view2Btn.selected = true;
					view.view1Btn.selected = view.view3Btn.selected = false;
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
						items = view.fixedList.selectedItems;			
					}
					if(items && items.length > 0 )
					{
						var index:int = ArrayCollection(view.usageList.selectedItem.dataProvider).getItemIndex(items[0]);
					}
					
					/*slideShowContainer.index = 0;
					slideShowContainer.loadMedia();*/
					/*if(animListDirty || fixedListDirty)
						slideShowContainer.dataProvider = usageList.selectedItem.dataProvider;*/
					view.view3Btn.selected = true;
					view.view1Btn.selected = view.view2Btn.selected = false;
					view.currentState = "view1";
					break;
			}
		}		
	}
}