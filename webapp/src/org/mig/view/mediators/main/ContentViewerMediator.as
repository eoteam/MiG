package org.mig.view.mediators.main
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.system.System;
	
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	
	import org.mig.events.ContentEvent;
	import org.mig.events.ViewEvent;
	import org.mig.model.vo.content.ContainerNode;
	import org.mig.utils.ClassUtils;
	import org.mig.view.components.main.ContentViewer;
	import org.mig.view.interfaces.IContentView;
	import org.robotlegs.mvcs.Actor;
	import org.robotlegs.mvcs.Mediator;

	public class ContentViewerMediator extends Mediator
	{
		[Inject]
		public var view:ContentViewer;
		
		private var content:ContainerNode;
		
		override public function onRegister():void {
			eventMap.mapListener(eventDispatcher,ContentEvent.SELECT,handleNodeSelected,ContentEvent);
			eventMap.mapListener(eventDispatcher,ViewEvent.MANAGER_SELECTED,handleManager,ViewEvent);
		}	
		
		private function handleNodeSelected(event:ContentEvent):void
		{
			var node:ContainerNode = event.args[0] as ContainerNode;
			view.managerContainer.visible = false;
			for(var i:int = 0;i<view.managerContainer.numChildren;i++) {
				var manager:DisplayObject = view.managerContainer.getChildAt(i);
				manager.visible = false;
			}
			if(node != content && node != null)
			{
				content = node;
				if (content != null && content.template.contentview.length > 0)
				{
					var contentView:IContentView = IContentView(ClassUtils.instantiateClass(content.template.contentview));
					contentView.content = content;
					UIComponent(contentView).percentHeight = 100; 
					//BindingUtils.bindProperty(contentView, "height", contentViewContainer, "height")
					if(view.contentViewContainer.numChildren > 0)
					{
						view.contentViewContainer.getChildAt(0);
						view.contentViewContainer.removeAllChildren();
						System.gc();
					}
					view.contentViewContainer.addChild(UIComponent(contentView)); 
					//Application.application.mainView.newContentSelector.selectedContent = content;
				}
			} 
		}
		private function handleManager(event:ViewEvent):void {
			var item:Object = event.args[0];
			for(var i:int = 0;i<view.managerContainer.numChildren;i++) {
				trace(view.managerContainer.getChildAt(i).name);
				if(view.managerContainer.getChildAt(i).name != item.name)
					view.managerContainer.getChildAt(i).visible = false;
				else {
					view.managerContainer.getChildAt(i).visible = true;
					view.managerContainer.visible = true;
				}
			}
		}
	}
}