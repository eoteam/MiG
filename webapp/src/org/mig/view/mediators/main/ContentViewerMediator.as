package org.mig.view.mediators.main
{
	import flash.display.DisplayObject;
	import flash.system.System;
	
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
			//if(!BaseContentData(selectedNode.data).modified)
			view.mediaManager.visible = false;
			if(node != content && node != null)
			{
				content = node;
				if (content != null && content.config.@contentView.length() > 0)
				{
					var contentView:IContentView = IContentView(ClassUtils.instantiateClass(content.config.@contentView));
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
			switch (item.name) {
				
				case "Media":
					view.mediaManager.visible = !view.mediaManager.visible;
					view.tagManager.visible = false;
				break;
				
				case "Tags":
					view.mediaManager.visible = false;
					view.tagManager.visible = !view.tagManager.visible;
				break;
			}
		}
	}
}