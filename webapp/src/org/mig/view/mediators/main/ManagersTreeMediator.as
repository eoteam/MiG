package org.mig.view.mediators.main
{
	import flash.events.Event;
	
	import mx.events.TreeEvent;
	
	import org.mig.events.AppEvent;
	import org.mig.events.ViewEvent;
	import org.mig.model.AppModel;
	import org.mig.view.components.main.MainView;
	import org.mig.view.components.main.ManagersTree;
	import org.robotlegs.mvcs.Mediator;

	public class ManagersTreeMediator extends Mediator
	{
		[Inject]
		public var appModel:AppModel;
		
		[Inject]
		public var treeView:ManagersTree;
		

		
		override public function onRegister():void {
			
			eventMap.mapListener(eventDispatcher,AppEvent.CONFIG_LOADED,handleConfig,AppEvent);
		}
		
		private function handleConfig(event:AppEvent):void {
			var root:Object = new Object();
			root.name = "Managers";
			root.children = [];
			for each(var item:Object in appModel.managers) {
				if(item.value == "ON")
					root.children.push(item);
			}
			treeView.dataProvider = root;	
			treeView.addEventListener(TreeEvent.ITEM_OPEN,handleResize);
			treeView.addEventListener(TreeEvent.ITEM_CLOSE,handleResize);
		}
		private function handleResize(event:Event):void {
			eventDispatcher.dispatchEvent(new ViewEvent(ViewEvent.RESIZE_MANAGER_TREE,[treeView.measureHeightOfItems()]));
		}
	}
}