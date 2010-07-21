package org.mig.view.mediators.main
{
	import flash.events.Event;
	
	import mx.events.ListEvent;
	import mx.events.TreeEvent;
	
	import org.mig.events.AppEvent;
	import org.mig.events.ViewEvent;
	import org.mig.model.AppModel;
	import org.mig.view.components.main.MainView;
	import org.mig.view.components.main.ManagersTree;
	import org.mig.view.renderers.ManagerTreeRenderer;
	import org.robotlegs.mvcs.Mediator;

	public class ManagersTreeMediator extends Mediator
	{
		[Inject]
		public var appModel:AppModel;
		
		[Inject]
		public var view:ManagersTree;
		

		override public function onRegister():void {
			
			eventMap.mapListener(eventDispatcher,AppEvent.STARTUP_COMPLETE,handleConfig,AppEvent);
			view.addEventListener(ListEvent.ITEM_CLICK,handleTreeChange);
		}
		
		private function handleConfig(event:AppEvent):void {
			var root:Object = new Object();
			root.name = "Managers";
			root.children = appModel.managers;
			view.dataProvider = root;	
			view.addEventListener(TreeEvent.ITEM_OPEN,handleResize);
			view.addEventListener(TreeEvent.ITEM_CLOSE,handleResize);
			//view.privileges = appModel.user.privileges;
		}
		private function handleResize(event:Event):void {
			eventDispatcher.dispatchEvent(new ViewEvent(ViewEvent.RESIZE_MANAGER_TREE,view.measureHeightOfItems()));
		}
		private function handleTreeChange(event:ListEvent):void {
			eventDispatcher.dispatchEvent(new ViewEvent(ViewEvent.MANAGER_SELECTED,view.selectedItem));
		}	
	}
}